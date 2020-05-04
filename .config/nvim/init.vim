" General settings
:let mapleader = ","

call plug#begin()

" NERDTree file system explorer
" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'
autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>


" vim-airline
" https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_detect_spell=0
let g:airline_left_alt_sep=''
let g:airline_left_sep='▓▒░'
let g:airline_powerline_fonts=1
let g:airline_right_alt_sep=''
let g:airline_right_sep='░▒▓'
let g:airline_skip_empty_sections = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.notexists = ' ▼'

let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'


" deoplete asynchronous autocomplete
" https://github.com/Shougo/deoplete.nvim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1


" deoplete-jedi for Python
" https://github.com/deoplete-plugins/deoplete-jedi
Plug 'deoplete-plugins/deoplete-jedi'


" phpcd autocomplete for PHP
" https://github.com/lvht/phpcd.vim
Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']


" Ale asynchronous syntax checker
" https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
      \  'python': ['flake8', 'autopep8']
      \ }


" fzf fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END


" vim-graphql
" https://github.com/jparise/vim-graphql
Plug 'jparise/vim-graphql'


" vim-unimpaired
" https://github.com/tpope/vim-unimpaired
Plug 'tpope/vim-unimpaired'
nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]

call plug#end()
