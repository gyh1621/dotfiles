return {
  -- start page
  "MaximilianLloyd/ascii.nvim",
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      local ascii = require "ascii"
      local function get_random_element(array)
        math.randomseed(os.time())
        local index = math.random(#array)
        return array[index]
      end
      opts.section.header.val = get_random_element {
        ascii.art.animals.cats.boxy,
        ascii.art.animals.cats.luna,
        ascii.get_random("gaming", "pacman"),
        ascii.get_random("planets", "planets"),
      }
      return opts
    end,
    dependencies = {
      "MaximilianLloyd/ascii.nvim",
    },
  },
}
