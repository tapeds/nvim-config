return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        theme = "purple", -- Choose the purple variant of the Kagawa theme
        styles = {
          comments = "italic", -- Make comments italic
          functions = "italic,bold", -- Make functions italic and bold
        },
      })
    end,
  },
}
