export WLAN=$(ip a | grep -m 1 wlp | cut -f 2 -d " " | sed 's/://')
export ETH=$(ip a | grep -m 1 enp | cut -f 2 -d " " | sed 's/://')
export MON1=$(xrandr -q | grep ' connected ' | grep primary | cut -f 1 -d" ")
export MON2=$(xrandr -q | grep ' connected ' | grep -v primary | cut -f 1 -d" ")

WINDOW_ID_BASE=/tmp/polybar_base_window_id
WINDOW_ID_TOP=/tmp/polybar_top_window_id
WINDOW_ID_TOP_TWO=/tmp/polybar_top_window_id_2
WINDOW_ID_TRAY=/tmp/polybar_tray_window_id


polybar_launch() {
    killall -q picom
    killall -q polybar
    while pgrep -x polybar > /dev/null; do sleep 1; done

    polybar main &
    xdotool search --sync --pid $! | cut -f 1 -d$'\n' > $WINDOW_ID_BASE

    polybar launcher &
    xdotool search --sync --pid $! | cut -f 1 -d$'\n' > $WINDOW_ID_TOP

    polybar secondary &
    xdotool search --sync --pid $! | cut -f 1 -d$'\n' > $WINDOW_ID_TOP_TWO

    polybar tray &
    xdotool search --sync --pid $! | cut -f 1 -d$'\n' > $WINDOW_ID_TRAY

    bar_collapse
}

rofi_open() {
    bar_expand &
    rofi -modi run -show run -location 1 -theme menu
    bar_collapse
}

bar_expand() {

    # xdotool windowunmap $(cat $WINDOW_ID_BASE)
    xdotool windowmap --sync $(cat $WINDOW_ID_TOP)
    for y in `seq 430 10 570`; do
	xdotool windowmove --sync  $(cat $WINDOW_ID_TOP) x $y
    done
}

bar_collapse() {
    xdotool windowunmap $(cat $WINDOW_ID_TOP)
    xdotool windowmap $(cat $WINDOW_ID_BASE)
    xdotool windowmove --sync $(cat $WINDOW_ID_TOP) x 430
}

case "$1" in
    test)
	bar_expand
	sleep 1
	bar_collapse
	;;

    app_menu)
	rofi_open
	;;

    collapse)
	bar_collapse
	;;

    *)
	polybar_launch &
	;;
esac
