local jq = require("jq")
local defaults = require('jq.config').setup()
jq.setup(defaults)

vim.api.nvim_create_user_command('Jq', function()
  jq.run({ commands = defaults.commands })
end)
vim.api.nvim_create_user_command('Yq', function()
  jq.run({ commands = vim.fn.reverse(defaults.commands) })
end)
