require("stevenpstar.keymaps")
require("stevenpstar.lazy")

require("lazy").setup({
	"nvim-treesitter/nvim-treesitter",
	"williamboman/mason.nvim",
	{
	    'nvim-telescope/telescope.nvim', tag = '0.1.5',
	    dependencies = { 'nvim-lua/plenary.nvim' }
	},
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {'williamboman/mason-lspconfig.nvim'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'L3MON4D3/LuaSnip'},
  "jose-elias-alvarez/null-ls.nvim",
  "rebelot/kanagawa.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "EdenEast/nightfox.nvim" },
  "tpope/vim-fugitive",
  { "yorickpeterse/vim-paper" },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true}
})

require("mason").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.wo.wrap = false
vim.o.background = "dark"
vim.cmd.colorscheme "gruvbox"

local lsp = require("lsp-zero")
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr}) end)

require("mason-lspconfig").setup({
  handlers = {
    lsp.default_setup,
  },
})

local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  })
})

