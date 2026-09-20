"""Offline tests for the exported Coze node; no API, credentials or database.

Run: python3 tests/coze_validator_test.py
"""
import asyncio
import json
from pathlib import Path
from types import SimpleNamespace
import unittest

SOURCE = Path(__file__).resolve().parents[1] / 'docs/performance/food-nutrition-validator.py'
SCOPE = {'Args': SimpleNamespace, 'Output': dict}
exec(compile(SOURCE.read_text(), str(SOURCE), 'exec'), SCOPE)


def run(raw, requested='["测试食品"]'):
    return asyncio.run(SCOPE['main'](SimpleNamespace(params={'raw': raw, 'input': requested})))


class CozeValidatorTest(unittest.TestCase):
    def test_malformed_json_must_not_look_like_success(self):
        with self.assertRaisesRegex(ValueError, 'INVALID_WORKFLOW_JSON'):
            run('[{"name":"测试食品"},"units":[]]')

    def test_truncated_json_must_fail(self):
        with self.assertRaisesRegex(ValueError, 'INVALID_WORKFLOW_JSON'):
            run('[{"name":"测试食品"')

    def test_scalar_result_must_fail(self):
        with self.assertRaisesRegex(ValueError, 'INVALID_WORKFLOW_ARRAY'):
            run('42')

    def test_wrong_input_shape_must_fail(self):
        with self.assertRaisesRegex(ValueError, 'INVALID_WORKFLOW_ARRAY'):
            run('[]', '{}')

    def test_empty_valid_result_retains_existing_contract(self):
        self.assertEqual(run('[]'), {'output': '[]'})
        self.assertEqual(run([]), {'output': '[]'})

    def test_missing_native_output_must_fail(self):
        with self.assertRaisesRegex(ValueError, 'INVALID_WORKFLOW_ARRAY'):
            run(None)

    def test_native_array_converts_tags_and_keeps_decimal_values(self):
        item = {
            'name': '测试食品', 'cat': '测试', 'is_common': 1, 'is_ingredient': 2,
            'tags': [{'type': '餐次', 'values': ['早餐', '早餐']},
                     {'type': '无效类型', 'values': ['不应返回']}],
            'units': [{'name': '克', 'weight': 1.25, 'is_default': 1, 'type': 'weight'}],
            'nutrition': [{'name': name, 'value': 1.25} for name in
                          ('kcal', 'pro', 'fat', 'carb', 'fiber', 'vit_c', 'mag', 'folic', 'cal', 'iron', 'vit_e')]
        }
        result = run([item])
        self.assertIsInstance(result['output'], str)
        foods = json.loads(result['output'])
        self.assertEqual(len(foods), 1)
        self.assertEqual(foods[0]['tags'], {'餐次': ['早餐']})
        self.assertEqual(foods[0]['units'][0]['weight'], 1.25)
        self.assertEqual(len(foods[0]['nutrition']), 11)
        self.assertTrue(all(row['value'] == 1.25 for row in foods[0]['nutrition']))
        item['nutrition'] = {row['name']: row['value'] for row in item['nutrition']}
        self.assertEqual(run([item]), result)
        del item['nutrition']['vit_e']
        self.assertEqual(run([item]), {'output': '[]'})

    def test_valid_food_keeps_string_contract_and_required_fields(self):
        item = {
            'name': '测试食品', 'cat': '测试', 'is_common': 1, 'is_ingredient': 2,
            'tags': {'餐次': ['早餐']},
            'units': [{'name': '克', 'weight': 1, 'is_default': 1, 'type': 'weight'}],
            'nutrition': [{'name': name, 'value': 1} for name in
                          ('kcal', 'pro', 'fat', 'carb', 'fiber', 'vit_c', 'mag', 'folic', 'cal', 'iron', 'vit_e')]
        }
        result = run('```json\n' + json.dumps([item, item]) + '\n```')
        self.assertIsInstance(result['output'], str)
        foods = json.loads(result['output'])
        self.assertEqual(len(foods), 1)
        self.assertEqual(foods[0]['name'], '测试食品')
        self.assertEqual(len(foods[0]['nutrition']), 11)
        self.assertEqual(sum(unit['is_default'] for unit in foods[0]['units']), 1)


if __name__ == '__main__':
    unittest.main()
