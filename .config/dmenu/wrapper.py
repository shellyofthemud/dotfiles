#!/usr/bin/env python

import os
import subprocess
import shutil
import glob
import re
import sys
import webbrowser
import json
from typing import List, Tuple

from subprocess import Popen, PIPE
from os.path import expanduser



class AppMenu():

    dmenu = "rofi -dmenu"

    def __init__(self, menu: List[Tuple], callback=None, prompt='Run', dmenu_args=None):
        self.menu = { i[0]: i[1] for i in menu }
        if not callback == None:
            self.callback = callback

        self.prompt = prompt
        if not dmenu_args == None:
            self.dmenu = dmenu + dmenu_args

    def run(self):
        items = '\n'.join(list(self.menu.keys()))
        returncode, stdout = open_dmenu(self.dmenu, items, prompt=self.prompt)
        if returncode == 1 or not stdout:
            sys.exit()
        else:
            out = self.menu[stdout.decode().split('\n')[0]]
            self.callback(out)
        pass

    def callback(self, key):
        key()

    def set_callback(self, cb):
        self.callback = cb


def main() -> None:
    AppMenu([
        ("Steam", AppMenu(get_steam_games(), callback=lambda id: Popen(['xdg-open', 'steam://rungameid/{}'.format(id)]), prompt="Steam").run),
        ("Chrome", AppMenu(get_chrome_bookmarks(), callback=lambda url: webbrowser.open(url), prompt='Chrome').run)
        ]).run()
    pass


def get_chrome_bookmarks():
    with open(expanduser('{}/.config/chromium/Default/Bookmarks'.format(expanduser('~'))), 'r') as bookmarks_json:
        bookmarks = json.loads(bookmarks_json.read())
        bar = bookmarks['roots']['bookmark_bar']['children'] 
        bar_parsed = [ (i['name'], i['url']) for i in bar ]
        return bar_parsed

def get_steam_games():
    games = []
    libraries = []

    with open('{}/.local/share/Steam/steamapps/libraryfolders.vdf'.format(expanduser('~')), 'r') as libraries_file:
        lines: List[str] = libraries_file.readlines()
        info = parse_vdf(lines, ['path'])
        for lib in info['path']:
            libraries.append(lib)

    for library in libraries:
        library = library.replace('$HOME', '~').replace('~', expanduser('~'))
        apps = glob.glob('{}/steamapps/appmanifest_*.acf'.format(library))
        for file in apps:
            with open(file, 'r') as game:
                lines: List[str] = game.readlines()
                info = parse_vdf(lines, ['appid', 'name'])
                games.append((info['name'], info['appid']))

    return games

def parse_vdf(vdf: List[str], keys: List[str]) -> dict:
    values = {}
    for line in vdf:
        matches = re.findall('\t*"(.+?)"', line)
        if len(matches) == 2 and index_of(keys, matches[0]) >= 0:
            if matches[0] in values:
                if not type(values[matches[0]]) == list:
                    tmp = values[matches[0]]
                    values[matches[0]] = [ tmp ]
                values[matches[0]].append(matches[1])
            else:
                values[matches[0]] = matches[1]
    return values

def launch_steam_game(appid: str):
    Popen(['xdg-open', 'steam://run//{}'.format(appid)])

def index_of(list, value) -> int:
    try:
        return list.index(value)
    except ValueError:
        return -1

def open_dmenu(dmenu: str, menu: str, prompt='dmenu') -> Tuple[int, bytes]:
    dmenu = Popen(
        dmenu.split() + [ '-p', prompt],
        stdin=PIPE,
        stdout=PIPE
    )

    (stdout, _) = dmenu.communicate(input=menu.encode('UTF-8'))

    return dmenu.returncode, stdout

if __name__ == "__main__":
    main()
