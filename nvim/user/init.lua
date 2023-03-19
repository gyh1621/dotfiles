return {
  colorscheme = "spaceduck",
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

    "mfussenegger/nvim-jdtls", -- load jdtls on module
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "jdtls" },
      },
    },

  },
  lsp = {
    setup_handlers = {
      jdtls = function(_, opts)
        vim.api.nvim_create_autocmd("Filetype", {
          pattern = "java", -- autocmd to start jdtls
          callback = function()
            require("jdtls").start_or_attach(opts)
          end,
        })
      end
    },
    config = {
      rust_analyzer = {
        settings = {
          ["rust_analyzer"] = {
            cargo = {
              features = { "all" },
            }
          }
        }
      },
      jdtls = function()
        -- use this function notation to build some variables
        local root_markers = { ".git", "Config", {"packageInfo"} }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        local ws_folders_jdtls = {}
        if root_dir then
          local file = io.open(root_dir .. "/.bemol/ws_root_folders")
          if file then
            for line in file:lines() do
              table.insert(ws_folders_jdtls, "file://" .. line)
            end
            file:close()
          end
        end

        -- calculate workspace dir
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
        os.execute("mkdir -p " .. workspace_dir)

        -- get the mason install path
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

        -- get the current OS
        local os
        if vim.fn.has "macunix" then
          os = "mac"
        elseif vim.fn.has "win32" then
          os = "win"
        else
          os = "linux"
        end

        -- return the server config
        return {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. install_path .. "/lombok.jar",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            install_path .. "/config_" .. os,
            "-data " .. workspace_dir,
          },
          root_dir = root_dir,
          init_options = {
            workspaceFolders = ws_folders_jdtls,
          },
        }

      end
    }
  }
}
