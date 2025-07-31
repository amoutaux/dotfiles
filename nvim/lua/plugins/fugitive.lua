return {
    'tpope/vim-fugitive', branch = 'master',
    lazy = true,
    keys = {
        {'git', '<cmd>Git<cr>'},
        {'S', '<Plug>fugitive:s', mode = {'n', 'v'}, ft = { 'fugitive', 'fugitiveblame' }},
        {'s', 'j', mode = {'n', 'v'}, ft = { 'fugitive', 'fugitiveblame' }},
        {'o', '<Plug>fugitive:>', ft = { 'fugitive', 'fugitiveblame' }},
        {'c', '<Plug>fugitive:<', ft = { 'fugitive', 'fugitiveblame' }},
        {'<leader>nc', '<Plug>fugitive:)', ft = { 'fugitive', 'fugitiveblame' }},
        {'<leader>pc', '<Plug>fugitive:(', ft = { 'fugitive', 'fugitiveblame' }},
    }
}
