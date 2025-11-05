
return {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key")
    local builtin = require("telescope.builtin")

    wk.register({
      ["<leader>"] = {
        ["<space>"] = {
          function()
            builtin.find_files({ cwd = vim.fn.getcwd() })
          end,
          "Find Files in Current Directory",
        },
      },
    })
  end,
}
