return {
  {
    "mstcl/ivory",
    lazy = true,
    priority = 1000,
    config = function() vim.cmd.colorscheme "ivory" end,
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main",
    },
  },
  {
    "pineapplegiant/spaceduck",
    name = "spaceduck",
    branch = "dev",
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
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    opts = {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
        return {}
      end,
      theme = "dragon", -- Load "wave" theme when 'background' option is not set
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    },
  },
}
