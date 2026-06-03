---
name: env-transfer
description: 将当前 Claude Code 环境（Skills + Plugins + 市场配置）打包为离线转移包，附带一键安装脚本，对方无需联网。当用户说"转移环境""打包skill""打包插件""导出环境""迁移环境""备份给朋友""给别人装一样的""换电脑了怎么搬""export my setup""pack my claude"时务必触发。即使用户只是随口问"能不能把我的插件复制给别人"，也应该触发此 skill。
---

# 环境转移器

你的任务：将当前用户的 Claude Code 完整环境打包成一个离线压缩包 + 安装脚本，对方解压运行即拥有完全相同的 Skills 和 Plugins。

## 为什么需要

手动装插件要联网、逐条执行 `claude plugin install`、配置路径、处理市场文件……每换一台机器重复一遍。这个 skill 用两个脚本完成全部工作：一个打包、一个安装。

## 打包脚本

这两个脚本已同在 skill 目录下，可直接使用：

- `pack-complete.ps1` — 打包脚本，复制 skills、插件缓存、市场配置，生成 .zip
- `install.bat` — 安装脚本，对方运行后自动复制到 `%USERPROFILE%\.claude\` 并生成正确的路径配置

## 执行流程

### 第一步：检查当前环境

运行 `claude plugin list`，向用户展示当前状态摘要：

- 已启用的插件及数量
- disabled 或 failed 的插件（如有，提醒用户）
- Skills 目录下的 skill 数量（`~/.claude/skills/` 下子目录数）
- 市场配置数量

在这步如发现：
- 已卸载但文件残留的插件 → 提醒用户确认是否删除
- 有 disabled 或 failed 的插件 → 提醒用户先修复再打包

### 第二步：用户确认后执行打包

运行打包脚本（从 skill 所在目录执行）：

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>/pack-complete.ps1"
```

> 打包脚本输出 zip 到桌面，文件名格式 `claude-complete-YYYYMMDD_HHmmss.zip`

打包完成后，将 zip 和 `install.bat` 一起移到当前工作目录（用户当前打开的项目根目录）。

### 第三步：输出结果

展示最终交付物和对方安装步骤：

```
## ✅ 打包完成

共 X 个插件、Y 个 Skills 已打包。

| 文件 | 大小 |
|------|------|
| claude-complete-20260604_120000.zip | 350 MB |
| install.bat | 4 KB |

### 对方安装只需三步
1. 解压 zip，得到 claude-backup 文件夹
2. 将 claude-backup 与 install.bat 放同一目录
3. 双击 install.bat → 重启 VSCode

无需联网。
```

## 注意事项

- **覆盖旧包**：同目录下有旧 zip 先删除再生成
- **路径适配**：install.bat 全部用 `%USERPROFILE%` 变量，自动适配对方 Windows 用户名
- **保守原则**：如果用户不确定某些插件是否要保留，先问再打包
- **包体积提醒**：压缩包通常在 300-400MB，建议用网盘分享
