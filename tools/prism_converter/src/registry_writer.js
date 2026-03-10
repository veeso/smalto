// Registry writer module — generates the registry.gleam module
// AIRBNB-2.1: const by default

/**
 * Render the registry.gleam module source code.
 *
 * @param {string[]} languages - list of language names to include
 * @returns {string} Gleam source code
 */
function renderRegistry(languages) {
  const sorted = [...languages].sort();

  if (sorted.length === 0) {
    return `import gleam/dict.{type Dict}
import smalto/grammar.{type Grammar}

pub fn languages() -> Dict(String, Grammar) {
  dict.new()
}
`;
  }

  const imports = sorted.map((lang) => `import smalto/languages/${lang}`).join('\n');

  const entries = sorted.map((lang) => `    #("${lang}", ${lang}.grammar())`).join(',\n');

  return `import gleam/dict.{type Dict}
import smalto/grammar.{type Grammar}
${imports}

pub fn languages() -> Dict(String, Grammar) {
  dict.from_list([
${entries},
  ])
}
`;
}

export { renderRegistry };
