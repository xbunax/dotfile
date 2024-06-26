require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- A list of servers to automatically install if they're not already installed
	ensure_installed = { "taplo", "pylsp", "clangd", "lua_ls", "bashls" },
})

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer
local lspconfig = require("lspconfig")

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {
	noremap = true,
	silent = true,
}
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format(
			--            async = true,
			--            filter = function (client)
			--                return client.name == "lua-ls"
			--            end
		)
	end, bufopts)
end

-- Configure each language
-- How to add LSP for a specific language?
-- 1. use `:Mason` to install corresponding LSP
-- 2. add configuration below
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.pylsp.setup({
	on_attach = on_attach,
})

lspconfig.gopls.setup({
	on_attach = on_attach,
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
-- lspconfig.lua_ls.setup {
--     on_attach = on_attach,
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = { 'vim' },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file("", true),
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }

lspconfig.bashls.setup({
	on_attach = on_attach,
})

-- source: https://rust-analyzer.github.io/manual.html#nvim-lsp
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				closingBraceHints = true, -- Whether to show inlay hints after a closing } to indicate what item it belongs to.
			},
		},
	},
})

lspconfig.clangd.setup({
	-- function(_, opts)
	--     opts.capabilities.offsetEncoding = { "utf-16" }
	-- end,

	on_attach = on_attach,
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
})

lspconfig.matlab_ls.setup({
	on_attach = on_attach,
})

lspconfig.yamlls.setup({
	on_attach = on_attach,
})

lspconfig.marksman.setup({
	on_attach = on_attach,
})

lspconfig.texlab.setup({
	on_attach = on_attach,
})

lspconfig.cmake.setup({
	on_attach = on_attach,
})

lspconfig.swift_mesonls.setup({
	on_attach = on_attach,
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "swift" },
		callback = function()
			local root_dir = vim.fs.dirname(vim.fs.find({
				"Package.swift",
				".git",
			}, { upward = true })[1])
			local client = vim.lsp.start({
				name = "sourcekit-lsp",
				cmd = { "sourcekit-lsp" },
				root_dir = root_dir,
			})
			vim.lsp.buf_attach_client(0, client)
		end,
	}),
})

lspconfig.taplo.setup({
	on_attach = on_attach,
})

lspconfig.typst_lsp.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = function()
		return vim.fn.getcwd()
	end,
	settings = {
		exportPdf = "onType", -- Choose onType, onSave or never.
		serverPath = "~/.local/share/nvim/mason/bin/typst-lsp", -- Normally, there is no need to uncomment it.
	},
})
