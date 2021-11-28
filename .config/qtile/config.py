from libqtile.config import Key
from libqtile.command import lazy
mod = "mod4"
alt = "mod1"

keys = [
	Key([mod, "shift"], "q",
		lazy.window.kill()),
	Key([mod], "h",
		lazy.layout.left()),
	Key([mod], "j",
		lazy.layout.down()),
	Key([mod], "k",
		lazy.layout.up()),
	Key([mod], "l",
		lazy.layout.right()),

    Key([mod], "enter",
        lazy.spawn("urxvt"))
]

@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == 'dialog'
            or window.window.get_wm_transient_for()):
                    window.floating = True

layouts = [
    layout.Tile()
]
