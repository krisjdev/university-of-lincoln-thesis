#let thesis(
  title: none,
  name: none,
  studentid: none,
  degree: none,
  programme: none,
  school: none,
  supervisor: none,
  date: none,
  
  doc
  ) = {
  
  set page(
    paper: "a4"
  )


  // make title page
  align(center)[
    
    #v(1.5cm)
    // this box makes sure that even on a single-line title,
    // that the logo doesn't get shifted up, since it's 2-ish lines tall
    #box(height: 48pt)[
      #text(size: 24pt, weight:"semibold", title)
    ]

    #v(1cm)
    #align(center)[
      #image("/resources/logo.jpg", width: 35%)
    ]

    #set par(leading: 1.2em)

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

  doc
}