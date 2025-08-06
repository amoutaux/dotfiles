return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  priority = 49, -- default lazy value is 50
  config = function()
    local presets = require("markview.presets")
    require("markview").setup({
      markdown = {
        headings = presets.headings.glow,
        horizontal_rules = presets.horizontal_rules.thin,
        tables = presets.tables.rounded,
      },
    })
  end,
}
