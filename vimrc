let g:mapleader = "\<Space>"

" ---------------------------------------------------------------------------
" Autoinstall vim-plug
" ---------------------------------------------------------------------------
"
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ---------------------------------------------------------------------------
" Execute Vim-Plug
" ---------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
" {{{
	let g:tmux_navigator_no_mappings = 1
" }}}
Plug 'editorconfig/editorconfig'
" {{{
	let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim',
Plug 'airblade/vim-gitgutter'
" {{{
	highlight GitGutterAdd ctermfg=Green
	highlight GitGutterDelete ctermfg=Red
	highlight GitGutterChange ctermfg=Blue
" }}}
Plug 'tpope/vim-fugitive'
if has('python3')
	Plug 'powerline/powerline', { 'dir': '~/.powerline', 'do': 'pip install -U --user -e .', 'rtp': 'powerline/bindings/vim'}
	" {{{
		let g:Powerline_symbols = 'fancy'
	" }}}
else
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	" {{{
		let g:airline_theme='luna'
		let g:airline_powerline_fonts = 1
	" }}}
endif
Plug 'preservim/nerdcommenter'
call plug#end()

" ---------------------------------------------------------------------------
" Global vim configuration
" ---------------------------------------------------------------------------

" secure
set secure

" syntax
if has('syntax')
	syntax enable
	" highlight extra whitespaces
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	if v:version >= 702
		autocmd BufWinLeave * call clearmatches()
	endif
	" highlight extra wrap characters
	highlight ColorColumn ctermbg=magenta
	call matchadd('ColorColumn', '\%79v', 100)
endif

" mouse mode
if has('mouse')
	set mouse=a
endif

" modeline
set modeline

" wrap text
set wrap

" highlight search
set hlsearch

" visual bell
set visualbell
set t_vb=

" show matching brackets
set showmatch

" show line/total line
set ruler

" show specials chars
set list listchars=tab:»\ ,nbsp:␣

" tags path
set tags^=.git/tags;

" dictionaries
set dictionary+=/usr/share/dict/words

" status bar
set laststatus=2

" tab bar
set showtabline=2

" update time for async updates
set updatetime=100

" display menu even if there is only one match
set completeopt=longest,menuone

" reload Vim settings after editing config file
if has('autocmd')
	autocmd! bufwritepost .vimrc source ~/.vimrc
endif

" ---------------------------------------------------------------------------
" file syntax and indent
" ---------------------------------------------------------------------------

" encoding
if has('multi_byte')
	set encoding=utf-8
	scriptencoding utf-8
endif

" indentation
filetype plugin indent on

" linux coding style
set noexpandtab
set tabstop=8
set shiftwidth=8
set textwidth=78
set autoindent smartindent
set smarttab
set backspace=eol,start,indent

" ---------------------------------------------------------------------------
" customization
" ---------------------------------------------------------------------------

set background=dark
set t_Co=256
if has("gui_running")
	set background=light
	colorscheme default
endif

" ---------------------------------------------------------------------------
" user defined functions
" ---------------------------------------------------------------------------

" tab or autocomplete
"function! CleverTab()
"        if pumvisible()
"                return "\<C-N>"
"        endif
"        if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"                return "\<Tab>"
"        elseif exists('&omnifunc') && &omnifunc != ''
"                return "\<C-X>\<C-O>\<C-n>\<C-p>\<Down>"
"        else
"                return "\<C-N>"
"        endif
"endfunction
"inoremap <expr> <silent> <tab> CleverTab()
"inoremap <expr> <CR> pumvisible() ? "\<C-y>\<Space>" : "\<C-g>u\<CR>"

" remove whitespaces
" autocmd BufWritePre * :%s/\s\+$//e

" ---------------------------------------------------------------------------
" user key bindings
" ---------------------------------------------------------------------------

" buffers
if executable('fzf')
	nmap <leader>b :Buffers<CR>
	cab buffers Buffers
	cab ls Buffers
else
	nmap <leader>b :buffers<CR>
endif
nmap <leader>bn :bnext<CR>
nmap <leader>bp :bprev<CR>

" registers
nmap <leader>r :reg<CR>

" files
if executable('fzf')
	nmap <leader>ff :FZF<CR>
else
	nmap <leader>ff :Sexplore<CR>
endif

" navigate
nmap <leader>w<left> :wincmd h<CR>
nmap <leader>w<right> :wincmd l<CR>
nmap <leader>w<up> :wincmd k<CR>
nmap <leader>w<down> :wincmd j<CR>
if has_key(plugs, 'vim-tmux-navigator')
	nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
	nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
	nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
	nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
endif

" git
if has_key(plugs, 'vim-gitgutter')
	nmap <leader>ga <Plug>(GitGutterStageHunk)
	nmap <leader>grs <Plug>(GitGutterUndoHunk)
endif
if has_key(plugs, 'vim-fugitive')
	nmap <leader>g   :Git<CR>
	nmap <leader>gaa :Gwrite<CR>
	nmap <leader>gc  :Gcommit<CR>
	nmap <leader>grh :Gread<CR>
	nmap <leader>gd  :Gdiff<CR>
	nmap <leader>glo :Glog<CR>
	nmap <leader>gst :Gstatus<CR>
endif
