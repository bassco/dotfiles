#!/usr/bin/env bash

# If asdf is not installed by brew... then do this manually
ASDF_DIR=~/.asdf
[ ! -f "${ASDF_DIR}" ] || {
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" \
	&& git -C "$ASDF_DIR" checkout $(git -C "$ASDF_DIR" describe --abbrev=0 --tags);
  source $ASDF_DIR/asdf.sh
}

# the plugins can be dumped with the following command
# asdf plugin list


asdf plugin add crane
asdf plugin add fzf
asdf plugin add golang
asdf plugin add golangci-lint
asdf plugin add gradle
asdf plugin add helm
asdf plugin add helmfile
asdf plugin add java
asdf plugin add just
asdf plugin add kubectl
asdf plugin add kubent
asdf plugin add kustomize
asdf plugin add nodejs
asdf plugin add pluto
asdf plugin add pre-commit
asdf plugin add python
asdf plugin add rust
asdf plugin add sops
asdf plugin add terraform
asdf plugin add terraform-docs
asdf plugin add terragrunt
asdf plugin add tflint
asdf plugin add yq
asdf plugin add zoxide
