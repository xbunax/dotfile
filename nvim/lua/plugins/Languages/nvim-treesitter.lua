return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPre", "VeryLazy" },
	opts = {
		install_dir = vim.fn.stdpath("data") .. "/site",
		ensure_installed = {
			"bash",
			"python",
			"diff",
			"xml",
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
		},
		ignore_install = {
			"latex",
		},
		auto_install = true,
	},
	config = function(_, opts)
		local TS = require("nvim-treesitter")
		TS.setup(opts)
	end,
}
