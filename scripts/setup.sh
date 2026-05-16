#!/usr/bin/env bash

# Install Nix package manager if not already installed
if command -v nix &>/dev/null; then
  echo "Nix is already installed: $(nix --version)"
else
  echo "Nix not found. Installing..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

  # Enable Nix Experimental features
  mkdir -p "$HOME/.config/nix"
  echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"
  echo "Nix installation complete."
fi
