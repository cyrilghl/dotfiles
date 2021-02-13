" ~/.vimrc


set mouse=a

set autoindent

set cindent

set tabstop=8

set softtabstop=4

set shiftwidth=4

set expandtab

set number

set cc=80

set clipboard=unnamedplus

syntax enable

let python_highlight_all = 1



" Install vim-plug if we don't already have it
if empty(glob("~/.vim/autoload/plug.vim"))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    execute '!mkdir -p ~/.vim/plugged'
    execute '!mkdir -p ~/.vim/autoload'
    " Download the actual plugin manager
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

autocmd FileType make setlocal noexpandtab

call plug#begin()
" rainbow brackets
Plug 'https://github.com/frazrepo/vim-rainbow'

" lightline
Plug 'https://github.com/itchyny/lightline.vim'

"isort sorts python imports
Plug 'fisadev/vim-isort'

"nerdtree
Plug 'preservim/nerdtree'

"nerdtree tabs
Plug 'https://github.com/jistr/vim-nerdtree-tabs'

"Clang-format auto
Plug 'rhysd/vim-clang-format'

" Bag of mappings
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/emmet-vim'



"jupiter-vim
Plug 'jupyter-vim/jupyter-vim'

"autoformat code
Plug 'Chiel92/vim-autoformat'

" Theming
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


" Filetype specific plugins
Plug 'pearofducks/ansible-vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-pandoc'
Plug '5long/pytest-vim-compiler'
Plug 'hashivim/vim-terraform'


" Tag management
Plug 'ludovicchabant/vim-gutentags'

" 'IDE' featureourc
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'janko/vim-test'

"autocomplete
Plug 'zxqfl/tabnine-vim'

"enabe sql connect
Plug 'https://github.com/vim-scripts/dbext.vim'

call plug#end()
filetype plugin indent on

runtime! plugin/sensible.vim

set encoding=utf-8 fileencodings=
syntax on

autocmd Filetype make setlocal noexpandtab

"autoenable clang-formating
autocmd FileType c ClangFormatAutoEnable

set list listchars=tab:»·,trail:·

" enable rainbow brackets
let g:rainbow_active = 1


"set lightline scheme
let g:lightline = {
            \ 'colorscheme': 'PaperColor_dark',
            \ }

" per .git vim configs

" just `git config vim.settings "expandtab sw=4 sts=4"` in a git repository

" change syntax settings for this repository
let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
    exe "set" git_settings
endif

" key map nerdtree
map <C-n> <plug>NERDTreeTabsOpen<CR>
map <C-f> <plug>NERDTreeTabsClose<CR>


" Highlight bad whitespace
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py match BadWhitespace /^\ \+/
au BufRead,BufNewFile *.py match BadWhitespace /\s\+$/

"execute python
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

" CREDIT: https://gist.github.com/vishnubob/c93b1bdc3d5df64a8bc29246adfa8c6c
" https://stackoverflow.com/questions/18948491/running-python-code-in-vim
function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright vsplit new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright vsplit new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    " setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
    if (line('$') == 1 && getline(1) == '')
        q!
    endif
    silent execute 'wincmd p'
endfunction
" autoformat every file
au BufWrite * :Autoformat







" Use a slightly darker background color to differentiate with the status line
let g:jellybeans_background_color_256='232'

" Feel free to switch to another colorscheme
colorscheme jellybeans


""""""""""""""""""""""""""""""""""""""""""""""""""
" User interface
""""""""""""""""""""""""""""""""""""""""""""""""""

" Make backspace behave as expected
set backspace=eol,indent,start

" Set the minimal amount of lignes under and above the cursor
" Useful for keeping context when moving with j/k
set scrolloff=5

" Show current mode
set showmode

" Show command being executed
set showcmd

" Show line number
set number

" Always show status line
set laststatus=2
" Enhance command line completion
set wildmenu

" Set completion behavior, see :help wildmode for details
set wildmode=longest:full,list:full

" Disable bell completely
set visualbell
set t_vb=

" Color the column after textwidth, usually the 80th
if version >= 703
    set colorcolumn=+1
endif

" Display whitespace characters
set list
set listchars=tab:>─,eol:¬,trail:\ ,nbsp:¤

set fillchars=vert:│

" Enables syntax highlighting
syntax on

" Enable Doxygen highlighting
let g:load_doxygen_syntax=1

" Allow mouse use in vim
set mouse=a

" Briefly show matching braces, parens, etc
set showmatch

" Enable line wrapping
set wrap

" Wrap on column 80
set textwidth=79

" Disable preview window on completion
set completeopt=longest,menuone

" Highlight current line
set cursorline

""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation options
""""""""""""""""""""""""""""""""""""""""""""""""""

" The length of a tab
" This is for documentation purposes only,
" do not change the default value of 8, ever.
set tabstop=8

" The number of spaces inserted/removed when using < or >
set shiftwidth=4

" The number of spaces inserted when you press tab.
" -1 means the same value as shiftwidth
set softtabstop=-1

" Insert spaces instead of tabs
set expandtab

" When tabbing manually, use shiftwidth instead of tabstop and softtabstop
set smarttab

" Set basic indenting (i.e. copy the indentation of the previous line)
" When filetype detection didn't find a fancy indentation scheme
set autoindent
set cinoptions=(0,u0,U0,t0,g0,N-s

""""""""""""""""""""""""""""""""""""""""""""""""""
" Search options
""""""""""""""""""""""""""""""""""""""""""""""""""

" Ignore case on search
set ignorecase

" Ignore case unless there is an uppercase letter in the pattern
set smartcase

" Move cursor to the matched string
set incsearch

" Don't highlight matched strings
set nohlsearch

set encoding=utf-8 fileencodings=
syntax on


set list listchars=tab:»·,trail:·

" enable rainbow brackets
let g:rainbow_active = 1

" Reload a file when it is changed from the outside
set autoread

" Write the file when we leave the buffer
set autowrite

" Disable backups, we have source control for that
set nobackup

" Force encoding to utf-8, for systems where this is not the default (windows
" comes to mind)
set encoding=utf-8

" Disable swapfiles too
set noswapfile

" Hide buffers instead of closing them
set hidden

" Set the time (in milliseconds) spent idle until various actions occur
" In this configuration, it is particularly useful for the tagbar plugin
set updatetime=500

" For some stupid reason, vim requires the term to begin with "xterm", so the
" automatically detected "rxvt-unicode-256color" doesn't work.
set term=xterm-256color

