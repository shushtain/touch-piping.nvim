-- this stuff will be executed at plugin load time

if vim.g.loaded_infloop == 1 then
	return
end

vim.g.loaded_infloop = 1

-- user commands

vim.api.nvim_create_user_command("InfloopStart", function()
	require("infloop").start()
end, {})
