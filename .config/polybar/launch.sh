export WLAN=$(ip a | grep -m 1 wlp | cut -f 2 -d " " | sed 's/://')
export ETH=$(ip a | grep -m 1 enp | cut -f 2 -d " " | sed 's/://')
export MON1=$(xrandr -q | grep ' connected ' | grep primary | cut -f 1 -d" ")
export MON2=$(xrandr -q | grep ' connected ' | grep -v primary | cut -f 1 -d" ")

WINDOW_ID_BASE=/tmp/polybar_base_window_id
WINDOW_ID_TOP=/tmp/polybar_top_window_id


polybar_launch() {
    killall -q polybar
    while pgrep -x polybar > /dev/null; do sleep 1; done

    polybar main &
    xdotool search --sync --pid $! | cut -f 1 -d$'\n' > $WINDOW_ID_BASE

	[[ $(command -v blueman-applet) ]] && blueman-applet


    # polybar app_menu &
    # xdotool search --sync --pid $! > $WINDOW_ID_TOP

    # bar_collapse
}

rofi_open() {
    bar_expand &
    rofi -modi run -show run
    bar_collapse
}

bar_collapse() {
    xdotool windowunmap $(cat $WINDOW_ID_TOP)
    xdotool windowmap $(cat $WINDOW_ID_BASE)
}

bar_expand() {
    # xdotool windowunmap $(cat $WINDOW_ID_BASE)
    xdotool windowmap $(cat $WINDOW_ID_TOP)
}

case "$1" in
    app_menu)
	rofi_open
	;;

    collapse)
	bar_collapse
	;;

    *)
	polybar_launch &;;
esac
