require('codecompanion').setup({
  adapters = {
    bedrock = function()
      local region = vim.fn.getenv('AWS_REGION')
      local credsJson = vim.fn.system({ 'aws', 'configure', 'export-credentials', '--profile', 'bedrock' })
      local exitCode = vim.v.shell_error
      if exitCode ~= 0 or region == nil or region == '' then
        return {}
      end

      local creds = vim.json.decode(credsJson, { luanil = { object = true, array = true } })
      local signature = string.format('aws:amz:%s:bedrock', region)
      local profile = string.format('%s:%s', creds.AccessKeyId, creds.SecretAccessKey)

      return require('codecompanion.adapters').extend('anthropic', {
        url = 'https://bedrock-runtime.${region}.amazonaws.com/model/${model}/invoke-with-response-stream',
        env = {
          region = region,
        },
        headers = {
          ['x-amz-security-token'] = creds.SessionToken,
        },
        raw = {
          '--aws-sigv4=${signature}',
          '--user=${profile}',
        },
      })
    end,
    vertex = function()
      return require('codecompanion.adapters').extend('gemini', {
        url = 'https://${region}-aiplatform.googleapis.com/v1/projects/${project_id}/locations/${region}/publishers/google/models',
        env = {
          project_id = 'VERTEXAI_PROJECT',
          region = 'VERTEXAI_LOCATION',
          api_key = 'cmd:gcloud auth application-default print-access-token',
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = 'bedrock',
    },
    inline = {
      adapter = 'bedrock',
    },
    agent = {
      adapter = 'bedrock',
    },
  },
})
