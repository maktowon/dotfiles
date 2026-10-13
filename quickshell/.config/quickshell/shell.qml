import Quickshell
import QtQuick
import qs.bar
import qs.lock
import qs.launcher

ShellRoot {
    // One wallpaper + bar per connected monitor
    Variants {
        model: Quickshell.screens

        Wallpaper {}
    }

    Variants {
        model: Quickshell.screens

        Bar {}
    }

    Lock {}

    Launcher {}
}
