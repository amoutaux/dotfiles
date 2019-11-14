"PLUGINS

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'pseewald/vim-anyfold'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'morhetz/gruvbox'  "colorscheme
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'

call plug#end()

"Plugins customization
"Set airline theme
let g:airline_theme='luna'
let g:airline_section_y=''
let g:airline_section_z=''
let g:airline_skip_empty_sections = 1
"Start autocompletion from deoplete at startup
let g:deoplete#enable_at_startup = 1
"Open Gdiff in vertical splits
set diffopt+=vertical
"More customization for python-mode plugin
let g:pymode_lint_on_fly = 1
let g:pymode_rope_completion = 1
"More customization for syntastic plugin
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_pylint_args = "--load-plugins pyling_django"
"Update synchrone plugins (ex: gitgutter) faster /!\ slow vim
set updatetime=1000


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
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
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
hi DiffText gui=NONE guifg=red guibg=black


"KEY MAPS
"Set mapleader (overwrite default '\')
let mapleader = ','
"Toggle NERDTree and FZF
noremap <leader>f :FZF<CR>
noremap <leader>t :NERDTreeToggle<CR>
"next/previous word
noremap L w
noremap H b
"next/previous block
noremap K {
noremap J }
"start/end of line
noremap fh 0
noremap fl $
"next/previous cursor position
noremap I <C-o>
noremap U <C-i>
"escape
tnoremap nn <Esc>
inoremap nn <Esc>
vnoremap nn <Esc>
"Set timeout for double key
set timeoutlen=200
"Switch tabs easily
nnoremap <C-t> :tabn<Enter>
"Open current pane in new tab full screen
nnoremap <C-T> :tabnew %<Enter>


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

