{ config, pkgs, pkgs-unstable, ... }:
{
  wayland.windowManager.sway =
    let
      wallpaper = builtins.fetchurl {
        url = "https://4kwallpapers.com/images/wallpapers/macos-monterey-wwdc-21-stock-dark-mode-5k-5120x2880-5585.jpg";
        sha256 = "01vfimsvbsg2prm77ziispqmd7l7dkslxb043ajwhi6vajja7mq3";
      };
      cfg = config.wayland.windowManager.sway.config;
      modeScreenshot = "󰄄  (r) region (s) screen";
      colors = {
        text = "#cccccc";
        indicator = "#cccccc";
      };
    in
    {
      enable = true;
      package = pkgs-unstable.swayfx;
      /* while swayfx is broken, remove the following extra config options: */
      /* corner_radius 4 */
      /* blur enable */
      extraConfig = ''
        for_window [app_id="floating_shell"] floating enable, border pixel 1, sticky enable
        for_window [title="dmenu"] floating enable, border pixel 1, sticky enable
        workspace 1
        exec firefox
        exec alacritty
      '';
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "${pkgs.wofi}/bin/wofi --show=drun";
        output = {
          "*" = {
            bg = "${wallpaper} fill";
          };
          "DP-1" = {
            pos = "0 0";
            scale = "1.8";
            mode = "3840x2160";
          };
          "HDMI-A-1" = {
            pos = "0 0";
          };
        };
        gaps = {
          inner = 6;
          smartBorders = "off";
        };
        fonts.names = [ "JetBrainsMono Nerd Font" "Roboto Mono" "sans-serif" ];
        window = {
          /* titlebar = false; */
          border = 1;
        };
        floating = {
          /* titlebar = false; */
          border = 1;
        };
        colors = {
          focused = {
            border = "#420d52";
            background = "#5e1b72";
            text = colors.text;
            indicator = colors.indicator;
            childBorder = "#4b115c";
          };
          focusedInactive = {
            border = "#7e5f87";
            background = "#7e5f87";
            text = colors.text;
            indicator = colors.indicator;
            childBorder = "#7e5f87";
          };
          unfocused = {
            border = "#444444";
            background = "#222222";
            text = colors.text;
            indicator = colors.indicator;
            childBorder = "#444444";
          };
          urgent = {
            border = "#420d52";
            background = "#5e1b72";
            text = colors.text;
            indicator = colors.indicator;
            childBorder = "#420d52";
          };
        };
        bars = [ ]; # managed as systemd user unit
        input = {
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:keyboard" = {
            xkb_layout = "de";
          };
        };
        keybindings = {
          # Basics
          "${cfg.modifier}+t" = "exec ${cfg.terminal}";
          "${cfg.modifier}+q" = "kill";
          "${cfg.modifier}+space" = "exec ${cfg.menu}";
          "${cfg.modifier}+Control+r" = "reload";

          # Focus
          "${cfg.modifier}+${cfg.left}" = "focus left";
          "${cfg.modifier}+${cfg.right}" = "focus right";
          "${cfg.modifier}+Left" = "focus left";
          "${cfg.modifier}+Right" = "focus right";

          "${cfg.modifier}+tab" = "workspace back_and_forth";

          # Moving
          "${cfg.modifier}+Shift+${cfg.left}" = "move left";
          "${cfg.modifier}+Shift+${cfg.right}" = "move right";
          "${cfg.modifier}+Shift+Left" = "move left";
          "${cfg.modifier}+Shift+Right" = "move right";

          # Workspaces
          "${cfg.modifier}+1" = "workspace number 1";
          "${cfg.modifier}+2" = "workspace number 2";
          "${cfg.modifier}+3" = "workspace number 3";
          "${cfg.modifier}+4" = "workspace number 4";
          "${cfg.modifier}+5" = "workspace number 5";
          "${cfg.modifier}+6" = "workspace number 6";
          "${cfg.modifier}+7" = "workspace number 7";
          "${cfg.modifier}+8" = "workspace number 8";
          "${cfg.modifier}+9" = "workspace number 9";
          "${cfg.modifier}+0" = "workspace number 10";

          "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
          "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
          "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
          "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
          "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
          "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
          "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
          "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
          "${cfg.modifier}+Shift+9" = "move container to workspace number 9";
          "${cfg.modifier}+Shift+0" = "move container to workspace number 10";

          # Moving workspaces between outputs
          "${cfg.modifier}+Control+${cfg.left}" = "move workspace to output left";
          "${cfg.modifier}+Control+${cfg.down}" = "move workspace to output down";
          "${cfg.modifier}+Control+${cfg.up}" = "move workspace to output up";
          "${cfg.modifier}+Control+${cfg.right}" = "move workspace to output right";

          "${cfg.modifier}+Control+Left" = "move workspace to output left";
          "${cfg.modifier}+Control+Down" = "move workspace to output down";
          "${cfg.modifier}+Control+Up" = "move workspace to output up";
          "${cfg.modifier}+Control+Right" = "move workspace to output right";

          # Layouts
          "${cfg.modifier}+w" = "layout tabbed";
          "${cfg.modifier}+f" = "fullscreen toggle";

          # screen lock
          "${cfg.modifier}+Shift+Space" = "exec ${pkgs.swaylock}/bin/swaylock && ${pkgs.swayfx}/bin/swaymsg mode default";

          # Screenshot mode
          "Print" = "mode \"${modeScreenshot}\"";
          "${cfg.modifier}+Shift+s" = "mode \"${modeScreenshot}\"";

          # Multimedia Keys
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        };
        modes = {
          "${modeScreenshot}" = {
            "r" = "exec ${pkgs.swayfx}/bin/swaymsg mode default && ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
            "s" = "exec ${pkgs.swayfx}/bin/swaymsg mode default && ${pkgs.grim}/bin/grim -o \"$(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused)' | ${pkgs.jq}/bin/jq -r '.name')\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
            Escape = "mode default";
            Return = "mode default";
          };
        };
      };
    };
}
