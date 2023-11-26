local colorscheme = ""
-- local hour = tonumber(os.date("%H"))
-- if hour >= 6 and hour < 18 then
--   -- Set the colorscheme for daytime
--   colorscheme = "catppuccin-latte"
-- else
--   -- Set the colorscheme for nighttime
--   colorscheme = "spaceduck"
-- end
colorscheme = "spaceduck"

return {
  colorscheme = colorscheme,
  plugins = {
    -- start page
    "MaximilianLloyd/ascii.nvim",
    {
      "goolord/alpha-nvim",
      opts = function(_, opts)
        -- customize the dashboard header
        local ascii = require('ascii')
        local function get_random_element(array)
          math.randomseed(os.time())
          local index = math.random(#array)
          return array[index]
        end
        opts.section.header.val = get_random_element({
          ascii.art.animals.cats.boxy,
          ascii.art.animals.cats.luna,
          ascii.art.misc.skulls.threeskulls_v1,
          ascii.get_random("gaming", "pacman"),
          ascii.get_random("planets", "planets")
        })
        return opts
      end,
      dependencies = {
        "MaximilianLloyd/ascii.nvim"
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        vim.cmd("set foldmethod=expr")
        vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
        vim.cmd("set nofoldenable")
        require 'nvim-treesitter.configs'.setup {
          ensure_installed = { "c", "lua", "vim", "help", "query", "bash", "cpp", "css", "dockerfile", "gitignore", "go",
            "html", "json", "jsonc", "python", "proto", "rust", "toml" },
          sync_install = true,
        }
      end,
    },

    -- extend Telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { -- add a new dependency to telescope that is our new plugin
        "tom-anders/telescope-vim-bookmarks.nvim",
      },
      -- the first parameter is the plugin specification
      -- the second is the table of options as set up in Lazy with the `opts` key
      config = function(plugin, opts)
        -- run the core AstroNvim configuration function with the options table
        require("plugins.configs.telescope")(plugin, opts)

        -- require telescope and load extensions as necessary
        local telescope = require "telescope"
        telescope.load_extension "vim_bookmarks"
      end,
    },

    -- scrolling
    {
      "echasnovski/mini.animate",
      event = "VeryLazy",
      -- enabled = false,
      opts = function()
        -- don't use animate when scrolling with the mouse
        local mouse_scrolled = false
        for _, scroll in ipairs { "Up", "Down" } do
          local key = "<ScrollWheel" .. scroll .. ">"
          vim.keymap.set({ "", "i" }, key, function()
            mouse_scrolled = true
            return key
          end, { expr = true })
        end

        local animate = require "mini.animate"
        return {
          resize = {
            timing = animate.gen_timing.linear { duration = 100, unit = "total" },
          },
          scroll = {
            timing = animate.gen_timing.linear { duration = 150, unit = "total" },
            subscroll = animate.gen_subscroll.equal {
              predicate = function(total_scroll)
                if mouse_scrolled then
                  mouse_scrolled = false
                  return false
                end
                return total_scroll > 1
              end,
            },
          },
          cursor = {
            timing = animate.gen_timing.linear { duration = 80, unit = "total" },
          },
        }
      end,
      config = function(_, opts) require("mini.animate").setup(opts) end,
    },

    -- completion
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "User AstroFile",
      opts = {
        suggestion = {
          auto_trigger = true,
          debounce = 150,
          kepmap = {
            accept = '<M-l>',
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-j>",
          }
        }
      },
    },

    -- bookmark
    {
      "MattesGroeger/vim-bookmarks",
      cmd = {
        "BookmarkToggle",
        "BookmarkAnnotate",
        "BookmarkShowAll",
        "BookmarkNext",
        "BookmarkPrev",
        "BookmarkClear",
        "BookmarkClearAll",
      },
    },
    {
      "tom-anders/telescope-vim-bookmarks.nvim",
      dependencies = { "MattesGroeger/vim-bookmarks" },
    },

    -- colorschemes
    "nyoom-engineering/oxocarbon.nvim",
    {
      "rose-pine/neovim",
      name = "rose-pine",
      opts = {
        variant = "main"
      }
    },
    {
      "pineapplegiant/spaceduck",
      name = "spaceduck",
      branch = "dev"
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      opts = {
        integrations = {
          aerial = true,
          neotree = true,
          treesitter = true,
          which_key = true,
          mason = true,
        }
      }
    },

    -- lsp
    {
      "simrat39/rust-tools.nvim",
      config = function(_, _)
      end
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "rust_analyzer" },
      },
    },

    -- Go
    {
      "ray-x/go.nvim",
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()
      end,
      event = { "CmdlineEnter" },
      ft = { "go", 'gomod' },
    }
  },
  lsp = {
    formatting = {
      format_on_save = true, -- enable or disable automatic formatting on save
    },
    setup_handlers = {
      -- add custom handler
      rust_analyzer = function(_, opts)
        opts.cmd = { "rust-analyzer" }
        opts.diagnostics = {
          enable = false
        }
        opts.checkOnSave = {
          command = "clippy"
        }
        opts.diagnostics = {
          enable = true
        }
        require("rust-tools").setup {
          server = opts
        }
      end
    }
  }
}
