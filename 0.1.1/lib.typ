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
  lang: "en",
  bib: (),
  body
) = {
  // Language dictionary
  let translations = (
    "en": (
      "contents": "Contents",
      "bibliography": "Bibliography",
      "acknowledgments": "Acknowledgments",
      "chapter": "Chapter",
      "supervisor": "Supervisor",
      "co-supervisor": "Co-Supervisor",
      "candidate": "Candidate",
      "matriculation_number": "Matriculation number",
      "academic_year": "Academic year"
    ),
    "it": (
      "contents": "Indice",
      "bibliography": "Bibliografia",
      "acknowledgments": "Ringraziamenti",
      "chapter": "Capitolo",
      "supervisor": "Relatore",
      "co-supervisor": "Correlatore",
      "candidate": "Candidato",
      "matriculation_number": "Numero di matricola",
      "academic_year": "Anno accademico"
    )
  )
  
  // Get translation dictionary for selected language, default to English
  let t = if lang in translations { translations.at(lang) } else { translations.at("en") }

    
  // State to track the current chapter
  let current-chapter = state("current-chapter", none)

  // State to track new chapter pages
  let chapter-start-page = state("chapter-start-page", none)

  set document(title: title, author: candidate.name)
  show link: underline
  set text(size: 13pt, lang: lang)
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1.1")
  show heading.where(level: 1): item => {
    if item.body == [#t.contents] {
      item
    } else if item.body == [#t.bibliography] or item.body == [#t.acknowledgments] {
      pagebreak()
      // Mark this page as a chapter start
      chapter-start-page.update(counter(page).get().first())
      block(width: 100%, height: 20%)[
        #set align(left + horizon)
        #set text(1.3em, weight: "bold")
        #text([#item.body])
      ]
    // Update current chapter for special sections
    current-chapter.update(item.body)
    } else {
      pagebreak()
      // Mark this page as a chapter start
      chapter-start-page.update(counter(page).get().first())
      // Update current chapter 
      current-chapter.update(item.body)
      block(width: 100%, height: 20%)[
            #set align(left + horizon)
            #set text(1.3em, weight: "bold")
            #text([#t.chapter #counter(heading).display() \ #item.body])
          ]
    }
  }

  show outline.entry: it => {
    if it.element.body == [#t.acknowledgments] or it.element.body == [#t.bibliography] {
      []
    } else {
      it
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
  text([*#t.supervisor*: \ #supervisor])
  v(20pt)
  text([*#t.co-supervisor*: \ #co-supervisor.map(item => [
          #item
        ]).join(linebreak())])

  align(right, block[
    #text(weight: "bold", [#t.candidate: ]) \
    #candidate.name \
    #text([#t.matriculation_number: #candidate.number]) \
  ])

  align(center + bottom, text(weight: "bold", [#t.academic_year: #date]))
  pagebreak()
  outline()
  
  set page(
    header: context {
      let page = counter(page).get().first()
      let chapter-num = counter(heading).get().first()
      let chapter-text = current-chapter.get()
      
      // Only show header if not a chapter start page
      if (chapter-text != none) and not (chapter-start-page.get() + 1) == page {
        let header-text = if chapter-num > 0 {
          //[#t.chapter #chapter-num. #chapter-text]
          [#chapter-start-page.get() ]
          [#page]
        } else {
          [#chapter-text]
        }
  
        if calc.odd(page){
          text(upper(header-text), style: "italic")
          h(1fr)
          [#page]
        }else{
          [#page]
          h(1fr)
          text(upper(header-text), style: "italic")
        }
      }
    },
    footer: context {
      let page = counter(page).get().first()
      
      // Show centered page number in footer only for chapter start pages
      if chapter-start-page.get() == page {
        align(center, [#page])
      }
    }
  )
  body

  if bib != () {
    pagebreak()
    bib
  }
}