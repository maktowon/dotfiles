import QtQuick
import qs

// "key   value" line for popups
Row {
    property alias key: k.text
    property alias value: v.text
    // Shared label column width so values line up across rows
    property real keyWidth: 0

    spacing: 12

    BarText {
        id: k
        width: Math.max(implicitWidth, keyWidth)
        color: Theme.muted
    }

    BarText {
        id: v
        color: Theme.fgBright
    }
}
