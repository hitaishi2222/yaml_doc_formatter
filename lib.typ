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

#let single_key_dict(k, v) = {
  let d = (:)
  d.insert(k, v)
  d
}

#let panic_keys = ("paper", "font", "style", "lang")
#let special_eval(item) = {
  if not check_dict(item) {
    panic("Given item is not dictionary.")
  }
  let key = item.keys().first()
  let val = item.at(key)
  if item.len() != 1 {
    return
  } else {
    if item.keys().first() in panic_keys {
      return val
    } else if item.keys().first() == "body" {
      return val
    } else if type(val) == bool {
      return val
    } else if type(val) == dictionary {
      let keys = val.keys()
      let new_dict = (:)
      for key in keys {
        new_dict.insert(key, special_eval(single_key_dict(
          key,
          val.at(key),
        )))
      }
      return new_dict
    } else {
      return eval(val)
    }
  }
}


#let has_dict(dict) = {
  if check_dict(dict) {
    if type(dict.values().first()) == dictionary { true } else { false }
  }
}

#let conf_yml = yaml("format.yml")


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
      new_dict.insert(key, special_eval(single_key_dict(key, old_dict.at(key))))
    }
    return new_dict
  }
}


#let conf_dict(dict) = (
  dict
    .pairs()
    .map(pair => {
      let (k, val) = pair
      (k, format_dict(val))
    })
    .to-dict()
)



#let cf = conf_dict(conf_yml)

#let setup-environment(config) = {
  it => {
    set page(..config.at("page", default: (:)))
    set text(..config.at("text", default: (:)))
    set par(..config.at("par", default: (:)))
    it
  }
}

#show: setup-environment(cf)

= Hello

== Secondary

Only snake_case are allowed in yaml.

// #conf_yml
// #cf

#lorem(50)
#let prob = ("1": (heading: (text: (size: 13pt))))

#prob

#type(prob)
#prob.keys()

#let config_heading(config) = {
  let config = config
  if (type(config) == array and config.len() == 1) {
    let new_conf = config.at(0)
    if new_conf.keys().contains("heading") {
      config = new_conf.at("heading")
    }
  }
  config
}

#config_heading(prob.values())

#show heading: it => {
  context {
    let current_page = it.location().page()
    if str(current_page) in prob.keys() {
      prob.values()
    }
  }
}

= World

#let ps = conf_yml.at("1")
#ps

#format_dict(ps)
