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
