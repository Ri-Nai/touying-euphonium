# 🎺 吹响吧！上低音号 - Touying 主题模板

基于 Typst 和 Touying 框架开发的演示文稿主题模板，灵感源自《吹响吧！上低音号》动画作品。通过现代排版系统实现优雅的演示文稿设计，适配学术汇报与创意展示场景。

## ✨ 灵感来源：  
[Touying](https://touying-typ.github.io/) 的 [aqua](https://touying-typ.github.io/zh/docs/themes/aqua/) 与 [stargazer](https://touying-typ.github.io/zh/docs/themes/stargazer/) 主题

## 📸 主题截图

|                                   功能演示                                   |                       页面效果                        |
| :--------------------------------------------------------------------------: | :---------------------------------------------------: |
|                 ![封面设计](./docs/imgs/cover.png) 封面设计                  | ![便笺大纲](./docs/imgs/sticky-outlines.png) 便笺大纲 |
| ![带背景的焦点页](./docs/imgs/focus-page-with-background.png) 带背景的焦点页 | ![简约焦点页](./docs/imgs/focus-page.png) 简约焦点页  |
|                  ![目录页](./docs/imgs/contents.png) 目录页                  |      ![正文页](./docs/imgs/body-page.png) 正文页      |

## 🚀 快速使用

### 基础配置
在项目根目录中新建 `.typ` 文件：

```typst
// 导入主题模板
#import "touying-euphonium.typ": *

// 应用主题配置
#show: euphonium-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [标题文本/内容块],      // 主标题
    subtitle: [副标题内容],       // 副标题
    institution: [机构名称],      // 组织单位
    author: [默认作者],          // 单作者模式
    authors: ([作者1], [作者2]),  // 多作者模式
    date: datetime(...),        // 日期格式
  )
)
```

以下是对 README 中内置函数部分的润色建议：

---

### 内置函数集

>[!CAUTION]
>使用带有 `background-image` 参数的函数会导致编译速度变慢，建议在需要时使用。

#### 1. 标题页
```typst
// 基础标题页
#title-slide()

// 自定义背景标题页
#title-slide(
  background-image: (
    path: "path/to/image.jpg",  // 图片路径（必填）
    alpha: 50%,                 // 透明度（0%-100%）
  ),
)
```

#### 2. 焦点内容页
```typst
// 基础焦点页
#focus-slide()[你的内容]

// 带背景焦点页
#focus-slide(
  background-image: (
    path: "path/to/image.jpg",
    alpha: 50%,
  ),
)[你的内容]
```

#### 3. 导航页
```typst
// 标准目录页
#outline-slide()

// 便笺风格目录页（自定义样式）
#sticky-custom-outlines()
```

#### 4. 通用幻灯片
```typst
// 基础幻灯片
#slide()[你的内容]

// 背景图幻灯片
#slide(
  background-image: (
    path: "path/to/image.jpg",
    alpha: 50%,
  ),
)[你的内容]
```

