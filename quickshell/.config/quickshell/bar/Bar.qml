import Quickshell
import QtQuick
import qs
import qs.bar.modules

// Floating bar: transparent window holding three pills (left / center / right)
PanelWindow {
    id: bar

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: Theme.gap
        left: Theme.gap
        right: Theme.gap
    }
    implicitHeight: Theme.barHeight
    color: "transparent"

    Pill {
        anchors.left: parent.left

        Workspaces {}
        WindowTitle {}
    }

    Pill {
        anchors.horizontalCenter: parent.horizontalCenter

        Clock {}
    }

    // Right: [audio + network + tray] [ram + cpu] (power)
    Row {
        anchors.right: parent.right
        spacing: Theme.gap

        Pill {
            Volume {}
            Microphone {}
            Network {}
            Tray {
                barWindow: bar
            }
        }

        Pill {
            Stats {}
        }

        // Round button-sized pill
        Pill {
            implicitWidth: Theme.barHeight

            Power {}
        }
    }
}
