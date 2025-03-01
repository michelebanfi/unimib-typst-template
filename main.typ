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
) = {
  set document(title: title, author: candidate.name)
  set text(size: 13pt)
  
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
}

