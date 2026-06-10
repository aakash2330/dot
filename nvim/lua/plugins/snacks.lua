return {
  {
    "folke/snacks.nvim",
    keys = {
      -- disable Snacks Explorer keymaps so we can use Neo-tree
      { "<leader>e", false },
      { "<leader>E", false },
    },
    opts = {
      scroll = { enabled = false },
      animate = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      -- picker = {
      --   win = {
      --     title = "",
      --     input = { keys = { ["<esc>"] = false } },
      --     list = { keys = { ["<esc>"] = false } },
      --     preview = { keys = { ["<esc>"] = false } },
      --   },
      -- },
    },
  },
}
