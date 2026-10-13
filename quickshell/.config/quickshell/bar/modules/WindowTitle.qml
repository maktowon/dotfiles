import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs
import qs.bar

BarText {
    readonly property var toplevel: Hyprland.activeToplevel
    // Hide a stale title when switching to an empty workspace
    readonly property bool onFocusedWs: toplevel?.workspace?.id === Hyprland.focusedWorkspace?.id

    text: toplevel && onFocusedWs ? toplevel.title : ""
    visible: text !== ""
    color: Theme.title
    elide: Text.ElideRight
    Layout.maximumWidth: 400
}
