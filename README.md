# Claude Code Skills

个人 Claude Code Agent Skills 合集，每个子目录是一个可安装的 skill。

## 已收录

| Skill | 说明 |
|-------|------|
| [submission-cleaner](./submission-cleaner/) | 提交版清理器 — 从 AI 协作项目中提取纯净课程提交版本，自动排除 CLAUDE.md、构建脚本、答辩文档等过程产物 |
| [course-defense-prep](./course-defense-prep/) | 课程答辩准备文档生成器 — 四阶段工作流 + Q&A 追问链模式 + DOCX 输出 |
| [env-transfer](./env-transfer/) | 环境转移打包器 — 一键打包 Skills + Plugins + 市场配置为离线转移包，对方无需联网 |

---

## 安装

### 方式一：直接复制到 skills 目录

```bash
# 提交版清理器
cp -r submission-cleaner ~/.claude/skills/

# 课程答辩准备
cp -r course-defense-prep ~/.claude/skills/

# 环境转移
cp -r env-transfer ~/.claude/skills/
```

重启 Claude Code（或 VSCode）即可生效。

### 方式二：通过 .skill 文件安装

下载对应 skill 的 `.skill` 文件后：

```bash
claude plugin install <路径>/env-transfer.skill
```

> 注意：`.skill` 文件需从 [Releases](https://github.com/Rainronin/claude-skills/releases) 下载，或自行运行 `python -m scripts.package_skill <skill目录>` 生成。

---

## 使用

### submission-cleaner

说"准备提交""创建提交版""整理提交"即触发。会自动扫描项目、分类文件，生成 `提交版/` 目录。

### course-defense-prep

说"准备答辩""答辩文档""答辩攻略"即触发。四阶段工作流生成答辩 DOCX，含追问链应对。

### env-transfer

说"转移环境""打包skill""导出环境""备份给朋友"即触发。一键打包所有 Skills + Plugins，生成离线压缩包 + install.bat。

---

## 许可

MIT
