local M = {}

-- https://gist.github.com/kylechui/a5c1258cd2d86755f97b10fc921315c3
local function create_make_repeatable()
  local n = 0
  _G.__rptcbs = {}
  return function(callback)
    n = n + 1
    local callback_name = 'cb' .. tostring(n)
    _G.__rptcbs[callback_name] = function()
      callback()
    end
    return function()
      vim.go.operatorfunc = 'v:lua.__rptcbs.' .. callback_name
      return 'g@l'
    end
  end
end
local make_repeatable = create_make_repeatable()

function M.keymap_set_repeatable(modes, map, callback, opts)
  opts = vim.tbl_deep_extend('force', opts or {}, {
    expr = true,
  })
  vim.keymap.set(modes, map, make_repeatable(callback), opts)
end

return M
