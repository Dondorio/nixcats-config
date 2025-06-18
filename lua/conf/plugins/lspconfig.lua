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
		{ "<leader>ln", vim.lsp.buf.rename, desc = "Rename" },
		{ "<leader>lr", vim.lsp.buf.references, desc = "References", nowait = true },

		{ "<leader>lgd", vim.lsp.buf.definition, desc = "Goto Definition" },
		{ "<leader>lgD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "<leader>lgy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
		{ "<leader>lgI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
	},
	on_require = { "lspconfig" },
}
