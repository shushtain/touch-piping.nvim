if vim.g.touch_piping then
  return
end

vim.g.touch_piping = {}

vim.api.nvim_create_user_command("TouchPipingStart", function(cmd)
  if cmd.fargs and #cmd.fargs == 2 then
    require("touch-piping").start({ size = cmd.fargs })
  else
    require("touch-piping").start()
  end
end, { nargs = "*" })
