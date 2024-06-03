return {
  "nvim-telescope/telescope.nvim",
  optional = true,
  opts = function(_, opts) opts.defaults.path_display = { "shorten" } end,
}
