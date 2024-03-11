# NVIM Config

This repository contains personalized configurations for nvim using Lua and NvChad ⚙️🪴

## Configure NVIM Config

Go to the repo directory and use symlink for nvim config

```sh
ln -s . ~/.config/nvim
```

## Setup Neovim

### Setup Requires

- True Color Terminal Like: [iTerm2](https://iterm2.com/)
- [Neovim](https://neovim.io/) (Version 0.9 or Later)
- [Nerd Font](https://www.nerdfonts.com/) - I use Meslo Nerd Font
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - For Telescope Fuzzy Finder
- XCode Command Line Tools

Install Deps with Homebrew:

```sh
brew install --cask iterm2

brew install node vim neovim tree-sitter git fd ripgrep lazygit lua luajit
```

For XCode Command Line Tools do:

```bash
xcode-select --install
```

If you have already installed vim, create a symbolic link to map directly neovim with vim

```sh
ln -s $(which nvim) /opt/homebrew/bin/vim
```

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
