pragma Singleton

import Quickshell
import QtQuick

// Nerd Font glyphs by codepoint (literal glyphs get mangled by some editors)
Singleton {
    readonly property string cpu: String.fromCodePoint(0xf4bc)
    readonly property string memory: String.fromCodePoint(0xf035b)
    readonly property string ethernet: String.fromCodePoint(0xf0200)
    readonly property string wifi: String.fromCodePoint(0xf0928)
    readonly property string netOff: String.fromCodePoint(0xf092d)
    readonly property string volumeHigh: String.fromCodePoint(0xf057e)
    readonly property string volumeMedium: String.fromCodePoint(0xf0580)
    readonly property string volumeLow: String.fromCodePoint(0xf057f)
    readonly property string volumeOff: String.fromCodePoint(0xf075f)
    readonly property string mic: String.fromCodePoint(0xf036c)
    readonly property string micOff: String.fromCodePoint(0xf036d)
    readonly property string clock: String.fromCodePoint(0xf0954)
    readonly property string calendar: String.fromCodePoint(0xf00ed)
    readonly property string power: String.fromCodePoint(0xf0425)
    readonly property string sleep: String.fromCodePoint(0xf04b2)
    readonly property string logout: String.fromCodePoint(0xf0343)
    readonly property string restart: String.fromCodePoint(0xf0709)
    readonly property string user: String.fromCodePoint(0xf0004)
    readonly property string lock: String.fromCodePoint(0xf033e)
    readonly property string arrowRight: String.fromCodePoint(0xf0054)
    readonly property string hourglass: String.fromCodePoint(0xf051f)
    readonly property string eye: String.fromCodePoint(0xf0208)
    readonly property string eyeOff: String.fromCodePoint(0xf0209)
}
