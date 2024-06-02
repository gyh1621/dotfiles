return {
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "rust_analyzer" })
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      local formatting = opts.formatting
      table.insert(formatting.format_on_save.allow_filetypes, "rust")

      local maps = opts.mappings
      maps.n["<Leader>r"] = { desc = "rust" }
      maps.n["<Leader>rd"] = { "<cmd>RustLsp openDocs<cr>", desc = "open docs" }
      maps.n["<Leader>re"] = { "<cmd>RustLsp explainError<cr>", desc = "explain error" }
      maps.n["<Leader>ra"] = { "<cmd>RustLsp codeAction<cr>", desc = "code action" }
      maps.n["<Leader>rc"] = { "<cmd>RustLsp openCargo<cr>", desc = "open Cargo.toml" }
    end,
  },
  { import = "astrocommunity.pack.rust" },
}
