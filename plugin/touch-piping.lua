if vim.g.touch_piping and vim.g.touch_piping.loaded == true then
  return
end

vim.g.touch_piping = { loaded = true }

vim.api.nvim_create_user_command("TouchPipingStart", function(opts)
  if opts.fargs and #opts.fargs == 2 then
    require("touch-piping").start(opts.fargs)
  else
    require("touch-piping").start()
  end
end, { nargs = "*" })
