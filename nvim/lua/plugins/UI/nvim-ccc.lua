return {
	"uga-rosa/ccc.nvim",
	event = "BufReadPre",
	config = function()
		require("ccc").setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
			output = { hex = { uppercase = true }, hsv = { enable = true } },
			input = { hex = { enable = true }, hsv = { enable = true } },
		})
	end,
}
