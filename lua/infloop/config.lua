local M = {}

M.defaults = {
	size = { 16, 16 },
}

M.options = {}

M.__setup = function(options)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
