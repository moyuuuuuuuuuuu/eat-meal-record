import json
import re


async def main(args: Args) -> Output:
    params = args.params
    raw = params.get('raw')
    if isinstance(raw, str):
        raw = re.sub(r'^```(?:json)?\s*|\s*```$', '', raw.strip(), flags=re.I | re.S).strip()
    try:
        data = json.loads(raw) if isinstance(raw, str) else raw
        requested = json.loads(str(params.get('input') or '[]'))
    except (ValueError, TypeError) as exc:
        raise ValueError('INVALID_WORKFLOW_JSON') from exc
    if isinstance(data, dict):
        data = data.get('data', data.get('foods', []))
    if not isinstance(data, list) or not isinstance(requested, list):
        raise ValueError('INVALID_WORKFLOW_ARRAY')
    allowed = {str(name).strip() for name in requested if str(name).strip()}
    nutrients = ('kcal','pro','fat','carb','fiber','vit_c','mag','folic','cal','iron','vit_e')
    unit_types = {'weight','count','volume','package','service','length'}
    tag_types = {'餐次','口味','营养','烹饪方式','适用人群','食材状态','过敏原','品牌产地','时令季节','特殊场景','存储方式'}
    result = []
    seen = set()
    for item in data:
        if not isinstance(item, dict):
            continue
        name = str(item.get('name') or '').strip()
        if name not in allowed or name in seen:
            continue
        nutrient_map = {}
        raw_nutrition = item.get('nutrition', [])
        if isinstance(raw_nutrition, dict):
            raw_nutrition = [{'name': key, 'value': value} for key, value in raw_nutrition.items()]
        if not isinstance(raw_nutrition, list):
            continue
        for row in raw_nutrition:
            if not isinstance(row, dict) or row.get('name') not in nutrients:
                continue
            try:
                value = float(row.get('value'))
            except Exception:
                continue
            if value >= 0:
                nutrient_map[row['name']] = round(value, 2)
        if any(key not in nutrient_map for key in nutrients):
            continue
        units = []
        for unit in item.get('units', []):
            if not isinstance(unit, dict):
                continue
            try:
                weight = float(unit.get('weight'))
            except Exception:
                continue
            unit_name = str(unit.get('name') or '').strip()
            unit_type = unit.get('type')
            if unit_name and unit_type in unit_types and weight > 0:
                units.append({'name':unit_name,'weight':round(weight,2),'is_default':1 if unit.get('is_default') in (1,True,'1') else 0,'type':unit_type})
        if not units:
            continue
        default_index = next((i for i, unit in enumerate(units) if unit['is_default'] == 1), 0)
        for i, unit in enumerate(units):
            unit['is_default'] = 1 if i == default_index else 0
        tags = {}
        raw_tags = item.get('tags') or {}
        if isinstance(raw_tags, list):
            raw_tags = {row.get('type'): row.get('values') for row in raw_tags if isinstance(row, dict)}
        if not isinstance(raw_tags, dict):
            continue
        for tag_type, values in raw_tags.items():
            if tag_type not in tag_types:
                continue
            if not isinstance(values, list):
                values = re.split(r'[、,，/|]+', str(values))
            values = list(dict.fromkeys(str(value).strip() for value in values if str(value).strip()))
            if values:
                tags[tag_type] = values
        if not tags:
            continue
        result.append({'name':name,'cat':str(item.get('cat') or '其他').strip() or '其他','is_common':1 if item.get('is_common') in (1,True,'1') else 2,'is_ingredient':1 if item.get('is_ingredient') in (1,True,'1') else 2,'tags':tags,'units':units,'nutrition':[{'name':key,'value':nutrient_map[key]} for key in nutrients]})
        seen.add(name)
    return {'output': json.dumps(result, ensure_ascii=False, separators=(',', ':'))}
