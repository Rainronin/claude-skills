# Claude Code Skills

个人 Claude Code Agent Skills 合集，每个子目录是一个可安装的 skill。

## 已收录

| Skill | 说明 |
|-------|------|
| [submission-cleaner](./submission-cleaner/) | 提交版清理器 — 从 AI 协作项目中提取纯净课程提交版本，自动排除 CLAUDE.md、构建脚本、答辩文档等过程产物 |
| [course-defense-prep](./course-defense-prep/) | 课程答辩准备文档生成器 — 四阶段工作流 + Q&A 追问链模式 + DOCX 输出 |

## 安装

将对应 skill 目录复制到 `~/.claude/skills/` 下即可：

```bash
cp -r submission-cleaner ~/.claude/skills/
cp -r course-defense-prep ~/.claude/skills/
```
