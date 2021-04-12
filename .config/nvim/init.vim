let mapleader = ","
set nocompatible
let g:polyglot_disabled = []
let g:ale_disable_lsp = 1
let g:ale_pattern_options = {'\.ts$': {'ale_enabled': 0}}

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
Plug 'metakirby5/codi.vim'

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

set autoread

" ========================================================================
" Language Preferences
" ========================================================================
let g:coc_global_extensions = [
  \'coc-bookmark',
  \'coc-eslint',
  \'coc-git',
  \'coc-json',
  \'coc-prettier',
  \'coc-tslint-plugin',
  \'coc-tsserver',
  \'coc-yank'
\]

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
let g:dune_quotes = [
  \   ['There is no escape — we pay for the violence of our ancestors.', '', " - Paul Muad'Dib Atreides"],
  \   ['He who can destroy a thing, controls a thing.', '', " - Paul Muad'Dib Atreides"],
  \   ['Long live the fighters!', '', " - Paul Muad'Dib Atreides"],
  \   ['My name is a killing word.', '', " - Paul Muad'Dib Atreides"],
  \   ['Father... father, the sleeper has awakened!', '', " - Paul Muad'Dib Atreides"],
  \   ["Now remember, walk without rhythm, and we won't attract the worm.", '', " - Paul Muad'Dib Atreides"],
  \   ["Are you suggesting the Duke's son is an animal?", '', " - Paul Muad'Dib Atreides"],
  \   ['I will bend like a reed in the wind.', '', " - Paul Muad'Dib Atreides"],
  \   ['I must rule with eye and claw — as the hawk among lesser birds.', '', ' - Duke Leto Atreides'],
  \   ["I'll miss the sea. But a man needs new experiences. They jar something deep inside, allowing him to grow. Without change, something sleeps inside of us and seldom awakens. The sleeper must awaken.", '', ' - Duke Leto Atreides'],
  \   ['The sleeper must awaken.', '', ' - Duke Leto Atreides'],
  \   ['And how can this be? For he is the Kwisatz Haderach!', '', ' - Alia Atreides'],
  \   ['Those sounds could be imitated.', '', ' - Mentat Thufir Hawat'],
  \   ['Parting with friends is a sadness. A place is only a place.', '', ' - Mentat Thufir Hawat'],
  \   ["Not in the mood? Mood's a thing for cattle and loveplay, not fighting!", '', ' - Gurney Halleck'],
  \   ["If wishes were fishes, we'd all cast nets.", '', ' - Gurney Halleck'],
  \   ["Good. The slow blade penetrates the shield... but, uh, look down. We'd have joined each other in death.", '', ' - Gurney Halleck'],
  \   ['Soon we leave for Arrakis. Arrakis is real. The Harkonnens are real.', '', ' - Gurney Halleck'],
  \   ['May the Hand of God be with you.', '', ' - Duncan Idaho'],
  \   ['He shall know your ways as if born to them.', '', ' - Dr. Liet-Kynes'],
  \   ['Bless the maker and his water, bless the coming and going of him, may his passing cleanse the world.', '', ' - Dr. Liet-Kynes'],
  \   ['Bless the Maker and all His Water. Bless the coming and going of Him, May His passing cleanse the world. May He keep the world for his people. - Fremen Saying'],
  \   ['May thy knife chip and shatter.', '', ' - Fremen saying of ill will against an adversary; Jamis to Paul before their duel'],
  \   ['Usul, we have wormsign the likes of which even God has never seen.', '', ' - Stilgar'],
  \   ['To save one from a mistake is a gift of paradise.', '', ' - Stilgar'],
  \   ['Tell me of your homeworld Usul.', '', ' - Chani'],
  \   ['I would not have permitted you to harm my tribe.', '', ' - Chani'],
  \   ['I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me. And when it has gone past I will turn the inner eye to see its path. Where the fear has gone there will be nothing. Only I will remain.', '', ' - Bene Gesserit Litany Against Fear'],
  \   ['They tried and died.', '', ' - Mother Gaius Helen Mohiam'],
  \   ['A beginning is a very delicate time.', '', ' - Princess Irulan'],
  \   ['God created Arrakis to train the faithful.', '', " - The Wisdom of Muad'Dib by the Princess Irulan"],
  \   ['He who controls the Spice, controls the universe!', '', ' - Baron Vladimir Harkonnen'],
  \   ['You see your death. My blade will finish you.', '', ' - Feyd-Rautha Harkonnen'],
  \   ['It is by will alone I set my mind in motion. It is by the juice of sapho that thoughts acquire speed, the lips acquire stains, the stains become a warning. It is by will alone I set my mind in motion. ', '', ' - The Mentat Mantra, recited by Piter De Vries'],
  \   ['Vendetta, he says, using the ancient tongue. The art of kanly is still alive in the Universe.', '', ' - Mentat Piter De Vries'],
  \   ['Take them to the desert as the traitor suggested. The worms will destroy the evidence. Their bodies must never be found.', '', ' - Mentat Piter De Vries'],
  \   ['A Secret Report within the Guild. Four Planets have come to our attention regarding a plot which could jeopardise Spice Production: Planet Arrakis, Source of the Spice. Planet Caladan, home of House Atreides. Planet Geidi Prime, home of House Harkonnen. Planet Kaitain, Home of the Emperor of the Known Universe. Send a third-stage Guild Navigator to Kaitain to demand details from the Emperor. The Spice must flow.', '', ' - The Guildmaster'],
  \   ['The Bene Gesserit witch must leave.', '', ' - Guildsman'],
  \   ["Muad'Dib learned rapidly because his first training was in how to learn.", '', ' - Frank Herbert - Dune'],
  \ ]

let g:startify_custom_header_quotes =
    \ startify#fortune#predefined_quotes() + g:dune_quotes

let g:startify_custom_header = map(g:ascii + startify#fortune#boxed(), '"   ".v:val')
let g:startify_change_to_dir = 0

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

" ==Auto-complete Configs
" ==========================================================================
" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gi :call CocAction('jumpDefinition', 'vsplit')<cr>
nmap <silent> gI :call CocAction('jumpDefinition', 'tabe')<cr>
nmap <silent> gr <Plug>(coc-references)

" Use D to show documentation in preview window.
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList --normal diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Run Linter Fix
nnoremap <silent><nowait> <space>f  :<C-u>CocFix<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" Open the yank list
nnoremap <silent><nowait> <space>y  :<C-u>CocList -A --normal yank<cr>
" Open the git change list
nnoremap <silent><nowait> <space>g  :<C-u>CocList -A --normal gstatus<cr>
nmap <leader>g <Plug>(coc-git-commit)
" Open the bookmark list
nnoremap <silent><nowait> <space>b :<C-u>CocList -A --normal bookmark<cr>
nmap <leader>b <Plug>(coc-bookmark-toggle)
" Open documentation for symbol under cursor
nnoremap <silent><nowait> <space>h :<C-u>call CocActionAsync('doHover')<cr>
" ==========================================================================

" Unfuck my screen
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Set ignores for CtrlP, etc.
set wildignore+=*/.git/*,*/tmp/*,*.swp,*/_build/*
set wildignore-=.env*,.eslint*,.gitignore

" Make C-c work the way I want it to
imap <C-c> <Esc>
nmap <C-c> <Esc>

" Lintin' yo scripts
let g:ale_completion_enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:ale_javascript_eslint_suppress_missing_config = 0
let g:ale_linters_explicit = 1
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'typescript': ['tsserver', 'prettier'],
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
autocmd Filetype list nmap <buffer> q :q<CR>

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
nmap <leader>zr :tabe ~/.zsh_profile<cr>:vsp ~/.zshrc<cr>:sp ~/.zsh_profile.local<cr>

" Update file in buffer
nmap <leader>e :e! %<cr>

" Try to autofix the file
nmap <leader>f :ALEFix<cr>
" nmap <leader>a :ALENextWrap<cr>
nmap <leader>a <Plug>(coc-diagnostic-next)
nmap <leader>z <Plug>(coc-diagnostic-prev)
nmap <leader>l :lwindow<cr>

" Lint project and open failures in QuickFix window
nmap <leader><leader>l :silent make<cr>

" Open Vista
let g:vista_default_executive = 'coc'
let g:vista_echo_cursor_strategy = 'both'
nmap <leader><leader>v :Vista!!<cr>

" Open Git blame
nmap <leader><leader>g :Git blame<cr>

" Run tests with vim-test
let test#strategy = 'neovim'
let test#neovim#term_position = "botright 30"
let g:test#javascript#runner = 'jest'
let test#javascript#jest#options = {
  \ 'all': '--findRelatedTests %',
  \}
nmap <leader>r :TestNearest<cr>
nmap <leader>R :TestFile<cr>
nmap <leader>j :CocCommand jest.singleTest<cr>
nmap <leader>J :CocCommand jest.fileTest<cr>
nmap <leader>JJ :CocCommand jest.projectTest<cr>

" Stage a Hunk for commit
nmap <leader>s :GitGutterStageHunk<cr>

" Strip bad whitespace
nmap <leader><Space> :StripWhitespace<cr>

" Toggle line-wrapping
nmap <leader><leader><Space> :setlocal nowrap!<cr>

" Toggle Codi scratchpad
nmap <leader><leader>c :Codi!!<cr>

" Pretty print JSON
nmap <leader>jj :%!python -m json.tool<cr>:setf json<cr>gg=G

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
