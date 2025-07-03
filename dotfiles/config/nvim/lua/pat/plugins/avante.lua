---@module 'avante'
---@type avante.Config
---@diagnostic disable-next-line: missing-fields
require('avante').setup({
  provider = 'bedrock',
  providers = {
    bedrock = {
      api_key_name = {},
      model = vim.env['ANTHROPIC_MODEL'],
      aws_profile = vim.env['AWS_PROFILE'],
      aws_region = vim.env['AWS_REGION'] or 'us-east-2',
    },
    ['bedrock-fast'] = {
      __inherited_from = 'bedrock',
      model = vim.env['ANTHROPIC_SMALL_FAST_MODEL'],
    },
    vertex = {
      model = vim.env['VERTEX_MODEL'],
    },
    ['vertex-fast'] = {
      __inherited_from = 'vertex',
      model = vim.env['VERTEX_SMALL_FAST_MODEL'],
    },
  },
  input = { provider = 'snacks' },
  selector = { provider = 'snacks' },
})
