#!/usr/bin/env python3

# This script gets the list of all current windows and shows them on wofi
# The selected window get's focused.
import subprocess
from i3ipc import Connection


def get_windows(conn):
    """Given a sway connection object, return the current windows infromation

    return: Dictionary with window id as key"""
    containers = conn.get_tree().descendants()
    containers = filter(lambda x: x.type in ["con", "floating_con"], containers)
    windows = [window_crawl(con) for con in containers]

    return {
        f'{window.id:<5}{", ".join(window.marks):<10}{window.name}': window
        for window in windows
    }


def window_crawl(con):
    """Recursively get containers without descendants e.g windows"""
    # TODO: This function is unneccesary the library provides two functions
    # leaves() and scratchpad() that could accomplish this.
    if con.descendants():
        for x in con.descendants():
            return window_crawl(x)
    else:
        return con


def wofi(options: list):
    """Calls rofi in dmenu mode with the given selection options

    It returns the selection
    """
    return subprocess.check_output(
        [
            "wofi",
            "--cache-file",
            "/dev/null",
            "--insensitive",
            "--allow-images",
            "--gtk-dark",
            "--dmenu",
        ],
        input="\n".join(options),
        encoding="UTF-8",
    ).strip("\n")


if __name__ == "__main__":
    sway = Connection()
    windows = get_windows(sway)
    result = wofi(windows.keys())
    window = windows[result]
    window.command("focus")
