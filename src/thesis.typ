#let ack_body = state("ack_body", [])
#let abstract_body = state("abstract_body", [])

#let _make_titlepage(title, name, studentid, degree, programme, school, supervisor, date) = {
  // make title page
  align(center)[

    #v(1.5cm)
    // this box makes sure that even on a single-line title,
    // that the logo doesn't get shifted up, since it's 2-ish lines tall
    #box(height: 48pt)[
      // set to default value temporarily so that the global par change
      // doesn't affect it (looks better this way)
      // https://typst.app/docs/reference/model/par/#parameters-leading
      #par(leading: 0.65em)[
        #text(size: 24pt, weight:"semibold", title)
      ]
    ]

    #v(1cm)
    #align(center)[
      #image("/resources/logo.jpg", width: 35%)
    ]

    #v(1.5cm)
    #text(size: 16pt)[
      #name \
      #studentid
    ]

    #v(1.5cm)

    Submitted in partial satisfaction of the requirements for the \ degree of
    #v(0.5cm)
    #degree #programme \
    #school \
    University of Lincoln

    #v(1cm)
    Supervisor: #supervisor \
    #v(1.5cm)
    #date

    #pagebreak()
  ]
}

#let _make_preamble_page(title, heading_label, content_body) = {
  show heading.where(level: 1): this => {
    text(size: 24pt)[
      #this.body
      #parbreak()
    ]
  }
  // [= Acknowledgements <acknowledgements>]
  heading[#title #label(heading_label)]
  // context ack_body.final()
  content_body
  pagebreak()
}

#let thesis(
  title: none,
  name: none,
  studentid: none,
  degree: none,
  programme: none,
  school: none,
  supervisor: none,
  date: none,
  header_text: none,
  bibliography_path: none,

  enable_acknowledgements: false,
  enable_abstract: false,

  doc
  ) = {
  
  set page(
    paper: "a4",
  )

  set par(leading: 1.2em)
  set text(size: 12pt)
  
  _make_titlepage(title, name, studentid, degree, programme, school, supervisor, date)

  set page(margin: (left: 3.5cm))

  // https://typst.app/docs/reference/text/text/#parameters-hyphenate
  // fill the entire line, instead of breaking into a new one
  // for words that are quite long
  set text(hyphenate: true)
  set par(justify: true, spacing: 2em)

  // set up header & footer
  set page(
    header: [
      #align(right)[
        #text(weight: "light", emph(header_text))
      ]
    ],

    footer: {
      box()[
        _#name (#studentid) _
        #h(1fr) 
        #context counter(page).display("i")
      ]
    }
  )

  // reset page counter to 1 after title page
  counter(page).update(1)

  if enable_acknowledgements {
    _make_preamble_page([Acknowledgements], "acknowledgements", context ack_body.final())
  }

  if enable_abstract {
    _make_preamble_page([Abstract], "abstract", context abstract_body.final())
  }

  // TODO make abstract, toc, etc here

  // set page counter to 1, reset its style, and add the section title to the footer
  context counter(page).update(1)
  set page(
    footer: [
      _#name (#studentid)_
      #h(1fr)
      #box()[
        #emph(context query(selector(heading.where(level: 1)).before(here())).last().body)
        #h(0.2cm)
        #context counter(page).display("1")
      ]
    ]
  )

  // different type of headings for following sections
  // follows the format "Chapter X \n Section title"
  set heading(numbering: "1.1")
  show heading.where(level: 1): this => {
    set text(size: 24pt)
    
    [
      Chapter #counter(heading).display("1") \
      #this.body 
      #parbreak()
    ]
  }

  show heading.where(level: 2): this => {
    set text(size: 18pt)
    set block(
      above: 3em,
      below: 1.6em,
    )
    this
  }

  show heading.where(level: 3): this => {
    set text(size: 16pt)
    this
  }

  counter(heading).update(0)
  doc

  // TODO: reset headings to remove "chapter" text
  // TODO: add custom harvard citation style to fit with lincoln requirements?
  pagebreak()
  bibliography(bibliography_path, style: "harvard-cite-them-right")
}

#let acknowledgements(doc) = {
  context ack_body.update(doc)
}

#let abstract(doc) = {
  context abstract_body.update(doc)
}