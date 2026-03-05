;; after/queries/liotree/folds.scm

; Rule 1: Multi-line comments are easy
(comment) @fold

; Rule 2: The "Flat Tree" Fold
; This looks for an entry with a directory and creates a range 
; that includes the following siblings.
(
  (entry (directory_name)) @fold.start
  (entry) @fold.end
  (#make-range! "fold" @fold.start @fold.end)
)
