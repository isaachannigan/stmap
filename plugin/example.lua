
-- For Lua configuration
local toggle_menu = require('toggle-menu')

toggle_menu.setup({
  options = {
    "Open terminal",
    "Run current file",
    "Check syntax",
    "Quit Neovim"
  },
  on_select = function(option)
    if option == "Open terminal" then
      vim.cmd("terminal")
    elseif option == "Run current file" then
      vim.cmd("!%:p")
    elseif option == "Check syntax" then
      vim.cmd("syntax on | checktime")
    elseif option == "Quit Neovim" then
      vim.cmd("qa!")
    end
  end
})

vim.keymap.set('n', '<leader>mm', toggle_menu.toggle, {noremap = true, silent = true})
