{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      config = {
        input = {
          kb_layout = "ca";
          kb_variant = "";
          follow_mouse = 2;
        };
      };

      monitor = [
        {
          output = "DP-1";
          mode = "3840x2160@240";
          position = "0x0";
          scale = 1.5;
          bitdepth = 10;
          cm = "hdr";
          sdrbrightness = 1.2;
          sdrsaturation = 1.1;
          vrr = 3;
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.dispatch(hl.dsp.focus({ workspace = 1 }))
              hl.exec_cmd("protonvpn-app")
            end
          '')
        ];
      };
    };
  };
}
