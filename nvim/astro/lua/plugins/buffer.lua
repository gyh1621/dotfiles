return {
  { import = "astrocommunity.recipes.disable-tabline" },
  { import = "astrocommunity.bars-and-lines.scope-nvim" },
  {
    "cbochs/grapple.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "AstroNvim/astroui", opts = { icons = { Grapple = "󰛢" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader><Leader>"
          maps.n[prefix] = { desc = require("astroui").get_icon("Grapple", 1, true) .. "Grapple" }
          maps.n[prefix .. "a"] = { "<Cmd>Grapple tag<CR>", desc = "Add file" }
          maps.n[prefix .. "d"] = { "<Cmd>Grapple untag<CR>", desc = "Remove file" }
          maps.n[prefix .. "t"] = { "<Cmd>Grapple toggle_tags<CR>", desc = "Toggle a file" }
          maps.n[prefix .. "s"] = { "<Cmd>Grapple toggle_scopes<CR>", desc = "Select from tags" }
          maps.n[prefix .. "l"] = { "<Cmd>Grapple toggle_loaded<CR>", desc = "Select a project scope" }
          maps.n[prefix .. "r"] = { "<Cmd>Grapple reset<CR>", desc = "Clear tags from current project" }
          maps.n["<C-n>"] = { "<Cmd>Grapple cycle forward<CR>", desc = "Select next tag" }
          maps.n["<C-p>"] = { "<Cmd>Grapple cycle backward<CR>", desc = "Select previous tag" }
        end,
      },
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    cmd = { "Grapple" },
  },
  {
    "LukasPietzschmann/telescope-tabs",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>bT"] = { "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Search tabs" },
            },
          },
        },
      },
    },
    opts = {
      show_preview = true,
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>bb"] = {
                function() require("bufferline.commands").cycle(vim.v.count1) end,
                desc = "Next buffer",
              },
              ["<Leader>bn"] = {
                function() require("bufferline.commands").cycle(-vim.v.count1) end,
                desc = "Previous buffer",
              },
              ["<Leader>b>"] = {
                function() require("bufferline.commands").move(vim.v.count1) end,
                desc = "Move buffer tab right",
              },
              ["<Leader>b<"] = {
                function() require("bufferline.commands").move(-vim.v.count1) end,
                desc = "Move buffer tab left",
              },
              ["<Leader>bd"] = { "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
              ["<Leader>b1"] = { "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
              ["<leader>b2"] = { "<cmd>BufferLineGoToBuffer 2<cr>", desc = "go to buffer 2" },
              ["<Leader>b3"] = { "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
              ["<Leader>b4"] = { "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
              ["<Leader>b5"] = { "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
              ["<Leader>b6"] = { "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
              ["<Leader>b7"] = { "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
              ["<Leader>b8"] = { "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
              ["<Leader>b9"] = { "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
            },
          },
        },
      },
    },
    eveny = "VeryLazy",
    opts = {
      options = {
        numbers = function(opts) return string.format("%s", opts.lower(opts.ordinal)) end,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "icon",
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match "error" and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
}
