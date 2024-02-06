"PLUGINS

call plug#begin()

"Git
Plug 'airblade/vim-gitgutter' "line git status (+, ~, -...)
Plug 'tpope/vim-fugitive' "Git status, Gvdiff, ...
"Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'
"Linters/Fixers
Plug 'hashivim/vim-terraform'
Plug 'Raimondi/delimitMate'
Plug 'dense-analysis/ale' "linting, fixing, jumping
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
"Moves
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak' "move to next/previous pair of chars
"Display
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'pseewald/vim-anyfold'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
"Markdown preview (need nodejs & yarn installed)
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

call plug#end()


""""""
"CORE"
""""""
"let g:python3_host_prog = '/opt/homebrew/bin/python3' "avoid having to install neovim packages in venvs
set clipboard=unnamedplus "cut/copy/paste shared between vim instances and computer
set directory=~/.config/nvim/tmp "swap files directory
set ignorecase
set smartcase "search is case-sensitive only if it contains an uppercase letter
set updatetime=1000 "time for synchrone actions (ex: gitgutter) faster /!\ slow vim
set timeoutlen=200 "time spent waiting for second key of a mapping
set expandtab "insert spaces instead of tabs
set shiftwidth=2
set textwidth=80
autocmd FileType groovy setlocal shiftwidth=4 textwidth=120 colorcolumn=120
set autoread "reload file if it has been changed outside of nvim
set undolevels=1000 "set number of changes that are stored so they can be undone
"vertical help ('bo'=bottom and opens on the right in vertical context)
cnoremap help vertical bo help
let g:netrw_preview = 1 "preview window shown in a vertical split"
let g:netrw_banner = 0 "hide netrw comment banner"
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
autocmd FileType netrw setl bufhidden=wipe
"recognize Jenkinsfiles as groovy
autocmd BufNewFile,BufRead *.jenkinsfile,*.Jenkinsfile,Jenkinsfile,jenkinsfile setfiletype groovy | set shiftwidth=2
"Recognize ruby files in a 'chef folder' as chef files to activate proper linting
autocmd BufNewFile,BufRead */recipes/*.rb,*/providers/*.rb,*/resources/*.rb,*/attributes/*.rb set ft=chef syntax=ruby


"""""""""
"DISPLAY"
"""""""""
syntax enable "enable syntax /!\ syntax on overwrite with default values
set colorcolumn=80 "show column number 80
filetype plugin indent on "activate folding
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
set list "show all whitespaces as characters
set listchars=trail:~,tab:..,nbsp:&, "select specific whitespaces
set number
set relativenumber
set hlsearch "highlight search results
set incsearch "highlight as search is being performed
"Custom colors for diffs
"NB: gui=reverse is a hack for increasing priority
"Available colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
hi DiffAdd ctermbg=235 ctermfg=64 cterm=reverse guibg=#262626 guifg=#5f8700 gui=reverse
hi DiffDelete ctermbg=235 ctermfg=88 cterm=reverse guibg=#262626 guifg=#870000 gui=reverse
hi DiffText ctermbg=235 ctermfg=172 cterm=reverse guibg=#262626 guifg=#d78700 gui=reverse
hi clear DiffChange


"""""""""
"PLUGINS"
"""""""""
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
\ '_': ['ale'],
\})
"Set supertab autocompletion cycle from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"
"Set airline theme
let g:airline_theme='luna'
let g:airline_section_y=''
let g:airline_section_z=''
let g:airline_skip_empty_sections = 1
"Define linters, fixers & lsp servers used by ale
let g:ale_enabled = 1
let g:ale_completion_enabled = 0 "We use deoplete
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_cursor_detail = 1
let g:ale_virtualtext_cursor = 0 "disable inline errors
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {}
let g:ale_linters['yaml'] = ['yamllint']
let g:ale_linters['markdown'] = ['markdownlint']
let g:ale_linters['ruby'] = ['rubocop']
let g:ale_linters['chef'] = ['cookstyle']
let g:ale_linters['groovy'] = ['npm-groovy-lint']
let g:ale_linters['python'] = ['flake8', 'pylint', 'mypy', 'pyright']
let g:ale_yamllint_options = "--strict"
let g:ale_python_pylint_options = '--max-line-length=120'
"Let mypy handle type checking
let g:ale_python_pyright_config = {
\  'pyright': {
\    'typeCheckingMode': "off",
\  },
\}
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers['sh'] = ['shfmt']
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['typescript'] = ['prettier', 'eslint']
let g:ale_fixers['typescriptreact'] = ['prettier', 'eslint']
let g:ale_fixers['swift'] = ['swiftformat']
let g:ale_fixers['python'] = ['black', 'autoflake']
let g:ale_fixers['json'] = ['prettier', 'fixjson']
let g:ale_fixers['yaml'] = ['yamlfmt']
let g:ale_fixers['ruby'] = ['rubocop']
let g:ale_fixers['chef'] = ['cookstyle']
let g:ale_fixers['terraform'] = ['terraform']
"More customization for statusline (in addition to vim-airline)
set statusline+=%#warningmsg#
set statusline+=%*
"NERDTree
let g:NERDTreeWinSize = 25
"Fzf (junegunn)
let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8 }}
let g:fzf_preview_window = ['down:50%', 'ctrl-/']
"Vim-sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S
"Markdown preview open in new window
let g:mkdp_browserfunc = 'g:Open_chrome'
let g:mkdp_theme = 'light'
"Vim-fugitive (uses its own mapping context)
nnoremap git :tab Git<CR>
autocmd FileType fugitive,fugitiveblame nnoremap <buffer> T h
autocmd FileType fugitive,fugitiveblame nnoremap <buffer> S j
autocmd FileType fugitive,fugitiveblame nnoremap <buffer> R k
autocmd FileType fugitive,fugitiveblame nnoremap <buffer> N l


"""""""""
"KEYMAPS"
"""""""""
"CORE
"Set mapleader (overwrite default '\')
let mapleader = ','
"Close windows
noremap <Leader>cp :pclose<CR>
noremap <Leader>cq :cclose<CR>
noremap <Leader>cl :lclose<CR>
"Go to previous file
noremap gpf :e#<CR>
"Toggle off highlights
noremap <leader>h :noh<CR>
"Search with boundaries
nnoremap // /\<\><Left><Left>
"Toggle FZF
noremap <leader>f :FZF<CR>
"Toggle netrw
" Rq: Lexplore is the only command that closes netrw if it's already opened
" Rq: %:p:h opens netrw in the current file directory (not the working directory)
nnoremap <silent> <leader>N :Lexplore %:p:h<CR>
nnoremap <leader>NQ :Lexplore<CR>
"escape
tnoremap dv <Esc>
inoremap dv <Esc>
vnoremap dv <Esc>
nnoremap dv <Esc>
"Jump next char in insert mode
inoremap ee <Esc>la
"Scroll 10 lines
noremap <C-d> 10jzz
noremap <C-u> 10kzz
"Next/Previous changes jumps
noremap <Leader>nc ]c
noremap <Leader>pc [c
"PLUGINS
"Open NERDTree on current file
nnoremap <leader>n :NERDTreeFind<CR>
"Vim Fugitive
noremap <Leader>gc :Git commit -v<CR>
noremap <Leader>gs :Git status<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiff!<CR>
noremap <Leader>dg :diffget<CR>
noremap <Leader>dp :diffput<CR>
"ALE
noremap <Leader>ne <Plug>(ale_next_wrap)
noremap <Leader>pe <Plug>(ale_previous_wrap)
noremap <Leader>af <Plug>(ale_fix)
noremap <Leader>ah <Plug>(ale_hover)
noremap <Leader>ad <Plug>(ale_go_to_definition)
noremap <Leader>atd <Plug>(ale_go_to_type_definition)
noremap <Leader>ar <Plug>(ale_find_references)
noremap <Leader>ado <Plug>(ale_documentation)
"RipGrep (via fzf)
noremap <Leader>rg :CustomRg<CR>

""""""""""""""""""

"Custom rg (use ':command Rg' to see the original one): search in hidden files too
command! -bang -nargs=* CustomRg
      \ call fzf#vim#grep(
      \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

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


"""""
"LUA"
"""""
"require('cmp-setup')

lua << EOF
require'nvim-treesitter.configs'.setup{
    auto_install = true
}
EOF



"""""""""""""""""
"KEYBOARD LAYOUT"
"""""""""""""""""

"bepo keyboard
source ~/.config/nvim/vimrc.bepo
"azerty keyboard
"source ~/.config/nvim/vimrc.azerty
