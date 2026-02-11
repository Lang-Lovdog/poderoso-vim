# For making my own tree-sitter parsers mwahahaha

.PHONY: all

liotree:
	cd liotree && tree-sitter generate && tree-sitter build
	mkdir -p ~/.local/share/nvim/site/pack/nvim-treesitter/start/nvim-treesitter/parser/
	cp liotree/parser.o 
