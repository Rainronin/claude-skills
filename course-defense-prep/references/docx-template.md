# DOCX 生成脚本模板

## 依赖

```bash
npm install -g docx
```

## 模板骨架

参考下方结构生成 `scripts/generate-defense-docx.js`。脚本中使用以下常量：

```javascript
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        Header, Footer, AlignmentType, HeadingLevel, BorderStyle, WidthType,
        ShadingType, PageNumber, PageBreak, LevelFormat } = require('docx');

const CW = 9026;  // A4 纸张可用宽度 (DXA)
const F = "Microsoft YaHei";  // 正文字体
const FM = "Consolas";  // 代码等宽字体
```

## 工具函数模板

```javascript
function pp(text, opts = {}) { /* 段落生成 */ }
function h1(t) { /* 一级标题 */ }
function h2(t) { /* 二级标题 */ }
function h3(t) { /* 三级标题 */ }
function body(t, o = {}) { /* 正文 */ }
function bold(t) { /* 加粗文字 */ }
function bu(t) { /* 列表项 */ }
function code(t) { /* 代码块 */ }
function gap() { return pp(""); }
function page() { return new Paragraph({ children: [new PageBreak()] }); }
function tc(text, opts = {}) { /* 表格单元格 */ }
function tbl(header, rows, widths) { /* 表格 */ }
```

## 文档输出

```javascript
const doc = new Document({
  styles: { /* Heading1/2/3 样式覆盖 */ },
  numbering: { config: [{ reference: "bullets", /* 项目符号 */ }] },
  sections: [{
    properties: {
      page: {
        size: { width: 11906, height: 16838 },  // A4
        margin: { top: 1134, right: 1134, bottom: 1134, left: 1134 }
      }
    },
    headers: { default: new Header({ /* 页眉 */ }) },
    footers: { default: new Footer({ /* 页脚 + 页码 */ }) },
    children,  // 文档内容数组
  }],
});

const out = "<输出路径>/答辩准备文档.docx";
Packer.toBuffer(doc).then(buf => {
  fs.writeFileSync(out, buf);
  console.log(`✅ ${out}`);
});
```

## 常见陷阱

1. **引号转义** — 中文文本中出现的 ASCII 双引号 `"` 必须用 `\"` 转义，否则 JS 语法错误。推荐使用中文引号 `“` 和 `”` 替代。

2. **表格宽度** — 必须用 `WidthType.DXA`，不能用 `PERCENTAGE`（Google Docs 不兼容）。列宽之和必须等于表宽。

3. **单元格底色** — `shading: { fill: "...", type: ShadingType.CLEAR }`，不能用 `SOLID`（会导致黑色背景）。

4. **代码块** — 用等宽字体 + 灰色背景 + 左缩进模拟 IDE 效果。字号 19（约 9.5pt）。

5. **NODE_PATH** — Windows 用户需要 `NODE_PATH="$(npm root -g)"` 前缀才能找到全局安装的 docx 包。
