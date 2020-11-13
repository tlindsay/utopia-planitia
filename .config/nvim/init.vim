let mapleader = ","
set nocompatible
let g:polyglot_disabled = []
let g:ale_disable_lsp = 1

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

" EXPERIMENTAL
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Editor Plugins
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'jiangmiao/auto-pairs' " This may not be the best one. Should get you auto closed brackets, etc.
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'psychollama/further.vim'
Plug 'w0rp/ale'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'airblade/vim-gitgutter'
Plug 'gcmt/taboo.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'janko/vim-test'
Plug 'yggdroot/indentLine'
Plug 'majutsushi/tagbar'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'chrisbra/Colorizer'

" Languages
Plug 'liuchengxu/vista.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mustache/vim-mustache-handlebars'
Plug 'kana/vim-textobj-user' " Dependency for textobj-rubyblock and textobj-javascript
Plug 'bfontaine/Brewfile.vim'

" Lang/Framework specific plugins
Plug 'tpope/vim-rails'
Plug 'tpope/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'jasonlong/vim-textobj-css'
Plug 'kana/vim-textobj-function'
" Plug 'poetic/vim-textobj-javascript'

call plug#end()

let g:coc_global_extensions = ['coc-tsserver', 'coc-tslint-plugin', 'coc-eslint', 'coc-json', 'coc-prettier']

set autoread

" Ruby Integration
let g:ruby_host_prog = 'rvm system do neovim-ruby-host'

" Use Tim Pope's Markdown, instead
let g:polyglot_disabled = ['markdown']

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

let g:colorizer_auto_filetypes = 'css,scss,html'

let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'help', 'startify']

let g:airline_extensions = ['ale', 'branch', 'ctrlp', 'fugitiveline', 'hunks', 'keymap', 'netrw', 'quickfix', 'term', 'vista', 'whitespace']
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#tabline#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline_highlighting_cache = 1
let g:airline_section_y = ''
let g:airline_section_z = ' %l/%L : %c'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:ale_sign_highlight_linenrs = 1
let g:ale_javascript_eslint_suppress_missing_config = 1

set statusline+=%#warningmsg#
set statusline+=%*

let g:taboo_modified_tab_flag = "ﴖ "

let g:taboo_tab_format = "%N:%m%f%l %d  "
let g:taboo_renamed_tab_format = "%N:%m[%l] "

set sessionoptions+=tabpages,globals

let g:ascii = [
      \'      ::::    :::  ::::::::::  ::::::::   :::     :::  :::::::::::    :::   :::' ,
      \'     :+:+:   :+:  :+:        :+:    :+:  :+:     :+:      :+:       :+:+: :+:+:' ,
      \'    :+:+:+  +:+  +:+        +:+    +:+  +:+     +:+      +:+      +:+ +:+:+ +:+' ,
      \'   +#+ +:+ +#+  +#++:++#   +#+    +:+  +#+     +:+      +#+      +#+  +:+  +#+'  ,
      \'  +#+  +#+#+#  +#+        +#+    +#+   +#+   +#+       +#+      +#+       +#+'   ,
      \' #+#   #+#+#  #+#        #+#    #+#    #+#+#+#        #+#      #+#       #+#'    ,
      \'###    ####  ##########  ########       ###      ###########  ###       ###'     ,
      \''
      \]
let g:startify_custom_header = map(g:ascii + startify#fortune#boxed(), '"   ".v:val')
let g:webdevicons_enable_startify = 1

let g:tagbar_type_javascript = {
      \ 'ctagstype': 'javascript',
      \ 'kinds': [
      \ 'A:arrays',
      \ 'P:properties',
      \ 'T:tags',
      \ 'O:objects',
      \ 'G:generator functions',
      \ 'F:functions',
      \ 'C:constructors/classes',
      \ 'M:methods',
      \ 'V:variables',
      \ 'I:imports',
      \ 'E:exports',
      \ 'S:styled components'
      \ ]}

let g:tagbar_type_scss = {
      \ 'ctagstype': 'scss',
      \ 'kinds': [
      \ 'm:mixins',
      \ 'v:variables',
      \ 'c:classes',
      \ 'i:ids',
      \ 't:tags',
      \ 'd:media'
      \ ]}

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

" Unfuck my screen
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Set ignores for CtrlP, etc.
set wildignore+=*/.git/*,*/tmp/*,*.swp,*/_build/*
set wildignore-=.env*,.eslint*,.gitignore

" Make C-c work the way I want it to
imap <C-c> <Esc>
nmap <C-c> <Esc>

" Lintin' yo scripts
let g:ale_completion_enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_javascript_eslint_suppress_missing_config = 0
let g:ale_linters_explicit = 1
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'typescript': ['tsserver'],
\  'ruby': ['rubocop']
\}
let g:ale_fixers = {
\  'javascript': ['eslint'],
\  'typescript': ['eslint', 'tslint', 'prettier'],
\  'ruby': ['rubocop']
\}

hi SpellBad ctermbg=darkred ctermfg=black
hi ALEErrorSign ctermbg=18 ctermfg=darkred

" Show indent guides
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_enabled = 1
let g:indentLine_conceallevel = 2

"-- FOLDING --
set foldmethod=syntax "syntax highlighting items specify folds
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened

" Adapted from https://gist.github.com/romainl/ce55ce6fdc1659c5fbc0f4224fd6ad29
augroup Linting
  autocmd!
  autocmd FileType javascript setlocal makeprg=eslint\ --format=unix\ .
  autocmd FileType qf setlocal nowrap
  autocmd FileType qf setlocal nonumber
  autocmd FileType qf setlocal norelativenumber
  autocmd Filetype qf nmap <buffer> q :q<CR>
  " autocmd QuickFixCmdPre [^l]* tabnew   Lint Fix
  autocmd QuickFixCmdPost [^l]* vertical topleft 30 cwindow
augroup END

" Highlight Markdown fenced code blocks
let g:markdown_github_languages = ['ruby', 'erb=eruby', 'js']

if executable('rg')
  " Make CtrlP use rg for listing the files. Way faster and no useless files.
  " https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob "" --no-require-git'
  let g:ctrlp_use_caching = 0

  set grepformat=%f:%l:%c:%m
  set grepprg=rg\ -S\ --vimgrep\ --no-heading
elseif executable('ag')
  " Make CtrlP use ag for listing the files. Way faster, but not as fast as rg
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrl_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0

  set grepprg=ag\ -S\ --vimgrep
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

" Resize panes
noremap <A-S-Right> :vertical resize +5<cr>
noremap <A-S-Left> :vertical resize -5<cr>
noremap <A-S-Up> :resize +5<cr>
noremap <A-S-Down> :resize -5<cr>

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

" Fix Handlebars comment strings
autocmd Filetype html.handlebars setlocal commentstring={{!--\ %s\ --}}

" Disable editor features in startify
autocmd FileType startify setlocal conceallevel=0
autocmd FileType startify DisableWhitespace

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
nmap <leader><Del> :%bw! <bar> Startify<cr>

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
nmap <leader>a :ALENextWrap<cr>
nmap <leader>l :lwindow<cr>

" Lint project and open failures in QuickFix window
nmap <leader><leader>l :silent make<cr>

" Run tests with vim-test
nmap <leader>R :TestFile<cr>

" Stage a Hunk for commit
nmap <leader>s :GitGutterStageHunk<cr>

" Strip bad whitespace
nmap <leader><Space> :StripWhitespace<cr>

" Toggle line-wrapping
nmap <leader><leader><Space> :setlocal nowrap!<cr>

" Pretty print JSON
nmap <leader>j :%!python -m json.tool<cr>:setf json<cr>gg=G

" Quickfix navigation
nmap <leader>n :cn<cr>
nmap <leader>p :cp<cr>

" Toggle relative line numbers
nmap <leader>. :set relativenumber!<cr>

" Highlight colors
nmap <leader>c :ColorHighlight<cr>

" Toggle Tagbar
nmap <leader>m :TagbarToggle<cr>

" Toggle Pencil
nmap <leader>P :PencilToggle<cr>

" Open NERDTree
nmap <leader>t :NERDTreeToggle<cr>

" Save a session
nmap <leader>S :mksession!<cr>

" Move buffer to new tab
nmap <leader>T <C-w>T

" Better splits
nmap <C-w>\ :vnew<cr>
nmap <C-w>- :new<cr>

" Rename the current tab
nmap <C-w>, :call RenameTab()<cr>

" Navigate tabs like tmux
map <C-w>n :tabnext<cr>
map <C-w>p :tabprevious<cr>

" Remap tabnew
map <C-w>t :tabnew<cr>

nmap <C-n> :GitGutterNextHunk<cr>

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
command! ProfileStart :profile start ~/profile.log | profile func * | profile file *<cr>
command! ProfileStop :profile pause<cr>

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

function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

source ~/.vimrc_background

function! ShowCurrentHighlight()
  echom "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
nnoremap <leader>i :call ShowCurrentHighlight()<CR>
