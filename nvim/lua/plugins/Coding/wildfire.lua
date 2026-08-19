return {
	"sustech-data/wildfire.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
	config = function()
		require("wildfire").setup({
			surrounds = {
				{ "(", ")" },
				{ "{", "}" },
				{ "<", ">" },
				{ "`", "`" },
				{ "[", "]" },
			},
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		})
	end,
}
