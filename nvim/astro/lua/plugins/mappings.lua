return {
  {
    "AstroNvim/astrocore",
    optional = true,
    opts = function(_, opts)
      local maps = opts.mappings

      maps.n["<Leader>o"] = { "<cmd>Outline<CR>", desc = "Document TOC" }

      -- switch panels
      maps.n["<Leader>ah"] = { "<C-w>h", desc = "Move to left split" }
      maps.n["<Leader>aj"] = { "<C-w>j", desc = "Move to below split" }
      maps.n["<Leader>ak"] = { "<C-w>k", desc = "Move to above split" }
      maps.n["<Leader>al"] = { "<C-w>l", desc = "Move to right split" }
      maps.n["<Leader>aK"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
      maps.n["<Leader>aJ"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
      maps.n["<Leader>aH"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
      maps.n["<Leader>aL"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }

      -- toggle term
      maps.i["<C-'>"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" }
      maps.n["<C-'>"] = {
        function()
          local count = vim.v.count
          if count > 0 then
            -- Get the terminal manager from ToggleTerm
            local terminals = require("toggleterm.terminal").get_all()

            -- Check if terminal with this number exists
            local exists = false
            for _, term in pairs(terminals) do
              if term.id == count then
                exists = true
                break
              end
            end

            if exists then
              -- Terminal exists, just toggle it
              vim.cmd(count .. "ToggleTerm direction=float")
            else
              -- New terminal, prompt for name
              vim.ui.input({ prompt = "Enter terminal name: " }, function(name)
                if name then vim.cmd(string.format("%dToggleTerm direction=float name=%s", count, name)) end
              end)
            end
          else
            vim.cmd "ToggleTerm direction=float"
          end
        end,
        desc = "ToggleTerm float",
      }
      maps.n["<C-M-'>"] = { "<Cmd>TermSelect<CR>", desc = "ToggleTerm float" }
      maps.n["<Leader>ts"] = { "<Cmd>TermSelect<CR>", desc = "Select ToggleTerm" }
      maps.n["<Leader>tr"] = { "<Cmd>ToggleTermSetName<CR>", desc = "Set ToggleTerm Name" }

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
