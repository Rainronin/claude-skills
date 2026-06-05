# Claude Code 开发工作流程说明书

> 一份通用的、新手也能看懂的 Claude Code 使用指南，尤其适合大学生写作业。照着这个流程走，零基础也能高效完成项目开发。

---

## 零、前置准备：安装 Skill 和插件

使用这套工作流程之前，需要先给你的 Claude Code 装上以下 Skill 和插件。打开终端，逐条执行安装命令即可。

### 必装（核心工作流依赖）

在 Claude Code 中输入以下指令，让它帮你安装：

```
帮我安装以下 Skill，全部装到全局：
- superpowers 插件
- frontend-design
- docx、pptx、xlsx、pdf（文档处理四件套）
- neat-freak
- find-skills
```

Claude Code 会自动执行 `npx skills add` 命令逐个安装。你只需要确认即可。

### 推荐安装（提升效率）

```
再帮我装几个可选的：
- mysql（数据库操作）
- submission-cleaner（提交前清理）
- 答辩（答辩准备）
- ppt-master（高级 PPT 生成）
- web-access（联网搜索）
```

### 验证安装

在 Claude Code 中输入：

```
检查一下我装的 Skill 是否都正常
```

Claude Code 会运行检查并告诉你结果。

---

## 零-B、配置全局规则

Skill 装好后，还需要告诉 Claude Code **什么时候用、怎么用**。以下是我使用的全局规则，建议你直接复制到你的 Claude Code 全局配置文件中。

### 怎么配置？

在 Claude Code 中输入：

```
帮我把以下规则写入全局 CLAUDE.md 配置文件，保存到 ~/.claude/CLAUDE.md：
```

然后把下面的规则内容粘贴过去。Claude Code 会自动找到配置文件路径并写入。

> ╔══════════════════════════════════════════════════════════════╗
> ║  📋  以下是需要复制的内容 —— 从这行开始                     ║
> ╚══════════════════════════════════════════════════════════════╝

```markdown
# 技能触发规则（最高优先级）

- **每次对话开始时，必须先调用 superpowers 技能** — 这不是可选项，是强制步骤
- 在任何回复、任何操作、任何代码之前，先用 Skill 工具加载 superpowers
- 即使只是简单问题、闲聊、澄清问题，也必须先触发此技能
- 该技能会引导你发现并调用其他相关技能 — 这是技能系统的入口，跳过它意味着你可能遗漏关键技能
- **红牌警示**：以下想法都是在找借口，必须停止——
  "这只是个简单问题" / "我先看看情况" / "不需要这么正式" /
  "我记得这个技能内容" / "这不算是任务" — 有技能就要先用

# superpowers 插件强制触发规则

- **superpowers 是一个技能插件套件**，内含多个子 skill：
  `superpowers:brainstorming`、`superpowers:systematic-debugging`、
  `superpowers:writing-plans`、`superpowers:verification-before-completion`、
  `superpowers:requesting-code-review`、`superpowers:test-driven-development`、
  `superpowers:dispatching-parallel-agents`、`superpowers:executing-plans`、
  `superpowers:finishing-a-development-branch`、`superpowers:receiving-code-review`、
  `superpowers:subagent-driven-development`、`superpowers:using-git-worktrees` 等
- **每次收到 `/superpowers` 或 `/using-superpowers` 指令时**，必须执行完整的 skill 扫描流程，无一例外：
  1. 扫描所有顶层 skill（frontend-design、docx、pptx、xlsx、neat-freak 等）—— ≥1% 匹配即触发
  2. 扫描所有 `superpowers:*` 子 skill（brainstorming、systematic-debugging、writing-plans 等）—— ≥1% 匹配即触发
  3. 两者不可互相替代，不可因为"用了顶层就不用子 skill"或反之
  4. 扫描时必须**逐项判断**，不可批量跳过
- **禁止因为"任务太简单"而省略扫描** — 这是开发规范，不是可选项。
  哪怕只是改一行 CSS、修一个拼写错误、回答一个确认性问题，也必须走完整扫描流程
- **红牌警示**（再次强调，因为这是最容易犯的错）：
  - "这只是简单 bug 修复不需要 skill 扫描" → 借口，立刻停下
  - "改几行 CSS 不需要触发 frontend-design" → 借口，立刻停下
  - "我问个问题不需要走流程" → 借口，立刻停下
  - "superpowers 只是方法论不是插件" → 错误认知，它是一个完整的插件套件

# 技能匹配强制扫描规则

- **在任何实质性操作之前（写代码、创建文件、搜索代码、分析问题、生成内容等），
  必须先扫描当前可用的技能列表，逐一判断是否匹配当前任务。**
- **匹配标准极低**：只要存在 ≥ 1% 的可能性某个 skill 适用于当前任务，就必须调用该 skill。
  宁可多触发一个不需要的 skill，也不能漏掉一个需要的 skill。
- **禁止凭直觉跳过**：不得依靠"我觉得这个不需要"、"这太简单了"、"我直接能做"来自行豁免。
  只有扫描完技能列表、确认无一匹配后，才能直接动手。
- **此规则覆盖所有交互场景**：不只是新任务开始时，对话中途用户追加需求、改变方向、
  提出新问题时，也必须重新扫描技能列表。
- **红牌警示**："我先写代码再调用 skill" / "这个太简单了不需要 skill" /
  "我知道有这个 skill 但这次应该用不上" / "先做一点再调用也不迟" /
  "用户没明确提到那个 skill 名" — 全部都是借口。

# 文件类型强制触发规则

当操作涉及以下文件类型时，**必须调用对应 skill**，即使你觉得自己能直接处理：
- `.docx` 文件 → 调用 `docx` skill
- `.pptx` 文件 → 调用 `pptx` skill
- `.xlsx` / `.xlsm` / `.csv` / `.tsv` 文件 → 调用 `xlsx` skill
- `.pdf` 文件 → 调用 `pdf` skill

**触发条件**：读取、创建、编辑、转换、提取内容——任何触碰这些文件的操作都要触发。
**红牌警示**："Read 工具就能读" / "我直接写个 Python 脚本" / "文件很小不用走 skill" — 都是借口，必须用 skill。

# 全局语言规范

- 所有对话和文档都使用中文
- 代码注释使用中文
- 错误提示使用中文
- 文档统一使用中文 Markdown 格式
```

> ╔══════════════════════════════════════════════════════════════╗
> ║  📋  复制内容到此结束                                       ║
> ╚══════════════════════════════════════════════════════════════╝

写入后重启 Claude Code 会话，规则就生效了。

> 💡 之后每次打开 Claude Code，它都会自动遵循这套规则。

---

## 先搞懂几个概念

### Claude Code 是什么？

Claude Code 是 Anthropic 推出的 AI 编程助手，能帮你写代码、修 Bug、生成文档。你通过对话告诉它要做什么，它会直接操作文件、运行命令、创建项目。

### Skill（技能）是什么？

Skill 是 Claude Code 的"专业工具箱"。每个 Skill 专精一个领域——比如 `docx` 专门处理 Word 文档，`frontend-design` 专门设计网页界面。触发 Skill 后，Claude Code 会按照该领域的专业流程来工作，而不是用通用方式瞎搞。

### /superpowers 是什么？

`/superpowers` 是一个**插件套件**，内含十多个子技能（如代码审查、Bug 调试、写计划、验证完成等）。每次输入 `/superpowers`，Claude Code 会自动扫描所有可用的 Skill，判断哪些对你的任务有帮助，然后触发它们。

### 洁癖检查（neat-freak）是什么？

项目做久了会积累垃圾——临时文件、过时的配置、写了一半的代码。洁癖检查就是让 Claude Code 系统性地审查整个项目，删除废弃文件、同步文档、更新记忆，确保项目始终干干净净。

**⚠️ 为什么洁癖检查非常重要？**

这不是可选的收尾动作，而是**保证项目可维护性的核心机制**：

- **防止上下文漂移**：你改了代码但 CLAUDE.md 没更新 → 下次开 Claude Code，它看到的是过时的文档 → 基于错误信息做决策 → 写出冲突的代码
- **防止垃圾堆积**：下载了临时脚本、生成了测试文件、废弃了旧 Servlet → 如果不清理，提交到 GitHub 时老师看到一堆无用文件会觉得你不专业
- **保证团队协作**：CLAUDE.md 和 README.md 是给下一个接手的人（或者明天的你自己）看的。代码可以随时重写，但文档和记忆是跨会话的唯一桥梁
- **每次大动作后必做**：框架搭建完 → 洁癖。修完一轮 Bug → 洁癖。文档生成完 → 洁癖。收工前 → 洁癖。积少成多比最后一次性清理轻松 10 倍

> 💡 一句话总结：**洁癖检查做少了，项目会慢慢腐烂；每次做完就查，项目永远像新的一样。**

### Plan 模式是什么？

Plan 模式是"先讨论方案，再动手写代码"的工作方式。你告诉 Claude Code 想做什么 → 它探索代码库 → 制定计划 → 你审批 → 开始实施。避免"写完才发现方向错了"。

---

## 标准工作流程（五步法）

### 第一步：启动项目 🚀

**操作步骤（按顺序）：**

1. **在项目文件夹中打开 Claude Code，选择 Plan 模式**
   - Plan 模式下 Claude Code 只能读文件、讨论方案，不会修改任何代码
   - 不要选 Auto 模式——那会让它跳过讨论直接动手

2. **在输入框手动输入 `/superpowers` + 你的需求**
   ```
   /superpowers 帮我搭建一个会议室预约系统的框架
   ```
   - 注意：是你手动输入 `/superpowers`，不是 Claude Code 自己决定
   - 把需求描述一并带上，越具体越好（选题、人数、技术栈等）

3. **和 Claude Code 讨论方案**
   - 它会扫描可用 Skill，触发匹配的（如 `brainstorming`、`writing-plans`）
   - 它可能问你几个问题（技术栈、功能范围、团队分工等），逐一回答
   - 方案写入计划文件，你可以随时查看

4. **审批计划，进入自动化**
   - Claude Code 会调用 `ExitPlanMode` 让你审批
   - 你点"批准" → Claude Code 退出 Plan 模式 → 进入 Auto 模式 → **自动按计划开始写代码**
   - 之后的创建目录、写配置文件、写源代码、搭建数据库……全是自动化的

**关键动作：**
- 如果有需求文档（.docx / .pdf），第一步就拖进项目文件夹，Claude Code 读取时会自动触发对应 Skill
- 回答问题时尽量明确（如"选题三：会议室预约，4 人小组，Java + MySQL"）

**完成后：**
```
输入: 洁癖检查
```
Claude Code 会建立项目文档体系（CLAUDE.md、README.md、Agent 记忆），清理临时文件。这一步不能跳过——没有 CLAUDE.md，下次开 Claude Code 它就不记得这个项目是怎么设计的。

---

### 第二步：搭建环境 ⚙️

**你做什么：**
告诉 Claude Code 你的需求：`帮我配置数据库` / `帮我在 VS Code 中运行这个项目`

**Claude Code 做什么：**
- 检测本机环境（有没有装 JDK、Node.js、MySQL 等）
- 缺少的组件自动安装（通过 winget / npm 等包管理器）
- 配置运行脚本（如 `npm run dev`、`mvn tomcat7:run`）
- 启动项目并在浏览器中验证

**你会看到：**
- 环境检测结果
- 安装进度
- 最终确认"项目已成功运行在 http://localhost:XXXX"

**小技巧：**
如果项目需要在机房/别人电脑上运行，提前告诉 Claude Code"机房环境不确定"——它会准备兼容方案（如嵌入式数据库、Maven Wrapper 等自包含方案）。

---

### 第三步：开发迭代 🔄

这是最核心的阶段，也是一轮轮"审查 → 修 Bug → 洁癖"的循环。

#### 3.1 代码审查

**触发方式：**
```
/superpowers review一遍代码检查
```

**Claude Code 做什么：**
1. 触发 `superpowers:requesting-code-review` + `code-review` 两个 Skill
2. 从 7 个角度（逐行扫描、边界检查、跨文件追踪、复用检查、简化机会、效率问题、架构审查）全面检查代码
3. 输出 10 条左右的发现，按严重程度排序：
   - 🔴 Critical：必须立即修复（如安全漏洞）
   - 🟠 Important：应该修复（如业务逻辑缺陷）
   - 🟡 Minor：建议修复（如代码风格问题）

**你做什么：**
1. 查看审查报告
2. 告诉 Claude Code "逐一修复"或指定修复哪些

#### 3.2 Bug 修复

**触发方式：**
```
/superpowers 用户登录后主页还显示登录按钮，逻辑不对
```
直接描述 Bug 表现即可，Claude Code 会自动触发 `systematic-debugging` 进入修复流程。

**Claude Code 做什么：**
1. 触发 `superpowers:systematic-debugging`
2. 按四阶段修复：找根因 → 分析模式 → 形成假设 → 实施修复
3. 修复后编译验证 → 运行验证
4. 提交 Git 并推送

**你做什么：**
- 如果发现 Bug，先自己在浏览器/终端里验证一遍
- 清楚描述 Bug 的表现（"点击 X 按钮后，页面显示 Y，但预期应该是 Z"）
- 修复后在浏览器里确认

#### 3.3 每轮迭代后的洁癖 ⚠️ 必做

```
输入: 洁癖检查
```

**这是最容易偷懒跳过的步骤，也是最重要的步骤。** 每修完一轮 Bug、每完成一个功能模块，立刻做洁癖检查。

会检查：
- 项目文档（CLAUDE.md）路由表、技术版本号是否和代码一致
- 有没有遗留的临时脚本、测试文件、废弃的 Servlet/JSP
- Agent 记忆是否需要更新（新增的路由、修改的数据库字段）
- Git 工作区是否干净、推送是否成功

**为什么不能攒到最后？** 攒了 10 轮变更后一次性洁癖 = 面对 100 行需要判断的改动 = 容易遗漏 = 文档和代码脱节。每轮做 = 每次只处理 5-10 行 = 轻松不出错。

---

### 第四步：生成文档 📄

项目代码完成后，需要生成课程/答辩所需的文档。

#### 4.1 项目设计文档（Word）

**你做什么：**
```
告诉 Claude Code: 帮我生成课程设计文档，按以下结构——
一、项目概述 二、需求分析 三、系统设计 四、系统实现 五、测试 六、总结
```

**Claude Code 做什么：**
- 从项目代码中提取关键信息（架构、数据库表、核心代码片段）
- 用 `frontend-design` 设计视觉风格
- 用 `docx` Skill 生成 .docx 文件
- 代码块用等宽字体、表格有表头着色、封面有标题/成员信息
- 需要截图的地方留 `[请在此处插入截图]` 占位标记

#### 4.2 答辩 PPT

**你做什么：**
```
告诉 Claude Code: 帮我做答辩 PPT，页数大概 N 页，配色和项目一致
```

**重要提醒：**
- PPT 是给评委看的，**不能出现**"课程要求""评分标准""考核内容"等字眼
- 内容要专业：功能展示 + 技术亮点 + 架构图 + 代码片段
- 去掉"总结与收获""Q&A"页面，演示结束直接结束页

**Claude Code 做什么（推荐用 ppt-master）：**
1. Strategist 阶段：确认配色/字体/页数/风格
2. Executor 阶段：逐页手写 SVG 生成幻灯片
3. 质量检查 → 后处理 → 导出 PPTX

#### 4.3 答辩准备文档（内部使用）

**你做什么：**
```
输入: /答辩
或: 调用答辩skill，生成一份答辩准备文档
```

**这份文档包含（不公开，自己看的）：**
- 30 秒项目概述（电梯演讲）
- 核心知识点详解（每个知识点对应项目代码位置）
- 高频面试题 Q&A（含追问链，评委可能连续问三个层次）
- PPT 逐页提问预判（评委看到第 N 页可能问什么）
- 答辩前 5 分钟速查卡（14 条一句话应答）
- 演示前自检清单（逐项打勾）

---

### 第五步：收尾 🎯

#### 5.1 最终代码审查

```
输入: /superpowers review一遍代码检查
```

确认所有已修复、无遗漏。

#### 5.2 最终洁癖检查 ⚠️ 收工前必做

```
输入: 洁癖检查
```

这是项目交付前的最后一道关卡。Claude Code 会机械式地逐文件审查，确保：

- [ ] CLAUDE.md 路由表、技术版本号与代码完全一致
- [ ] README.md 的安装/运行步骤可以真实执行
- [ ] .gitignore 正确排除了 target/、node_modules/、preview.html 等
- [ ] 无废弃文件（已删除的 Dashboard Servlet/JSP、临时脚本 .ps1）
- [ ] 无相对时间残留（不能有"今天""昨天""最近"）
- [ ] Git 工作区干净，无未提交变更
- [ ] Git 远程已同步（`git log --oneline` 的 HEAD = origin/master）
- [ ] Agent 记忆系统（MEMORY.md + 记忆文件）与项目现状一致

**为什么最终洁癖不能省？** 这是你交作业/提交代码前的最后检查。一个干净的项目让老师/面试官觉得你专业；一个残留着 `get-maven.ps1`、`test-output.html`、废弃 `dashboard.jsp` 的项目让人觉得你做事不认真。

#### 5.3 交付物确认

确保以下文件都在项目根目录（或你知道在哪）：
- 项目源代码（已推送 GitHub）
- 课程设计文档 .docx
- 答辩 PPT .pptx
- 答辩准备文档 .docx（可选）

---

## 附录 A：常用 Skill 速查

| 你要做什么 | 用什么 Skill / 命令 |
|-----------|-------------------|
| 开始任何工作 | `/superpowers` |
| 多步骤复杂任务 | `superpowers:writing-plans` |
| 代码审查 | `superpowers:requesting-code-review` |
| 修 Bug | `superpowers:systematic-debugging` |
| 创意设计讨论 | `superpowers:brainstorming` |
| 验证工作完成 | `superpowers:verification-before-completion` |
| 整理项目文档 | `neat-freak` 或 `/neat-freak` |
| 设计网页界面 | `frontend-design` |
| 处理 Word 文档 | `docx` |
| 处理 PPT 幻灯片 | `pptx` 或 `ppt-master` |
| 处理 Excel 表格 | `xlsx` |
| 处理 PDF 文件 | `pdf` |
| 数据库操作 | `mysql` |
| 生成答辩准备 | `答辩` |
| 清理提交版本 | `submission-cleaner` |
| 安装新 Skill | `find-skills` |
| Git 工作隔离 | `superpowers:using-git-worktrees` |

## 附录 B：红牌警示 🟥

以下想法在任何情况下都是**借口**，必须停止：

| 借口 | 真相 |
|------|------|
| "这只是简单问题，不需要 Skill" | 简单问题也有对应的专业做法 |
| "我先看看情况" | Skill 扫描优先于任何操作 |
| "我记得 Skill 内容" | Skill 会更新，每次都要重新加载 |
| "这不算是任务" | 任何实质性操作都是任务 |
| "先做一点再调用也不迟" | 晚了——错误方向已经走出去了 |

---

> 📅 最后更新：2025-06-05  
> 💡 使用方法：下次开新项目，直接复制到项目根目录作为参考，或写入全局 CLAUDE.md 作为永久规则。
