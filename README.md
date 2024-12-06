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
    dark_fg = '#fff',
    light_fg = '#222'
})
```
You can change this options as you like and specify as many components as you
want.
By default, chameleon will pick a dark or light foreground color when you pick
the bg option for a component, these colors will be picked from the `dark_fg`
and `light_fg` options in the configuration 

## Usage

### Picking a color

There's a builtin command called `:ChamPickColor`, which will open a `vim.ui.input`
for you to pick a color, and, upon picking it, you will see your changes in your
lualine configuration.  
Alternatively, you can create a keymap or use the lua function directly by
calling `require("chameleon").pick_color()`  
The color will be tied to your `cwd` (`vim.loop.cwd()`) and will be
automatically saved on the plugin's config file.

> [!important] 
> At the moment, only complete hex colors are accepted (e.g #558866). The short
> syntax is not supported yet

### Clearing the color for cwd
You can remove the configured color for the current project or cwd with the
`:ChamClearCwd` command.

### Erasing the confgiguration
There's also a command to clear all the saved colors and empty the configuration 
file. The command `:ChamClearConfig` will clean the config file and get rid
of all customizations (another command to clear only the current working dir's
config is planned).

### Summary

- `:ChamPickColor` - Pick a hex color for current cwd
- `:ChamClearCwd` - Remove the picked color for currend cwd
- `:ChamClearConfig` - Remove all configuration for all registered cwds

## TODO
- [x] Select automatic foreground color when background color option is used.
- [x] Command to clear current cwd color configuration
- [x] Use plenary.nvim for file operations
- [ ] Allow for different fg and bg colors per cwd (right now it uses the same
color for whatever section was configured in the `lualine` config section
