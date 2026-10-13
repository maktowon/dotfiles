import QtQuick
import qs

// Round icon-only button; fills with iconColor on hover
Rectangle {
    id: root

    property alias icon: iconText.text
    property color iconColor: Theme.accent

    signal clicked

    implicitWidth: 44
    implicitHeight: 44
    radius: width / 2
    color: mouse.containsMouse ? iconColor : Theme.bg
    border.width: 2
    border.color: mouse.containsMouse ? iconColor : Theme.surfaceHover

    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
        id: iconText
        anchors.centerIn: parent
        color: mouse.containsMouse ? Theme.bg : root.iconColor
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
