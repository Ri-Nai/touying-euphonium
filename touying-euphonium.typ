#import "@preview/touying:0.5.5": *
#import "@preview/grayness:0.2.0": *

#let _tblock(self: none, title: none, it) = {
  grid(
    columns: 1,
    row-gutter: 0pt,
    block(
      fill: self.colors.primary-dark,
      width: 100%,
      radius: (top: 6pt),
      inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em),
      text(fill: self.colors.neutral-lightest, weight: "bold", title),
    ),

    rect(
      fill: gradient.linear(self.colors.primary-dark, self.colors.primary.lighten(90%), angle: 90deg),
      width: 100%,
      height: 4pt,
    ),

    block(
      fill: self.colors.primary-light.lighten(90%),
      width: 100%,
      radius: (bottom: 6pt),
      inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em),
      it,
    ),
  )
}
#let tblock(title: none, it) = touying-fn-wrapper(_tblock.with(title: title, it))

#let outline-slide(
  config: (:),
  title: utils.i18n-outline-title,
  numbered: true,
  level: none,
  depth: 2,
  align: left + horizon,
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = title
  touying-slide(
    self: utils.merge-dicts(
      self,
      config-page(
        header: self.store.header-background.with(title: utils.call-or-display(self, self.store.title)),
        footer: self.store.footer,
        background: utils.call-or-display(self, self.store.background),
      ),
    ),
    config: config,
    std.align(
      align,
      components.adaptive-columns(
        underline(
          stroke: 0.5em + self.colors.primary-lighter.opacify(-80%),
          evade: false,
          // radius: 0.5em,
          // offset: 0.5em,
        )[
          #text(
            fill: self.colors.primary-darkest,
            size: 1em,
            weight: "bold",
            components.custom-progressive-outline(
              level: level,
              indent: (0em, 1em),
              vspace: (1em, 0.1em),
              numbered: (numbered,),
              text-size: (1.2em, 0.8em, 0.6em),
              depth: depth,
              ..args.named(),
            ),
          )],
      )
        + args.pos().sum(default: none),
    ),
  )
})


#let sticky-custom-outlines(
  text-size: (1.5em, 1.2em, 0.8em),
  title: utils.i18n-outline-title,
  columns: none,
  numbered: true,
  level: none,
  config: (:),
  ..args,
) = touying-slide-wrapper(self => {
  self.store.title = title
  touying-slide(
    self: utils.merge-dicts(
      self,
      config-page(
        header: self.store.header-background.with(title: utils.call-or-display(self, self.store.title)),
        footer: self.store.footer,
        background: utils.call-or-display(self, self.store.background),
      ),
    ),
    config: config,
    context {
      set text(weight: "bold")
      let show-heading = it => {
        let current-heading = it
        let next-headings = query(
          heading.where(level: current-heading.level).after(inclusive: false, current-heading.location()),
        )
        let show-headings = query(heading.where().after(inclusive: false, current-heading.location()))
        if next-headings != () {
          let next-heading = next-headings.at(0)
          show-headings = query(
            heading
              .where()
              .after(inclusive: false, current-heading.location())
              .before(inclusive: false, next-heading.location()),
          )
        }
        align(
          center,
          box(
            outset: (x: 0.5em, y: 0.5em),
            inset: (x: 0.5em, y: 1.5em),
            width: 100%,
            // height: 100%,
            {
              set align(center)
              set text(fill: self.colors.primary-darkest)
              link(
                current-heading.location(),
                text(
                  size: text-size.at(current-heading.level - 1),
                  current-heading.body,
                ),
              )
              set align(left)
              components.adaptive-columns(
                show-headings
                  .map(it => link(
                    it.location(),
                    h(1em * (it.level - 2))
                      + text(
                        size: text-size.at(it.level - 1),
                        it.body,
                      ),
                  ))
                  .join(linebreak()),
              )
            },
          ),
        )
      }

      let show-headings = query(heading.where(level: 1))

      grid(
        fill: self.colors.primary-lightest,
        columns: if columns != none {
          columns
        } else {
          calc.min(show-headings.len(), 5) * (1fr,)
        },
        stroke: 1pt + self.colors.primary-light,
        row-gutter: 1em,
        column-gutter: 1em,
        ..show-headings.map(show-heading)
      )
    },
  )
})

#let new-section-slide(
  config: (:),
  title: utils.i18n-outline-title,
  level: 1,
  numbered: true,
  ..args,
  body,
) = outline-slide(
  config: config,
  title: title,
  level: level,
  numbered: numbered,
  ..args,
  body,
)


#let shadowed-text(shadow-color: gray, offset: (0.1em, 0.05em), it) = {
  box({
    place(
      dx: offset.at(0),
      dy: offset.at(1),
      align(center, text(fill: rgb(shadow-color), it)),
    )
    text(stroke: shadow-color + 0.8pt)[#it]
  })
}

#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      header: self.store.header-background.with(title: none),
      background: utils.call-or-display(
        self,
        self.store.background,
      ),
    ),
    config,
  )
  self.store.title = none
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    show: std.align.with(center)
    box(
      // fill: self.colors.primary-lightest,
      inset: (bottom: 1em),
      radius: 0.5em,
      {
        // let title-color = rgb("#F7FC0D")
        set text(
          fill: self.colors.title-color,
          font: ("Noto Sans CJK SC", "Noto Sans SC", "Arial"),
          size: 2em,
          weight: 1000,
        )
        shadowed-text(
          shadow-color: self.colors.primary,
          offset: (0.1em, 0.04em),
          info.title,
        )
        if info.subtitle != none {
          parbreak()
          set text(fill: self.colors.primary)
          shadowed-text(
            shadow-color: self.colors.title-color.darken(15%),
            offset: (0.07em, 0.04em),
            info.subtitle,
          )
          // text(size: 1.0em, fill: self.colors.neutral-lightest, weight: "bold", info.subtitle)
        }
      },
    )

    set text(fill: self.colors.primary-darker, weight: "bold")

    // authors
    place(
      dy: -2em,
      image("assets/header.png", height: 4em),
    )
    grid(
      columns: (1fr,) * calc.min(info.authors.len(), 3),
      column-gutter: 1em,
      row-gutter: 1em,
      ..info.authors.map(author => text(1.2em, author)),
    )
    v(0.5em)
    // institution
    if info.institution != none {
      parbreak()
      text(size: 1.2em, info.institution)
    }
    // date
    if info.date != none {
      parbreak()
      text(size: 1.0em, info.date.display("[year] 年 [month] 月 [day] 日"))
    }
  }
  touying-slide(self: self, body)
})

#let focus-slide(
  config: (:),
  align: horizon + center,
  background-image: none,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      // fill: self.colors.primary,
      margin: 2em,
      header: none,
      footer: none,
      background: utils.call-or-display(
        self,
        self.store.background.with(background-image: background-image),
      ),
    ),
  )

  show text: it => {
    set text(
      fill: self.colors.title-color,
      font: ("Noto Sans CJK SC", "Noto Sans SC", "Arial"),
      size: 4em,
      weight: 1000,
    )
    shadowed-text(
      shadow-color: self.colors.primary,
      offset: (0.1em, 0.04em),
      it,
    )
  }
  touying-slide(
    self: self,
    config: config,
    std.align(
      align,
      {
        place(
          left + horizon,
          // dx: -2em,
          dy: -1em,
          std.align(
            block(
              image(
                "assets/header.png",
                width: 100%,
                height: 70%,
              ),
              width: 100%,
              height: 100%,
              // overflow: hidden,
            ),
          ),
        )
        body
      },
    ),
  )
})

#let slide(
  title: auto,
  background-image: none,
  ..args,
) = touying-slide-wrapper(self => {
  if title != auto {
    self.store.title = title
  }

  // set page
  let footer(self) = {
    set align(bottom)
    show: pad.with(.4em)
    set text(fill: self.colors.neutral-lightest, size: .8em)
    utils.call-or-display(self, self.store.footer)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
  }


  self = utils.merge-dicts(
    self,
    config-page(
      header: self.store.header-background,
      footer: self.store.footer,
      background: utils.call-or-display(
        self,
        self.store.background.with(background-image: background-image),
      ),
    ),
  )
  touying-slide(
    self: self,
    ..args,
  )
})


#let euphonium-theme(
  aspect-ratio: "16-9",
  font-size: 20pt,
  font: ("Noto Serif SC", "Times New Roman", "SimSun"),
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 5em, bottom: 2em, x: 2em),
      header-ascent: 2.7em,
    ),
    config-common(slide-fn: slide),
    config-methods(
      alert: utils.alert-with-primary-color,
      tblock: _tblock,
      init: (self: none, body) => {
        // set text(fill: self.colors.primary-dark, size: 0.8em)
        set text(font: font, size: font-size)
        set list(marker: image("assets/euphonium-logo.png", width: 0.8em))
        show figure.caption: set text(size: 0.6em)
        show footnote.entry: set text(size: 0.6em)
        show heading: set text(fill: self.colors.primary)
        show link: it => if type(it.dest) == str {
          set text(fill: self.colors.primary)
          it
        } else {
          it
        }
        show figure.where(kind: table): set figure.caption(position: top)

        body
      },
    ),
    config-colors(
      primary: rgb("#00B1CF"),
      primary-light: rgb("#4DCFE0"),
      primary-lighter: rgb("#9DECF2"),
      primary-lightest: rgb("#E6F9FC"),
      primary-dark: rgb("#007A8D"),
      primary-darker: rgb("#005A6E"),
      primary-darkest: rgb("#003B4A"),

      neutral-lightest: rgb("#F5F5F5"),
      neutral-darkest: rgb("#3F3F3F"),

      title-color: rgb("#F7FC0D"),
    ),
    config-common(new-section-slide-fn: new-section-slide),
    config-store(
      title: none,
      background-image: none,
      header-background: (self, title: auto) => {
        set align(top)
        set align(center)
        show: components.cell.with(height: 250%, width: 90%, inset: 1em)
        place(dx: -1em, dy: 1em, image("assets/header.png", width: 2em + 100%, height: 2em))
        set align(horizon)
        set align(left)
        h(5em)
        set text(fill: self.colors.primary, size: 1.2em)
        if title == none { } else if title == auto {
          utils.display-current-heading(level: 1)
          utils.call-or-display(self, "  |  ")
          if self.store.title != none {
            utils.call-or-display(self, self.store.title)
          } else {
            utils.display-current-heading(level: 2)
          }
        } else {
          title
        }
      },
      footer: self => {
        show: pad.with(.4em)
        set text(fill: self.colors.primary-dark, size: 0.8em)
        set align(bottom)

        self.info.institution
        h(1fr)
        self.info.author
        h(1fr)
        self.info.title
        h(1fr)
        self.info.date.display("[year] 年 [month] 月 [day] 日")
        h(1fr)
        set text(fill: self.colors.neutral-lightest)
        context utils.slide-counter.display() + " / " + utils.last-slide-number
      },
      margin: (
        top: 4.5em,
        bottom: 2em,
        x: 2em,
      ),
      header-ascent: 2.2em,
      background: (self, background-image: none) => {
        if background-image == none {
          background-image = self.store.background-image
        }
        let page-width = if self.page.paper == "presentation-16-9" { 841.89pt } else { 793.7pt }
        let r = if self.at("show-notes-on-second-screen", default: none) == none { 1.0 } else { 0.5 }
        if background-image != none {
          place(
            top + left,
            transparent-image(
              read(
                background-image.path,
                encoding: none,
              ),
              alpha: background-image.alpha,
              width: 100%,
              height: 100%,
            ),
          )
        }
        let bias1 = -page-width * (1 - r)
        let bias2 = -page-width * 2 * (1 - r)
        place(left + top, dx: -15pt, dy: -26pt, circle(radius: 40pt, fill: self.colors.primary))
        place(left + top, dx: 65pt, dy: 12pt, circle(radius: 19pt, fill: self.colors.primary))
        place(left + top, dx: r * 1.3%, dy: 12%, circle(radius: 15pt, fill: self.colors.primary))
        place(left + top, dx: r * 2.5%, dy: 20%, circle(radius: 8pt, fill: self.colors.primary))
        place(right + bottom, dx: 15pt + bias2, dy: 26pt, circle(radius: 40pt, fill: self.colors.primary))
        place(right + bottom, dx: -65pt + bias2, dy: -12pt, circle(radius: 21pt, fill: self.colors.primary))
        place(right + bottom, dx: r * -3% + bias2, dy: -15%, circle(radius: 13pt, fill: self.colors.primary))
        place(right + bottom, dx: r * -2.5% + bias2, dy: -27%, circle(radius: 8pt, fill: self.colors.primary))

        place(
          dx: self.store.margin.x - 1em,
          dy: self.store.margin.top - self.store.header-ascent - 1em,
          rect(
            width: 100% - self.store.margin.x * 2 + 2em,
            height: 100% - self.store.margin.top - self.store.margin.bottom + self.store.header-ascent + 1.5em,
            stroke: 10pt + self.colors.primary,
            inset: 20pt,
          ),
        )
        place(
          top + right,
          dx: -1em,
          dy: 1.5em,
          image(
            width: 3em,
            "assets/euphonium-logo.png",
          ),
        )
      },
    ),
    config-info(
      institution: [Institution],
      author: [Author],
      title: [Title],
      date: datetime.today(),
    ),
    ..args,
  )

  body
}
