#!/usr/bin/env bash

set -e

nix run home-manager/master -- news --flake .#okate
