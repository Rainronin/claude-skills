# Claude Code Skills

个人 Claude Code Agent Skills 合集，每个子目录是一个可安装的 skill。

## 已收录

| Skill | 说明 |
|-------|------|
| [submission-cleaner](./submission-cleaner/) | 提交版清理器 — 从 AI 协作项目中提取纯净课程提交版本，自动排除 CLAUDE.md、构建脚本、答辩文档等过程产物 |
| [course-defense-prep](./course-defense-prep/) | 课程答辩准备文档生成器 — 四阶段工作流 + Q&A 追问链模式 + DOCX 输出 |
| [env-transfer](./env-transfer/) | 环境转移打包器 — 一键打包 Skills + Plugins + 市场配置，离线安装，对方解压即用 |

## 安装

### 方式一：直接复制

将对应 skill 目录复制到 `~/.claude/skills/` 下：

```bash
cp -r env-transfer ~/.claude/skills/
```

### 方式二：通过 .skill 文件安装

```bash
claude plugin install <路径>/env-transfer.skill
```
