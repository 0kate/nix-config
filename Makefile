REBUILD_CMD := sudo nixos-rebuild switch --flake

vm-interl.rebuild:
	$(REBUILD_CMD) '.#vm-intel'

wsl.rebuild:
	$(REBUILD_CMD) '.#wsl'
