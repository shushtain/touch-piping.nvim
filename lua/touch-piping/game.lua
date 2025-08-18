local M = {}

M.new = function(opts)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].readonly = true

  vim.b[buf].touch_piping = opts
  local plugin = vim.g.touch_piping
  plugin.buf = buf
  vim.g.touch_piping = plugin

  M.gen()

  local state = vim.b[buf].touch_piping
  state.success = false

  vim.cmd("hi TouchPipingSuccess ctermfg=11 guifg=#89E6F4")
  state.namespace = vim.api.nvim_create_namespace("touch_piping_highlights")

  vim.b[buf].touch_piping = state
  M.draw()

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = (vim.o.lines - #state.weights.task - 4) / 2,
    col = (vim.o.columns - #state.weights.task[1]) / 2,
    width = #state.weights.task[1],
    height = #state.weights.task,
    border = state.no_border and "solid" or state.style,
    style = "minimal",
    focusable = true,
    noautocmd = true,
  })

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
  vim.wo[win].scrolloff = 0
  vim.wo[win].sidescrolloff = 0
  vim.bo[buf].modifiable = false

  state.win = win
  vim.b[buf].touch_piping = state

  vim.keymap.set("n", opts.keymaps.rotate_clockwise, function()
    M.rotate(true)
  end, { buffer = buf, desc = "Rotate Clockwise" })

  vim.keymap.set("n", opts.keymaps.rotate_reverse, function()
    M.rotate(false)
  end, { buffer = buf, desc = "Rotate Reverse" })

  vim.keymap.set("n", opts.keymaps.quit, function()
    vim.cmd("close")
  end, { buffer = buf, desc = "Quit" })
end

M.gen = function()
  local utils = require("touch-piping.utils")

  local buf = vim.g.touch_piping.buf
  local state = vim.b[buf].touch_piping

  local width = state.size[1] * 1
  local height = state.size[2] + 2

  local grid = {}
  for y = 1, height do
    grid[y] = {}
    for x = 1, width do
      if (y == 1) or (y == height) or (x == 1) or (x == width) then
        grid[y][x] = 0
      else
        grid[y][x] = math.random(1, 3) % 2
      end
    end
  end

  local solution = {}
  local task = {}
  for y, _ in ipairs(grid) do
    solution[y] = {}
    task[y] = {}
    for x, _ in ipairs(grid[y]) do
      if y == 1 or y == #grid or x == 1 or x == #grid[y] or grid[y][x] == 0 then
        solution[y][x] = 16
        task[y][x] = 16
      else
        local total = grid[y - 1][x]
          + grid[y][x + 1] * 2
          + grid[y + 1][x] * 4
          + grid[y][x - 1] * 8
        solution[y][x] = total
        local rnd = math.random(1, #utils.logic[total].group)
        local alt = utils.logic[total].group[rnd]
        task[y][x] = alt
      end
    end
  end

  table.remove(solution, 1)
  table.remove(solution, #solution)
  table.remove(task, 1)
  table.remove(task, #task)

  state.weights = { solution = solution, task = task }
  vim.b[buf].touch_piping = state
end

M.draw = function()
  local utils = require("touch-piping.utils")

  local buf = vim.g.touch_piping.buf
  local state = vim.b[buf].touch_piping

  vim.bo[buf].readonly = false
  vim.bo[buf].modifiable = true

  local lines = {}
  for y, _ in ipairs(state.weights.task) do
    local line = {}
    for x, _ in ipairs(state.weights.task[y]) do
      local weight = state.weights.task[y][x]
      line[x] = utils.symbols[state.style][weight]
    end
    lines[y] = table.concat(line)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if state.success then
    state.extmark = vim.api.nvim_buf_set_extmark(buf, state.namespace, 0, 0, {
      id = state.extmark or nil,
      end_row = #state.weights.task,
      hl_eol = true,
      hl_group = state.highlights.success or "TouchPipingSuccess",
    })
    if not state.no_border then
      vim.api.nvim_win_set_config(
        state.win,
        { title = " ✓ ", title_pos = "center" }
      )
    end
  else
    state.extmark = vim.api.nvim_buf_set_extmark(buf, state.namespace, 0, 0, {
      id = state.extmark or nil,
      end_row = #state.weights.task,
      hl_eol = true,
      hl_group = state.highlights.default or "Normal",
    })
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  vim.b[buf].touch_piping = state
end

M.rotate = function(clockwise)
  local utils = require("touch-piping.utils")

  local buf = vim.g.touch_piping.buf
  local state = vim.b[buf].touch_piping

  local cursor = vim.fn.getcursorcharpos(0)
  local line = cursor[2]
  local col = cursor[3]

  local current_char = state.weights.task[line][col]
  local new_char = clockwise and utils.logic[current_char].next
    or utils.logic[current_char].prev

  state.weights.task[line][col] = new_char
  vim.b[buf].touch_piping = state

  M.check()
  M.draw()
end

M.check = function()
  local buf = vim.g.touch_piping.buf
  local state = vim.b[buf].touch_piping

  for y, _ in ipairs(state.weights.task) do
    for x, _ in ipairs(state.weights.task[y]) do
      if state.weights.task[y][x] ~= state.weights.solution[y][x] then
        return false
      end
    end
  end

  vim.keymap.set("n", state.keymaps.rotate_clockwise, "<Nop>", { buffer = buf })
  vim.keymap.set("n", state.keymaps.rotate_reverse, "<Nop>", { buffer = buf })

  state.success = true
  vim.b[buf].touch_piping = state
end

return M
