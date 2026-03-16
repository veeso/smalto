# smalto_lustre_themes

[![Package Version](https://img.shields.io/hexpm/v/smalto_lustre_themes)](https://hex.pm/packages/smalto_lustre_themes)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smalto_lustre_themes/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Pre-built theme configurations for
[smalto_lustre](https://hex.pm/packages/smalto_lustre). 45 themes ported from
[Prism.js](https://prismjs.com/) as inline-styled Lustre elements — no CSS
files needed.

## Quick start

```sh
gleam add smalto smalto_lustre smalto_lustre_themes
```

```gleam
import smalto
import smalto/languages/python
import smalto/lustre as smalto_lustre
import smalto/lustre/themes

let tokens = smalto.to_tokens("print('hello')", python.grammar())
let elements = smalto_lustre.to_lustre(tokens, themes.dracula())
```

## Available themes

| Function | Based on |
|---|---|
| `a11y_dark()` | A11y Dark |
| `atom_dark()` | Atom Dark |
| `base16_ateliersulphurpool_light()` | Base16 Atelier Sulphurpool Light |
| `cb()` | CB |
| `coldark_cold()` | Coldark Cold |
| `coldark_dark()` | Coldark Dark |
| `coy()` | Coy |
| `coy_without_shadows()` | Coy without Shadows |
| `darcula()` | Darcula |
| `dark()` | Dark |
| `default()` | Default |
| `dracula()` | Dracula |
| `duotone_dark()` | Duotone Dark |
| `duotone_earth()` | Duotone Earth |
| `duotone_forest()` | Duotone Forest |
| `duotone_light()` | Duotone Light |
| `duotone_sea()` | Duotone Sea |
| `duotone_space()` | Duotone Space |
| `funky()` | Funky |
| `ghcolors()` | GitHub Colors |
| `gruvbox_dark()` | Gruvbox Dark |
| `gruvbox_light()` | Gruvbox Light |
| `holi_theme()` | Holi |
| `hopscotch()` | Hopscotch |
| `laserwave()` | Laserwave |
| `lucario()` | Lucario |
| `material_dark()` | Material Dark |
| `material_light()` | Material Light |
| `material_oceanic()` | Material Oceanic |
| `night_owl()` | Night Owl |
| `nord()` | Nord |
| `okaidia()` | Okaidia |
| `one_dark()` | One Dark |
| `one_light()` | One Light |
| `pojoaque()` | Pojoaque |
| `shades_of_purple()` | Shades of Purple |
| `solarized_dark_atom()` | Solarized Dark Atom |
| `solarizedlight()` | Solarized Light |
| `synthwave84()` | Synthwave '84 |
| `tomorrow()` | Tomorrow Night |
| `twilight()` | Twilight |
| `vs()` | VS |
| `vsc_dark_plus()` | VS Code Dark+ |
| `xonokai()` | Xonokai |
| `z_touch()` | Z-Touch |
