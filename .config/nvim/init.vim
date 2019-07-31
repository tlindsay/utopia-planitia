let mapleader = ","

" ========================================================================
" Vim Plug
" ========================================================================

" Download vim-plug if missing
if empty(glob("~/.config/nvim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.config/nvim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

call plug#begin('~/.vim/plugins')

" Vanilla Vim Plugins
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif

" Editor Plugins
Plug 'editorconfig/editorconfig-vim'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'jiangmiao/auto-pairs' " This may not be the best one. Should get you auto closed brackets, etc.
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'shougo/deoplete.nvim'
Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'w0rp/ale'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'gcmt/taboo.vim'
Plug 'skammer/vim-css-color' " Highlights CSS colors
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'janko/vim-test'

" Languages
Plug 'sheerun/vim-polyglot'
Plug 'mustache/vim-mustache-handlebars'
Plug 'kana/vim-textobj-user' " Dependency for textobj-rubyblock and textobj-javascript
Plug 'bfontaine/Brewfile.vim'

" Lang/Framework specific plugins
Plug 'tpope/vim-rails'
Plug 'mattn/emmet-vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'jasonlong/vim-textobj-css'
Plug 'kana/vim-textobj-function'
" Plug 'poetic/vim-textobj-javascript'

call plug#end()

set autoread

" Ruby Integration
let g:ruby_host_prog = 'rvm system do neovim-ruby-host'

" ========================================================================
" Display Preferences
" ========================================================================
" Whitespace and Indention Settings
set list
set ai
set si
set wrap
set shiftwidth=2
set tabstop=2
set expandtab
set smarttab

set ruler
set number
set relativenumber

set cursorline
set cursorcolumn
set scrolloff=4

set showmatch

" Theme Settings
let base16colorspace=256
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif

let g:airline_extensions = ['ale', 'branch', 'ctrlp', 'fugitiveline', 'hunks', 'keymap', 'netrw', 'quickfix', 'term', 'vista', 'whitespace']
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#tabline#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline_highlighting_cache = 1
let g:airline_section_y = ''
let g:airline_section_z = ' %l/%L : %c'

set statusline+=%#warningmsg#
set statusline+=%*

let g:taboo_tab_format = "%N: %f%l%m "
let g:taboo_renamed_tab_format = "%N:[%l]%m "

" ========================================================================
" Search Preferences
" ========================================================================
set ignorecase
set smartcase
set hlsearch
set incsearch

" ========================================================================
" Editor Behavior
" ========================================================================
set clipboard=unnamed

" Set ignores for CtrlP, etc.
set wildignore+=*/.git/*,*/tmp/*,*.swp
set wildignore-=.env*,.eslint*,.prettierrc,.gitignore

" Make C-c work the way I want it to
imap <C-c> <Esc>

" Get some autocompletion up in here
let g:deoplete#enable_at_startup = 1
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

" Lintin' yo scripts
let g:ale_completion_enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'ruby': ['rubocop']
\}
let g:ale_fixers = {
\  'javascript': ['eslint'],
\  'ruby': ['rubocop']
\}
hi SpellBad ctermbg=darkred ctermfg=black
hi Visual term=reverse cterm=reverse

" Prettify JS
augroup javascript_folding
  au!
  au FileType javascript setlocal foldmethod=syntax
  au FileType javascript normal zR
augroup END
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:conceallevel = 0

if executable('rg')
  " Make CtrlP use rg for listing the files. Way faster and no useless files.
  " https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  " Make CtrlP use ag for listing the files. Way faster, but not as fast as rg
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrl_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" bind & to grep word under cursor
nnoremap & :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Sensible navigation
nnoremap j gj
nnoremap k gk

" Mouse mode!
set mouse=a

" Move lines around
" https://elliotekj.com/2017/01/19/moving-lines-of-code-around-in-vim/
nnoremap J :m+<cr>==
nnoremap K :m-2<cr>==
xnoremap J :m'>+<cr>gv=gv
xnoremap K :m-2<cr>gv=gv

" Better method movement
nmap m ]m
nmap M [m

" Fix wrapping navigation
set whichwrap+=<,>,h,l
set backspace=eol,start,indent

" Sensible Splitting
set splitbelow
set splitright

" Easy exits
autocmd Filetype help nmap <buffer> q :q<CR>
autocmd Filetype vundle  nmap <buffer> q :q<CR>

" Fix Handlebars comment strings
autocmd Filetype html.handlebars setlocal commentstring={{!--\ %s\ --}}

" Ignore my typos
command! Q q
command! Qall qall
command! QA qall

" ========================================================================
" SHORTCUTS AND LEADERS
" ========================================================================

" The Elm plugin tries to set its own leader commands
let g:elm_setup_keybindings = 0

" Close all buffers, except those with unwritten changes
nmap <leader><Del> :bufdo! bw<cr>

" Close a tab easily
nmap <leader>x :tabclose<cr>

" Open a new tab easily
nmap <leader>T :tabnew<cr>

" Edit this file!
nmap <leader>vr :tabe $MYVIMRC<cr>
nmap <leader>rv :source $MYVIMRC<cr>:PlugInstall<cr>

" Update file in buffer
nmap <leader>e :e! %<cr>

" Try to autofix the file
nmap <leader>f :ALEFix<cr>

" Run tests with vim-test
nmap <leader>R :TestFile<cr>

" Stage a Hunk for commit
nmap <leader>s :GitGutterStageHunk<cr>

" Strip bad whitespace
nmap <leader><Space> :StripWhitespace<cr>

" Pretty print JSON
nmap <leader>j :%!python -m json.tool<cr>:setf json<cr>gg=G

" Toggle JS prettification
nmap <leader>l :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<cr>

" Toggle relative line numbers
nmap <leader>. :set relativenumber!<cr>

" Open NERDTree
nmap <leader>t :NERDTreeToggle<cr>

" Save a session
nmap <leader>S :mksession!<cr>

" Better splits
nmap <C-w>\ :vnew<cr>
nmap <C-w>- :new<cr>

" Rename the current tab
nmap <C-w>, :call RenameTab()<cr>

" Navigate tabs like tmux
map <C-w>n :tabnext<cr>
map <C-w>p :tabprevious<cr>

" Misc
nmap <leader>q :q<cr>
nmap <leader>Q :q!<cr>
nmap <leader>w :w!<cr>
nmap <leader>W :wall!<cr>
nmap <leader>h :nohlsearch<cr>

" ========================================================================
" FUNCTIONS
" ========================================================================

command! FixEmberSetGet :%s/\(this\).\([s,g]et\)(/\2(\1, /g

" Wraps TabooRename to make it interactive
function! RenameTab()
  let l:placeholder = (exists("t:taboo_tab_name") ? t:taboo_tab_name : "")
  let l:tabName = input('New Tab Name: ', l:placeholder)
  redraw
  if empty(l:tabName)
    TabooReset
    echom "Tab name reset!"
  else
    execute "TabooRename" l:tabName
    echom "Tab name updated!"
  endif
  return
endfunction

colorscheme base16-paraiso

" Highlight Handlebars Angle-bracket Components
" NOTE: This _must_ come after the colorscheme declaration
hi mustacheAngleComponentName guifg=blue ctermfg=blue
hi mustacheHbsComponent guifg=blue ctermfg=blue


function! ShowCurrentHighlight()
  echom "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
nnoremap <leader>i :call ShowCurrentHighlight()<CR>
