"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

set shell=/bin/bash


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu "Turn on WiLd menu
set ruler "Always show current position
set cmdheight=2 "The commandbar height

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros 

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

set t_Co=256
if has("gui_running")
  set guioptions-=T
  set background=dark
  colorscheme desert
  set nonu
else
  colorscheme zenburn
  set background=dark
  highlight Pmenu ctermbg=238 gui=bold
  set nonu
endif



set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set expandtab
"set shiftwidth=4
"set tabstop=4
"set smarttab

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=8
"
" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" C: tabs (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
fu Select_c_style()
	if search('^\t', 'n', 150)
	     set shiftwidth=4
             set noexpandtab
	el 
		set shiftwidth=2
		set expandtab
	en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
" highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
" au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Instead of highlighting badwhitespace, I rather use the list and listchars 
" modes.
set list listchars=tab:>-,trail:.,extends:>

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

set lbr
set tw=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if MySys() == "windows"
      set undodir=C:\Windows\Temp
    else
      set undodir=~/.vim_runtime/undodir
    endif

    set undofile
catch
endtry


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tags, auto-complete and stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1
function FindCtagsHere(dir, dir_sep)
	let tag_dir = a:dir
	let sep = a:dir_sep
	while !filereadable(tag_dir.sep."tags") && tag_dir!=$HOME && stridx(tag_dir, sep)>=0
		let tag_dir = substitute(tag_dir, sep.'[^'.sep.']\+$', "", "")
	endwhile
        if filereadable(tag_dir.sep."tags")
		return tag_dir.sep."tags"
	else
		return ''
	endif
endfunction

function BuildCtags()
	let ctag_file = FindCtagsHere(expand('%:p:h'), '/')
        
	if filereadable(tag_dir.sep."tags")
		silent !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q %<c-r>=ctag_file<cr><cr>
endfunction

function! LoadCscope()
	let db = findfile("cscope.out", ".;")
	if (!empty(db))
		let path = strpart(db, 0, match(db, "/cscope.out$"))
		set nocscopeverbose " suppress 'duplicate connection' error
		exe "cs add " . db . " " . path
		set cscopeverbose
	endif
endfunction

au BufEnter /* call LoadCscope()

set nocp
filetype plugin on

set tags=./tags;

noremap <silent> <F6> <C-]>
nnoremap <silent> <F7> <C-R>=BuildCtags()<CR><CR>
nnoremap <silent> <F8> :TagbarToggle<CR>
"nnoremap <silent> <F8> :TlistToggle<CR>

""""""""""""""""""""""""""""""
" => Some Toggles
""""""""""""""""""""""""""""""
" Map key to toggle opt
function MapToggle(key, opt)
	let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
	exec 'nnoremap '.a:key.' '.cmd
	exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <F11> ignorecase

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

set number
