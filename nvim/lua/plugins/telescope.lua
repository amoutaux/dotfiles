return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
    	defaults = {
	    mappings = {
	    	n = {
		    ["dv"] = "close",
		}
	    }
	}
    },
    keys = {
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Telescope search files" },
        { "<leader>ls", "<cmd>Telescope live_grep<cr>", desc = "Telescope live search" },
        { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Telescope search buffers" },
    },
    lazy = false
}
