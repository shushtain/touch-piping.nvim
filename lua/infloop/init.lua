local config = require("infloop.config")
local utils = require("infloop.utils")
local M = {}

M.start = function()
	utils.new_window({
		content = utils.generate_content(utils.generate_grid({ 24, 12 })),
	})
end

M.setup = function(options)
	config.__setup(options)
end

return M
