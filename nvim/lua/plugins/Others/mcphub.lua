return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	config = function()
		require("mcphub").setup({
			auto_approve = false, -- Auto approve mcp tool calls
			auto_toggle_mcp_servers = true,
			extensions = {
				avante = {
					make_slash_commands = true, -- make /slash commands from MCP server prompts
				},
			},
		})
	end,
}
