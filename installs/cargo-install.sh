#!/usr/bin/env bash
#
# rust installs cargo from mise

cargo install --locked cargo-deny && cargo deny init
cargo install nu
cargo install cargo-watch
cargo install zoxide
cargo install fd-find
