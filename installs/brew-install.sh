#!/usr/bin/env bash

# from https://brew.sh/ ...
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install the files
brew bundle install

# startup services
brew services start atuin
brew services start felixkratz/formulae/sketchybar

# rust binaries
# ~/.cargo/binstall.toml
cargo-binstall bat
# xh - like HTTPie : https://github.com/ducaale/xh
cargo-binstall xh
# eza - a better ls experience? : https://github.com/eza-community/eza
cargo-binstall eza
