{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 1;
          top = 2;
          left = 1;
          bottom = 2;
        };
      };
      display = {
        separator = "  ";
        constants = [
          "─────────────────"
        ];
        key = {
          type = "icon";
          paddingLeft = 2;
        };
      };
      modules = [
        {
          type = "custom";
          format = "┌{$1} {#1}Hardware Information{#} {$1}┐";
        }
        "cpu"
        "gpu"
        "memory"
        "disk"
        {
          type = "custom";
          format = "├{$1} {#1}Software Information{#} {$1}┤";
        }
        "os"
        "kernel"
        "wm"
        "shell"
        "terminal"
        {
          type = "custom";
          format = "└{$1}──────────────────────{$1}┘";
        }
      ];
    };
  };
}
