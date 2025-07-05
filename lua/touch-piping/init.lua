local config = require("touch-piping.config")
local game = require("touch-piping.game")
local utils = require("touch-piping.utils")
local M = {}

M.start = function(opts)
  local options =
    vim.tbl_deep_extend("force", {}, config.options, { size = opts } or {})
  game.new_window(options)
end

M.setup = function(opts)
  config.__setup(opts)
end

return M
