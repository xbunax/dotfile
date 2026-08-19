return {
	{
		"EvWilson/spelunk.nvim",
		dependencies = {
			"folke/snacks.nvim", -- Optional: for enhanced fuzzy search capabilities
			"nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
			"nvim-lualine/lualine.nvim", -- Optional: for statusline display integration
		},
		config = function()
			require("spelunk").setup({
				enable_persist = true,
				base_mappings = {
					-- Toggle the UI open/closed
					toggle = "<leader>Bt",
					-- Add a bookmark to the current stack
					add = "<leader>Ba",
					-- Delete current line's bookmark from the current stack
					delete = "<leader>Bd",
					-- Move to the next bookmark in the stack
					next_bookmark = "<leader>Bn",
					-- Move to the previous bookmark in the stack
					prev_bookmark = "<leader>Bp",
					-- Fuzzy-find all bookmarks
					search_bookmarks = "<leader>Bf",
					-- Fuzzy-find bookmarks in current stack
					search_current_bookmarks = "<leader>Bc",
					-- Fuzzy find all stacks
					search_stacks = "<leader>Bs",
					-- Change line of hovered bookmark
					change_line = "<leader>Bl",
				},
			})
		end,
	},
}
