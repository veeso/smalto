// Renderer module — generates Gleam source code from parsed grammar IR
// AIRBNB-2.1: const by default

/**
 * Escape a string for use inside a Gleam string literal.
 * Gleam strings use double quotes and backslash escapes.
 *
 * @param {string} str
 * @returns {string}
 */
function escapeGleamString(str) {
  return str.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

/**
 * Render a single rule as a Gleam expression string.
 *
 * @param {{ token: string, pattern: string, greedy: boolean, inside: object|null }} rule
 * @param {string} indent - current indentation
 * @returns {string}
 */
function renderRule(rule, indent = '    ') {
  const escapedPattern = escapeGleamString(rule.pattern);

  if (rule.inside) {
    if (rule.inside.type === 'ref') {
      // nested_rule is always non-greedy per the builder API
      return `${indent}grammar.nested_rule("${rule.token}", "${escapedPattern}", "${rule.inside.language}")`;
    }

    // Inline inside grammar
    const innerIndent = `${indent}  `;
    const insideRules = rule.inside.rules
      .map((r) => renderRule(r, innerIndent))
      .join(',\n');
    const builderFn = rule.greedy ? 'grammar.greedy_rule_with_inside' : 'grammar.rule_with_inside';

    if (rule.inside.rules.length === 0) {
      // No inside rules — fall through to simple rule
      const simpleFn = rule.greedy ? 'grammar.greedy_rule' : 'grammar.rule';
      return `${indent}${simpleFn}("${rule.token}", "${escapedPattern}")`;
    }

    return `${indent}${builderFn}("${rule.token}", "${escapedPattern}", [\n${insideRules},\n${indent}])`;
  }

  const builderFn = rule.greedy ? 'grammar.greedy_rule' : 'grammar.rule';
  return `${indent}${builderFn}("${rule.token}", "${escapedPattern}")`;
}

/**
 * Render a full Gleam module from a parsed grammar IR.
 *
 * @param {{ name: string, extends: string|null, rules: Array }} ir
 * @returns {string} Gleam source code
 */
function renderGrammar(ir) {
  const extendsValue = ir.extends
    ? `option.Some("${ir.extends}")`
    : 'option.None';

  const rulesStr = ir.rules.length === 0
    ? '[]'
    : `[\n${ir.rules.map((r) => renderRule(r)).join(',\n')},\n  ]`;

  return `import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "${ir.name}", extends: ${extendsValue}, rules: rules())
}

fn rules() -> List(Rule) {
  ${rulesStr}
}
`;
}

export { renderGrammar, escapeGleamString, renderRule };
