#let is_num(string) = {
  string.contains(regex("^\\d+$"))
}

#let is_range(string) = {
  string.contains(regex("^\\d+\-\\d+$"))
}

#let is_phrase(string) = {
  string.contains(regex("^[\w\_]+$"))
}

#let check_dict(item) = if type(item) != dictionary { false } else { true }

#set page(paper: "a4")
#set text(font: "Times New Roman", size: 15pt)
#set par(justify: true)

#let to_form(item) = {
  if not check_dict(item) {
    panic("Given item is not dictionary.")
  }
  let key = item.keys().first()
  let val = item.at(key)
  if item.len() != 1 {
    return
  } else {
    if item.keys().first() in ("paper", "font") {
      return item
    } else if item.keys().first() == "body" {
      return (key: [#val])
    } else if type(val) == bool {
      return item
    } else {
      return (item.keys().first(): eval(val))
    }
  }
}

// NEW ONE
#let to_form(item) = {
  if not check_dict(item) {
    panic("Given item is not dictionary.")
  }
  let key = item.keys().first()
  let val = item.at(key)
  if item.len() != 1 {
    return
  } else {
    if item.keys().first() in ("paper", "font") {
      return val
    } else if item.keys().first() == "body" {
      return val
    } else if type(val) == bool {
      return val
    } else {
      return eval(val)
    }
  }
}


#to_form((body: "to play"))

#let ex1 = (hello: (paper: "a4"))
#let ex2 = (paper: "a4")

#let to_sdict(k, v) = {
  let d = (:)
  d.insert(k, v)
  d
}

#to_sdict("paper", "a4")

#let has_dict(dict) = {
  if check_dict(dict) {
    if type(dict.values().first()) == dictionary { true } else { false }
  }
}

#has_dict(ex2)

#type(ex2.values().first())
#type(ex1.values().first())

#to_form((body: "to play"))

#let df = yaml("format.yml")

#let my-dict = (a: "10pt", b: "20pt")

#let format_dict(old_dict) = {
  if has_dict(old_dict) {
    old_dict
      .pairs()
      .map(pair => {
        let (k, val) = pair
        (k, format_dict(val))
      })
      .to-dict()
  } else {
    let keys = old_dict.keys()
    let new_dict = (:)
    for key in keys {
      new_dict.insert(key, to_form(to_sdict(key, old_dict.at(key))))
    }
    return new_dict
  }
}



#df

// #format_dict(my-dict)

#let conf_dict(dict) = (
  dict
    .pairs()
    .map(pair => {
      let (k, val) = pair
      (k, format_dict(val))
    })
    .to-dict()
)


#let new_df = conf_dict(df)

#new_df



// #let conf(doc) = {
//   set page(..settings)
//   set text(..df.at("text"))
//
//   doc
// }
//
// #show: doc => conf(doc)


= Hello

== Secondary

Only snake_case are allowed in yaml.
