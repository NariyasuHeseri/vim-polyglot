" Turn on filetype plugins (:help filetype-plugin).
if has('autocmd') && !(exists("did_load_filetypes") && exists("did_indent_on"))
  filetype plugin indent on
endif

" Enable syntax highlighting.
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" No need to duplicate work
if exists('g:loaded_sensible')
	finish
endif

" Code taken from https://github.com/tpope/vim-sensible
" and (mostly comments) from https://github.com/sheerun/vimrc
if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'sensible')
	" Autoindent when starting new line, or using `o` or `O`.
	set autoindent

	" Allow backspace in insert mode.
	set backspace=indent,eol,start

	" Don't scan included files. The .tags file is more performant.
	set complete-=i

	" Use 'shiftwidth' when using `<Tab>` in front of a line.
	" By default it's used only for shift commands (`<`, `>`).
	set smarttab

	" Disable octal format for number processing.
	set nrformats-=octal

	" Allow for mappings including `Esc`, while preserving
	" zero timeout after pressing it manually.
	" (only vim needs a fix for this)
	if !has('nvim') && &ttimeoutlen == -1
		set ttimeout
		set ttimeoutlen=100
	endif

	" Enable highlighted case-insensitive incremential search.
	set incsearch

	" Use <C-L> to clear the highlighting of :set hlsearch.
	if maparg('<C-L>', 'n') ==# ''
		nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
	endif

	" Always show window statuses, even if there's only one.
	set laststatus=2

	" Show the line and column number of the cursor position.
	set ruler

	" Autocomplete commands using nice menu in place of window status.
	" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
	set wildmenu

	" Keep 5 columns next to the cursor when scrolling horizontally.
	if !&scrolloff
		set scrolloff=1
	endif
	if !&sidescrolloff
		set sidescrolloff=5
	endif

	" When 'wrap' is on, display last line even if it doesn't fit.
	set display+=lastline

	" Force utf-8 encoding
	set encoding=utf-8

	" Set default whitespace characters when using `:set list`
	if &listchars ==# 'eol:$'
		set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
	endif

	" Delete comment character when joining commented lines
	if v:version > 703 || v:version == 703 && has("patch541")
		set formatoptions+=j
	endif

	" Search upwards for tags file instead only locally
	if has('path_extra')
		setglobal tags-=./tags tags-=./tags; tags^=./tags;
	endif

	" Fix issues with fish shell
	" https://github.com/tpope/vim-sensible/issues/50
	if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
		set shell=/usr/bin/env\ bash
	endif

	" Reload unchanged files automatically.
	set autoread

	" Increase history size to 1000 items.
	if &history < 1000
		set history=1000
	endif

	" Allow for up to 50 opened tabs on Vim start.
	if &tabpagemax < 50
		set tabpagemax=50
	endif

	" Always save upper case variables to viminfo file.
	if !empty(&viminfo)
		set viminfo^=!
	endif

	" Don't save options in sessions and views
	set sessionoptions-=options
	set viewoptions-=options

	" Allow color schemes to do bright colors without forcing bold.
	if &t_Co == 8 && $TERM !~# '^Eterm'
		set t_Co=16
	endif

	" Load matchit.vim, but only if the user hasn't installed a newer version.
	if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
		runtime! macros/matchit.vim
	endif

	" `Ctrl-U` in insert mode deletes a lot. Use `Ctrl-G` u to first break undo,
	" so that you can undo `Ctrl-U` without undoing what you typed before it.
	if empty(mapcheck('<C-U>', 'i'))
		inoremap <C-U> <C-G>u<C-U>
	endif

	if empty(mapcheck('<C-W>', 'i'))
		inoremap <C-W> <C-G>u<C-W>
	endif
endif