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
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
  { "diegoulloao/neofusion.nvim", priority = 1000 , config = true },
  {
  'stevearc/conform.nvim',
    opts = {},
  },
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require 'nordic' .load()
    end
  },
  { 
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end
  },
-- Lua
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 140
      }
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "rose-pine/neovim"
  },
  { 'projekt0n/github-nvim-theme' },
  { 'yazeed1s/oh-lucy.nvim' },
  { 'mellow-theme/mellow.nvim' },
  { 'ramojus/mellifluous.nvim' },
})

require("mason").setup()
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    go = {"gofmt"}
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

require("rose-pine").setup({
  variant="moon",
  dark_variant="moon",
  dim_inactive_windows = false,
  enable = {
    terminal = true,
    legacy_highlights= true,
    migrations = true,
  },
  styles = {
    bold = true,
    italics = true,
    transparency = true,
  },
})

require("catppuccin").setup({
  transparent_background = true
})
require("gruvbox").setup({
  transparent_mode = true
})

local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>qk', '<cmd>cprev<return>', {})
vim.keymap.set('n', '<leader>qj', '<cmd>cnext<return>', {})
vim.keymap.set('n', '<leader>s', '<cmd>:w<cr> | <cmd>terminal npx tsc<cr>', {})
--vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, {})
vim.keymap.set(
	"n",
	"<leader>de",
	"<cmd>Telescope diagnostics bufnr=0 theme=dropdown prompt_title=diagnostics previewer=false <CR>"
)

vim.wo.wrap = false
vim.o.background = "dark"
vim.cmd.colorscheme "mellifluous"

local lsp = require("lsp-zero")
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr}) end)

require("mason-lspconfig").setup({
  handlers = {
    lsp.default_setup,
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  })
})

