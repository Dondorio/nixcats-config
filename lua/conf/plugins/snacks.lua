require("snacks").setup({
  explorer = {},
  picker = {},
  bigfile = {},
  image = {},
  lazygit = {},
  -- terminal = {},
  rename = {},
  notifier = {},
  animate = {},
  scroll = {},
  scope = {},

  input = {
    enable = true,
    icon = " ",
    icon_hl = "SnacksInputIcon",
    icon_pos = "left",
    prompt_pos = "title",
    win = { style = "input" },
    expand = true,
  },

  indent = {
    priority = 1000,
    enabled = true,     -- enable indent guides
    char = "│",
    only_scope = false, -- only show indent guides of the scope
    only_current = false, -- only show indent guides in the current window
    hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides

    scope = {
      priority = 200,
      enabled = true,
      only_current = false,
      -- char = "┇",
      underline = true,
      hl = "SnacksIndentScope",
    },
    -- chunk = {
    --   priority = 200,
    --   enabled = false,
    --   only_current = false,
    --   hl = "SnacksIndentChunk",
    --   char = {
    --     corner_top = "┏",
    --     corner_bottom = "┗",
    --     horizontal = "━",
    --     vertical = "┃",
    --     arrow = "⯈",
    --   },
    -- },
  },
  gitbrowse = {},

  styles = {
    input = {
      {
        backdrop = false,
        position = "float",
        border = "rounded",
        title_pos = "center",
        height = 1,
        width = 60,
        relative = "editor",
        noautocmd = true,
        row = 2,
        -- relative = "cursor",
        -- row = -3,
        -- col = 0,
        wo = {
          winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
          cursorline = false,
        },
        bo = {
          filetype = "snacks_input",
          buftype = "prompt",
        },
        --- buffer local variables
        b = {
          completion = false, -- disable blink completions in input
        },
        keys = {
          n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
          i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
          i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
          i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
          i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
          i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
          i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
          q = "cancel",
        },
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer.open()
end, { desc = "Snacks Explorer" })

-- Find files
vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fs", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })

-- Find buffers
vim.keymap.set("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Search Buffers" })

-- Grep
vim.keymap.set("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>fG", function()
  Snacks.picker.git_files()
end, { desc = "Find Git Files" })

-- Git
vim.keymap.set("n", "<leader>fG", function()
  Snacks.picker.git_files()
end, { desc = "Find Git Files" })

vim.keymap.set("n", "<leader>uC", function()
  Snacks.picker.colorschemes()
end, { desc = "Colourschemes" })
