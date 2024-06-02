return {
  -- Copilot
  { import = "astrocommunity.completion.copilot-cmp" },
  -- Preview
  { "rmagatti/goto-preview", opts = {
    width = 120,
    height = 30,
    resizing_mappings = true,
  } },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      local maps = opts.mappings

      maps.n["<Leader>jd"] =
        { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" }
      maps.n["<Leader>jD"] =
        { "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview Declaration" }
      maps.n["<Leader>jt"] =
        { "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview Type Definition" }
      maps.n["<Leader>ji"] =
        { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview Implementation" }
      maps.n["<Leader>jr"] =
        { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview References" }
      maps.n["<Leader>jc"] =
        { "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close all preview windows" }
    end,
  },
  -- Proto
  { import = "astrocommunity.pack.proto" },
  -- HTML
  { import = "astrocommunity.pack.html-css" },
  -- JSON
  { import = "astrocommunity.pack.json" },
  -- TS
  { import = "astrocommunity.pack.typescript-all-in-one" },
  -- Python
  { import = "astrocommunity.pack.python" },
  -- Bash
  { import = "astrocommunity.pack.bash" },
  -- Lua
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "lua_ls" })
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      local formatting = opts.formatting
      table.insert(formatting.format_on_save.allow_filetypes, "lua")
    end,
  },
  { import = "astrocommunity.pack.lua" },
}
