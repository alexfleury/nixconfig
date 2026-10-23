{
  lib,
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
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = 1.0;
          cm = "auto";
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
