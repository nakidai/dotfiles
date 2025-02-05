xrandr --output eDP-1 --mode 1920x1080 && xrandr --output HDMI-1 --mode 1920x1080 --left-of eDP-1
python "$HOME/dwmscripts/sysbar.py" &
(python "$HOME/dwmscripts/prekol.py" >& ultralogprekola) &
flameshot &
compton &
xhost +local:
exec dwm
