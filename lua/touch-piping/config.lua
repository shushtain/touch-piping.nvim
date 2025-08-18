---@class TouchPiping.Config
---@field no_border? boolean If `true`, disable window border. Default is `false`
---@field size? table Game size as {<cols>, <rows>}
---@field style? TouchPiping.Config.Style Style of elements
---@field highlights? TouchPiping.Config.Highlights Highlighting for game elements
---@field keymaps? TouchPiping.Config.Keymaps Key bindings local to the game buffer

---@class TouchPiping.Config.Highlights
---@field default? string Default is `Normal`
---@field success? string Default is `TouchPipingSuccess`

---@class TouchPiping.Config.Keymaps
---@field rotate_clockwise? string Any valid keymap. Default is `r`
---@field rotate_reverse? string Any valid keymap. Default is `R`
---@field quit? string Any valid keymap. Default is `q`

---@alias TouchPiping.Config.Style
---| "rounded" ╭┼┼┼╯
---| "single"  ┌┼┼┼┘
---| "bold"    ┏╋╋╋┛
---| "double"  ╔╬╬╬╝

local M = {}

---@type TouchPiping.Config
M.config = {
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

---@param opts? TouchPiping.Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
