pragma Singleton

import Quickshell
import QtQuick

// Nord palette — https://www.nordtheme.com/docs/colors-and-palettes
Singleton {
    // Polar Night (backgrounds)
    readonly property color nord0: "#2E3440"
    readonly property color nord1: "#3B4252"
    readonly property color nord2: "#434C5E"
    readonly property color nord3: "#4C566A"

    // Snow Storm (foregrounds)
    readonly property color nord4: "#D8DEE9"
    readonly property color nord5: "#E5E9F0"
    readonly property color nord6: "#ECEFF4"

    // Frost (accents)
    readonly property color nord7: "#8FBCBB"
    readonly property color nord8: "#88C0D0"
    readonly property color nord9: "#81A1C1"
    readonly property color nord10: "#5E81AC"

    // Aurora (states)
    readonly property color nord11: "#BF616A" // red
    readonly property color nord12: "#D08770" // orange
    readonly property color nord13: "#EBCB8B" // yellow
    readonly property color nord14: "#A3BE8C" // green
    readonly property color nord15: "#B48EAD" // purple

    // Semantic roles — use these in modules, not raw nordN
    readonly property color bg: nord0
    readonly property color surface: nord1
    readonly property color surfaceHover: nord2
    readonly property color muted: nord3
    readonly property color fg: nord4
    readonly property color fgBright: nord6
    readonly property color accent: nord8
    readonly property color accentAlt: nord9
    readonly property color error: nord11
    readonly property color warning: nord13
    readonly property color success: nord14

    // Per-module accent colors (icons)
    readonly property color workspaceActive: nord8
    readonly property color workspaceOccupied: nord9
    readonly property color title: nord7
    readonly property color clock: nord13
    readonly property color date: nord9
    readonly property color cpu: nord12
    readonly property color mem: nord15
    readonly property color net: nord14
    readonly property color volume: nord8
    readonly property color mic: nord15
    readonly property color power: nord11

    // Typography & sizing
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 18
    readonly property bool fontBold: true
    readonly property int iconSize: 20
    readonly property int barHeight: 34
    readonly property int gap: 8 // matches hyprland gaps_out
    readonly property int pillPadding: 12
    readonly property int pillRadius: barHeight / 2
    readonly property int spacing: 12
}
