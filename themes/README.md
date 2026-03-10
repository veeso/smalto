# Smalto Themes

Pre-built CSS themes for Smalto's HTML output, adapted from [Prism.js](https://prismjs.com) themes.

## Usage

1. Include a theme CSS file in your HTML
2. Wrap highlighted output in `<pre class="smalto"><code>`:

```html
<link rel="stylesheet" href="smalto-dracula.css">

<pre class="smalto"><code><!-- output from smalto.to_html() --></code></pre>
```

For inline code, use `<code class="smalto-inline">`.

## Available Themes (45)

### Bundled (from PrismJS/prism)

| Theme | File |
|-------|------|
| Default | `smalto-default.css` |
| Coy | `smalto-coy.css` |
| Dark | `smalto-dark.css` |
| Funky | `smalto-funky.css` |
| Okaidia | `smalto-okaidia.css` |
| Solarized Light | `smalto-solarizedlight.css` |
| Tomorrow Night | `smalto-tomorrow.css` |
| Twilight | `smalto-twilight.css` |

### Community (from PrismJS/prism-themes)

| Theme | File |
|-------|------|
| A11y Dark | `smalto-a11y-dark.css` |
| Atom Dark | `smalto-atom-dark.css` |
| Base16 Atelier Sulphurpool Light | `smalto-base16-ateliersulphurpool.light.css` |
| CB | `smalto-cb.css` |
| Coldark Cold | `smalto-coldark-cold.css` |
| Coldark Dark | `smalto-coldark-dark.css` |
| Coy Without Shadows | `smalto-coy-without-shadows.css` |
| Darcula | `smalto-darcula.css` |
| Dracula | `smalto-dracula.css` |
| Duotone Dark | `smalto-duotone-dark.css` |
| Duotone Earth | `smalto-duotone-earth.css` |
| Duotone Forest | `smalto-duotone-forest.css` |
| Duotone Light | `smalto-duotone-light.css` |
| Duotone Sea | `smalto-duotone-sea.css` |
| Duotone Space | `smalto-duotone-space.css` |
| GitHub Colors | `smalto-ghcolors.css` |
| Gruvbox Dark | `smalto-gruvbox-dark.css` |
| Gruvbox Light | `smalto-gruvbox-light.css` |
| Holi | `smalto-holi-theme.css` |
| Hopscotch | `smalto-hopscotch.css` |
| Laserwave | `smalto-laserwave.css` |
| Lucario | `smalto-lucario.css` |
| Material Dark | `smalto-material-dark.css` |
| Material Light | `smalto-material-light.css` |
| Material Oceanic | `smalto-material-oceanic.css` |
| Night Owl | `smalto-night-owl.css` |
| Nord | `smalto-nord.css` |
| One Dark | `smalto-one-dark.css` |
| One Light | `smalto-one-light.css` |
| Pojoaque | `smalto-pojoaque.css` |
| Shades of Purple | `smalto-shades-of-purple.css` |
| Solarized Dark Atom | `smalto-solarized-dark-atom.css` |
| Synthwave '84 | `smalto-synthwave84.css` |
| VS | `smalto-vs.css` |
| VS Code Dark+ | `smalto-vsc-dark-plus.css` |
| Xonokai | `smalto-xonokai.css` |
| Z-Touch | `smalto-z-touch.css` |

## Regenerating

To re-fetch and convert themes from Prism.js:

```sh
node tools/fetch_themes.js
```

## License

MIT — adapted from [PrismJS/prism](https://github.com/PrismJS/prism) and [PrismJS/prism-themes](https://github.com/PrismJS/prism-themes). See [LICENSE](./LICENSE).
