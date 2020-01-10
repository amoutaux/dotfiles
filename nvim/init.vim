"PLUGINS

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'pseewald/vim-anyfold'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'morhetz/gruvbox'  "colorscheme
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'
Plug 'sheerun/vim-polyglot'
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

"Plugins customization
"Set supertab autocompletion cycle from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"
"Set airline theme
let g:airline_theme='luna'
let g:airline_section_y=''
let g:airline_section_z=''
let g:airline_skip_empty_sections = 1
"Start autocompletion from deoplete at startup
let g:deoplete#enable_at_startup = 1
"Close preview window after completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
"Open Gdiff in vertical splits
set diffopt+=vertical
"More customization for python-mode plugin
let g:pymode_lint_on_fly = 1
let g:pymode_rope_completion = 1
"Let NERDTree show hidden files by default
let g:NERDTreeShowHidden=1
"Define linters used by ale
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = 'eslint'
"More customization for statusline
set statusline+=%#warningmsg#
set statusline+=%*
"More customization for gutentags
let g:gutentags_ctags_exclude = [ 'node_modules']
"Update synchrone plugins (ex: gitgutter) faster /!\ slow vim
set updatetime=1000


"Set swap files directory
set directory=~/.config/nvim/tmp

"DISPLAY
"Enable syntax /!\ syntax on overwrite with default values
syntax enable
"Max width of columns
set textwidth=80
set colorcolumn=80 "show column number 80
"Folding
filetype plugin indent on
autocmd Filetype * AnyFoldActivate "activate AnyFold plugin for all filetypes
set foldlevel=0 "close all folds by default
"Colorscheme
set termguicolors
if finddir("~/.config/nvim/plugged/gruvbox") != ""
    set bg=dark
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
endif
"display trailing whitespaces
set listchars=trail:~,tab:..
set list
"Set maximum line width
set textwidth=80
"Set lines numbers
set number
"Highligh search results
set hlsearch
set incsearch
"Custom colors for diffs
hi DiffAdd ctermbg=235 ctermfg=95 cterm=reverse guibg=#262626 guifg=#5f875f gui=reverse
hi DiffDelete ctermbg=235 ctermfg=95 cterm=reverse guibg=#262626 guifg=#875f5f gui=reverse
hi DiffChange ctermbg=235 ctermfg=65 cterm=reverse guibg=#262626 guifg=#5f875f gui=reverse
hi DiffText ctermbg=235 ctermfg=65 cterm=reverse guibg=#262626 guifg=#5f875f gui=reverse

"KEYMAPS
"Set mapleader (overwrite default '\')
let mapleader = ','
"Toggle NERDTree and FZF
noremap <leader>f :FZF<CR>
noremap <leader>n :NERDTreeToggle<CR>
"escape
tnoremap nn <Esc>
inoremap nn <Esc>
vnoremap nn <Esc>
"Jump next char in insert mode
inoremap ee <Esc>la
"tab indentation
set expandtab
set shiftwidth=4
"Set timeout for double key
set timeoutlen=200
"Gitgutter
noremap <Leader>gc :Gcommit -v<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>dg :diffget<CR>
"Ale errors jump
nmap <Leader>ne <Plug>(ale_next_wrap)
nmap <Leader>pe <Plug>(ale_previous_wrap)
"Ale Fix
nmap <Leader>af <Plug>(ale_fix)
"Ctags
nnoremap <Leader>t :BTags<CR>
nnoremap <Leader>T :Tags<CR>
"Next/Previous changes jumps
noremap <Leader>nc ]c
noremap <Leader>pc [c

"MISCELLANEOUS
"Reload file if it has been changed outside of nvim
set autoread
"Set number of undo levels
set undolevels=1000
"Show the filename in the window titlebar
set title
"Pressing <F10> will show color syntaxing applied to what is under the cursor
map <F10> :echo "hi<" . snIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


"Allow scrolling faster. Enter with \i, leave with \k
"let g:OnOff=1
"function! MultiScroll(OnOff)
"if a:OnOff == 1
"  noremap k 10<Up>
"  noremap j 10<Down>
"  noremap h 10<Left>
"  noremap l 10<Right>
" let g:OnOff = 0
"else
"  let g:OnOff = 1
"  noremap k <Up>
"  noremap j <Down>
"  noremap h <Left>
"  noremap l <Right>
"endif
"endfunction
"noremap <Tab> :call MultiScroll(OnOff)<RETURN>


"Cut/Copy/Paste shared between vim instances and computer
set clipboard=unnamedplus

"bepo keyboard
source ~/.config/nvim/vimrc.bepo
"azerty keyboard
"source ~/.config/nvim/vimrc.azerty
