# Cheameleon.nvim
The idea of this project is to provide a similar functionality to peacock in
vscode.  
Currently, the plugin only supports modifying lualine components' background (`bg`) or foreground (`fg`) color


## Installation

### lazy
Currently I'm using lazy but the implementation for other package managers is
similar
```lua
{ 
  "JulianH99/chameleon.nvim", 
  dependencies = { "nvim-lualine/lualine.nvim" },
}
```

### Configuration
Default options are

```lua
require("chameleon").setup({
  config_path = vim.fs.normalize(vim.fn.stdpath("data") .. "\\chameleon.json"),
  lualine = {
    { 
      section = "c", -- lualine section letter
      component_index = 1, -- beware lua is 1-indexed
      change = "fg", -- or bg to change background 
    },
  },
})
```
You can change this options as you like and specify as many components as you
want

## Usage

### Picking a color

There's a builtin command called `:ChamPickColor`, which will open a `vim.ui.input`
for you to pick a color, and, upon picking it, you will see your changes in your
lualine configuration.  
Alternatively, you can create a keymap or use the lua function directly by
calling `require("chameleon").pick_color()`  
The color will be tied to your `cwd` (`vim.loop.cwd()`) and will be
automatically saved on the plugin's config file.

### Erasing the confgiguration
There's also a command to clear all the saved colors and empty the configuration 
file. The command `:ChamClearConfig` will clean the config file and get rid
of all customizations (another command to clear only the current working dir's
config is planned).


## TODO
- Select automatic foreground color when background color option is used.
