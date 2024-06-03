return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        -- status.component.mode {
        --   mode_text = { padding = { left = 1, right = 1 } },
        -- }, -- add the mode text
        status.component.git_branch(),
        status.component.file_info(),
        -- status.component.builder {
        --   {
        --     provider = function()
        --       local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
        --       local cwd = vim.fn.getcwd(0)
        --       cwd = vim.fn.fnamemodify(cwd, ":~")
        --       -- if not conditions.width_percent_below(#cwd, 0.25) then cwd = vim.fn.pathshorten(cwd) end
        --       local trail = cwd:sub(-1) == "/" and "" or "/"
        --       return icon .. cwd .. trail
        --     end,
        --   },
        --   hl = { fg = "grey", bold = true },
        --   -- surround = { separator = "right", color = status.hl.mode_bg }, -- background highlight based on mode
        -- },
        status.component.separated_path {
          padding = { left = 0 },
          separator = "/",
          max_depth = 4,
          path_func = status.provider.filename { modify = ":.:h" },
          hl = { fg = "grey", bold = true },
          update = { "BufEnter", "BufLeave", "DirChanged" },
        },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.cmd_info(),

        status.component.fill(),
        status.component.fill(),

        status.component.lsp(),
        status.component.virtual_env(),
        status.component.treesitter(),
        status.component.nav(),
        -- remove the 2nd mode indicator on the right
      }
    end,
  },
}
