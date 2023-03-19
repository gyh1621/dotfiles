return {
  -- Smart Splits
  n = {
    -- neo tree
    ["<leader>n"]  ={ "<cmd>Neotree toggle<CR>" },
    -- switch buffers
    ["<leader>ah"] = { "<C-w>h", desc = "Move to left split" },
    ["<leader>aj"] = { "<C-w>j", desc = "Move to below split" },
    ["<leader>ak"] = { "<C-w>k", desc = "Move to above split" },
    ["<leader>al"] = { "<C-w>l", desc = "Move to right split" },
    ["<leader>aK"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
    ["<leader>aJ"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
    ["<leader>aH"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" },
    ["<leader>aL"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
  }
}

