import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.bar

// Input (mic): click to mute, scroll to change, hover for a slider
Item {
    id: root

    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool muted: source?.audio?.muted ?? false
    readonly property real volume: source?.audio?.volume ?? 0

    // Node properties are only live while the node is bound
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    IconLabel {
        id: label
        anchors.centerIn: parent
        icon: !root.source || root.muted ? Icons.micOff : Icons.mic
        iconColor: !root.source || root.muted ? Theme.error : Theme.mic
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: if (root.source) root.source.audio.muted = !root.muted
        onWheel: wheel => {
            if (!root.source) return;
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.source.audio.volume = Math.max(0, Math.min(1, root.volume + step));
        }
    }

    BarPopup {
        target: root

        AudioControl {
            title: "Input"
            node: root.source
            icon: Icons.mic
            mutedIcon: Icons.micOff
            color: Theme.mic
        }
    }
}
