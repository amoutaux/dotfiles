"PLUGINS

call plug#begin()

"Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
"Autocompletion/Linters
Plug 'sheerun/vim-polyglot'
Plug 'Raimondi/delimitMate'
Plug 'pseewald/vim-anyfold'
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
"Moves
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
"Misc
Plug 'scrooloose/nerdtree'
"Display
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Markdown preview (need nodejs & yarn installed)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

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
"More customization for python-mode plugin
let g:pymode_lint_on_fly = 1
let g:pymode_rope_completion = 1
"Let NERDTree show hidden files by default
let g:NERDTreeShowHidden = 1
"Define linters used by ale
let g:ale_enabled = 1
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['typescript'] = ['prettier', 'eslint']
let g:ale_fixers['typescriptreact'] = ['prettier', 'eslint']
let g:ale_fixers['swift'] = ['swiftformat']
let g:ale_fixers['python'] = ['autopep8', 'reorder-python-imports']
let g:ale_python_pylint_options = '--max-line-length=120'
let g:ale_fixers['json'] = ['prettier']
"More customization for statusline
set statusline+=%#warningmsg#
set statusline+=%*
"More customization for gutentags
set statusline+=%{gutentags#statusline()}
"Update synchrone plugins (ex: gitgutter) faster /!\ slow vim
set updatetime=1000
"Netrw
let g:netrw_preview = 1 "preview window shown in a horizontal split"
let g:netrw_banner = 0 "hide netrw comment banner"
let g:netrw_altv = 1
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 0 "open file in current window"
"  To avoid having to close the netrw window after selecting a file, I
"  open netrw in the current window with :Explore then open files
"Fzf (junegunn)
let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8 }}
let g:fzf_preview_window = ['down:50%', 'ctrl-/']

"Markdown preview open in new window
let g:mkdp_browserfunc = 'g:Open_chrome'


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
set foldopen-=block "don't unfold on block move commands
"Colorscheme
set termguicolors
if finddir("~/.config/nvim/plugged/gruvbox") != ""
    set bg=dark
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
endif
"display whitespaces (trailing, tabs, non-breaking)
set listchars=trail:~,tab:..,nbsp:&,
set list
"Set lines numbers
set number
"Highligh search results
set hlsearch
set incsearch
"Custom colors for diffs
"NB: gui=reverse is a hack for increasing priority
"Available colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
hi DiffAdd ctermbg=235 ctermfg=64 cterm=reverse guibg=#262626 guifg=#5f8700 gui=reverse
hi DiffDelete ctermbg=235 ctermfg=88 cterm=reverse guibg=#262626 guifg=#870000 gui=reverse
hi DiffText ctermbg=235 ctermfg=172 cterm=reverse guibg=#262626 guifg=#d78700 gui=reverse
hi clear DiffChange

"KEYMAPS
"Set mapleader (overwrite default '\')
let mapleader = ','
"Toggle off highlights
noremap <leader>h :noh<CR>
"Toggle NERDTree and FZF
noremap <leader>f :FZF<CR>
noremap <leader>n :NERDTreeFind<CR>
" Toggle netrw
nnoremap <silent> ,e :Explore<CR>
"escape
tnoremap dv <Esc>
inoremap dv <Esc>
vnoremap dv <Esc>
nnoremap dv <Esc>
"Jump next char in insert mode
inoremap ee <Esc>la
"tab indentation
set expandtab
set shiftwidth=4
"Set timeout for double key
set timeoutlen=200
"Gitgutter
noremap <Leader>gc :Git commit -v<CR>
noremap <Leader>gs :Git status<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiff!<CR>
noremap <Leader>dg :diffget<CR>
noremap <Leader>dp :diffput<CR>
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
"Goto/Goback
noremap <Leader>nt <C-T>
noremap <Leader>pt <C-]>
"With ALE
noremap <Leader>ad :ALEGoToDefinition<CR>
noremap <Leader>ar :ALEFindReferences<CR>
noremap <Leader>ah :ALEDocumentation<CR>
"Second chance using ternjs
noremap <Leader>sc :TernDef<CR>
"RipGrep (via fzf)
noremap <Leader>rg :call SmartRg() <CR>
"Close windows
noremap <Leader>cp :pclose<CR>
noremap <Leader>cq :cclose<CR>
noremap <Leader>cl :lclose<CR>

"MISCELLANEOUS
"Reload file if it has been changed outside of nvim
set autoread
"Set number of undo levels
set undolevels=1000
"Show the filename in the window titlebar
set title
"Pressing <F10> will show color syntaxing applied to what is under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


"CUSTOM FUNCTIONS
"Use word under cursor for ripgrep if possible
function! SmartRg()
if matchstr(getline('.'), '\%'.col('.').'c.') =~# '\k'
    call feedkeys(":Rg \<C-R>\<C-W>\<CR>")
else
    call feedkeys(":Rg\<CR>")
endif
endfunction

"Filter quickfix list
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~#' : '=~#'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)

"Open a new chrome window (useful for markdown-preview)
function! g:Open_chrome(url)
    silent exec '!open -na "Google chrome" --args --new-window ' . a:url
endfunction

"Cut/Copy/Paste shared between vim instances and computer
set clipboard=unnamedplus

"bepo keyboard
source ~/.config/nvim/vimrc.bepo
"azerty keyboard
"source ~/.config/nvim/vimrc.azerty
