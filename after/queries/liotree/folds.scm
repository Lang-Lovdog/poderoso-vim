;; 1. Fold the 'contents' field inside a directory_entry
(directory_entry 
  contents: (_) @fold)

;; 2. Fold the 'contents' field inside a root
(root 
  contents: (_) @fold)

;; 3. Fold multi-line comments
(comment) @fold
