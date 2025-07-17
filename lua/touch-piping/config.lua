---@diagnostic disable: inject-field

---@class TouchPiping.Config
---@field size? table {<columns>, <rows>}
---@field style? string rounded | single | bold | double
---@field highlights? Highlights Highlight styles for the game elements
---@field keymaps? Keymaps Key bindings local to the game buffer

---@class Highlights
---@field default? string Defaults to `Normal`
---@field success? string Defaults to `TouchPipingSuccess`

---@class Keymaps
---@field rotate_clockwise? string Any valid keymap. Defaults to `r`
---@field rotate_reverse? string Any valid keymap. Defaults to `R`
---@field quit? string Any valid keymap. Defaults to `q` to match other plugins. Change to something that is harder to hit by accident

---@type TouchPiping.Config
local M = {}

M.defaults = {
  size = { 18, 6 },
  style = "rounded",
  highlights = {
    default = "Normal",
    success = "TouchPipingSuccess",
  },
  keymaps = {
    rotate_clockwise = "r",
    rotate_reverse = "R",
    quit = "q",
  },
}

M.options = {}

M.__setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
