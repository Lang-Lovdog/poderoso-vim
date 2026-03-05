/**
 * @file This is Lang Lovdog's format for directory tree representation
 * @author Lang Lovdog Inu Oókami <hataraku_wulfus@outlook.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "liotree",

  // Do not include \n in extras so we can anchor rules to line starts
  extras: $ => [/[ \t\r]/],

  rules: {
    source_file: $ => repeat($._node),

    _node: $ => choice($.root, $.entry),

    // Fixed Root: Recognizes | followed by a directory name
    root: $ => seq(
      $.root_bar,
      " ",
      field("name", $.directory_name),
      optional($.comment),
      /\n/
    ),

    root_bar: $ => "|",

    // Fixed Entry: Splits the bar from the dashes to prevent "conceal eating"
    entry_bar: $ => "|",

    entry: $ => seq(
      $.entry_bar,
      field("bridge", optional(repeat($.depth_mark))),
      field("leaf", $.depth_mark),
      " ",
      field("name", choice($.directory_name, $.file_name)),
      optional($.comment),
      /\n/
    ),

    depth_mark: $ => /[-+]/,

    directory_name: $ => /[^-+|>\s][^|>\n]*\//,
    file_name: $ => /[^-+|>\s][^|>\/\n]*/,

    // Comment handles multi-line with the | bar
    comment: $ => seq(
      ">",
      repeat(choice(/[^|\n]/, $.comment_newline)),
      "||"
    ),

    comment_newline: $ => seq(/\n\s*/, "|", /\s*/)
  }
});
