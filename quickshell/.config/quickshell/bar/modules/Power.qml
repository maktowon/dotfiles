import Quickshell
import QtQuick
import qs
import qs.bar

// Power button; hover opens suspend / logout / reboot / shutdown
BarText {
    id: root

    text: Icons.power
    font.pixelSize: Theme.iconSize + 2
    color: menu.visible ? Theme.fgBright : Theme.power

    BarPopup {
        id: menu
        target: root

        Repeater {
            model: [
                { icon: Icons.sleep, label: "Suspend", color: Theme.accent, cmd: ["systemctl", "suspend"] },
                { icon: Icons.logout, label: "Log out", color: Theme.warning, cmd: ["hyprctl", "dispatch", "hl.dsp.exit()"] },
                { icon: Icons.restart, label: "Reboot", color: Theme.nord12, cmd: ["systemctl", "reboot"] },
                { icon: Icons.power, label: "Shut down", color: Theme.error, cmd: ["systemctl", "poweroff"] },
            ]

            Rectangle {
                id: entry

                required property var modelData

                implicitWidth: 160
                implicitHeight: 34
                radius: 6
                color: hover.containsMouse ? Theme.surfaceHover : "transparent"

                IconLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 10
                    icon: entry.modelData.icon
                    iconColor: entry.modelData.color
                    text: entry.modelData.label
                    textColor: hover.containsMouse ? Theme.fgBright : Theme.fg
                }

                MouseArea {
                    id: hover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        menu.close();
                        Quickshell.execDetached(entry.modelData.cmd);
                    }
                }
            }
        }
    }
}
