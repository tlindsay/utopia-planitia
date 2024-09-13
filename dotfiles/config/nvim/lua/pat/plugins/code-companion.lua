require('codecompanion').setup({
  adapters = {
    ollama = 'ollama',
  },
  strategies = {
    chat = {
      adapter = 'ollama',
    },
    inline = {
      adapter = 'ollama',
    },
    agent = {
      adapter = 'ollama',
    },
  },
})
