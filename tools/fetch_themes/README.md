# Fetch Themes

A Node.js tool that fetches [Prism.js](https://prismjs.com/) CSS themes and adapts them for [Smalto](../../)'s class prefix.

## Requirements

- Node.js 20+
- npm

## Setup

```sh
npm install
```

## Usage

```sh
npm start
```

Or directly:

```sh
node src/index.js
```

### What it does

1. Fetches CSS from [PrismJS/prism](https://github.com/PrismJS/prism) (8 bundled themes) and [PrismJS/prism-themes](https://github.com/PrismJS/prism-themes) (37 community themes)
2. Rewrites selectors from `.token.X` to `.smalto-X`
3. Converts code block selectors to `.smalto` wrapper class
4. Converts inline code selectors to `.smalto-inline`
5. Adds license headers with Prism.js attribution
6. Writes 45 adapted CSS files to `../../themes/`

### Output

The tool generates CSS theme files in `../../themes/` with the `smalto-` prefix (e.g., `smalto-dracula.css`, `smalto-nord.css`).

### Selector transformations

| Prism.js selector                      | Smalto selector   |
| -------------------------------------- | ----------------- |
| `.token.keyword`                       | `.smalto-keyword` |
| `code[class*="language-"]`             | `.smalto code`    |
| `pre[class*="language-"]`              | `.smalto`         |
| `:not(pre) > code[class*="language-"]` | `.smalto-inline`  |

## Themes

### Bundled (8)

Default, Coy, Dark, Funky, Okaidia, Solarized Light, Tomorrow Night, Twilight

### Community (37)

A11y Dark, Atom Dark, Base16 Ateliersulphurpool Light, CB, Coldark Cold, Coldark Dark, Coy Without Shadows, Darcula, Dracula, Duotone Dark, Duotone Earth, Duotone Forest, Duotone Light, Duotone Sea, Duotone Space, GH Colors, Gruvbox Dark, Gruvbox Light, Holi, Hopscotch, Laserwave, Lucario, Material Dark, Material Light, Material Oceanic, Night Owl, Nord, One Dark, One Light, Pojoaque, Shades of Purple, Solarized Dark Atom, Synthwave '84, VS, VSC Dark Plus, Xonokai, Z-Touch
