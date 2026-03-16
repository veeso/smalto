////  Pre-built inline-styled theme configurations for smalto_lustre.
////
////  **Auto-generated** by `tools/theme_converter` from the CSS themes in
////  `themes/`. Do not edit by hand — re-run the converter instead.
////
////  Each function returns a `Config(msg)` with inline-styled `<span>` elements
////  matching the corresponding CSS theme from the smalto themes collection.
////  Unlike the CSS themes, these configs require no external stylesheet — all
////  styles are applied directly to the elements.
////
////  ## Usage
////
////  ```gleam
////  import smalto
////  import smalto/languages/python
////  import smalto/lustre as smalto_lustre
////  import smalto/lustre/themes
////
////  let tokens = smalto.to_tokens("print('hello')", python.grammar())
////  let elements = smalto_lustre.to_lustre(tokens, themes.dracula())
////  ```
////
////  ## Available themes (45)
////
////  - `a11y_dark()`
////  - `atom_dark()`
////  - `base16_ateliersulphurpool_light()`
////  - `cb()`
////  - `coldark_cold()`
////  - `coldark_dark()`
////  - `coy()`
////  - `coy_without_shadows()`
////  - `darcula()`
////  - `dark()`
////  - `default()`
////  - `dracula()`
////  - `duotone_dark()`
////  - `duotone_earth()`
////  - `duotone_forest()`
////  - `duotone_light()`
////  - `duotone_sea()`
////  - `duotone_space()`
////  - `funky()`
////  - `ghcolors()`
////  - `gruvbox_dark()`
////  - `gruvbox_light()`
////  - `holi_theme()`
////  - `hopscotch()`
////  - `laserwave()`
////  - `lucario()`
////  - `material_dark()`
////  - `material_light()`
////  - `material_oceanic()`
////  - `night_owl()`
////  - `nord()`
////  - `okaidia()`
////  - `one_dark()`
////  - `one_light()`
////  - `pojoaque()`
////  - `shades_of_purple()`
////  - `solarized_dark_atom()`
////  - `solarizedlight()`
////  - `synthwave84()`
////  - `tomorrow()`
////  - `twilight()`
////  - `vs()`
////  - `vsc_dark_plus()`
////  - `xonokai()`
////  - `z_touch()`
////

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import smalto/lustre.{type Config} as smalto_lustre

/// a11y-dark theme for JavaScript, CSS, and HTML Based on the okaidia theme: https://github.com/PrismJS/prism/blob/gh-pages
pub fn a11y_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#00e0e0")]))
  |> smalto_lustre.string(styled_span([#("color", "#abe338")]))
  |> smalto_lustre.number(styled_span([#("color", "#00e0e0")]))
  |> smalto_lustre.comment(styled_span([#("color", "#d4d0ab")]))
  |> smalto_lustre.function(styled_span([#("color", "#ffd700")]))
  |> smalto_lustre.operator(styled_span([#("color", "#00e0e0")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#fefefe")]))
  |> smalto_lustre.type_(styled_span([#("color", "#ffd700")]))
  |> smalto_lustre.module(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#00e0e0")]))
  |> smalto_lustre.constant(styled_span([#("color", "#ffa07a")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#abe338")]))
  |> smalto_lustre.tag(styled_span([#("color", "#ffa07a")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#abe338")]))
  |> smalto_lustre.selector(styled_span([#("color", "#abe338")]))
  |> smalto_lustre.property(styled_span([#("color", "#ffa07a")]))
  |> smalto_lustre.regex(styled_span([#("color", "#ffd700")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#ffd700"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#00e0e0")],
    code_color: "#008000",
  ))
}

/// atom-dark theme for `prism.js` Based on Atom's `atom-dark` theme: https://github.com/atom/atom-dark-syntax @author Joe G
pub fn atom_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#96CBFE")]))
  |> smalto_lustre.string(styled_span([#("color", "#A8FF60")]))
  |> smalto_lustre.number(styled_span([#("color", "#FF73FD")]))
  |> smalto_lustre.comment(styled_span([#("color", "#7C7C7C")]))
  |> smalto_lustre.function(styled_span([#("color", "#DAD085")]))
  |> smalto_lustre.operator(styled_span([#("color", "#EDEDED")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#c5c8c6")]))
  |> smalto_lustre.type_(
    styled_span([#("color", "#FFFFB6"), #("text-decoration", "underline")]),
  )
  |> smalto_lustre.module(styled_span([#("color", "#c5c8c6")]))
  |> smalto_lustre.variable(styled_span([#("color", "#C6C5FE")]))
  |> smalto_lustre.constant(styled_span([#("color", "#f92672")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#A8FF60")]))
  |> smalto_lustre.tag(styled_span([#("color", "#96CBFE")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#A8FF60")]))
  |> smalto_lustre.selector(styled_span([#("color", "#A8FF60")]))
  |> smalto_lustre.property(styled_span([#("color", "#96CBFE")]))
  |> smalto_lustre.regex(styled_span([#("color", "#E9C062")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#fd971f"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#96CBFE")],
    code_color: "#008000",
  ))
}

/// base16 ateliersulphurpool.light theme
pub fn base16_ateliersulphurpool_light() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#ac9739")]))
  |> smalto_lustre.string(styled_span([#("color", "#22a2c9")]))
  |> smalto_lustre.number(styled_span([#("color", "#c76b29")]))
  |> smalto_lustre.comment(styled_span([#("color", "#898ea4")]))
  |> smalto_lustre.function(styled_span([#("color", "#5e6687")]))
  |> smalto_lustre.operator(styled_span([#("color", "#c76b29")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#5e6687")]))
  |> smalto_lustre.type_(styled_span([#("color", "#5e6687")]))
  |> smalto_lustre.module(styled_span([#("color", "#5e6687")]))
  |> smalto_lustre.variable(styled_span([#("color", "#3d8fd1")]))
  |> smalto_lustre.constant(styled_span([#("color", "#c76b29")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#22a2c9")]))
  |> smalto_lustre.tag(styled_span([#("color", "#3d8fd1")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#c76b29")]))
  |> smalto_lustre.selector(styled_span([#("color", "#6679cc")]))
  |> smalto_lustre.property(styled_span([#("color", "#c08b30")]))
  |> smalto_lustre.regex(styled_span([#("color", "#22a2c9")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#c94922"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#22a2c9")],
    code_color: "#008000",
  ))
}

/// cb theme
pub fn cb() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#c27628")]))
  |> smalto_lustre.string(styled_span([#("color", "#B0C975")]))
  |> smalto_lustre.number(styled_span([#("color", "#8799B0")]))
  |> smalto_lustre.comment(styled_span([#("color", "#797979")]))
  |> smalto_lustre.function(styled_span([#("color", "#e5a638")]))
  |> smalto_lustre.operator(styled_span([#("color", "#fff")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#fff")]))
  |> smalto_lustre.type_(styled_span([#("color", "#e5a638")]))
  |> smalto_lustre.module(styled_span([#("color", "#fff")]))
  |> smalto_lustre.variable(styled_span([#("color", "#fdfba8")]))
  |> smalto_lustre.constant(styled_span([#("color", "#e5a638")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#B0C975")]))
  |> smalto_lustre.tag(styled_span([#("color", "#ffd893")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#c27628")]))
  |> smalto_lustre.selector(styled_span([#("color", "#fff")]))
  |> smalto_lustre.property(styled_span([#("color", "#c27628")]))
  |> smalto_lustre.regex(styled_span([#("color", "#9B71C6")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#E45734"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#c27628")],
    code_color: "#008000",
  ))
}

/// Coldark Theme for Prism.js Theme variation: Cold Tested with HTML, CSS, JS, JSON, PHP, YAML, Bash script @author Armand 
pub fn coldark_cold() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#a04900")]))
  |> smalto_lustre.string(styled_span([#("color", "#116b00")]))
  |> smalto_lustre.number(styled_span([#("color", "#755f00")]))
  |> smalto_lustre.comment(styled_span([#("color", "#3c526d")]))
  |> smalto_lustre.function(styled_span([#("color", "#7c00aa")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a04900")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#006d6d")]))
  |> smalto_lustre.type_(styled_span([#("color", "#005a8e")]))
  |> smalto_lustre.module(styled_span([#("color", "#111b27")]))
  |> smalto_lustre.variable(styled_span([#("color", "#005a8e")]))
  |> smalto_lustre.constant(styled_span([#("color", "#755f00")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#af00af")]))
  |> smalto_lustre.tag(styled_span([#("color", "#006d6d")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#755f00")]))
  |> smalto_lustre.selector(styled_span([#("color", "#a04900")]))
  |> smalto_lustre.property(styled_span([#("color", "#005a8e")]))
  |> smalto_lustre.regex(styled_span([#("color", "#af00af")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#c22f2e"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#111b27")],
    code_color: "#008000",
  ))
}

/// Coldark Theme for Prism.js Theme variation: Dark Tested with HTML, CSS, JS, JSON, PHP, YAML, Bash script @author Armand 
pub fn coldark_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#e9ae7e")]))
  |> smalto_lustre.string(styled_span([#("color", "#91d076")]))
  |> smalto_lustre.number(styled_span([#("color", "#e6d37a")]))
  |> smalto_lustre.comment(styled_span([#("color", "#8da1b9")]))
  |> smalto_lustre.function(styled_span([#("color", "#c699e3")]))
  |> smalto_lustre.operator(styled_span([#("color", "#e9ae7e")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#66cccc")]))
  |> smalto_lustre.type_(styled_span([#("color", "#6cb8e6")]))
  |> smalto_lustre.module(styled_span([#("color", "#e3eaf2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#6cb8e6")]))
  |> smalto_lustre.constant(styled_span([#("color", "#e6d37a")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#f4adf4")]))
  |> smalto_lustre.tag(styled_span([#("color", "#66cccc")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#e6d37a")]))
  |> smalto_lustre.selector(styled_span([#("color", "#e9ae7e")]))
  |> smalto_lustre.property(styled_span([#("color", "#6cb8e6")]))
  |> smalto_lustre.regex(styled_span([#("color", "#f4adf4")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#cd6660"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#e3eaf2")],
    code_color: "#008000",
  ))
}

/// prism.js Coy theme for JavaScript, CoffeeScript, CSS and HTML Based on https://github.com/tshedor/workshop-wp-theme (Exa
pub fn coy() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#1990b8")]))
  |> smalto_lustre.string(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.number(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.comment(styled_span([#("color", "#7D8B99")]))
  |> smalto_lustre.function(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a67f59")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#5F6364")]))
  |> smalto_lustre.type_(styled_span([#("color", "#1990b8")]))
  |> smalto_lustre.module(styled_span([#("color", "black")]))
  |> smalto_lustre.variable(styled_span([#("color", "#a67f59")]))
  |> smalto_lustre.constant(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.tag(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.selector(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.property(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.regex(styled_span([#("color", "#e90")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#e90")],
    url_styles: [#("text-decoration", "underline"), #("color", "#a67f59")],
    code_color: "#008000",
  ))
}

/// Coy without shadows Based on Tim Shedor's Coy theme for prism.js Author: RunDevelopment
pub fn coy_without_shadows() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#1990b8")]))
  |> smalto_lustre.string(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.number(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.comment(styled_span([#("color", "#7D8B99")]))
  |> smalto_lustre.function(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a67f59")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#5F6364")]))
  |> smalto_lustre.type_(styled_span([#("color", "#1990b8")]))
  |> smalto_lustre.module(styled_span([#("color", "black")]))
  |> smalto_lustre.variable(styled_span([#("color", "#a67f59")]))
  |> smalto_lustre.constant(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.tag(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.selector(styled_span([#("color", "#2f9c0a")]))
  |> smalto_lustre.property(styled_span([#("color", "#c92c2c")]))
  |> smalto_lustre.regex(styled_span([#("color", "#e90")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#e90")],
    url_styles: [#("text-decoration", "underline"), #("color", "#a67f59")],
    code_color: "#008000",
  ))
}

/// Darcula theme Adapted from a theme based on: IntelliJ Darcula Theme (https://github.com/bulenkov/Darcula) @author Alexan
pub fn darcula() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#cc7832")]))
  |> smalto_lustre.string(styled_span([#("color", "#6a8759")]))
  |> smalto_lustre.number(styled_span([#("color", "#6897bb")]))
  |> smalto_lustre.comment(styled_span([#("color", "#e8bf6a")]))
  |> smalto_lustre.function(styled_span([#("color", "#ffc66d")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a9b7c6")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#a9b7c6")]))
  |> smalto_lustre.type_(styled_span([#("color", "#ffc66d")]))
  |> smalto_lustre.module(styled_span([#("color", "#a9b7c6")]))
  |> smalto_lustre.variable(styled_span([#("color", "#9876aa")]))
  |> smalto_lustre.constant(styled_span([#("color", "#9876aa")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#e8bf6a")]))
  |> smalto_lustre.tag(styled_span([#("color", "#e8bf6a")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#a9b7c6")]))
  |> smalto_lustre.selector(styled_span([#("color", "#cc7832")]))
  |> smalto_lustre.property(styled_span([#("color", "#9876aa")]))
  |> smalto_lustre.regex(styled_span([#("color", "#a9b7c6")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#cc7832"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#287bde")],
    code_color: "#008000",
  ))
}

/// prism.js Dark theme for JavaScript, CSS and HTML Based on the slides of the talk “/Reg(exp){2}lained/” @author Lea Verou
pub fn dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "hsl(350, 40%, 70%)")]))
  |> smalto_lustre.string(styled_span([#("color", "hsl(75, 70%, 60%)")]))
  |> smalto_lustre.number(styled_span([#("color", "hsl(350, 40%, 70%)")]))
  |> smalto_lustre.comment(styled_span([#("color", "hsl(30, 20%, 50%)")]))
  |> smalto_lustre.function(styled_span([#("color", "white")]))
  |> smalto_lustre.operator(styled_span([#("color", "hsl(40, 90%, 60%)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "white")]))
  |> smalto_lustre.type_(styled_span([#("color", "white")]))
  |> smalto_lustre.module(styled_span([#("color", "white")]))
  |> smalto_lustre.variable(styled_span([#("color", "hsl(40, 90%, 60%)")]))
  |> smalto_lustre.constant(styled_span([#("color", "hsl(350, 40%, 70%)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "hsl(75, 70%, 60%)")]))
  |> smalto_lustre.tag(styled_span([#("color", "hsl(350, 40%, 70%)")]))
  |> smalto_lustre.attribute(styled_span([#("color", "hsl(75, 70%, 60%)")]))
  |> smalto_lustre.selector(styled_span([#("color", "hsl(75, 70%, 60%)")]))
  |> smalto_lustre.property(styled_span([#("color", "hsl(350, 40%, 70%)")]))
  |> smalto_lustre.regex(styled_span([#("color", "#e90")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#e90"), #("font-weight", "bold")],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "hsl(40, 90%, 60%)"),
    ],
    code_color: "#008000",
  ))
}

/// prism.js default theme for JavaScript, CSS and HTML Based on dabblet (http://dabblet.com) @author Lea Verou
pub fn default() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#07a")]))
  |> smalto_lustre.string(styled_span([#("color", "#690")]))
  |> smalto_lustre.number(styled_span([#("color", "#905")]))
  |> smalto_lustre.comment(styled_span([#("color", "slategray")]))
  |> smalto_lustre.function(styled_span([#("color", "#DD4A68")]))
  |> smalto_lustre.operator(styled_span([#("color", "#9a6e3a")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#999")]))
  |> smalto_lustre.type_(styled_span([#("color", "#DD4A68")]))
  |> smalto_lustre.module(styled_span([#("color", "black")]))
  |> smalto_lustre.variable(styled_span([#("color", "#e90")]))
  |> smalto_lustre.constant(styled_span([#("color", "#905")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#690")]))
  |> smalto_lustre.tag(styled_span([#("color", "#905")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#690")]))
  |> smalto_lustre.selector(styled_span([#("color", "#690")]))
  |> smalto_lustre.property(styled_span([#("color", "#905")]))
  |> smalto_lustre.regex(styled_span([#("color", "#e90")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#e90"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#9a6e3a")],
    code_color: "#008000",
  ))
}

/// Dracula Theme originally by Zeno Rocha [@zenorocha] https://draculatheme.com/ Ported for PrismJS by Albert Vallverdu [@b
pub fn dracula() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#8be9fd")]))
  |> smalto_lustre.string(styled_span([#("color", "#50fa7b")]))
  |> smalto_lustre.number(styled_span([#("color", "#bd93f9")]))
  |> smalto_lustre.comment(styled_span([#("color", "#6272a4")]))
  |> smalto_lustre.function(styled_span([#("color", "#f1fa8c")]))
  |> smalto_lustre.operator(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.type_(styled_span([#("color", "#f1fa8c")]))
  |> smalto_lustre.module(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.constant(styled_span([#("color", "#ff79c6")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#50fa7b")]))
  |> smalto_lustre.tag(styled_span([#("color", "#ff79c6")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#50fa7b")]))
  |> smalto_lustre.selector(styled_span([#("color", "#50fa7b")]))
  |> smalto_lustre.property(styled_span([#("color", "#ff79c6")]))
  |> smalto_lustre.regex(styled_span([#("color", "#ffb86c")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#ffb86c"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#f8f8f2")],
    code_color: "#008000",
  ))
}

/// duotone dark theme
pub fn duotone_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#ffcc99")]))
  |> smalto_lustre.string(styled_span([#("color", "#ffcc99")]))
  |> smalto_lustre.number(styled_span([#("color", "#e09142")]))
  |> smalto_lustre.comment(styled_span([#("color", "#6c6783")]))
  |> smalto_lustre.function(styled_span([#("color", "#9a86fd")]))
  |> smalto_lustre.operator(styled_span([#("color", "#e09142")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#6c6783")]))
  |> smalto_lustre.type_(styled_span([#("color", "#9a86fd")]))
  |> smalto_lustre.module(styled_span([#("color", "#9a86fd")]))
  |> smalto_lustre.variable(styled_span([#("color", "#ffcc99")]))
  |> smalto_lustre.constant(styled_span([#("color", "#e09142")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#ffcc99")]))
  |> smalto_lustre.tag(styled_span([#("color", "#e09142")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#c4b9fe")]))
  |> smalto_lustre.selector(styled_span([#("color", "#eeebff")]))
  |> smalto_lustre.property(styled_span([#("color", "#9a86fd")]))
  |> smalto_lustre.regex(styled_span([#("color", "#ffcc99")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#c4b9fe"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#ffcc99")],
    code_color: "#008000",
  ))
}

/// duotone earth theme
pub fn duotone_earth() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#fcc440")]))
  |> smalto_lustre.string(styled_span([#("color", "#fcc440")]))
  |> smalto_lustre.number(styled_span([#("color", "#bfa05a")]))
  |> smalto_lustre.comment(styled_span([#("color", "#6a5f58")]))
  |> smalto_lustre.function(styled_span([#("color", "#88786d")]))
  |> smalto_lustre.operator(styled_span([#("color", "#bfa05a")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#6a5f58")]))
  |> smalto_lustre.type_(styled_span([#("color", "#88786d")]))
  |> smalto_lustre.module(styled_span([#("color", "#88786d")]))
  |> smalto_lustre.variable(styled_span([#("color", "#fcc440")]))
  |> smalto_lustre.constant(styled_span([#("color", "#bfa05a")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#fcc440")]))
  |> smalto_lustre.tag(styled_span([#("color", "#bfa05a")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#a48774")]))
  |> smalto_lustre.selector(styled_span([#("color", "#fff3eb")]))
  |> smalto_lustre.property(styled_span([#("color", "#88786d")]))
  |> smalto_lustre.regex(styled_span([#("color", "#fcc440")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#a48774"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#fcc440")],
    code_color: "#008000",
  ))
}

/// duotone forest theme
pub fn duotone_forest() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#e5fb79")]))
  |> smalto_lustre.string(styled_span([#("color", "#e5fb79")]))
  |> smalto_lustre.number(styled_span([#("color", "#a2b34d")]))
  |> smalto_lustre.comment(styled_span([#("color", "#535f53")]))
  |> smalto_lustre.function(styled_span([#("color", "#687d68")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a2b34d")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#535f53")]))
  |> smalto_lustre.type_(styled_span([#("color", "#687d68")]))
  |> smalto_lustre.module(styled_span([#("color", "#687d68")]))
  |> smalto_lustre.variable(styled_span([#("color", "#e5fb79")]))
  |> smalto_lustre.constant(styled_span([#("color", "#a2b34d")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#e5fb79")]))
  |> smalto_lustre.tag(styled_span([#("color", "#a2b34d")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#b3d6b3")]))
  |> smalto_lustre.selector(styled_span([#("color", "#f0fff0")]))
  |> smalto_lustre.property(styled_span([#("color", "#687d68")]))
  |> smalto_lustre.regex(styled_span([#("color", "#e5fb79")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#b3d6b3"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#e5fb79")],
    code_color: "#008000",
  ))
}

/// duotone light theme
pub fn duotone_light() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#728fcb")]))
  |> smalto_lustre.string(styled_span([#("color", "#728fcb")]))
  |> smalto_lustre.number(styled_span([#("color", "#063289")]))
  |> smalto_lustre.comment(styled_span([#("color", "#b6ad9a")]))
  |> smalto_lustre.function(styled_span([#("color", "#b29762")]))
  |> smalto_lustre.operator(styled_span([#("color", "#063289")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#b6ad9a")]))
  |> smalto_lustre.type_(styled_span([#("color", "#b29762")]))
  |> smalto_lustre.module(styled_span([#("color", "#728fcb")]))
  |> smalto_lustre.variable(styled_span([#("color", "#93abdc")]))
  |> smalto_lustre.constant(styled_span([#("color", "#063289")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#728fcb")]))
  |> smalto_lustre.tag(styled_span([#("color", "#063289")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#896724")]))
  |> smalto_lustre.selector(styled_span([#("color", "#2d2006")]))
  |> smalto_lustre.property(styled_span([#("color", "#b29762")]))
  |> smalto_lustre.regex(styled_span([#("color", "#728fcb")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#896724"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#728fcb")],
    code_color: "#008000",
  ))
}

/// duotone sea theme
pub fn duotone_sea() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#47ebb4")]))
  |> smalto_lustre.string(styled_span([#("color", "#47ebb4")]))
  |> smalto_lustre.number(styled_span([#("color", "#0aa370")]))
  |> smalto_lustre.comment(styled_span([#("color", "#4a5f78")]))
  |> smalto_lustre.function(styled_span([#("color", "#57718e")]))
  |> smalto_lustre.operator(styled_span([#("color", "#0aa370")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#4a5f78")]))
  |> smalto_lustre.type_(styled_span([#("color", "#57718e")]))
  |> smalto_lustre.module(styled_span([#("color", "#57718e")]))
  |> smalto_lustre.variable(styled_span([#("color", "#47ebb4")]))
  |> smalto_lustre.constant(styled_span([#("color", "#0aa370")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#47ebb4")]))
  |> smalto_lustre.tag(styled_span([#("color", "#0aa370")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#7eb6f6")]))
  |> smalto_lustre.selector(styled_span([#("color", "#ebf4ff")]))
  |> smalto_lustre.property(styled_span([#("color", "#57718e")]))
  |> smalto_lustre.regex(styled_span([#("color", "#47ebb4")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#7eb6f6"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#47ebb4")],
    code_color: "#008000",
  ))
}

/// duotone space theme
pub fn duotone_space() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#fe8c52")]))
  |> smalto_lustre.string(styled_span([#("color", "#fe8c52")]))
  |> smalto_lustre.number(styled_span([#("color", "#dd672c")]))
  |> smalto_lustre.comment(styled_span([#("color", "#5b5b76")]))
  |> smalto_lustre.function(styled_span([#("color", "#767693")]))
  |> smalto_lustre.operator(styled_span([#("color", "#dd672c")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#5b5b76")]))
  |> smalto_lustre.type_(styled_span([#("color", "#767693")]))
  |> smalto_lustre.module(styled_span([#("color", "#767693")]))
  |> smalto_lustre.variable(styled_span([#("color", "#fe8c52")]))
  |> smalto_lustre.constant(styled_span([#("color", "#dd672c")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#fe8c52")]))
  |> smalto_lustre.tag(styled_span([#("color", "#dd672c")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#aaaaca")]))
  |> smalto_lustre.selector(styled_span([#("color", "#ebebff")]))
  |> smalto_lustre.property(styled_span([#("color", "#767693")]))
  |> smalto_lustre.regex(styled_span([#("color", "#fe8c52")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#aaaaca"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#fe8c52")],
    code_color: "#008000",
  ))
}

/// prism.js Funky theme Based on “Polyfilling the gaps” talk slides http://lea.verou.me/polyfilling-the-gaps/ @author Lea V
pub fn funky() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "deeppink")]))
  |> smalto_lustre.string(styled_span([#("color", "yellow")]))
  |> smalto_lustre.number(styled_span([#("color", "#0cf")]))
  |> smalto_lustre.comment(styled_span([#("color", "#aaa")]))
  |> smalto_lustre.operator(styled_span([#("color", "yellowgreen")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#999")]))
  |> smalto_lustre.variable(styled_span([#("color", "yellowgreen")]))
  |> smalto_lustre.constant(styled_span([#("color", "#0cf")]))
  |> smalto_lustre.builtin(styled_span([#("color", "yellow")]))
  |> smalto_lustre.tag(styled_span([#("color", "#0cf")]))
  |> smalto_lustre.attribute(styled_span([#("color", "yellow")]))
  |> smalto_lustre.selector(styled_span([#("color", "yellow")]))
  |> smalto_lustre.property(styled_span([#("color", "#0cf")]))
  |> smalto_lustre.regex(styled_span([#("color", "orange")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "orange"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "yellowgreen")],
    code_color: "#008000",
  ))
}

/// GHColors theme by Avi Aryan (http://aviaryan.in) Inspired by Github syntax coloring
pub fn ghcolors() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#00a4db")]))
  |> smalto_lustre.string(styled_span([#("color", "#e3116c")]))
  |> smalto_lustre.number(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "#999988"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(
    styled_span([#("color", "#9a050f"), #("font-weight", "bold")]),
  )
  |> smalto_lustre.operator(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.type_(
    styled_span([#("color", "#9a050f"), #("font-weight", "bold")]),
  )
  |> smalto_lustre.module(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.variable(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.constant(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#e3116c")]))
  |> smalto_lustre.tag(styled_span([#("color", "#00009f")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#00a4db")]))
  |> smalto_lustre.selector(styled_span([#("color", "#00009f")]))
  |> smalto_lustre.property(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.regex(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#36acaa")],
    code_color: "#008000",
  ))
}

/// Gruvbox dark theme Adapted from a theme based on: Vim Gruvbox dark Theme (https://github.com/morhetz/gruvbox) @author Az
pub fn gruvbox_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#fb4934")]))
  |> smalto_lustre.string(styled_span([#("color", "#b8bb26")]))
  |> smalto_lustre.number(styled_span([#("color", "#d3869b")]))
  |> smalto_lustre.comment(styled_span([#("color", "#fabd2f")]))
  |> smalto_lustre.function(styled_span([#("color", "#fabd2f")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a89984")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#a89984")]))
  |> smalto_lustre.type_(styled_span([#("color", "#fabd2f")]))
  |> smalto_lustre.module(styled_span([#("color", "#ebdbb2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#fb4934")]))
  |> smalto_lustre.constant(styled_span([#("color", "#fb4934")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#fabd2f")]))
  |> smalto_lustre.tag(styled_span([#("color", "#fabd2f")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#a89984")]))
  |> smalto_lustre.selector(styled_span([#("color", "#fb4934")]))
  |> smalto_lustre.property(styled_span([#("color", "#fb4934")]))
  |> smalto_lustre.regex(styled_span([#("color", "#ebdbb2")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#fb4934"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#b8bb26")],
    code_color: "#008000",
  ))
}

/// Gruvbox light theme Based on Gruvbox: https://github.com/morhetz/gruvbox Adapted from PrismJS gruvbox-dark theme: https:
pub fn gruvbox_light() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#9d0006")]))
  |> smalto_lustre.string(styled_span([#("color", "#797403")]))
  |> smalto_lustre.number(styled_span([#("color", "#8f3f71")]))
  |> smalto_lustre.comment(styled_span([#("color", "#b57614")]))
  |> smalto_lustre.function(styled_span([#("color", "#b57614")]))
  |> smalto_lustre.operator(styled_span([#("color", "#7c6f64")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#7c6f64")]))
  |> smalto_lustre.type_(styled_span([#("color", "#b57614")]))
  |> smalto_lustre.module(styled_span([#("color", "#3c3836")]))
  |> smalto_lustre.variable(styled_span([#("color", "#9d0006")]))
  |> smalto_lustre.constant(styled_span([#("color", "#9d0006")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#b57614")]))
  |> smalto_lustre.tag(styled_span([#("color", "#b57614")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#7c6f64")]))
  |> smalto_lustre.selector(styled_span([#("color", "#9d0006")]))
  |> smalto_lustre.property(styled_span([#("color", "#9d0006")]))
  |> smalto_lustre.regex(styled_span([#("color", "#3c3836")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#9d0006"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#797403")],
    code_color: "#008000",
  ))
}

/// MIT License Copyright (c) 2021 Ayush Saini Holi Theme for prism.js @author Ayush Saini <@AyushCodes on Twitter>
pub fn holi_theme() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#0fe468")]))
  |> smalto_lustre.string(styled_span([#("color", "#49c6ec")]))
  |> smalto_lustre.number(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.comment(styled_span([#("color", "#446e69")]))
  |> smalto_lustre.function(styled_span([#("color", "#78f3e9")]))
  |> smalto_lustre.operator(styled_span([#("color", "#ec8e01")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#d6b007")]))
  |> smalto_lustre.type_(styled_span([#("color", "#78f3e9")]))
  |> smalto_lustre.module(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.variable(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.constant(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#e60067")]))
  |> smalto_lustre.tag(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#e60067")]))
  |> smalto_lustre.selector(styled_span([#("color", "#e60067")]))
  |> smalto_lustre.property(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.regex(styled_span([#("color", "#d6e7ff")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#d6e7ff"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#ec8e01")],
    code_color: "#008000",
  ))
}

/// hopscotch theme
pub fn hopscotch() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#8fc13e")]))
  |> smalto_lustre.string(styled_span([#("color", "#149b93")]))
  |> smalto_lustre.number(styled_span([#("color", "#fd8b19")]))
  |> smalto_lustre.comment(styled_span([#("color", "#797379")]))
  |> smalto_lustre.function(styled_span([#("color", "#b9b5b8")]))
  |> smalto_lustre.operator(styled_span([#("color", "#fd8b19")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#b9b5b8")]))
  |> smalto_lustre.type_(styled_span([#("color", "#b9b5b8")]))
  |> smalto_lustre.module(styled_span([#("color", "#b9b5b8")]))
  |> smalto_lustre.variable(styled_span([#("color", "#1290bf")]))
  |> smalto_lustre.constant(styled_span([#("color", "#fd8b19")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#149b93")]))
  |> smalto_lustre.tag(styled_span([#("color", "#1290bf")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#fd8b19")]))
  |> smalto_lustre.selector(styled_span([#("color", "#c85e7c")]))
  |> smalto_lustre.property(styled_span([#("color", "#fdcc59")]))
  |> smalto_lustre.regex(styled_span([#("color", "#149b93")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#dd464c"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#149b93")],
    code_color: "#008000",
  ))
}

/// laserwave theme
pub fn laserwave() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#40b4c4")]))
  |> smalto_lustre.string(styled_span([#("color", "#b4dce7")]))
  |> smalto_lustre.number(styled_span([#("color", "#b381c5")]))
  |> smalto_lustre.comment(styled_span([#("color", "#74dfc4")]))
  |> smalto_lustre.function(styled_span([#("color", "#eb64b9")]))
  |> smalto_lustre.operator(styled_span([#("color", "#74dfc4")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#7b6995")]))
  |> smalto_lustre.type_(styled_span([#("color", "#74dfc4")]))
  |> smalto_lustre.module(styled_span([#("color", "#ffffff")]))
  |> smalto_lustre.variable(styled_span([#("color", "#ffffff")]))
  |> smalto_lustre.constant(styled_span([#("color", "#74dfc4")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#ffe261")]))
  |> smalto_lustre.tag(styled_span([#("color", "#74dfc4")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#eb64b9")]))
  |> smalto_lustre.selector(styled_span([#("color", "#eb64b9")]))
  |> smalto_lustre.property(styled_span([#("color", "#40b4c4")]))
  |> smalto_lustre.regex(styled_span([#("color", "#b4dce7")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#40b4c4"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#ffffff")],
    code_color: "#008000",
  ))
}

/// Lucario Theme originally by Raphael Amorim [@raphamorim] https://github.com/raphamorim/lucario Ported for PrismJS by Chr
pub fn lucario() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#6EB26E")]))
  |> smalto_lustre.string(styled_span([#("color", "#FCFCD6")]))
  |> smalto_lustre.number(styled_span([#("color", "#BC94F9")]))
  |> smalto_lustre.comment(styled_span([#("color", "#5c98cd")]))
  |> smalto_lustre.function(styled_span([#("color", "#66D8EF")]))
  |> smalto_lustre.operator(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.type_(styled_span([#("color", "#66D8EF")]))
  |> smalto_lustre.module(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.constant(styled_span([#("color", "#F05E5D")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#FCFCD6")]))
  |> smalto_lustre.tag(styled_span([#("color", "#F05E5D")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#FCFCD6")]))
  |> smalto_lustre.selector(styled_span([#("color", "#FCFCD6")]))
  |> smalto_lustre.property(styled_span([#("color", "#F05E5D")]))
  |> smalto_lustre.regex(styled_span([#("color", "#F05E5D")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#F05E5D"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#f8f8f2")],
    code_color: "#008000",
  ))
}

/// material dark theme
pub fn material_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#c792ea")]))
  |> smalto_lustre.string(styled_span([#("color", "#a5e844")]))
  |> smalto_lustre.number(styled_span([#("color", "#fd9170")]))
  |> smalto_lustre.comment(styled_span([#("color", "#616161")]))
  |> smalto_lustre.function(styled_span([#("color", "#c792ea")]))
  |> smalto_lustre.operator(styled_span([#("color", "#89ddff")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#89ddff")]))
  |> smalto_lustre.type_(styled_span([#("color", "#f2ff00")]))
  |> smalto_lustre.module(styled_span([#("color", "#eee")]))
  |> smalto_lustre.variable(styled_span([#("color", "#ff6666")]))
  |> smalto_lustre.constant(styled_span([#("color", "#c792ea")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#ffcb6b")]))
  |> smalto_lustre.tag(styled_span([#("color", "#ff6666")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#ffcb6b")]))
  |> smalto_lustre.selector(styled_span([#("color", "#ff6666")]))
  |> smalto_lustre.property(styled_span([#("color", "#80cbc4")]))
  |> smalto_lustre.regex(styled_span([#("color", "#f2ff00")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#c792ea"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#ff6666")],
    code_color: "#008000",
  ))
}

/// material light theme
pub fn material_light() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#7c4dff")]))
  |> smalto_lustre.string(styled_span([#("color", "#f6a434")]))
  |> smalto_lustre.number(styled_span([#("color", "#f76d47")]))
  |> smalto_lustre.comment(styled_span([#("color", "#aabfc9")]))
  |> smalto_lustre.function(styled_span([#("color", "#7c4dff")]))
  |> smalto_lustre.operator(styled_span([#("color", "#39adb5")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#39adb5")]))
  |> smalto_lustre.type_(styled_span([#("color", "#6182b8")]))
  |> smalto_lustre.module(styled_span([#("color", "#90a4ae")]))
  |> smalto_lustre.variable(styled_span([#("color", "#e53935")]))
  |> smalto_lustre.constant(styled_span([#("color", "#7c4dff")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#39adb5")]))
  |> smalto_lustre.tag(styled_span([#("color", "#e53935")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#39adb5")]))
  |> smalto_lustre.selector(styled_span([#("color", "#e53935")]))
  |> smalto_lustre.property(styled_span([#("color", "#39adb5")]))
  |> smalto_lustre.regex(styled_span([#("color", "#6182b8")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#7c4dff"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#e53935")],
    code_color: "#008000",
  ))
}

/// material oceanic theme
pub fn material_oceanic() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(
    styled_span([#("color", "#c792ea"), #("font-style", "italic")]),
  )
  |> smalto_lustre.string(styled_span([#("color", "#c3e88d")]))
  |> smalto_lustre.number(styled_span([#("color", "#fd9170")]))
  |> smalto_lustre.comment(styled_span([#("color", "#546e7a")]))
  |> smalto_lustre.function(styled_span([#("color", "#c792ea")]))
  |> smalto_lustre.operator(styled_span([#("color", "#89ddff")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#89ddff")]))
  |> smalto_lustre.type_(styled_span([#("color", "#f2ff00")]))
  |> smalto_lustre.module(styled_span([#("color", "#c3cee3")]))
  |> smalto_lustre.variable(styled_span([#("color", "#f07178")]))
  |> smalto_lustre.constant(styled_span([#("color", "#c792ea")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#ffcb6b")]))
  |> smalto_lustre.tag(styled_span([#("color", "#f07178")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#ffcb6b")]))
  |> smalto_lustre.selector(styled_span([#("color", "#f07178")]))
  |> smalto_lustre.property(styled_span([#("color", "#80cbc4")]))
  |> smalto_lustre.regex(styled_span([#("color", "#f2ff00")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#c792ea"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#fd9170")],
    code_color: "#008000",
  ))
}

/// MIT License Copyright (c) 2018 Sarah Drasner Sarah Drasner's[@sdras] Night Owl Ported by Sara vieria [@SaraVieira] Added
pub fn night_owl() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.string(styled_span([#("color", "rgb(173, 219, 103)")]))
  |> smalto_lustre.number(styled_span([#("color", "rgb(247, 140, 108)")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "rgb(199, 146, 234)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "rgb(130, 170, 255)")]))
  |> smalto_lustre.operator(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "rgb(199, 146, 234)")]))
  |> smalto_lustre.type_(styled_span([#("color", "rgb(255, 203, 139)")]))
  |> smalto_lustre.module(styled_span([#("color", "rgb(178, 204, 214)")]))
  |> smalto_lustre.variable(styled_span([#("color", "rgb(214, 222, 235)")]))
  |> smalto_lustre.constant(styled_span([#("color", "rgb(130, 170, 255)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "rgb(130, 170, 255)")]))
  |> smalto_lustre.tag(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.attribute(
    styled_span([#("color", "rgb(173, 219, 103)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.selector(
    styled_span([#("color", "rgb(199, 146, 234)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.property(styled_span([#("color", "rgb(128, 203, 196)")]))
  |> smalto_lustre.regex(styled_span([#("color", "rgb(214, 222, 235)")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [
      #("color", "rgb(214, 222, 235)"),
      #("font-weight", "bold"),
    ],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "rgb(173, 219, 103)"),
    ],
    code_color: "#008000",
  ))
}

/// Nord Theme Originally by Arctic Ice Studio https://nordtheme.com Ported for PrismJS by Zane Hitchcoxc (@zwhitchcox) and 
pub fn nord() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.string(styled_span([#("color", "#A3BE8C")]))
  |> smalto_lustre.number(styled_span([#("color", "#B48EAD")]))
  |> smalto_lustre.comment(styled_span([#("color", "#636f88")]))
  |> smalto_lustre.function(styled_span([#("color", "#88C0D0")]))
  |> smalto_lustre.operator(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.type_(styled_span([#("color", "#88C0D0")]))
  |> smalto_lustre.module(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.constant(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#A3BE8C")]))
  |> smalto_lustre.tag(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#A3BE8C")]))
  |> smalto_lustre.selector(styled_span([#("color", "#A3BE8C")]))
  |> smalto_lustre.property(styled_span([#("color", "#81A1C1")]))
  |> smalto_lustre.regex(styled_span([#("color", "#EBCB8B")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#EBCB8B"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#81A1C1")],
    code_color: "#008000",
  ))
}

/// okaidia theme for JavaScript, CSS and HTML Loosely based on Monokai textmate theme by http://www.monokai.nl/ @author oco
pub fn okaidia() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#66d9ef")]))
  |> smalto_lustre.string(styled_span([#("color", "#a6e22e")]))
  |> smalto_lustre.number(styled_span([#("color", "#ae81ff")]))
  |> smalto_lustre.comment(styled_span([#("color", "#8292a2")]))
  |> smalto_lustre.function(styled_span([#("color", "#e6db74")]))
  |> smalto_lustre.operator(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.type_(styled_span([#("color", "#e6db74")]))
  |> smalto_lustre.module(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.variable(styled_span([#("color", "#f8f8f2")]))
  |> smalto_lustre.constant(styled_span([#("color", "#f92672")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#a6e22e")]))
  |> smalto_lustre.tag(styled_span([#("color", "#f92672")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#a6e22e")]))
  |> smalto_lustre.selector(styled_span([#("color", "#a6e22e")]))
  |> smalto_lustre.property(styled_span([#("color", "#f92672")]))
  |> smalto_lustre.regex(styled_span([#("color", "#fd971f")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#fd971f"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#f8f8f2")],
    code_color: "#008000",
  ))
}

/// One Dark theme for prism.js Based on Atom's One Dark theme: https://github.com/atom/atom/tree/master/packages/one-dark-s
pub fn one_dark() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "hsl(286, 60%, 67%)")]))
  |> smalto_lustre.string(styled_span([#("color", "hsl(95, 38%, 62%)")]))
  |> smalto_lustre.number(styled_span([#("color", "hsl(29, 54%, 61%)")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "hsl(220, 14%, 71%)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "hsl(207, 82%, 66%)")]))
  |> smalto_lustre.operator(styled_span([#("color", "hsl(207, 82%, 66%)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "hsl(95, 38%, 62%)")]))
  |> smalto_lustre.type_(styled_span([#("color", "hsl(29, 54%, 61%)")]))
  |> smalto_lustre.module(styled_span([#("color", "hsl(220, 14%, 71%)")]))
  |> smalto_lustre.variable(styled_span([#("color", "hsl(207, 82%, 66%)")]))
  |> smalto_lustre.constant(styled_span([#("color", "hsl(355, 65%, 65%)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "hsl(95, 38%, 62%)")]))
  |> smalto_lustre.tag(styled_span([#("color", "hsl(355, 65%, 65%)")]))
  |> smalto_lustre.attribute(styled_span([#("color", "hsl(29, 54%, 61%)")]))
  |> smalto_lustre.selector(styled_span([#("color", "hsl(95, 38%, 62%)")]))
  |> smalto_lustre.property(styled_span([#("color", "hsl(355, 65%, 65%)")]))
  |> smalto_lustre.regex(styled_span([#("color", "hsl(95, 38%, 62%)")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [
      #("color", "hsl(355, 65%, 65%)"),
      #("font-weight", "bold"),
    ],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "hsl(187, 47%, 55%)"),
    ],
    code_color: "#008000",
  ))
}

/// One Light theme for prism.js Based on Atom's One Light theme: https://github.com/atom/atom/tree/master/packages/one-ligh
pub fn one_light() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "hsl(301, 63%, 40%)")]))
  |> smalto_lustre.string(styled_span([#("color", "hsl(119, 34%, 47%)")]))
  |> smalto_lustre.number(styled_span([#("color", "hsl(35, 99%, 36%)")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "hsl(230, 8%, 24%)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "hsl(221, 87%, 60%)")]))
  |> smalto_lustre.operator(styled_span([#("color", "hsl(221, 87%, 60%)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "hsl(119, 34%, 47%)")]))
  |> smalto_lustre.type_(styled_span([#("color", "hsl(35, 99%, 36%)")]))
  |> smalto_lustre.module(styled_span([#("color", "hsl(230, 8%, 24%)")]))
  |> smalto_lustre.variable(styled_span([#("color", "hsl(221, 87%, 60%)")]))
  |> smalto_lustre.constant(styled_span([#("color", "hsl(5, 74%, 59%)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "hsl(119, 34%, 47%)")]))
  |> smalto_lustre.tag(styled_span([#("color", "hsl(5, 74%, 59%)")]))
  |> smalto_lustre.attribute(styled_span([#("color", "hsl(35, 99%, 36%)")]))
  |> smalto_lustre.selector(styled_span([#("color", "hsl(119, 34%, 47%)")]))
  |> smalto_lustre.property(styled_span([#("color", "hsl(5, 74%, 59%)")]))
  |> smalto_lustre.regex(styled_span([#("color", "hsl(119, 34%, 47%)")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "hsl(5, 74%, 59%)"), #("font-weight", "bold")],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "hsl(198, 99%, 37%)"),
    ],
    code_color: "#008000",
  ))
}

/// pojoaque theme
pub fn pojoaque() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#cb4b16")]))
  |> smalto_lustre.string(styled_span([#("color", "#468966")]))
  |> smalto_lustre.number(styled_span([#("color", "#b89859")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "#586e75"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "#b58900")]))
  |> smalto_lustre.operator(styled_span([#("color", "#dccf8f")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#dccf8f")]))
  |> smalto_lustre.type_(styled_span([#("color", "#b58900")]))
  |> smalto_lustre.module(styled_span([#("color", "#dccf8f")]))
  |> smalto_lustre.variable(styled_span([#("color", "#b58900")]))
  |> smalto_lustre.constant(styled_span([#("color", "#b89859")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#468966")]))
  |> smalto_lustre.tag(styled_span([#("color", "#ffb03b")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#b89859")]))
  |> smalto_lustre.selector(styled_span([#("color", "#859900")]))
  |> smalto_lustre.property(styled_span([#("color", "#b89859")]))
  |> smalto_lustre.regex(styled_span([#("color", "#859900")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#dc322f"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#dccf8f")],
    code_color: "#008000",
  ))
}

/// Shades of Purple Theme for Prism.js @author Ahmad Awais <https://twitter.com/MrAhmadAwais/> @support Follow/tweet at htt
pub fn shades_of_purple() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(
    styled_span([#("color", "#ff9d00"), #("font-weight", "400")]),
  )
  |> smalto_lustre.string(styled_span([#("color", "#a5ff90")]))
  |> smalto_lustre.number(styled_span([#("color", "#ff628c")]))
  |> smalto_lustre.comment(styled_span([#("color", "rgb(255, 157, 0)")]))
  |> smalto_lustre.function(styled_span([#("color", "rgb(250, 208, 0)")]))
  |> smalto_lustre.operator(styled_span([#("color", "rgb(255, 180, 84)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#ffffff")]))
  |> smalto_lustre.type_(styled_span([#("color", "#fb94ff")]))
  |> smalto_lustre.module(styled_span([#("color", "#9efeff")]))
  |> smalto_lustre.variable(styled_span([#("color", "#ff628c")]))
  |> smalto_lustre.constant(styled_span([#("color", "#ff628c")]))
  |> smalto_lustre.builtin(styled_span([#("color", "rgb(255, 157, 0)")]))
  |> smalto_lustre.tag(styled_span([#("color", "rgb(255, 157, 0)")]))
  |> smalto_lustre.attribute(styled_span([#("color", "rgb(255, 180, 84)")]))
  |> smalto_lustre.selector(styled_span([#("color", "#ff9d00")]))
  |> smalto_lustre.property(styled_span([#("color", "#ff628c")]))
  |> smalto_lustre.regex(styled_span([#("color", "#9efeff")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#ff9d00"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#287bde")],
    code_color: "#008000",
  ))
}

/// Solarized dark atom theme for `prism.js` Based on Atom's `atom-dark` theme: https://github.com/atom/atom-dark-syntax @au
pub fn solarized_dark_atom() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.string(styled_span([#("color", "#859900")]))
  |> smalto_lustre.number(styled_span([#("color", "#859900")]))
  |> smalto_lustre.comment(styled_span([#("color", "#586e75")]))
  |> smalto_lustre.function(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.operator(styled_span([#("color", "#EDEDED")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#93a1a1")]))
  |> smalto_lustre.type_(
    styled_span([#("color", "#FFFFB6"), #("text-decoration", "underline")]),
  )
  |> smalto_lustre.module(styled_span([#("color", "#839496")]))
  |> smalto_lustre.variable(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.constant(styled_span([#("color", "#dc322f")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#859900")]))
  |> smalto_lustre.tag(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#859900")]))
  |> smalto_lustre.selector(styled_span([#("color", "#859900")]))
  |> smalto_lustre.property(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.regex(styled_span([#("color", "#E9C062")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#fd971f"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#96CBFE")],
    code_color: "#008000",
  ))
}

/// solarizedlight theme
pub fn solarizedlight() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#859900")]))
  |> smalto_lustre.string(styled_span([#("color", "#2aa198")]))
  |> smalto_lustre.number(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.comment(styled_span([#("color", "#93a1a1")]))
  |> smalto_lustre.function(styled_span([#("color", "#b58900")]))
  |> smalto_lustre.operator(styled_span([#("color", "#657b83")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#586e75")]))
  |> smalto_lustre.type_(styled_span([#("color", "#b58900")]))
  |> smalto_lustre.module(styled_span([#("color", "#657b83")]))
  |> smalto_lustre.variable(styled_span([#("color", "#cb4b16")]))
  |> smalto_lustre.constant(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#2aa198")]))
  |> smalto_lustre.tag(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#2aa198")]))
  |> smalto_lustre.selector(styled_span([#("color", "#2aa198")]))
  |> smalto_lustre.property(styled_span([#("color", "#268bd2")]))
  |> smalto_lustre.regex(styled_span([#("color", "#cb4b16")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#cb4b16"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#657b83")],
    code_color: "#008000",
  ))
}

/// synthwave84 theme
pub fn synthwave84() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#f4eee4")]))
  |> smalto_lustre.string(styled_span([#("color", "#f87c32")]))
  |> smalto_lustre.number(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.comment(styled_span([#("color", "#8e8e8e")]))
  |> smalto_lustre.function(styled_span([#("color", "#fdfdfd")]))
  |> smalto_lustre.operator(styled_span([#("color", "#67cdcc")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#ccc")]))
  |> smalto_lustre.type_(styled_span([#("color", "#fff5f6")]))
  |> smalto_lustre.module(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.variable(styled_span([#("color", "#f87c32")]))
  |> smalto_lustre.constant(styled_span([#("color", "#f92aad")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#f4eee4")]))
  |> smalto_lustre.tag(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.selector(styled_span([#("color", "#72f1b8")]))
  |> smalto_lustre.property(styled_span([#("color", "#72f1b8")]))
  |> smalto_lustre.regex(styled_span([#("color", "#f87c32")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#f4eee4"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#67cdcc")],
    code_color: "#008000",
  ))
}

/// prism.js tomorrow night eighties for JavaScript, CoffeeScript, CSS and HTML Based on https://github.com/chriskempson/tom
pub fn tomorrow() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#cc99cd")]))
  |> smalto_lustre.string(styled_span([#("color", "#7ec699")]))
  |> smalto_lustre.number(styled_span([#("color", "#f08d49")]))
  |> smalto_lustre.comment(styled_span([#("color", "#999")]))
  |> smalto_lustre.function(styled_span([#("color", "#f08d49")]))
  |> smalto_lustre.operator(styled_span([#("color", "#67cdcc")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#ccc")]))
  |> smalto_lustre.type_(styled_span([#("color", "#f8c555")]))
  |> smalto_lustre.module(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.variable(styled_span([#("color", "#7ec699")]))
  |> smalto_lustre.constant(styled_span([#("color", "#f8c555")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#cc99cd")]))
  |> smalto_lustre.tag(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#e2777a")]))
  |> smalto_lustre.selector(styled_span([#("color", "#cc99cd")]))
  |> smalto_lustre.property(styled_span([#("color", "#f8c555")]))
  |> smalto_lustre.regex(styled_span([#("color", "#7ec699")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#cc99cd"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#67cdcc")],
    code_color: "#008000",
  ))
}

/// prism.js Twilight theme Based (more or less) on the Twilight theme originally of Textmate fame. @author Remy Bach
pub fn twilight() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "hsl(53, 89%, 79%)")]))
  |> smalto_lustre.string(styled_span([#("color", "hsl(76, 21%, 52%)")]))
  |> smalto_lustre.number(styled_span([#("color", "hsl(14, 58%, 55%)")]))
  |> smalto_lustre.comment(styled_span([#("color", "hsl(0, 0%, 47%)")]))
  |> smalto_lustre.function(styled_span([#("color", "white")]))
  |> smalto_lustre.operator(styled_span([#("color", "hsl(76, 21%, 52%)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "white")]))
  |> smalto_lustre.type_(styled_span([#("color", "white")]))
  |> smalto_lustre.module(styled_span([#("color", "white")]))
  |> smalto_lustre.variable(styled_span([#("color", "hsl(76, 21%, 52%)")]))
  |> smalto_lustre.constant(styled_span([#("color", "hsl(53, 89%, 79%)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "hsl(53, 89%, 79%)")]))
  |> smalto_lustre.tag(styled_span([#("color", "hsl(14, 58%, 55%)")]))
  |> smalto_lustre.attribute(styled_span([#("color", "hsl(76, 21%, 52%)")]))
  |> smalto_lustre.selector(styled_span([#("color", "hsl(53, 89%, 79%)")]))
  |> smalto_lustre.property(styled_span([#("color", "hsl(53, 89%, 79%)")]))
  |> smalto_lustre.regex(styled_span([#("color", "hsl(42, 75%, 65%)")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [
      #("color", "hsl(42, 75%, 65%)"),
      #("font-weight", "bold"),
    ],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "hsl(76, 21%, 52%)"),
    ],
    code_color: "#008000",
  ))
}

/// VS theme by Andrew Lock (https://andrewlock.net) Inspired by Visual Studio syntax coloring
pub fn vs() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#0000ff")]))
  |> smalto_lustre.string(styled_span([#("color", "#A31515")]))
  |> smalto_lustre.number(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "#008000"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.operator(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.type_(styled_span([#("color", "#2B91AF")]))
  |> smalto_lustre.module(styled_span([#("color", "#393A34")]))
  |> smalto_lustre.variable(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.constant(styled_span([#("color", "#36acaa")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#A31515")]))
  |> smalto_lustre.tag(styled_span([#("color", "#800000")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#ff0000")]))
  |> smalto_lustre.selector(styled_span([#("color", "#800000")]))
  |> smalto_lustre.property(styled_span([#("color", "#ff0000")]))
  |> smalto_lustre.regex(styled_span([#("color", "#ff0000")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#e90"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#ff0000")],
    code_color: "#008000",
  ))
}

/// vsc dark plus theme
pub fn vsc_dark_plus() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#569CD6")]))
  |> smalto_lustre.string(styled_span([#("color", "#ce9178")]))
  |> smalto_lustre.number(styled_span([#("color", "#b5cea8")]))
  |> smalto_lustre.comment(styled_span([#("color", "#808080")]))
  |> smalto_lustre.function(styled_span([#("color", "#dcdcaa")]))
  |> smalto_lustre.operator(styled_span([#("color", "#d4d4d4")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#ce9178")]))
  |> smalto_lustre.type_(styled_span([#("color", "#4ec9b0")]))
  |> smalto_lustre.module(styled_span([#("color", "#4ec9b0")]))
  |> smalto_lustre.variable(styled_span([#("color", "#9cdcfe")]))
  |> smalto_lustre.constant(styled_span([#("color", "#9cdcfe")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#ce9178")]))
  |> smalto_lustre.tag(styled_span([#("color", "#569cd6")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#9cdcfe")]))
  |> smalto_lustre.selector(styled_span([#("color", "#d7ba7d")]))
  |> smalto_lustre.property(styled_span([#("color", "#9cdcfe")]))
  |> smalto_lustre.regex(styled_span([#("color", "#d16969")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#569cd6"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#569cd6")],
    code_color: "#008000",
  ))
}

/// xonokai theme for JavaScript, CSS and HTML based on: https://github.com/MoOx/sass-prism-theme-base by Maxime Thirouin ~ 
pub fn xonokai() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "#ef3b7d")]))
  |> smalto_lustre.string(styled_span([#("color", "#e6d06c")]))
  |> smalto_lustre.number(styled_span([#("color", "#a77afe")]))
  |> smalto_lustre.comment(styled_span([#("color", "#6f705e")]))
  |> smalto_lustre.function(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.operator(styled_span([#("color", "#a77afe")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "#bebec5")]))
  |> smalto_lustre.type_(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.module(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.variable(styled_span([#("color", "#fff")]))
  |> smalto_lustre.constant(styled_span([#("color", "#a77afe")]))
  |> smalto_lustre.builtin(styled_span([#("color", "#e6d06c")]))
  |> smalto_lustre.tag(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.attribute(styled_span([#("color", "#e6d06c")]))
  |> smalto_lustre.selector(styled_span([#("color", "#a6e22d")]))
  |> smalto_lustre.property(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.regex(styled_span([#("color", "#76d9e6")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [#("color", "#ef3b7d"), #("font-weight", "bold")],
    url_styles: [#("text-decoration", "underline"), #("color", "#e6d06c")],
    code_color: "#008000",
  ))
}

/// z touch theme
pub fn z_touch() -> Config(msg) {
  smalto_lustre.default_config()
  |> smalto_lustre.keyword(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.string(styled_span([#("color", "rgb(173, 219, 103)")]))
  |> smalto_lustre.number(styled_span([#("color", "rgb(247, 140, 108)")]))
  |> smalto_lustre.comment(
    styled_span([#("color", "rgb(199, 146, 234)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.function(styled_span([#("color", "rgb(34 183 199)")]))
  |> smalto_lustre.operator(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.punctuation(styled_span([#("color", "rgb(199, 146, 234)")]))
  |> smalto_lustre.type_(styled_span([#("color", "rgb(255, 203, 139)")]))
  |> smalto_lustre.module(styled_span([#("color", "rgb(178, 204, 214)")]))
  |> smalto_lustre.variable(styled_span([#("color", "rgb(214, 222, 235)")]))
  |> smalto_lustre.constant(styled_span([#("color", "rgb(34 183 199)")]))
  |> smalto_lustre.builtin(styled_span([#("color", "rgb(34 183 199)")]))
  |> smalto_lustre.tag(styled_span([#("color", "rgb(127, 219, 202)")]))
  |> smalto_lustre.attribute(
    styled_span([#("color", "rgb(173, 219, 103)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.selector(
    styled_span([#("color", "rgb(199, 146, 234)"), #("font-style", "italic")]),
  )
  |> smalto_lustre.property(styled_span([#("color", "rgb(128, 203, 196)")]))
  |> smalto_lustre.regex(styled_span([#("color", "rgb(214, 222, 235)")]))
  |> smalto_lustre.custom(custom_renderer(
    important_styles: [
      #("color", "rgb(214, 222, 235)"),
      #("font-weight", "bold"),
    ],
    url_styles: [
      #("text-decoration", "underline"),
      #("color", "rgb(173, 219, 103)"),
    ],
    code_color: "#008000",
  ))
}

// --- Private helpers ---

fn styled_span(styles: List(#(String, String))) -> fn(String) -> Element(msg) {
  fn(value) {
    html.span(
      list.map(styles, fn(s) {
        let #(k, v) = s
        attribute.style(k, v)
      }),
      [element.text(value)],
    )
  }
}

fn custom_renderer(
  important_styles important_styles: List(#(String, String)),
  url_styles url_styles: List(#(String, String)),
  code_color code_color: String,
) -> fn(String, String) -> Element(msg) {
  fn(name, value) {
    case name {
      "important" -> styled_span(important_styles)(value)
      "bold" ->
        html.span([attribute.style("font-weight", "bold")], [
          element.text(value),
        ])
      "italic" ->
        html.span([attribute.style("font-style", "italic")], [
          element.text(value),
        ])
      "strike" ->
        html.span([attribute.style("text-decoration", "line-through")], [
          element.text(value),
        ])
      "code" ->
        html.span([attribute.style("color", code_color)], [element.text(value)])
      "url" -> styled_span(url_styles)(value)
      _ -> element.text(value)
    }
  }
}
