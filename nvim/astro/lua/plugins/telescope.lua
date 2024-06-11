return {
  "nvim-telescope/telescope.nvim",
  optional = true,
  opts = function(_, opts)
    opts.defaults.layout_strategy = "vertical"
    opts.defaults.layout_config = {
      width = 0.9,
      height = 0.9,
      preview_height = 0.6,
      preview_cutoff = 0,
    }

    -- opts.defaults.path_display = { "shorten" }
    opts.defaults.path_display = function(opts, path)
      local tail = require("telescope.utils").path_tail(path)
      path = require("telescope.utils").path_smart(path)
      -- remove tail and / from path
      path = path:sub(1, #path - #tail - 1)
      path = string.format("%s (%s)", tail, path)
      local highlights = {
        {
          {
            0, -- highlight start position
            #path, -- highlight end position
          },
          "Comment", -- highlight group name
        },
      }
      return path, highlights
    end
  end,
}
