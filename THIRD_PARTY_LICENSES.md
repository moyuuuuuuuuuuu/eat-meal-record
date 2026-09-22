# 第三方开源许可

本仓库基于 Webman 开发，项目自有代码按根目录的 [MIT License](LICENSE) 授权。根目录的 MIT 声明保留了 Webman 原有的版权与许可文字。

依赖或仓库内附带的第三方代码、静态资源，仍分别遵守其权利人提供的许可证和版权声明；根目录的 MIT 声明不替代这些声明。分发时应一并保留相应的许可证、版权声明及要求的 NOTICE。

## Composer 依赖

版本以 `composer.lock` 为准。锁文件当前记录的 97 个生产依赖中，91 个标注 MIT，3 个标注 BSD-3-Clause，2 个标注 Apache-2.0，`webman/redis-queue` 没有在锁文件中填写许可证字段。安装后的完整许可文本和版权声明请查看各包自身的文件及源码；未标注许可证不能视为自动获得 MIT 或 Apache-2.0 授权。

| 依赖 | `composer.lock` 中的许可 |
| --- | --- |
| `firebase/php-jwt` | BSD-3-Clause |
| `nikic/fast-route` | BSD-3-Clause |
| `vlucas/phpdotenv` | BSD-3-Clause |
| `moyuuuuuuuu/qianfan` | Apache-2.0 |
| `phpoption/phpoption` | Apache-2.0 |
| `webman/redis-queue` | 未标注，需以该包发布的许可文件核实 |

其余 91 个生产依赖在锁文件中标注 MIT。升级依赖后应重新检查锁文件和随包许可证。

## 仓库内附带的第三方资源

- `plugin/admin/public/demos/` 保留了该目录原有的 [MIT 许可文件](plugin/admin/public/demos/LICENSE) 和版权声明。
- `plugin/admin/public/component/jsoneditor/jsoneditor.js` 文件头标注 Apache-2.0；该文件及其许可声明继续适用。
- `plugin/admin/public/resource/tinymce/` 中的资源标注 Tiny Technologies 的 LGPL 或商业许可。该目录当前没有其文件头所指的 `License.txt`；在重新分发这些资源前，应向对应上游发行包核实具体版本、许可文本和附带义务。
- 其他后台静态资源若带有文件头或内置许可声明，也应保留并遵守其各自条款。

本文件是许可索引，不授予任何第三方代码的新许可。
