return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      diff_opts = {
        internal = true,
      },
      word_diff = true,
    },
    keys = {
      {
        "<leader>ghw",
        function()
          require("gitsigns").toggle_word_diff()
        end,
        desc = "Toggle Word Diff",
      },
    },
  },
}
