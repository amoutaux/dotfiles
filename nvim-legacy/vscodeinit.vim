"Shortcuts are copied from neovim to keep consistency
"Ex: find across all files = <leader>rg to match neovim ripgrep shortcut

set directory=~/.config/nvim/tmp
set clipboard=unnamedplus
syntax enable
set hlsearch
set incsearch
set textwidth=80

"Set mapleader (overwrite default '\')
let mapleader = ','
"Toggle off highlights
noremap <leader>h :noh<CR>
"Show the preview window for what's under cursor
nmap <leader>s <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
"nerdtree-like
nmap <leader>n <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
"nerdcommenter-like
xmap <leader>c<space> <Plug>VSCodeCommentary
nmap <leader>c<space> <Plug>VSCodeCommentary
omap <leader>c<space> <Plug>VSCodeCommentary
nmap <leader>c<space> <Plug>VSCodeCommentaryLine
"ripgrep-like
nmap <leader>rg <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>
"aleformat-like
nmap <leader>af <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
"next-previous-errors
nmap <leader>ne <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nmap <leader>pe <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
"next-previous-changes
nmap <leader>nc <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nmap <leader>pc <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
"fzf-like
nmap <leader>f <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
"tmux-like full-screen 
nmap <c-z> <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
"folds
nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>

"BEPO
" {W} -> [É]
" ——————————
" On remappe W sur É: 
map é w
map É W
cmap é w

" [HJKL] -> {TSRN}
" ————————————————
" {tn} = « gauche / droite »
noremap t h
noremap n l
" {sr} = « haut / bas »
noremap s j
noremap r k
" {TN} = « haut / bas de l'écran »
noremap T H
noremap N L

" [HJKL] <- {TSRN}
" ————————————————
" {H} devient 'till'
noremap h t
noremap H T
" {j} devient 'substitute' / {J} reste Join
noremap j s
" {K} devient 'replace'
noremap k r
noremap K R
" {L} devient 'next'
noremap l n
noremap L N

" <> en direct
" ————————————
noremap « <
noremap » >
