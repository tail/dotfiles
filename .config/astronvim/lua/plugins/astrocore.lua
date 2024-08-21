-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
--
---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        clipboard = "",
        mouse = "",
        relativenumber = false,
        exrc = true,
      },
    },

    mappings = {
      -- normal mode mappings
      n = {
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<A-[>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<A-]>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<A-{>"] = { function() require("astrocore.buffer").move(-vim.v.count1) end, desc = "Previous buffer" },
        ["<A-}>"] = { function() require("astrocore.buffer").move(vim.v.count1) end, desc = "Next buffer" },
        ["<C-p>"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" },
        ["<Leader><Leader>"] = { function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
        ["<Leader>fs"] = {
          function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
          desc = "Search LSP workspace symbols",
        },
        ["<C-space>"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
        ["<C-/>"] = {
          function() require("Comment.api").toggle.linewise.count(vim.v.count1) end,
          desc = "Toggle comment line",
        },
        ["<Leader>*"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor or selection" },
      },

      -- visual mode mappings
      v = {
        ["<Leader>fc"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor or selection" },
        ["<Leader>*"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor or selection" },
      },
    },

    sessions = {
      -- Configure auto saving
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = {}, -- buffer types to ignore sessions
      },
    },
  },
}
