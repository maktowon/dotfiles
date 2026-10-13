import Quickshell.Hyprland
import QtQuick
import qs

// Always shows workspaces 1..5 as dots: active = wide accent pill,
// occupied = bright dot, empty = muted dot
Row {
    id: root

    readonly property int count: 5
    readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1

    spacing: 6

    Repeater {
        model: root.count

        Rectangle {
            required property int index
            readonly property int wsId: index + 1
            readonly property bool active: root.activeId === wsId
            readonly property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

            anchors.verticalCenter: parent.verticalCenter
            width: active ? 24 : 10
            height: 10
            radius: height / 2
            color: active ? Theme.workspaceActive : occupied ? Theme.workspaceOccupied : Theme.muted

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.wsId} })`)
            }
        }
    }

    // Scroll over the dots to cycle through 1..5
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            const step = event.angleDelta.y < 0 ? 1 : -1;
            const next = ((root.activeId - 1 + step + root.count) % root.count) + 1;
            Hyprland.dispatch(`hl.dsp.focus({ workspace = ${next} })`);
        }
    }
}
