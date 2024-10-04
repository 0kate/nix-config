return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "release",
  opts = {
    show_help = "yes",         -- Show help text for CopilotChatInPlace, default: yes
    debug = false,             -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
    disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
    -- language = "English" -- Copilot answer language settings when using default prompts. Default language is English.
    -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
    -- temperature = 0.1,
  },
  build = function()
    vim.notify("Please update the remote plugins by running \":UpdateRemotePlugins\", then restart Neovim.")
  end,
  event = "VeryLazy",
  lazy = false,
}
