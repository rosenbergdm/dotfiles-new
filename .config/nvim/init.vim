" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell encoding=utf-8:
" }
set encoding=utf-8
scriptencoding utf-8

nnoremap ; :



" Add the dein installation directory into runtimepath
set runtimepath+=~/.config/dein/repos/github.com/Shougo/dein.vim


if dein#load_state('~/.cache/dein')

  " Disabled plugins
  call dein#disable('Vimjas/vim-python-pep8-indent')
  call dein#disable('numirias/semshi')
  call dein#disable('autozimu/LanguageClient-neovim') ", {'branch': 'next', 'do': './install.sh' })
  call dein#disable('roxma/nvim-yarp')
  call dein#disable('dense-analysis/ale')

  " Enabled plugins go after the dein#begin call
  call dein#begin('~/.cache/dein')

  " Enabled plugins

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('junegunn/fzf.vim')
  call dein#add('mbbill/undotree')
  call dein#add('junegunn/vim-easy-align')
  " call dein#add('dense-analysis/ale')
  call dein#add('wsdjeg/dein-ui.vim')
  call dein#add('honza/vim-snippets')

  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')

  call dein#add('morhetz/gruvbox')
  call dein#add('scrooloose/nerdtree')
  call dein#add('neoclide/coc.nvim', {'merged':0, 'rev': 'release'})
  call dein#add('tibabit/vim-templates')

  "CSV
  call dein#add('chrisbra/csv.vim')

  "Python
  call dein#add('psf/black', {'tag': '19.10b0'})

  "R
  call dein#add('ncm2/ncm2')
  call dein#add('jalvesaq/Nvim-R')
  call dein#add('gaalcaras/ncm-R')


  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable


set foldenable
set foldmethod=marker
set termguicolors
colorscheme gruvbox

set clipboard=unnamedplus
set nohlsearch
set number
set showmatch
set smartcase
set wildmode=longest,list
set wildignore+=*/.idea/*
set wildignore+=*/.git/*
set wildignore+=*/.svn/*
set wildignore+=*/vendor/*
set wildignore+=*/node_modules/*
set diffopt+=iwhite
set expandtab
set foldlevelstart=20
set hidden
set linebreak
set listchars=tab:——,trail:_
set modelines=1
set mouse=a
set autoindent
set backspace=indent,eol,start
set path+=**
set scrolloff=5
set shiftwidth=2
set shortmess+=c
set sidescrolloff=5
set smartindent
set splitbelow
set splitright
set synmaxcol=500
set tabstop=2
set textwidth=0
set timeoutlen=300
set updatetime=300
set wrapmargin=0
set cmdheight=2
set signcolumn=yes
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
set viewoptions
set showmode
set cursorline
set incsearch
set whichwrap=b,s,h,l,<,>,[,]
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set undodir^=~/.config/nvim/undo//
set undofile
set swapfile
set directory^=~/.config/nvim/swap//
set writebackup
set nobackup
set backupcopy
set backupdir^=~/.config/nvim/backup//
let mapleader=','
set pyxversion=3


nmap :NERDTreeToggle
set autochdir
inoremap <C-Space> <C-x><C-o>
cmap qq wqa<enter>



map <F6> :UndotreeToggle<CR>
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
vnoremap < <gv
vnoremap > >gv

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

let g:markdown_fenced_languages = [ 'vim', 'help' ]
set runtimepath+=~/.cache/dein/repos/github.com/autozimu/LanguageClient-neovim
let g:LanguageClient_serverCommands = {'haskell': ['hie-wrapper', '--lsp'], 'sh': ['bash-language-server', 'start']}
let g:ale_open_list = 1
let b:ale_r_lint_package = 0



let g:tmpl_search_paths = ['~/.config/nvim/templates']


" Generic autocommands
augroup generic
  au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
augroup END



" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

function! SQLFormat() range
  let l:saved_a = @a
  silent! normal! gv"ad
  let l:text = @a
  let l:text = substitute(l:text, '\n\s*\\\\', ' ', 'g')
  let l:newtext = system('echo ' . shellescape(l:text) . ' | /Users/davidrosenberg/bin/fmtsql.sh')
  let @a = l:newtext
  normal! k
  put a
  let @a = l:saved_a
endfunction

vnoremap <leader>sq :call SQLFormat()<CR>

" How to use plugins
" EasyAlign: visually select the text, then gaX where X is what you want to
" align on
"
" Commentary: easily comment and uncomment
"   Visual mode - select section and hit 'gc' to comment/un-comment
"   Normal mode - hit 'gcc' to comment/un-comment the current line
"
" SQLFormat: pretty-print a selection of SQL code
"   Visual mode - highlight the selection and hit <leader>sq
"
"
