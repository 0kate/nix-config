REBUILD_CMD := sudo nixos-rebuild switch --flake

vm-x86_64.rebuild:
	$(REBUILD_CMD) '.#vm-x86_64'

wsl.rebuild:
	$(REBUILD_CMD) '.#wsl'
