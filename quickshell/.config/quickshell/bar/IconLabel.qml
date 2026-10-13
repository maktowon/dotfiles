import QtQuick
import qs

// Colored icon followed by an optional text label
Row {
    property alias icon: iconText.text
    property alias text: label.text
    property color iconColor: Theme.accent
    property color textColor: Theme.fg

    spacing: 6

    BarText {
        id: iconText
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Theme.iconSize
        color: parent.iconColor
    }

    BarText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        visible: text !== ""
        color: parent.textColor
    }
}
