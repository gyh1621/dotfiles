return {
  {
    "AstroNvim/astrocore",
    optional = true,
    opts = function(_, opts)
      local maps = opts.mappings

      -- switch panels
      maps.n["<Leader>ah"] = { "<C-w>h", desc = "Move to left split" }
      maps.n["<Leader>aj"] = { "<C-w>j", desc = "Move to below split" }
      maps.n["<Leader>ak"] = { "<C-w>k", desc = "Move to above split" }
      maps.n["<Leader>al"] = { "<C-w>l", desc = "Move to right split" }
      maps.n["<Leader>aK"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
      maps.n["<Leader>aJ"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
      maps.n["<Leader>aH"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
      maps.n["<Leader>aL"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }

      -- -- bookmarks
      -- ["<leader>mm"] = { "<cmd>BookmarkToggle<CR>", desc = "Toggle bookmark at current line" },
      -- ["<leader>mi"] = { "<cmd>BookmarkAnnotate<CR>", desc = "Add annotation at current line" },
      -- ["<leader>ma"] = { "<cmd>BookmarkShowAll<CR>", desc = "Show all bookmarks" },
      -- ["<leader>mn"] = { "<cmd>BookmarkNext<CR>", desc = "Go to next bookmark" },
      -- ["<leader>mp"] = { "<cmd>BookmarkPrev<CR>", desc = "Go to previous bookmark" },
      -- telescope
      -- -- bookmarks
      -- ["<leader>fd"] = { "<cmd>Telescope vim_bookmarks all<CR>", desc = "Show all bookmarks" },
      -- ["<leader>fD"] = {
      --   "<cmd>Telescope vim_bookmarks current_file<CR>",
      --   desc = "Show all bookmarks in current file",
      -- },
    end,
  },
}
