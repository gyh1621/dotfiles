---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "vim",
      "vimdoc",
      "lua",
      "rust",
      "python",
      "go",
      "proto",
      "query",
      "bash",
      "json",
      "jsonc",
      "toml",
      "gitignore",
      "dockerfile",
      "html",
      "css",
    })
    opts.sync_install = true
  end,
}
