import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.bar

// Output volume: scroll to change, click to mute, hover for a slider
Item {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int percent: Math.round(volume * 100)

    // Node properties are only live while the node is bound
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    IconLabel {
        id: label
        anchors.centerIn: parent
        icon: !root.sink || root.muted ? Icons.volumeOff
            : root.percent >= 60 ? Icons.volumeHigh
            : root.percent >= 25 ? Icons.volumeMedium
            : Icons.volumeLow
        iconColor: !root.sink || root.muted ? Theme.error : Theme.volume
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: if (root.sink) root.sink.audio.muted = !root.muted
        onWheel: wheel => {
            if (!root.sink) return;
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + step));
        }
    }

    BarPopup {
        target: root

        AudioControl {
            title: "Output"
            node: root.sink
            icon: Icons.volumeHigh
            mutedIcon: Icons.volumeOff
            color: Theme.volume
        }
    }
}
