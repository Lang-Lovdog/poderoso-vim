;; highlights.scm
;; extends

; --- 1. Structural Conceals ---
((root_bar) @conceal.root
(#set! @conceal.root "conceal" ""))

((entry_bar) @conceal.entry
(#set! @conceal.entry "conceal" "├"))

; Handle every dash/plus individually 
; We apply the line icon to ALL of them first
((depth_mark) @conceal.line @operator
(#set! @conceal.line "conceal" "─"))

; --- 2. Smart Icons (The "Overlays") ---
; If a depth_mark is the last child of a depth_marker, it's our icon candidate
; Note: Older TS engines may need the simple version:
; 1. DEFAULT LINE (The Fallback)
; We put this first so specific icon rules can override it
((file_entry 
  bridge: (depth_mark) @conceal.line)
(#set! @conceal.line "conceal" "─"))

((directory_entry 
  bridge: (depth_mark) @conceal.line)
(#set! @conceal.line "conceal" "─"))

; 2. LEAF (The Icons)
; If the leaf belongs to a directory entry
((directory_entry 
    leaf: (depth_mark) @conceal.dir
    name: (directory_name))
 (#set! @conceal.dir "conceal" ""))

; If the leaf belongs to a file entry
((file_entry 
    leaf: (depth_mark) @conceal.file
    name: (file_name))
 (#set! @conceal.file "conceal" ""))


; --- 3. Comment Logic ---

; Match the entire comment node
((comment) @comment.liotree @spell)

; Match the specific markers within the comment for concealing
((comment ">" @conceal.start)
 (#set! @conceal.start "conceal" "▶"))

((comment "||" @conceal.stop)
 (#set! @conceal.stop "conceal" "█"))

; Handle the internal bars (|) for your multi-line research notes
((comment_newline "|" @conceal.pipe)
 (#set! @conceal.pipe "conceal" "│"))

((format_space) @conceal.line
(#set! @conceal.line "conceal" "·"))

(directory_entry bridge: (depth_mark) @liotree.bridge)
(directory_entry leaf: (depth_mark) @liotree.leaf)
(file_entry bridge: (depth_mark) @liotree.bridge)
(file_entry leaf: (depth_mark) @liotree.leaf)
((directory_name) @liotree.directory @nospell)
((file_name) @liotree.file @nospell)
(root_bar) @liotree.bar
(entry_bar) @liotree.bar
