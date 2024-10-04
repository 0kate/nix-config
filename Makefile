REBUILD_CMD := sudo nixos-rebuild switch --flake

test-vm.rebuild:
	$(REBUILD_CMD) '.#test-vm'

wsl.rebuild:
	$(REBUILD_CMD) '.#wsl'
