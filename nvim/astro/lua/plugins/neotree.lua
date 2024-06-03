return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true,
  opts = function(_, opts)
    opts.filesystem.group_empty_dirs = true
    opts.filesystem.scan_mode = "deep"
  end,
}
