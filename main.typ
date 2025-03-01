#let template(
  title: [Thesis title],
  candidate: (),
  supervisor: (),
  co-supervisor: (),
  department: (),
  university: (),
  school: (),
  course:(),
  date: (),
  logo: none,
  body
) = {
  set document(title: title, author: candidate.name)
  show link: underline
  set text(size: 13pt)
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1.1")
  show heading.where(level: 1): item => {
    if item.body == [Bibliography] or item.body == [Contents] {
      item
    } else {
      pagebreak()
      block(width: 100%, height: 20%)[
            #set align(left + horizon)
            #set text(1.3em, weight: "bold")
            #text([Chapter #counter(heading).display() \ #item.body])
          ]
    }
  }
  
  align(center, block[
    #text(smallcaps(university), stretch: 142%) \
    *#school* \
    *#department* \
    *#course* \
  ])

  v(40pt)
  if logo != none {
    align(center, logo)
  }

  v(40pt)
  align(center, text(size: 20pt, title, weight: "bold"))

  v(40pt)
  text([*Supervisor*: \ #supervisor])
  v(20pt)
  text([*Co-Supervisor*: \ #co-supervisor.map(item => [
          #item
        ]).join(linebreak())])

  align(right, block[
    #text(weight: "bold", [Candidate: ]) \
    #candidate.name \
    #text([Matriculation number: #candidate.number]) \
  ])

  align(center + bottom, text(weight: "bold", [Academic year: #date]))
  pagebreak()
  outline()
  pagebreak()
  
  set page(header: context {
    let page = counter(page).get().first()
    align(if calc.odd(page) { right } else { left })[#page]
  })
  body
  pagebreak()
  set page(header: context {
    none
  })
  bibliography("refs.bib")
}