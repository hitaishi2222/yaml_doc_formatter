# yaml-doc-formatter

Format a [Typst](https://typst.app) document from a YAML file.

The styling (page geometry, fonts, paragraph settings, heading numbering, per-section
overrides) lives in a YAML file instead of being scattered through the Typst source.
The Typst document then references the parsed configuration where it needs it.

<p>
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square"/>
  <img src="https://img.shields.io/badge/typst-0.13--239dad?style=flat-square&logo=typst&logoColor=239dad"/>
</p>

## Layout

| File | What it is |
|---|---|
| `lib.typ` | The package: the Typst functions that read and apply the YAML config |
| `format.yml` | Example configuration |
| `typst.toml` | Package manifest |

## Configuration

Keys are `snake_case`. The top-level `page`, `text` and `par` keys map straight
onto Typst's `page`, `text` and `par` setters:

```yaml
page:
  paper: a4
  margin: 2cm
text:
  font: Times New Roman
  size: 13pt
par:
  justify: true
```

Numbered sections take a heading block, optionally with their own page setup:

```yaml
1:
  heading:
    numbering: "1."
    text:
      size: 13pt
  page:
    margin: 1cm
```

## Usage

```typst
#import "@preview/yaml-doc-formatter:0.1.0": *

#let conf_yml = yaml("format.yml")

// Apply the page/text/par configuration to the rest of the document.
#show: setup-environment(conf_yml)

= Hello

== Secondary
```

Section-level configuration is looked up by heading number and applied through
the same `format_dict` helper.

## Status

Experimental. The package is still being shaped: the YAML schema may change, and
the example configuration covers only the cases I have needed so far.

## License

MIT. See [LICENSE](LICENSE).
