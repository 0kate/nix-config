REBUILD_CMD := sudo nixos-rebuild switch --flake

test-vm.rebuild:
	$(REBUILD_CMD) '.#test-vm'

wsl.rebuild:
	$(REBUILD_CMD) '.#wsl'

mise.install:
	nix-shell --extra-experimental-features flakes \
		-p gcc \
		-p zlib \
		-p libffi \
		-p openssl \
		-p libyaml \
		-p python3 \
		--run "mise install"
