# Touch Piping for Neovim

A simple game where you can practice navigating the buffer by fixing broken pipes.

![Example](https://raw.githubusercontent.com/shushtain/touch-piping.nvim/refs/heads/main/example.png)

## Setup

### Lazy

Provided values are the defaults:

```lua
return {
  "shushtain/touch-piping.nvim",
  config = function()
    require("touch-piping").setup({
      --- Grid size: { cols, rows }
      size = { 18, 6 },
      --- Style: rounded | single | bold | double
      style = "rounded",
      --- Highlight groups
      highlights = {
        default = "Normal",
        success = "TouchPipingSuccess",
      }
      --- Keymaps (local to the game)
      keymaps = {
        -- these must be valid vim keymaps
        rotate_clockwise = "r",
        rotate_reverse = "R",
        -- this can be changed or set to false
        -- if often quitting by accident
        quit = "q",
      },
    })
  end
}
```

## Usage

Just invoke a command:

```vim
:TouchPipingStart
```

Or provide size overrides:

```vim
:TouchPipingStart 24 8
```

## Considerations

- Make sure you know how to quit a window in a regular way before playing.
- Tasks are generated randomly, so there is a small chance of an empty task.
- Use at least 5 columns and 3 rows to get something playable.
- Style `double` has the best shapes, but needs bigger font size.
