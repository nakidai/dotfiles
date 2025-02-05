function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(
        mode, shortcut, command,
        {
            noremap=true,
            silent=true
        }
    )
end

function nmap(shortcut, command)
    map("n", shortcut, command)
end

function tmap(shortcut, command)
    map("t", shortcut, command)
end

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Show docs
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader          = " "
vim.g.maplocalleadder    = " "


vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.autoindent     = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.smarttab       = true
vim.opt.softtabstop    = 4
vim.opt.mouse          = "nvi"
vim.opt.termguicolors  = true
vim.opt.clipboard      = "unnamedplus"
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "80"

vim.g.NERDTreeQuitOnOpen = 1
vim.g.c_syntax_for_h     = 1
vim.cmd([[
let g:lightline = {
      \ 'colorscheme': 'catppuccin',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
]])

-- Toggle files tree
nmap("<Leader>y", ":NERDTreeToggle<CR>")
-- Create splits
nmap("<Leader>v", ":vsplit<CR>")
nmap("<Leader>s", ":split<CR>")
-- Set split to clean buffer
nmap("<Leader>q", ":enew<bar>bd #<CR>")
-- Navigate in splits
nmap("<Leader>h", ":wincmd h<CR>")
nmap("<Leader>j", ":wincmd j<CR>")
nmap("<Leader>k", ":wincmd k<CR>")
nmap("<Leader>l", ":wincmd l<CR>")
-- Edit size of split
nmap("<c-k>",     ":resize +5<CR>")
nmap("<c-j>",     ":resize -5<CR>")
nmap("<c-h>",     ":vertical resize -5<CR>")
nmap("<c-l>",     ":vertical resize +5<CR>")
-- Switch tabs
nmap("H",         ":tabp<CR>")
nmap("L",         ":tabn<CR>")
-- Hide search highlighting
nmap("<Leader>n", ":nohlsearch<CR>")
-- Terminal
tmap("<C-c><C-c>", "<C-\\><C-n>")
-- Update date in mdoc
nmap("<leader>d", ":0delete<CR>:0read !date +'.Dd \\%B \\%e, \\%Y'<CR>")

require("lazy").setup(
    {
        {"catppuccin/nvim", name="catppuccin", priority=1000},
        -- Status & tab bars
        {"itchyny/lightline.vim"},
        -- Automatically create closing bracket
        {"windwp/nvim-autopairs"},
        -- Plugin for comfortable navigating
        {"preservim/nerdtree"},
        -- Plugin for surrounding text in something faster
        {"kylechui/nvim-surround"},
        -- Plugin for snippets
        {"neoclide/coc.nvim", branch="release"},
        -- Plugin for git integration
        {"tpope/vim-fugitive"},
        -- LSP
        {"neovim/nvim-lspconfig"},
        -- Lua
        {"lervag/vimtex", init=function() vim.g.vimtex_view_method = "zathura" end},
        -- Caddyfile syntax
        {"isobit/vim-caddyfile"},
        -- C3 syntax
        {"Airbus5717/c3.vim"},
    }
)

vim.g.vtex_flavor="latex"
vim.g.vimtex_view_method = "zathura"
vim.g.conceallevel=1
vim.g.tex_conceal="abdmg"

vim.cmd.colorscheme("catppuccin-frappe")
require("nvim-surround").setup({})
require("nvim-autopairs").setup({})
local lsp = require("lspconfig")
lsp.pyright.setup({})
lsp.clangd.setup({})
lsp.jdtls.setup({})
lsp.cmake.setup({})
lsp.c3_lsp.setup({})
lsp.texlab.setup({})
lsp.zls.setup({})

-- coc.nvim (idk didn't check and i'm too tired at 5 49 am D:)

local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

-- Some useful commands
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
