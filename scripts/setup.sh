#!/usr/bin/env bash

# Install Nix package manager
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# Enable Nix Experimental features
echo 'experimental-features = nix-command flakes' >> $HOME/.config/nix/nix.conf
