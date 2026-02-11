; Lateral bar (the '|' character)
(lateral_bar) @type

; Depth markers ('-' and '+')
(depth_marks) @keyword

; ----------------------------------------------------------------------
; Names
; ----------------------------------------------------------------------
(quoted_dirname)   @function
(unquoted_dirname) @function
(quoted_filename)  @keyword
(unquoted_filename) @variable

; Unclosed quoted strings – highlight as error
(unclosed_quoted_string) @error

; ----------------------------------------------------------------------
; Comments
; ----------------------------------------------------------------------
; Inline comment: the '>' delimiter and the text that follows
(comment_start) @punctuation.delimiter
(inline_comment
  comment_text: _ @comment)

; Full comment lines – the whole line is comment text
(comment_line
  comment_text: _ @comment)

; Optional '||' at the end of a comment
(comment_end) @punctuation.special

; ----------------------------------------------------------------------
; (Optional) Mark the whole root line or structure line if you need
; special highlighting; the name highlighting already takes effect.
; ----------------------------------------------------------------------
; For example, to highlight the '|' of a root line differently:
; (root_line lateral_bar) @type
; (structure_line lateral_bar) @type
