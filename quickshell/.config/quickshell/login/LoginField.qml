import QtQuick
import qs

// Pill-shaped input with a leading icon
Rectangle {
    id: root

    property alias icon: iconText.text
    property alias input: input
    property alias text: input.text
    property bool masked: false

    signal accepted

    implicitWidth: 320
    implicitHeight: 44
    radius: height / 2
    color: Theme.bg
    border.width: 2
    border.color: input.activeFocus ? Theme.accent : Theme.surfaceHover

    Behavior on border.color { ColorAnimation { duration: 120 } }

    Text {
        id: iconText
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
        color: input.activeFocus ? Theme.accent : Theme.muted
    }

    TextInput {
        id: input
        anchors.left: iconText.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        color: Theme.fgBright
        selectionColor: Theme.accentAlt
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize + 1
        font.bold: Theme.fontBold
        echoMode: root.masked ? TextInput.Password : TextInput.Normal
        passwordCharacter: "•"
        onAccepted: root.accepted()
    }
}
