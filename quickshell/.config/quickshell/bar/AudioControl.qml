import QtQuick
import qs

// One PipeWire node: title + device name, then [mute] [slider] [percent]
Column {
    id: root

    required property var node
    property string title
    property string icon
    property string mutedIcon
    property color color: Theme.accent

    readonly property bool muted: node?.audio?.muted ?? false
    readonly property real volume: node?.audio?.volume ?? 0

    spacing: 6

    Row {
        spacing: 8

        BarText {
            text: root.title
            color: root.color
        }

        BarText {
            text: root.node?.description || root.node?.name || "No device"
            color: Theme.muted
            width: 200
            elide: Text.ElideRight
        }
    }

    Row {
        spacing: 10

        // Mute toggle
        BarText {
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            text: root.muted ? root.mutedIcon : root.icon
            color: root.muted ? Theme.error : root.color
            font.pixelSize: Theme.iconSize

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (root.node) root.node.audio.muted = !root.muted
            }
        }

        Slider {
            anchors.verticalCenter: parent.verticalCenter
            width: 200
            value: root.volume
            fillColor: root.muted ? Theme.muted : root.color
            onMoved: v => { if (root.node) root.node.audio.volume = v; }
        }

        BarText {
            id: percentText
            anchors.verticalCenter: parent.verticalCenter
            width: muteMetrics.advanceWidth
            horizontalAlignment: Text.AlignRight
            text: root.muted ? "muted" : `${Math.round(root.volume * 100)}%`
            color: root.muted ? Theme.error : Theme.fg

            TextMetrics {
                id: muteMetrics
                font: percentText.font
                text: "muted"
            }
        }
    }
}
