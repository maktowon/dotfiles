import Quickshell
import QtQuick
import qs

// Dropdown under a bar item. Opens while the item is hovered and stays open
// while the pointer is over the popup itself.
PopupWindow {
    id: popup

    required property Item target
    default property alias content: body.data
    readonly property bool hovered: targetHover.hovered || popupHover.hovered
    // Transparent strip from the item down to the visible popup, so moving
    // the pointer from item to popup never leaves both
    readonly property real bridge: (Theme.barHeight - target.height) / 2 + Theme.gap

    anchor.item: target
    anchor.rect.x: (target.width - width) / 2
    anchor.rect.y: target.height
    implicitWidth: body.implicitWidth + 24
    implicitHeight: body.implicitHeight + 24 + bridge
    color: "transparent"
    visible: false

    function close() {
        visible = false;
    }

    onHoveredChanged: {
        if (hovered) {
            closeTimer.stop();
            visible = true;
        } else {
            closeTimer.restart();
        }
    }

    // Wayland sends "leave item" just before "enter popup"; wait one tick so
    // that handoff doesn't close the popup. Not a visible delay.
    Timer {
        id: closeTimer
        interval: 30
        onTriggered: popup.visible = popup.hovered
    }

    HoverHandler {
        id: targetHover
        parent: popup.target
    }

    Item {
        anchors.fill: parent

        HoverHandler {
            id: popupHover
        }

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: popup.bridge
            radius: 10
            color: Theme.surface
            border.color: Theme.surfaceHover
            border.width: 1

            Column {
                id: body
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4
            }
        }
    }
}
