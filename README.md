
# nixconfig

Personal NixOS and home-manager configurations.

## Description

This repository contains configurations for my personal NixOS and home-manager setup.
It provides a modular and reproducible way to manage my system and user environment using the Nix package manager.

## Structure

The structure is designed to be modular and straightforward:

```
.
├── configuration.nix
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── home.nix
├── LICENSE
├── README.md
├── scripts
│   ├── Scripts (shell, bash, python, etc.)
├── packages
│   ├── Custom Nix derivations
├── user
│   ├── cli
│   │   ├── Command-line interface tools
│   └── desktop
│       ├── Programs with a graphical interface
│       ├── hyprland
│       │   ├── Environment packages used with a Hyprland DE
└── wallpapers
    ├── Wallpapers
```

## Post-installation tweaks

### Steam

Launch a Steam game with HDR enabled.

```shell
DXVK_HDR=1 gamescope -W 3840 -H 2160 -r 240 --mangoapp --hdr-enabled -f -- LD_PRELOAD="" %command%
```

### SSH

SSH keys should be backed up by `borgmatic`.

## TODOs

- Reorganization of the folder for many machines.
- Make better use of `default.nix`.
- Complete *Post-installation tweaks*.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [NixOS](https://nixos.org/)
- [home-manager](https://github.com/nix-community/home-manager)