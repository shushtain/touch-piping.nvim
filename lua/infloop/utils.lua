local M = {}

M.new_window = function(params)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].readonly = true

	local content = {}
	for i = 1, #params.content do
		content[i] = table.concat(params.content[i])
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	local win_id = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = math.floor((vim.o.lines - #params.content[1]) / 2),
		col = math.floor((vim.o.columns - #params.content) / 2),
		width = #params.content[1],
		height = #params.content,
		border = "rounded",
		style = "minimal",
		focusable = true,
		noautocmd = true,
	})

	vim.wo[win_id].number = false
	vim.wo[win_id].relativenumber = false
	vim.wo[win_id].wrap = false
	vim.wo[win_id].scrolloff = 0
	vim.wo[win_id].sidescrolloff = 0
	vim.bo[buf].modifiable = false

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "r", function()
		M.rotate_cell({ buf = buf, content = params.content })
	end, { buffer = buf, noremap = true, silent = true })

	return win_id
end

M.rotate_cell = function(params)
	local buf = params.buf
	vim.bo[buf].modifiable = true

	local cursor_pos = vim.fn.getcursorcharpos(0)
	local cursor_pos_bytes = vim.api.nvim_win_get_cursor(0)
	print(table.concat(cursor_pos, ", "))
	local line = cursor_pos[2]
	local col = cursor_pos[3]
	local col_bytes = cursor_pos_bytes[2]

	local current_char = params.content[line][col]
	local new_char = current_char

	if current_char == "╹" then
		new_char = "╺"
	elseif current_char == "╺" then
		new_char = "╻"
	elseif current_char == "┗" then
		new_char = "┏"
	elseif current_char == "╻" then
		new_char = "╸"
	elseif current_char == "┃" then
		new_char = "━"
	elseif current_char == "┏" then
		new_char = "┓"
	elseif current_char == "┣" then
		new_char = "┳"
	elseif current_char == "╸" then
		new_char = "╹"
	elseif current_char == "┛" then
		new_char = "┗"
	elseif current_char == "━" then
		new_char = "┃"
	elseif current_char == "┻" then
		new_char = "┣"
	elseif current_char == "┓" then
		new_char = "┛"
	elseif current_char == "┫" then
		new_char = "┻"
	elseif current_char == "┳" then
		new_char = "┫"
	end

	if new_char ~= current_char then
		local new_line = params.content[line]
		new_line[col] = new_char
		local new_line_str = table.concat(new_line)
		vim.api.nvim_buf_set_lines(buf, line - 1, line, false, { new_line_str })
	end

	vim.bo[buf].modifiable = false
	vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { line, col_bytes })
end

M.generate_content = function(grid)
	local content = {}
	for y, _ in ipairs(grid) do
		content[y] = {}
		for x, _ in ipairs(grid[y]) do
			if y == 1 or y == #grid or x == 1 or x == #grid[y] or grid[y][x] == 0 then
				content[y][x] = " "
			else
				local total = grid[y - 1][x] + grid[y][x + 1] * 2 + grid[y + 1][x] * 4 + grid[y][x - 1] * 8
				if total == 0 then
					content[y][x] = "∙"
				elseif total == 1 then
					content[y][x] = "╹"
				elseif total == 2 then
					content[y][x] = "╺"
				elseif total == 3 then
					content[y][x] = "┗"
				elseif total == 4 then
					content[y][x] = "╻"
				elseif total == 5 then
					content[y][x] = "┃"
				elseif total == 6 then
					content[y][x] = "┏"
				elseif total == 7 then
					content[y][x] = "┣"
				elseif total == 8 then
					content[y][x] = "╸"
				elseif total == 9 then
					content[y][x] = "┛"
				elseif total == 10 then
					content[y][x] = "━"
				elseif total == 11 then
					content[y][x] = "┻"
				elseif total == 12 then
					content[y][x] = "┓"
				elseif total == 13 then
					content[y][x] = "┫"
				elseif total == 14 then
					content[y][x] = "┳"
				elseif total == 15 then
					content[y][x] = "╋"
				end
			end
		end
	end
	return content
end

M.generate_grid = function(size)
	local grid = {}
	for y = 1, size[2] do
		grid[y] = {}
		for x = 1, size[1] do
			if y == 1 or y == size[2] or x == 1 or x == size[1] then
				grid[y][x] = 0
			else
				grid[y][x] = math.random(1, 3) % 2
			end
		end
	end
	return grid
end

return M
