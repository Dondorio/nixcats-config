return {
	"nvim-lspconfig",
	for_cat = {
		cat = "general.lsp",
		default = true,
	},
	event = { "FileType" },
	cmd = {
		"LspInfo",
		"LspStart",
		"LspStop",
		"LspRestart",
	},
	keys = {
		{ "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },
		{ "gn", vim.lsp.buf.rename, desc = "Rename" },
		{ "<leader>lr", vim.lsp.buf.references, desc = "References", nowait = true },

		{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "gY", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
		{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
	},
	on_require = { "lspconfig" },
}
