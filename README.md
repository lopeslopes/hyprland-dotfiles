# hyprland-dotfiles
Dotfiles for Hyprland desktop configuration

This configuration uses the Hyprland WM in conjunction with Waybar (for status bar and system tray) and Wofi (for dmenu and power menu).

Some packages you'll need to replicate this are:
- Hyprland (WM)
- Waybar (status bar)
- Wofi (dmenu/power menu)
- Grim + Slurp (screenshot utils)
- Hyprpaper (wallpaper)
- Swaylock (screen lock)

I also use Sakura as my terminal emulator and pavucontrol for sound management, so make sure to change this to your used applications in the `hypr/hyprland.conf` file.

Note: My NVIDIA gpu requires some env variables settings in `hypr/hyprland.conf`, change that as needed if you use other gpus.

To do:
- Create css file with standardized colors for all applications, to make it easier to setup a theme.
