return {
  "Raimondi/delimitMate",
  branch = "master",
  init = function()
    vim.g.delimitMate_expand_cr = 1 -- Smart <CR> handling between brackets
    vim.g.delimitMate_expand_space = 1 -- Optional: add space between brackets
    vim.g.delimitMate_smart_quotes = 1 -- Handle quotes smartly
    vim.g.delimitMate_autoclose = 1 -- Autoclose brackets
  end,
}
