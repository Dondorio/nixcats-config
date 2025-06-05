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
  on_require = { "lspconfig" },
}
