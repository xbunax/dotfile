local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local fileType = vim.bo.filetype
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	require("plugins.start-time"),
	require("plugins.dashboard"),
	require("plugins.neodev"),
	require("plugins.gruvbox"),
	require("plugins.navbuddy"),
	require("plugins.mason"),
	--require("plugins.lspconfig")
	require("plugins.cmp"),
	require("plugins.hlchunk"),
	require("plugins.treesitter"),
	--require("plugins.minianimate")
	-- require("plugins.neoscroll"),
	require("plugins.winbar"),
	require("plugins.dressing"),
	require("plugins.autopaires"),
	require("plugins.noice"),
	require("plugins.ufo"),
	require("plugins.telescope"),
	require("plugins.toggleterm"),
	require("plugins.scrollbar"),
	-- require("plugins.symbols-outline"),
	require("plugins.vim-illuminate"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	-- require("plugins.leap"),
	require("plugins.flash"),
	-- require("plugins.wildfire"),
	require("plugins.wildfire-untree"),
	require("plugins.alternate"),
	require("plugins.nvim-tree"),
	require("plugins.lspsaga"),
	require("plugins.markdown-pre"),
	require("plugins.oil"),
	require("plugins.fzf-lua"),
	require("plugins.fzf"),
	require("plugins.comment"),
	require("plugins.lazygit"),
	require("plugins.multi-cursor"),
	require("plugins.typst"),
	require("plugins.typst-preview"),
	require("plugins.surround"),
	require("plugins.copilot"),
	require("plugins.clangd-extensions"),
	require("plugins.leetcode"),
	require("plugins.scope"),
	require("plugins.conform"),
	-- require("plugins.vim-tpipeline"),
	-- require("plugins.null-ls"),
	-- require("plugins.colorizer"),
	--   require("plugins.autosave"),
	--require("plugins.neotree"),
})
