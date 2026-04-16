-- Minimal neovim config — plugin-free, portable

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.scrolloff = 15
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.timeoutlen = 1000
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.termguicolors = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.winminheight = 0
vim.opt.winminwidth = 0
vim.opt.winheight = 5
vim.opt.winwidth = 5

-- Cursor: block in normal, thin bar in insert
vim.opt.guicursor =
    "n-v-c:block-Cursor/lCursor,i:ver25-iCursor"

-------------------------------------------------------------------------------
-- Colorscheme
-------------------------------------------------------------------------------
-- "slate" and "desert" are safe on any neovim version.
-- "habamax" requires 0.9+, "lunaperche" requires 0.8+.
local ok, _ = pcall(vim.cmd, "colorscheme lunaperche")
if not ok then
    vim.cmd("colorscheme desert")
end

-------------------------------------------------------------------------------
-- Keymaps
-------------------------------------------------------------------------------
-- Clear search highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlights" })

-- Pane movement with Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Pane resize with Ctrl+arrows
vim.keymap.set("n", "<C-Up>", "<C-w>-", { desc = "Shrink split height" })
vim.keymap.set("n", "<C-Down>", "<C-w>+", { desc = "Expand split height" })
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "Shrink split width" })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "Expand split width" })

-- File explorer (netrw, built-in)
vim.keymap.set("n", "<C-p>", ":Lexplore<CR>", { desc = "Toggle file explorer" })

-- Buffer navigation
vim.keymap.set("n", "<leader><leader>", ":buffers<CR>:buffer ", { desc = "List buffers" })

-- Fuzzy-ish file finding with :find (set path to search recursively)
vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.keymap.set("n", "<leader>sf", ":find ", { desc = "Find file" })

-- Grep integration (uses ripgrep if available)
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
end
vim.keymap.set("n", "<leader>sg", ":grep ", { desc = "Grep search" })
vim.keymap.set("n", "<leader>sw", function()
    vim.cmd("grep " .. vim.fn.expand("<cword>"))
end, { desc = "Grep current word" })

-- Diagnostics (active if LSP is available)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- LSP keymaps (only active when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MinimalLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "==", function() vim.lsp.buf.format({ async = true }) end, opts)
    end,
})

-------------------------------------------------------------------------------
-- Autocmds
-------------------------------------------------------------------------------
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
