return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	root_markers = { "package.json", ".git" },
}
