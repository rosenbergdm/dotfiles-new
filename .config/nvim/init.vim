" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell encoding=utf-8:
" }
set encoding=utf-8
scriptencoding utf-8

"{{{ Plugin Configuration

" Add the dein installation directory into runtimepath
set runtimepath+=~/.config/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  " To disable a plugin, remove the 'add' line, add a 'disable' line,
  "   and then run :call dein#check_clean(), and :call dein#update()

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
  call dein#add('wsdjeg/dein-ui.vim')

  " Language Server / Completion
  call dein#add('neoclide/coc.nvim', {'merged':0, 'rev': 'release'})
  call dein#add('Shougo/deoplete.nvim')
  " Coc Extensions Installed:
    " coc-clangd
    " coc-css
    " coc-diagnostic
    " coc-eslint
    " coc-git
    " coc-go
    " coc-highlight
    " coc-html
    " coc-json
    " coc-markdownlint
    " coc-prettier
    " coc-pyright
    " coc-r-lsp
    " coc-sh
    " coc-snippets
    " coc-texlab
    " coc-tsserver

  " Generic / Universal extensions
  call dein#add('junegunn/fzf.vim')
  call dein#add('mbbill/undotree')
  call dein#add('junegunn/vim-easy-align')
  call dein#add('honza/vim-snippets')

  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')

  call dein#add('morhetz/gruvbox')
  call dein#add('scrooloose/nerdtree')
  call dein#add('tibabit/vim-templates')

  " Filetype specific 

  "CSV
  call dein#add('chrisbra/csv.vim')

  "Python
  call dein#add('psf/black', {'branch': 'stable'})

  "R
  call dein#add('ncm2/ncm2')
  call dein#add('jalvesaq/Nvim-R')
  call dein#add('gaalcaras/ncm-R')
  call dein#add('jalvesaq/R-Vim-runtime')

  "JSX / Javascript / TypeScript / React
  call dein#add('MaxMEllon/vim-jsx-pretty')
  call dein#add('yuezk/vim-js')

  "JSON / JSONC
  call dein#add('neoclide/jsonc.vim')

  "Go
  call dein#add('fatih/vim-go', {'do': ':GoUpdateBinaries' })

  " Plugin Finalization
  call dein#end()
  call dein#save_state()
endif

"}}}

"{{{ Settings and options
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
set autochdir

"}}}

"{{{ Function Definitions

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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"}}}

"{{{ Key mappings
" Everywhere-----------------------------
map <F2> :NERDTreeToggle
map <F6> :UndotreeToggle<CR>

" Normal-----------------------------
nnoremap ; :
nmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>rn <Plug>(coc-rename)
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Visual-----------------------------
xmap <leader>f  <Plug>(coc-format-selected)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vnoremap <leader>sq :call SQLFormat()<CR>

vnoremap < <gv
vnoremap > >gv


" Insert-----------------------------
inoremap jj <esc>
inoremap <C-Space> <C-x><C-o>

" Command-----------------------------
cnoremap qq wqa<enter>



"{{{ COC Mappings: 
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Renaming of symbols
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
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

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"}}}
"}}}

"{{{ Local config settings (let)
let g:coc_snippet_next = '<tab>'
let g:markdown_fenced_languages = [ 'vim', 'help' ]
let g:tmpl_search_paths = ['~/.config/nvim/templates']
let g:tmpl_author_email = 'dmr@davidrosenberg.me'
let g:tmpl_author_name = 'David M. Rosenberg'
let g:tmpl_license = 'GPLv3'

" let g:LanguageClient_serverCommands = {'haskell': ['hie-wrapper', '--lsp'], 'sh': ['bash-language-server', 'start']}
" let g:ale_open_list = 1
" let b:ale_r_lint_package = 0
"}}}

"{{{ Autocommands
"Generic autocommands
augroup generic
  au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
augroup END
autocmd CursorHold * silent call CocActionAsync('highlight')
"}}}

" How to use plugins
" GLOBAL KEYBINDINGS:
" Visual:
"   ,f      Format selected
" Normal:
"   zM      Close all folds
" Insert:
"
"------------------- PLUGINS --------------------------
" CoC:
"   Format: select code and hit ',f'
"

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
