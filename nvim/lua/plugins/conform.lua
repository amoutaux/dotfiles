return {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
        formatters_by_ft = {
            -- ALL
            ['*'] = { 'codespell', 'trim_whitespace' },
            --
            lua = { 'stylua' },
            python = function(bufnr)
                if require('conform').get_formatter_info('ruff_format', bufnr).available then
                    return { 'ruff_format' }
                else
                    return { 'isort', 'black', 'autopep8' }
                end
            end,
        },
        default_format_opts = {
            lsp_format = 'fallback',
        },
        -- Set the log level. Use `:ConformInfo` to see the location of the log file.
        log_level = vim.log.levels.ERROR,
        -- Conform will notify you when a formatter errors
        notify_on_error = true,
        -- Conform will notify you when no formatters are available for the buffer
        notify_no_formatters = true,
        -- Custom formatters and overrides for built-in formatters
    },
}
