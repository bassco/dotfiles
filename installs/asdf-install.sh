#!/usr/bin/env bash

# If asdf is not installed by brew... then do this manually
#ASDF_DIR=~/.asdf
#git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" \
#	&& git -C "$ASDF_DIR" checkout $(git -C "$ASDF_DIR" describe --abbrev=0 --tags)
#source $ASDF_DIR/asdf.sh

# the plugins can be dumped with the following command
# asdf plugin list

asdf plugin add golang
asdf install golang latest
asdf global golang latest

asdf plugin add nodejs
asdf install nodejs lts
asdf global nodejs lts

asdf plugin add rust
asdf install rust nightly
asdf install rust 1.74.0
asdf global rust 1.74.0
