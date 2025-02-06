
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

## TODOs

- Reorganization of the folder.
- Make better use of `default.nix`.
- `user/desktop/grimdawn.nix`: Configure GD-Stash (java app) for Grim Dawn.
- `user/desktop/dracula.nix`:

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [NixOS](https://nixos.org/)
- [home-manager](https://github.com/nix-community/home-manager)