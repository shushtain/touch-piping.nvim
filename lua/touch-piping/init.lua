local M = {}

function M.start(opts)
  local config = vim.tbl_deep_extend(
    "force",
    require("touch-piping.config").config,
    opts or {}
  )
  require("touch-piping.game").new(config)
end

---Override default configuration.
---@param opts? TouchPiping.Config
function M.setup(opts)
  require("touch-piping.config").setup(opts)
end

return M
