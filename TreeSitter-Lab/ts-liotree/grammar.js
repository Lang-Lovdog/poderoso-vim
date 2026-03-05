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
  extras: $ => [/[\t\r]/],

  rules: {
    source_file: $ => repeat($._item),

    _item: $ => choice(
      $.root,
      $.file_entry,
      $.directory_entry,
      $.comment
    ),


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

    format_space: $ => /\s/,

    depth_mark: $ => /[-+]/,

    file_entry: $ => seq(
      $.entry_bar,
      field("bridge", optional(repeat($.depth_mark))),
      field("leaf", $.depth_mark),
      " ",
      field("name", $.file_name),
      optional($.comment),
      /\n/
    ),

    directory_entry: $ => prec.left(seq(
      $.entry_bar,
      field("bridge", optional(repeat($.depth_mark))),
      field("leaf", $.depth_mark),
      " ",
      field("name", $.directory_name),
      optional($.comment),
      /\n/,
      // THE MAGIC: A directory can contain more items
      optional(field("contents", repeat1($._item))) 
    )),

    directory_name: $ => seq(
      /[^-+|>\s][^|>\n]*\/['"]{0,1}/,
      field("formatspace", optional(repeat($.format_space)))
    ),

    file_name: $ => seq(
      choice(
      /[^-+|>\s][^|>\/\n\s]*/,
      /\"[^|>\/\n]*\"/,
      /\'[^|>\/\n]*\'/
      ),
      field("formatspace", optional(repeat($.format_space)))
    ),

    // Comment handles multi-line with the | bar
    comment: $ => seq(
      ">",
      repeat(choice(/[^|\n]/, $.comment_newline)),
      "||"
    ),

    comment_newline: $ => seq(/\n\s*/, "|", /\s*/)
  }
});
