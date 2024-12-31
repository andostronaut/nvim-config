# NVIM Config

This repository contains personalized configurations for nvim using Lua and NvChad ⚙️🪴

## Configure NVIM Config

Go to the repo directory and use symlink for nvim config

```sh
ln -s . ~/.config/nvim
```

## Setup Neovim

### Setup Requires

- True Color Terminal Like: [iTerm2](https://iterm2.com/), [Ghostty](https://ghostty.org), [KiTTY](https://9bis.net/kitty)
- [Neovim](https://neovim.io/) (Version 0.9 or Later)
- [Nerd Font](https://www.nerdfonts.com/) - I use Meslo Nerd Font
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - For Telescope Fuzzy Finder
- XCode Command Line Tools

Install Deps with Homebrew:

```sh
brew install node vim neovim tree-sitter git fd ripgrep lazygit lua luajit
```

### Install Mason Plugins

Install Mason binaries on running this command `Mason` and tools with this command `MasonToolsInstall`

### Setup Go on Neovim

Install binaries on running this command `GoInstallBinaries`

## Uninstall nvim

```sh
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Windows
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data
```

## License

[MIT](LICENSE)
