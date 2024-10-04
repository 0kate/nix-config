return {
  "lewis6991/gitsigns.nvim",
  init = function()
    require("gitsigns").setup({
      current_line_blame = true,
    })
  end,
}
