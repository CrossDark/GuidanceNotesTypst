// 本模板基于lib模板https://github.com/talal/ilm 使用DeepSeek修改而成

// 用于弥补缺少 `std` 作用域的工作区。
#let std-bibliography = bibliography
#let std-smallcaps = smallcaps
#let std-upper = upper

// 用增加字符间距的函数覆盖默认的 `smallcaps` 和 `upper` 函数。
// 默认的字间距（tracking）是 0pt。
#let smallcaps(body) = std-smallcaps(text(tracking: 0.6pt, body))
#let upper(body) = std-upper(text(tracking: 0.6pt, body))

// 模板中使用的颜色 - 更改为深色主题
#let stroke-color = luma(80)
#let fill-color = luma(30)

// 此函数获取整个文档作为其 `body`。
#let ilm(
  // 您作品的标题。
  title: [Your Title],
  // 作者姓名。
  author: "Author",
  // 使用的纸张尺寸。
  paper-size: "a4",
  // 将在封面页显示的日期。
  // 该值需要是 'datetime' 类型。
  // 更多信息: https://typst.app/docs/reference/foundations/datetime/
  // 示例: datetime(year: 2024, month: 03, day: 17)
  date: none,
  // 日期在封面页上显示的格式。
  // 更多信息: https://typst.app/docs/reference/foundations/datetime/#format
  // 默认格式将日期显示为: MMMM DD, YYYY
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",
  // 您作品的摘要。如果没有，可以省略。
  abstract: none,
  // 前言页的内容。这将显示在封面页之后。如果没有，可以省略。
  preface: none,
  // 调用 `outline` 函数的结果或 `none`。
  // 如果要禁用目录，请将其设置为 `none`。
  // 更多信息: https://typst.app/docs/reference/model/outline/
  table-of-contents: outline(),
  // 在正文之后、参考文献之前显示附录。
  appendix: (
    enabled: false,
    title: "",
    heading-numbering-format: "",
    body: none,
  ),
  // 调用 `bibliography` 函数的结果或 `none`。
  // 示例: bibliography("refs.bib")
  // 更多信息: https://typst.app/docs/reference/model/bibliography/
  bibliography: none,
  // 是否在新页开始章节。
  chapter-pagebreak: true,
  // 是否在外部链接旁边显示一个绛红色圆圈。
  external-link-circle: true,
  // 显示图（图像）的索引。
  figure-index: (
    enabled: false,
    title: "",
  ),
  // 显示表的索引
  table-index: (
    enabled: false,
    title: "",
  ),
  // 显示代码清单（代码块）的索引。
  listing-index: (
    enabled: false,
    title: "",
  ),
  // 您作品的内容。
  body,
) = {
  // 设置文档的元数据。
  set document(title: title, author: author)

  // 设置深色主题 - 黑色背景和白色文本
  set page(fill: black)
  set text(fill: white, size: 12pt)

  // 设置中文字体和深色主题文本颜色
  set text(font: ("SimSun", "SimHei", "Microsoft YaHei", "KaiTi", "STKaiti", "STSong"))

  // 设置原始文本字体及深色主题
  show raw: set text(font: ("Iosevka", "Fira Mono"), size: 9pt, fill: white)

  // 配置页面尺寸和边距。
  set page(
    paper: paper-size,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )

  // 深色主题的封面页。
  page(
    align(
      center,
      block(width: 90%)[
        // 顶部空白
        #v(10em)

        // 设置间距
        #let v-space = v(4em, weak: true)

        // 标题
        #text(3em, fill: white)[*#title*]

        // 作者
        #v-space
        #text(1.6em, fill: white, author)

        #if abstract != none {
          v-space
          block(width: 80%)[
            // 默认行高是 0.65em。
            #par(leading: 0.78em, justify: true, linebreaks: "optimized", abstract)
          ]
        }

        #if date != none {
          v-space
          text(fill: white, date.display(date-format))
        }
      ],
    ),
  )

  // 使用深色主题配置段落属性。
  set par(leading: 0.7em, spacing: 1.35em, justify: true, linebreaks: "optimized")

  // 在标题后添加垂直间距。
  show heading: it => {
    it
    v(2%, weak: true)
  }
  // 不对标题进行断字。
  show heading: set text(hyphenate: false, fill: white)

  // 在外部链接旁边显示一个浅色小圆圈（深色主题）。
  show link: it => {
    it
    // 针对 ctheorems 包的工作区，使其标签保持默认的链接样式。
    if external-link-circle and type(it.dest) != label {
      sym.wj
      h(1.6pt)
      sym.wj
      super(box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + rgb("#ff6666"))))
    }
  }

  // 将前言显示为第二页（深色主题）。
  if preface != none {
    page(preface)
  }

  // 显示目录（深色主题）。
  if table-of-contents != none {
    table-of-contents
  }

  // 配置页码和页脚（深色主题）。
  set page(
    footer: context {
      // 获取当前页码。
      let i = counter(page).at(here()).first()

      // 居中对齐
      let is-odd = calc.odd(i)
      let aln = center

      // 我们是否在开始新章节的页面上？
      let target = heading.where(level: 1)
      if query(target).any(it => it.location().page() == i) {
        return align(aln)[#i]
      }

      // 查找当前所在部分的章节。
      let before = query(target.before(here()))
      if before.len() > 0 {
        let current = before.last()
        let gap = 1.75em
        // 显示章节名称
        let chapter = upper(text(size: 0.7em, fill: white, current.body))
        if current.numbering != none {
          align(aln)[#chapter]
          align(aln)[#i]
        }
      }
    },
  )

  // 配置公式编号（深色主题）。
  set math.equation(numbering: "(1)")

  // 在内联代码的小框中显示，并保持正确的基线（深色主题）。
  show raw.where(block: false): box.with(
    fill: fill-color,
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // 显示带内边距的代码块（深色主题）。
  show raw.where(block: true): block.with(inset: (x: 5pt), fill: fill-color)

  // 跨页拆分大表格。
  show figure.where(kind: table): set block(breakable: true)
  set table(
    // 增加表格单元格的内边距
    inset: 7pt, // 默认为 5pt
    stroke: (0.5pt + stroke-color),
    fill: black,
  )
  // 对表头行使用小型大写字母（深色主题）。
  show table.cell.where(y: 0): smallcaps
  // 设置表格文本颜色为白色
  show table: set text(fill: white)

  // 将 `body` 用花括号包裹，使其拥有自己的上下文。这样 show/set 规则将仅适用于 body。
  {
    // 配置标题编号。
    set heading(numbering: "1.")

    // 在新页开始章节。
    show heading.where(level: 1): it => {
      if chapter-pagebreak {
        pagebreak(weak: true)
      }
      it
    }
    body
  }

  // 在参考文献之前显示附录（深色主题）。
  if appendix.enabled {
    pagebreak()
    heading(level: 1, fill: white)[#appendix.at("title", default: "附录")]

    // 对于附录中的标题前缀，标准约定是 A.1.1.
    let num-fmt = appendix.at("heading-numbering-format", default: "A.1.1.")

    counter(heading).update(0)
    set heading(
      outlined: false,
      numbering: (..nums) => {
        let vals = nums.pos()
        if vals.len() > 0 {
          let v = vals.slice(0)
          return numbering(num-fmt, ..v)
        }
      },
    )

    appendix.body
  }

  // 显示参考文献（深色主题）。
  if bibliography != none {
    pagebreak()
    show std-bibliography: set text(0.85em, fill: white)
    // 对参考文献使用默认段落属性。
    show std-bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto, fill: white)
    bibliography
  }

  // 显示图、表和代码清单的索引（深色主题）。
  let fig-t(kind) = figure.where(kind: kind)
  let has-fig(kind) = counter(fig-t(kind)).get().at(0) > 0
  if figure-index.enabled or table-index.enabled or listing-index.enabled {
    show outline: set heading(outlined: true)
    context {
      let imgs = figure-index.enabled and has-fig(image)
      let tbls = table-index.enabled and has-fig(table)
      let lsts = listing-index.enabled and has-fig(raw)
      if imgs or tbls or lsts {
        // 注意，我们只分页一次，而不是为每个单独的索引分页。这是因为对于只有少量图的文档，在每个索引处都开始新页会导致过多的空白。
        pagebreak()
      }

      if imgs {
        outline(
          title: figure-index.at("title", default: "图表索引"),
          target: fig-t(image),
        )
      }
      if tbls {
        outline(
          title: table-index.at("title", default: "表格索引"),
          target: fig-t(table),
        )
      }
      if lsts {
        outline(
          title: listing-index.at("title", default: "代码索引"),
          target: fig-t(raw),
        )
      }
    }
  }
}

// 此函数将其 `body`（内容）格式化为一个块引用（blockquote），适用于深色主题。
#let blockquote(body) = {
  block(
    width: 100%,
    fill: fill-color,
    inset: 2em,
    stroke: (y: 0.5pt + stroke-color),
    body,
  )
}
