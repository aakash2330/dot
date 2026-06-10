return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        use_libuv_file_watcher = true,
        window = {
          auto_expand_width = false,
        },
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal=true position=left<cr>", desc = "Explorer Neo-tree" },
      { "<leader>E", "<cmd>Neotree toggle float<cr>", desc = "Explorer Neo-tree (float)" },
    },
  },
}
