
local M = {}

local win_id = nil
local buf_id = nil

-- Default configuration
local config = {
  options = {"Option 1", "Option 2", "Option 3"},
  on_select = function(option) print("Selected: " .. option) end
}

function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

local function close_window()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  win_id = nil
  buf_id = nil
end

local function create_window()
  -- Create buffer
  buf_id = vim.api.nvim_create_buf(false, true)
  
  -- Add content to buffer
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, config.options)
  
  -- Set keymaps for buffer
  vim.api.nvim_buf_set_keymap(buf_id, 'n', '<CR>', ':lua require("toggle-menu").select()<CR>', {silent = true})
  vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q', ':lua require("toggle-menu").toggle()<CR>', {silent = true})

  -- Window configuration
  local width = 30
  local height = #config.options + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  }

  -- Create window
  win_id = vim.api.nvim_open_win(buf_id, true, opts)
  
  -- Window settings
  vim.wo[win_id].number = false
  vim.wo[win_id].relativenumber = false
  vim.wo[win_id].cursorline = true
end

function M.toggle()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    close_window()
  else
    create_window()
  end
end

function M.select()
  local row = vim.api.nvim_win_get_cursor(win_id)[1]
  local option = config.options[row]
  close_window()
  config.on_select(option)
end

return M
