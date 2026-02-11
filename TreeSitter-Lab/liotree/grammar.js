export default grammar({
  name: 'liotree',

  extras: $ => [],  // no automatic whitespace – we match it explicitly

  rules: {
    // A file is a sequence of lines, each terminated by a newline.
    // The final line may lack a newline.
    source_file: $ => seq(
      repeat(seq($._line, '\n')),
      optional($._line)
    ),

    _line: $ => choice(
      $.root_line,
      $.structure_line,
      $.comment_line,
      $.blank_line
    ),

    // Blank line (zero or more spaces/tabs)
    blank_line: $ => /[ \t]*/,

    // ------------------------------------------------------------------
    // Root line:  |name…   (no depth markers, no space after '|')
    // ------------------------------------------------------------------
    root_line: $ => seq(
      /[ \t]*/,               // leading indentation
      $.lateral_bar,
      field('name', $.name),
      optional($.inline_comment)
    ),

    // ------------------------------------------------------------------
    // Structure line:  |-- name…   (depth markers + whitespace)
    // ------------------------------------------------------------------
    structure_line: $ => seq(
      /[ \t]*/,
      $.lateral_bar,
      field('depth', $.depth_marks),
      /[ \t]+/,               // at least one space/tab after the depth marks
      field('name', $.name),
      optional($.inline_comment)
    ),

    // ------------------------------------------------------------------
    // Comment line:  |  text…   (at least two spaces after '|')
    // ------------------------------------------------------------------
    comment_line: $ => seq(
      /[ \t]*/,
      $.lateral_bar,
      /[ \t]{2,}/,           // two or more spaces/tabs
      field('text', $.comment_text),
      optional($.comment_end)
    ),

    // ------------------------------------------------------------------
    // Name – may be quoted (with or without trailing '/'),
    // unquoted, or an unclosed quoted string (error token)
    // ------------------------------------------------------------------
    name: $ => choice(
      $.quoted_dirname,
      $.quoted_filename,
      $.unquoted_dirname,
      $.unquoted_filename,
      $.unclosed_quoted_string
    ),

    // ------------------------------------------------------------------
    // Basic tokens
    // ------------------------------------------------------------------
    lateral_bar: $ => '|',
    depth_marks: $ => /[-+]+/,

    // Inline comment:   > text …
    inline_comment: $ => seq(
      /\s*/,                 // optional whitespace before '>'
      $.comment_start,
      field('text', $.comment_text),
      optional($.comment_end)
    ),
    comment_start: $ => '>',
    comment_end:   $ => '||',

    // Comment text stops at a '|' or newline, so we can optionally match
    // a trailing '||' as a separate token.
    comment_text: $ => token(/[^|\n]*/),

    // ------------------------------------------------------------------
    // Quoted names – with or without trailing '/'
    // ------------------------------------------------------------------
    quoted_dirname: $ => token(choice(
      seq("'", repeat(choice(/[^']/, /\\./)), "'/"),
      seq('"', repeat(choice(/[^"]/, /\\./)), '"/')
    )),

    quoted_filename: $ => token(choice(
      seq("'", repeat(choice(/[^']/, /\\./)), "'"),
      seq('"', repeat(choice(/[^"]/, /\\./)), '"')
    )),

    // ------------------------------------------------------------------
    // Unquoted names – first char cannot be '-', '+', '|', '>', or whitespace
    // ------------------------------------------------------------------
    unquoted_dirname: $ => token(
      /[^-+|>\s][^|>]*\//
    ),
    unquoted_filename: $ => token(
      /[^-+|>\s][^|>]*/
    ),

    // ------------------------------------------------------------------
    // Error token: an opening quote with no closing quote before newline
    // ------------------------------------------------------------------
    unclosed_quoted_string: $ => token(choice(
      seq("'", repeat(/[^'\n]/)),
      seq('"', repeat(/[^"\n]/))
    )),
  }
});
