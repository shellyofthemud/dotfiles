from libqtile.config import Key
from libqtile.command import lazy
mod = "mod4"
alt = "mod1"

keys = [
	Key([mod, "shift"], "q",
		lazy.shutdown()),
	Key([mod, "h"],
		lazy.layout.left()),
	Key([mod, "j"],
		lazy.layout.down()),
	Key([mod, "k"],
		lazy.layout.up()),
	Key([mod, "l"],
		lazy.layout.right())
]
