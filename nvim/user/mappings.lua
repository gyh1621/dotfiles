return {
  -- Smart Splits
  n = {
    -- neo tree
    ["<leader>n"]  = { "<cmd>Neotree toggle<CR>" },
    -- switch buffers
    ["<leader>ah"] = { "<C-w>h", desc = "Move to left split" },
    ["<leader>aj"] = { "<C-w>j", desc = "Move to below split" },
    ["<leader>ak"] = { "<C-w>k", desc = "Move to above split" },
    ["<leader>al"] = { "<C-w>l", desc = "Move to right split" },
    ["<leader>aK"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
    ["<leader>aJ"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
    ["<leader>aH"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" },
    ["<leader>aL"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" },
    -- bookmarks
    ["<leader>mm"] = { "<cmd>BookmarkToggle<CR>", desc = "Toggle bookmark at current line" },
    ["<leader>mi"] = { "<cmd>BookmarkAnnotate<CR>", desc = "Add annotation at current line" },
    ["<leader>ma"] = { "<cmd>BookmarkShowAll<CR>", desc = "Show all bookmarks" },
    ["<leader>mn"] = { "<cmd>BookmarkNext<CR>", desc = "Go to next bookmark" },
    ["<leader>mp"] = { "<cmd>BookmarkPrev<CR>", desc = "Go to previous bookmark" },
    -- rust-tools
    ["<leader>r"]  = { "<cmd>RustHoverActions<CR>", desc = "Rust hover actions" },
    ["<leader>R"]  = { "<cmd>RustCodeAction<CR>", desc = "Rust code actions" },
    -- telescope
    -- -- bookmarks
    ["<leader>fd"] = { "<cmd>Telescope vim_bookmarks all<CR>", desc = "Show all bookmarks" },
    ["<leader>fD"] = { "<cmd>Telescope vim_bookmarks current_file<CR>", desc = "Show all bookmarks in current file" },
    -- goto preview
    ["<leader>jd"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
    ["<leader>jD"] = { "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview Declaration" },
    ["<leader>jt"] = { "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview Type Definition" },
    ["<leader>ji"] = { "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview Implementation" },
    ["<leader>jr"] = { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview References" },
    ["<leader>jc"] = { "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close all preview windows" },
  }
}
