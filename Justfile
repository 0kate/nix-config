machine := ""
_rebuild-cmd := "sudo nixos-rebuild switch --flake"

alias rb := rebuild
rebuild:
    {{_rebuild-cmd}} ".#{{machine}}"


workstation := ""
_device := if workstation == "laptop" {
    "/dev/nvme0n1"
} else {
    "/dev/sda"
}
_partition-prefix := if workstation == "laptop" { "p" } else { "" }

bootstrap0:
	parted {{_device}} -- mklabel gpt; \
		parted {{_device}} -- mkpart primary 512MB -8GB; \
		parted {{_device}} -- mkpart primary linux-swap -8GB 100\%; \
		parted {{_device}} -- mkpart ESP fat32 1MB 512MB; \
		parted {{_device}} -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos {{_device}}{{_partition-prefix}}1; \
		mkswap -L swap {{_device}}{{_partition-prefix}}2; \
		mkfs.fat -F 32 -n boot {{_device}}{{_partition-prefix}}3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
			networking.wireless.enable = true;\n \
			networking.wireless.userControlled.enable = true;\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd && reboot;
