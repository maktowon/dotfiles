import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs

// System tray: left click activates, right click opens the app's menu
Row {
    id: root

    required property var barWindow

    spacing: 8
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        IconImage {
            id: icon

            required property var modelData

            anchors.verticalCenter: parent.verticalCenter
            implicitSize: 16
            source: modelData.icon

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    const item = icon.modelData;
                    if (mouse.button === Qt.MiddleButton) {
                        item.secondaryActivate();
                    } else if (mouse.button === Qt.RightButton || item.onlyMenu) {
                        if (!item.hasMenu) return;
                        const p = icon.mapToItem(null, 0, root.barWindow.height);
                        item.display(root.barWindow, p.x, p.y);
                    } else {
                        item.activate();
                    }
                }
            }
        }
    }
}
