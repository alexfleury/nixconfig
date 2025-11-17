```
       .__                            _____.__
  ____ |__|__  ___ ____  ____   _____/ ____\__| ____
 /    \|  \  \/  // ___\/  _ \ /    \   __\|  |/ ___\
|   |  \  |>    <\  \__(  <_> )   |  \  |  |  / /_/  >
|___|  /__/__/\_ \\___  >____/|___|  /__|  |__\___  /
     \/         \/    \/           \/        /_____/
```

My personal NixOS and home-manager configurations.


## Description

This repository contains configurations for my personal NixOS and home-manager setup.
It provides a modular and reproducible way to manage my system and user environment using the Nix package manager.

## Structure

The structure is designed to be modular, and it based on https://code.m3ta.dev/m3tam3re/nixcfg.

```shell
.
├── flake.lock
├── flake.nix
├── home
│   ├── username
│   │   └── hostname.nix
│   ├── common
│   │   └── default.nix
│   └── features
│       ├── cli
│       └── desktop
├── hosts
│   ├── common
│   │   ├── default.nix
│   │   ├── modules
│   │   └── users
│   └── hostname
│       ├── configuration.nix
│       ├── default.nix
│       └── hardware-configuration.nix
├── LICENSE
├── overlays
│   └── # Nix overlays...
├── packages
│   └── # Custom packages...
├── README.md
├── scripts
│   └── # Custom scripts.
├── secrets
└── wallpapers
    └── # Image files...
```


## Post-installation tweaks

### Steam

- Enabling mangohud in steam requires to change the start command.

```shell
mangohud %command%
```

- Way to launch a Steam game with gamescope,

```shell
LD_PRELOAD="" gamescope -W 3840 -H 2160 -r 240 --mangoapp -f -- %command%
```

- Same but with HDR enabled.

```shell
DXVK_HDR=1 LD_PRELOAD="" gamescope -W 3840 -H 2160 -r 240 --mangoapp --hdr-enabled -f -- %command%
```

### CSS

Many CSS properties for styling can be found at https://docs.gtk.org/gtk4/css-properties.html.

### Wallpaper repos

- https://github.com/dharmx/walls
- https://github.com/dracula/wallpaper

### Desktop files

They can be found in these directories:

- `/run/current-system/sw/share/applications`
- `$HOME/.local/state/nix/profiles/profile/share/applications`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [NixOS](https://nixos.org/)
- [home-manager](https://github.com/nix-community/home-manager)
- [@m3tam3re](https://www.youtube.com/@m3tam3re) on Youtube for the template.