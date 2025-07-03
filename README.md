# Spectrolite

Converter for RGB-based color spaces.

> Polished spectrolite lets the colors play.  
> Please polish this plugin.

## Features

- Converts between HEX, RGB, HSL, and Cubehelix color spaces.
- Supports alpha channels for all the color spaces listed above.
- Has options to format lowercase HEX, round HSL and Cubehelix.

> For more information about the Cubehelix color space, look for [Dave Green's Cubehelix](https://people.phy.cam.ac.uk/dag9/CUBEHELIX/#Paper). The specific implementation of Cubehelix for this plugin is described below.

## Config

Here is my config using Lazy:

```lua
return {
  "shushtain/spectrolite.nvim",
  config = function()
    require("spectrolite").setup({
      lower_hex = false,
      round_hsl = true,
      round_hxl = true,
    })
    vim.keymap.set({ "n", "v" }, "<leader>#h", "<cmd> SpectroliteHex <CR>")
    vim.keymap.set({ "n", "v" }, "<leader>#r", "<cmd> SpectroliteRgb <CR>")
    vim.keymap.set({ "n", "v" }, "<leader>#s", "<cmd> SpectroliteHsl <CR>")
    vim.keymap.set({ "n", "v" }, "<leader>#x", "<cmd> SpectroliteHxl <CR>")
  end
}
```

Defaults are:

- `lower_hex = false`
- `round_hsl = true`
- `round_hxl = true`

No keymaps are set internally.

> I've switched to Neovim quite recently. For the lack of skill, I don't have an example for setting up Packer.

## Cubehelix?

Cubehelix colors, in modern terms, are described by `hue`, `saturation`, and `lightness`. Although max `saturation` for some colors can be close to `500%`, the real value of this color space lies in colors with `saturation` up to `100%`. As long as you are within this range, colors of any `hue` keep constant _(accessibility)_ contrast between their `lightness` values.

> Since the name of this color space is much longer, and the `saturation` values are quite different from both HSL and (ok)LCH, I've chosen to specify it as `hxl`.

![Color spaces](https://raw.githubusercontent.com/shushtain/spectrolite.nvim/refs/heads/main/example1.jpg)

For example, a button with the background of `(240, 100%, 30%)` and the text of `(240, 100%, 90%)` will measure to the same color accessibility contrast as a button with the background of `(160, 50%, 30%)` and the text of `(160, 100%, 90%)`.

![Example](https://raw.githubusercontent.com/shushtain/spectrolite.nvim/refs/heads/main/example2.jpg)

I typically set `saturation 110%` for signal (error, warning) colors. The clipping (which leads to contrast mutations) is minimal.

## Credits

- [Dave Green's Cubehelix](https://people.phy.cam.ac.uk/dag9/CUBEHELIX/#Paper)
- [NTBBloodbath's Color Converter](https://github.com/NTBBloodbath/color-converter.nvim)

## Contributing

I'm not sure I can handle more Lua for now.  
Just make a flawless version for me to switch to.

> Are you ready to DeepSeek for your life?  
> Good luck! And **don't** fork it up!
