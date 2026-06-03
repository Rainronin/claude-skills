---
name: submission-cleaner
description: 从课程项目中提取纯净提交版——创建"提交版/"目录，只复制课程要求的核心文件（.ipynb, .html, CSV, PNG 图表等），自动排除 AI 过程产物（CLAUDE.md, scripts/, 答辩文档, 构建脚本等）。当用户提到"提交版""提交前清理""准备上交""创建干净版本""strip AI files""clean submission""整理提交"时务必触发。即使只是在对话末尾随口提一句"准备提交了"也应该触发此 skill。手动触发：/submission-cleaner 或直接说"调用 submission-cleaner"。
---

# 提交版清理器

你是一个项目清洁工。你的任务是：在项目根目录下创建一个 `提交版/` 子文件夹，只包含课程提交必需的文件，排除所有 AI 协作过程产物。

## 为什么需要这个

在 AI 协作开发课程项目的过程中，会积累大量对提交无用的文件——AI 配置、构建脚本、答辩文档、调试日志……这些混在项目里会让老师困惑，甚至可能因为 `CLAUDE.md` 或奇怪的脚本名被质疑是否独立完成。这个 skill 一键分离。

## 执行流程

### 第一步：扫描并分类

机械式遍历项目根目录下所有文件（跳过 `.git/`、`node_modules/`、`提交版/` 自身），按以下规则分类：

**✅ 提交文件（COPY）**：
| 规则 | 示例 |
|------|------|
| Jupyter Notebook | `*.ipynb` |
| 导出的 HTML 报告 | `*.html`（通常在 outputs/ 下） |
| 数据集文件 | `*.csv`, `*.xlsx`, `*.xls`, `*.json`（数据文件） |
| 可视化图表 | `*.png`, `*.jpg`, `*.jpeg`, `*.svg`（通常在 outputs/figures/ 下） |
| 参考/说明文档 | `references/*.md`、`*说明*.md`、`*数据来源*.md`（非 CLAUDE.md/README.md/AGENTS.md） |
| 运行说明 | `运行说明.md`、`使用说明.md`、`HOW_TO_RUN.md` 等 |

**❌ AI 产物（SKIP）**：
| 规则 | 示例 |
|------|------|
| AI 协作配置 | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.claude/`, `.github/copilot*` |
| Git 相关 | `.git/`, `.gitignore`, `.gitattributes` |
| 项目 README | `README.md`（通常含 AI 生成的项目结构说明，非提交必需） |
| 构建/生成脚本 | `scripts/`, `*.js`（构建工具）, `build_*.py`, `generate_*.py` |
| 答辩/个人文档 | `答辩*.docx`, `defense*.docx`, `答辩*.md` |
| 环境配置脚本 | `setup_env.ps1`, `setup.sh`, `requirements*.txt`（可选——如果老师要求提交则保留） |
| 临时/调试文件 | `fix_*.js`, `fix_*.py`, `*_debug*`, `*.bak` |
| 打包产物 | `*.skill`, `*.zip`, `*.tar.gz` |

**⚠️ 灰色地带（询问用户）**：
- 根目录下的 `*.py` 文件——可能是主程序，也可能是辅助脚本。列出让用户逐项确认。
- `requirements.txt` / `environment.yml`——有些课程要求提交依赖清单。

### 第二步：向用户展示分类结果

在执行复制前，必须向用户展示分类摘要：

```
## 提交版将包含：
- notebooks/analysis.ipynb
- outputs/report.html
- outputs/figures/*.png (9 张)
- data/*.csv (2 个)
- references/data_sources.md
- 运行说明.md

## 将排除：
- CLAUDE.md (AI 配置)
- README.md (项目说明)
- scripts/ (构建脚本)
- 答辩准备文档.docx (个人文档)
- setup_env.ps1 (环境配置)

共 15 个文件入版，11 个文件排除。
```

灰色地带的文件单独列出，询问用户是否纳入。用户确认后再执行复制。

### 第三步：执行复制

```
提交版/
├── (保持原始子目录结构，但去除空目录)
```

- 创建 `提交版/` 目录
- 对每个入选文件，保持其相对于项目根目录的路径结构
- 不复制空目录
- 不创建 `.gitkeep` 等多余文件

### 第四步：输出摘要

```
## 提交版已就绪

提交版/ — X MB，Y 个文件
├── notebooks/...
├── outputs/...
├── data/...
└── ...

可以直接将此文件夹打包上交，或将其中的文件提交到教学平台。
```

## 关键原则

- **保守优先**：不确定的文件，宁可先问用户再决定，不要自作主张排除
- **保持原样**：不修改文件内容，不重命名，只做纯复制
- **不要动原始项目**：只在 `提交版/` 子目录下操作
- **跳过提交版自身**：如果项目里已有 `提交版/`，先删除再重建
- **中文友好**：所有输出和中文字段名保持原样
