{
  lib,
  ...
}:
let
  mkLuaInline = lib.generators.mkLuaInline;
  mkArgs = args: { _args = args; };
  bind =
    keys: dispatcher: options:
    mkArgs [
      keys
      dispatcher
      options
    ];
  dsp.exec_cmd = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
in
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

      bind =  [
        (bind "code:107" (dsp.exec_cmd "noctalia msg screenshot-region") { })
      ];

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("protonvpn-app")
            end
          '')
        ];
      };
    };
  };
}
