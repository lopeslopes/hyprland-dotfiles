local lsp = require('lsp-zero').preset({})

lsp.set_preferences({
	sign_icons = {  }
})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pylint = {
                    args = {'--ignore=E501,E231,E226', '-'}
                },
                pycodestyle={
                    enabled=true,
                    ignore={'E501', 'E231', 'E226'},
                    maxLineLength=120
                }
            }
        }
    }
})


lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<Tab>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
  }
})
