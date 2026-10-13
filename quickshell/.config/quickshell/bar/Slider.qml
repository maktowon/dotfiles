import QtQuick
import qs

// Horizontal 0..1 slider: click/drag to set, scroll for 5% steps
Item {
    id: root

    property real value: 0
    property color fillColor: Theme.accent

    signal moved(real value)

    function emit(v) {
        root.moved(Math.max(0, Math.min(1, v)));
    }

    implicitWidth: 180
    implicitHeight: 18

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: height / 2
        color: Theme.surfaceHover

        Rectangle {
            width: parent.width * Math.min(1, root.value)
            height: parent.height
            radius: parent.radius
            color: root.fillColor
        }
    }

    Rectangle {
        x: (root.width - width) * Math.min(1, root.value)
        anchors.verticalCenter: parent.verticalCenter
        width: 14
        height: 14
        radius: width / 2
        color: Theme.fgBright
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => root.emit(mouse.x / width)
        onPositionChanged: mouse => { if (pressed) root.emit(mouse.x / width); }
        onWheel: wheel => root.emit(root.value + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    }
}
