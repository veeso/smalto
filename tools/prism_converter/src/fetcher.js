// Fetcher module — loads Prism.js grammars via require
// AIRBNB-2.1: const by default

import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const Prism = require('prismjs');
const loadLanguages = require('prismjs/components/');

// Map from our language name to Prism component name
const COMPONENT_MAP = {
  bash: 'bash',
  c: 'c',
  cpp: 'cpp',
  css: 'css',
  dart: 'dart',
  dockerfile: 'docker',
  elixir: 'elixir',
  erlang: 'erlang',
  go: 'go',
  haskell: 'haskell',
  html: 'markup',
  java: 'java',
  javascript: 'javascript',
  json: 'json',
  kotlin: 'kotlin',
  lua: 'lua',
  markdown: 'markdown',
  php: 'php',
  python: 'python',
  ruby: 'ruby',
  rust: 'rust',
  scala: 'scala',
  sql: 'sql',
  swift: 'swift',
  toml: 'toml',
  typescript: 'typescript',
  xml: 'xml',
  yaml: 'yaml',
  zig: 'zig',
};

// Known extends relationships in Prism.js (hardcoded for reliability)
const KNOWN_EXTENDS = {
  c: 'clike',
  cpp: 'c',
  dart: 'clike',
  go: 'clike',
  java: 'clike',
  javascript: 'clike',
  kotlin: 'clike',
  php: 'clike',
  ruby: 'clike',
  scala: 'java',
  swift: 'clike',
  typescript: 'javascript',
};

const ALL_LANGUAGES = Object.keys(COMPONENT_MAP);

// Load all components at once — Prism handles dependency ordering
loadLanguages(ALL_LANGUAGES.map((lang) => COMPONENT_MAP[lang]));

// Build a lookup map from Prism grammar objects to our language names
// Used for resolving `rest` self-references
const grammarToName = new Map();
for (const lang of ALL_LANGUAGES) {
  const component = COMPONENT_MAP[lang];
  const grammar = Prism.languages[component];
  if (grammar) {
    grammarToName.set(grammar, lang);
  }
}
// Also add clike for rest resolution
if (Prism.languages.clike) {
  grammarToName.set(Prism.languages.clike, 'clike');
}

/**
 * Fetch a single language grammar from Prism.js.
 *
 * @param {string} language - our language name
 * @returns {{ grammar: object, extends: string|null }}
 */
function fetchGrammar(language) {
  const component = COMPONENT_MAP[language];
  if (!component) {
    throw new Error(`Unknown language: ${language}`);
  }

  const grammar = Prism.languages[component];
  if (!grammar || typeof grammar !== 'object') {
    throw new Error(`Failed to load Prism grammar for: ${language} (component: ${component})`);
  }

  const extendsLang = KNOWN_EXTENDS[language] || null;

  return { grammar, extends: extendsLang };
}

/**
 * Fetch all supported language grammars.
 *
 * @returns {Object.<string, { grammar: object, extends: string|null }>}
 */
function fetchAllGrammars() {
  const results = {};
  for (const lang of ALL_LANGUAGES) {
    results[lang] = fetchGrammar(lang);
  }
  return results;
}

export {
  fetchGrammar,
  fetchAllGrammars,
  ALL_LANGUAGES,
  COMPONENT_MAP,
  KNOWN_EXTENDS,
  grammarToName,
};
