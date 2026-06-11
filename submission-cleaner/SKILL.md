---
name: submission-cleaner
description: 从课程项目中提取纯净提交版——创建 ASCII 命名的提交目录，自动识别项目类型（HarmonyOS/Android/Python），保留必需构建配置和 IDE 模块文件，排除 AI 过程产物。支持复制后校验 SDK 版本一致性。
---

# 提交版清理器

你是一个项目清洁工。你的任务是：在项目根目录下创建一个纯 ASCII 命名的提交子文件夹，只包含课程提交必需的文件，排除所有 AI 协作过程产物。

## 为什么需要这个

在 AI 协作开发课程项目的过程中，会积累大量对提交无用的文件——AI 配置、构建脚本、答辩文档、调试日志……这些混在项目里会让老师困惑，甚至可能因为 `CLAUDE.md` 或奇怪的脚本名被质疑是否独立完成。这个 skill 一键分离。

## 关键第一条：输出目录必须用 ASCII 命名

**绝不能用中文命名输出目录。** 许多构建系统（HarmonyOS hvigor、Android Gradle 等）不支持路径中包含非 ASCII 字符，遇到中文路径会直接拒绝构建并报出误导性错误（如"targetSdkVersion 未配置"，实际根因是路径含中文）。

默认使用 `project-submit/`。如果用户有偏好，可以换成其他纯 ASCII 名称（如 `yidong-dzy/`）。绝对不要用 `提交版/` 这种中文路径。

## 执行流程

### 第〇步：确认输出目录名

询问用户输出目录名（默认 `project-submit/`），确保是纯 ASCII 路径。

### 第一步：识别项目类型并扫描

遍历项目根目录（跳过 `.git/`、`node_modules/`、构建输出目录），首先识别项目类型：

| 项目类型 | 识别特征 |
|----------|----------|
| **HarmonyOS** | 存在 `build-profile.json5`、`hvigorfile.ts`、`oh-package.json5` |
| **Python/Jupyter** | 存在 `*.ipynb`、`requirements.txt` |
| **Android** | 存在 `build.gradle`、`settings.gradle` |
| **通用课程项目** | 以上都不匹配 |

然后按项目类型对应的规则分类文件。

### 第二步：分类规则

#### ✅ 通用提交文件（任何项目类型都 COPY）

| 规则 | 示例 |
|------|------|
| Jupyter Notebook | `*.ipynb` |
| 导出的 HTML 报告 | `*.html`（通常在 outputs/ 下） |
| 数据集文件 | `*.csv`, `*.xlsx`, `*.xls`, `*.json`（数据文件） |
| 可视化图表 | `*.png`, `*.jpg`, `*.jpeg`, `*.svg`（通常在 outputs/figures/ 下） |
| 参考/说明文档 | `references/*.md`、`*说明*.md`、`*数据来源*.md`（非 CLAUDE.md/README.md/AGENTS.md） |
| 课程报告文档 | `*报告*.docx`、`*论文*.docx`、`*设计*.doc` |
| 运行说明 | `运行说明.md`、`使用说明.md`、`HOW_TO_RUN.md` 等 |
| 源代码目录 | `src/`、`pages/`、`components/` 等 |

#### 🏗️ 平台构建配置文件（HarmonyOS 项目——必修，不是 AI 产物）

> **重要**：这些是 HarmonyOS 项目的核心构建配置，删除会导致 DevEco Studio 无法识别/编译项目。

| 文件 | 作用 |
|------|------|
| `build-profile.json5`（根目录） | 顶层构建配置：SDK 版本、签名、模块列表 |
| `hvigorfile.ts`（根目录） | 根目录 hvigor 构建任务入口 |
| `oh-package.json5`（根目录） | 根目录包依赖管理 |
| `hvigor/hvigor-config.json5` | hvigor 构建系统配置 |
| `entry/build-profile.json5` | entry 模块构建配置 |
| `entry/hvigorfile.ts` | entry 模块 hvigor 构建任务 |
| `entry/oh-package.json5` | entry 模块包依赖 |
| `entry/src/main/module.json5` | entry 模块声明（Stage 模型） |
| `entry/src/mock/mock-config.json5` | Mock 数据配置（开发用，视情况保留） |
| `AppScope/app.json5` | 应用全局配置（bundleName、版本等） |
| `code-linter.json5` | 代码检查配置（可选） |

#### 🏗️ 平台构建配置文件（Android 项目——必修）

| 文件 | 作用 |
|------|------|
| `build.gradle` / `build.gradle.kts` | 构建配置 |
| `settings.gradle` / `settings.gradle.kts` | 项目设置 |
| `gradle.properties` | Gradle 属性 |
| `local.properties` | 本地 SDK 路径（可排除，让用户自行配置） |

#### 💻 IDE 项目配置（保留核心，排除个人缓存）

**HarmonyOS（DevEco Studio）/ JetBrains IDE — `.idea/` 目录：**

| 文件 | 处理 |
|------|------|
| `modules.xml` | ✅ **COPY** — 项目模块列表 |
| `modules/*.iml` | ✅ **COPY** — 模块定义 + SDK 库引用，缺了 IDE 不认项目 |
| `workspace.xml` | ❌ SKIP — 个人窗口布局、打开文件记录 |
| `vcs.xml` | ❌ SKIP — 个人 Git 配置 |
| `.deveco/` | ❌ SKIP — DevEco Studio 缓存（打开项目时自动重建） |

#### ❌ AI 产物 & 无用文件（任何项目类型都 SKIP）

| 规则 | 示例 |
|------|------|
| AI 协作配置 | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.claude/`, `.reasonix/`, `.codegraph/`, `.github/copilot*` |
| Git 相关 | `.git/`, `.gitignore`, `.gitattributes` |
| 项目 README | `README.md`（通常含 AI 生成的项目结构说明，非提交必需） |
| AI 提示词文件 | `UI prompt.txt`，`prompt*.txt`，`*提示词*` 等 |
| 构建/生成脚本（非平台标准） | `scripts/`, `build_*.py`, `generate_*.py`, `fix_*.py`, `_fix_*.py` |
| 答辩/个人文档 | `答辩*.docx`, `defense*.docx`, `答辩*.md`, `答辩*.pptx` |
| 环境配置脚本 | `setup_env.ps1`, `setup.sh` |
| 临时/调试文件 | `fix_*.js`, `*_debug*`, `*.bak` |
| 打包产物 | `*.skill`, `*.zip`, `*.tar.gz`, `*.hap`（构建输出） |
| Node.js 工具配置 | `package.json`, `package-lock.json`（根目录的，非项目依赖） |
| 设计系统临时文档 | `UI设计系统*.md` 等（非正式论文/报告） |

#### 🧹 构建产物目录（递归排除）

| 目录 | 说明 |
|------|------|
| `build/` | 所有构建输出 |
| `.hvigor/cache/` | hvigor 构建缓存 |
| `.hvigor/outputs/` | hvigor 构建输出 |
| `.hvigor/report/` | hvigor 构建报告 |
| `.hvigor/dependencyMap/` | ⚠️ 灰色 — 保留可能有助于构建，但通常 hvigor 会自动重建 |

#### ⚠️ 灰色地带（询问用户）

- 根目录下的 `*.py` 文件——可能是主程序，也可能是辅助/修复脚本。列出让用户逐项确认。
- `requirements.txt` / `environment.yml`——有些课程要求提交依赖清单。
- `答辩PPT.pptx`——如果用户确认这是提交材料的一部分则纳入，否则排除。
- `.hvigor/dependencyMap/`——hvigor 依赖映射，DevEco Studio 通常会重建，但保留也无害。

### 第三步：向用户展示分类结果

在执行复制前，必须向用户展示分类摘要：

```
## [project-submit/] 将包含：
### 源代码
- src/main/ets/... (30 个 .ets 源文件)
### 构建配置
- build-profile.json5
- hvigorfile.ts
- ...
### 资源文件
- resources/... (9 个资源文件)
### IDE 配置
- .idea/modules/1.iml
- .idea/modules/entry.iml
- .idea/modules.xml
### 文档
- 课程设计报告.docx

## 将排除：
- CLAUDE.md (AI 配置)
- README.md (项目说明)
- .hvigor/cache/ (构建缓存)
- 答辩准备文档.docx (个人文档)
- UI prompt.txt (AI 提示词)

共 XX 个文件入版，YY 个文件排除。
```

灰色地带的文件单独列出，询问用户是否纳入。用户确认后再执行复制。

### 第四步：执行复制

```
project-submit/
├── (保持原始子目录结构，但去除空目录)
```

- 创建输出目录（纯 ASCII 命名）
- 对每个入选文件，保持其相对于项目根目录的路径结构
- 不复制空目录
- 不创建 `.gitkeep` 等多余文件
- 如果目标已存在，先删除再重建

### 第五步：复制后校验

复制完成后，对 HarmonyOS 项目必须做以下检查：

1. **构建配置完整性**：确认 `build-profile.json5`、`hvigorfile.ts`、`oh-package.json5`、`entry/build-profile.json5`、`entry/hvigorfile.ts` 全部到位
2. **SDK 版本一致性**：`build-profile.json5` 中的 `targetSdkVersion` 不能是 `"1"`（那意味着原始项目被 DevEco Studio 同步修正过，但提交版复制了旧值）。与原始项目对比确保一致
3. **`.idea/modules/1.iml` 含 SDK 引用**：必须包含 `<orderEntry type="module-library">` 中的 ArkTS SDK 库路径声明，否则 IDE 不认项目
4. **路径无中文**：确认输出目录路径的任何一段都不含中文字符

如果发现问题，自动修复或提请用户注意。

### 第六步：输出摘要

```
## 提交版已就绪

project-submit/ — X MB，Y 个文件
├── src/...
├── build-profile.json5
├── ...
├── .idea/ (modules only)
└── 课程设计报告.docx

用 DevEco Studio / 对应 IDE 打开 project-submit/ 即可编译运行。
可以直接将此文件夹打包上交，或将其中的文件提交到教学平台。
```

## 关键原则

- **输出目录 ASCII 化**：绝不用中文路径，默认 `project-submit/`
- **平台感知**：不同项目类型的"构建必需文件"定义不同，HarmonyOS 的 `.json5`/`.ts` 构建文件不是 AI 产物
- **IDE 配置保留核心**：`.idea/modules/` 是 IDE 识别项目的关键，保留；`workspace.xml`/`vcs.xml` 是个人配置，排除
- **复制后校验**：对比原始项目关键配置文件，确保版本号一致性，防止因文件版本差异导致构建失败
- **保守优先**：不确定的文件，宁可先问用户再决定，不要自作主张排除
- **保持原样**：不修改文件内容（校验发现错误除外），不重命名，只做纯复制
- **不要动原始项目**：只在输出子目录下操作
- **中文友好**：所有输出和中文字段名保持原样