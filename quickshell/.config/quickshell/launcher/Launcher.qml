import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import qs

// App launcher: type to filter installed .desktop apps, Enter to launch.
// Toggle with: qs ipc call launcher toggle
Scope {
    id: root

    property bool open: false

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            root.open = !root.open;
        }
    }

    LazyLoader {
        active: root.open

        PanelWindow {
            id: window

            // Open on the monitor Hyprland has focused
            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "quickshell"

            readonly property var apps: {
                const query = search.text.trim().toLowerCase();
                const all = DesktopEntries.applications.values.filter(e => !e.noDisplay);
                if (query === "")
                    return all.sort((a, b) => a.name.localeCompare(b.name));

                // Name prefix > name substring > generic name / keywords
                const score = e => {
                    const name = e.name.toLowerCase();
                    if (name.startsWith(query)) return 3;
                    if (name.includes(query)) return 2;
                    const extra = [e.genericName, ...e.keywords].join(" ").toLowerCase();
                    return extra.includes(query) ? 1 : 0;
                };
                return all.map(e => ({ e, s: score(e) }))
                    .filter(x => x.s > 0)
                    .sort((a, b) => b.s - a.s || a.e.name.localeCompare(b.e.name))
                    .map(x => x.e);
            }

            function launch(entry) {
                if (!entry) return;
                entry.execute();
                root.open = false;
            }

            // Click outside the panel to close
            MouseArea {
                anchors.fill: parent
                onClicked: root.open = false
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.bg
                opacity: 0.35
            }

            Rectangle {
                id: panel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.2
                width: 560
                height: content.implicitHeight + 24
                radius: 14
                color: Theme.surface
                border.color: Theme.surfaceHover
                border.width: 1

                // Swallow clicks so they don't reach the close area
                MouseArea {
                    anchors.fill: parent
                }

                Column {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Rectangle {
                        width: parent.width
                        height: 44
                        radius: height / 2
                        color: Theme.bg
                        border.width: 2
                        border.color: Theme.accent

                        Text {
                            id: searchIcon
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            text: Icons.search
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.iconSize
                            color: Theme.accent
                        }

                        TextInput {
                            id: search
                            anchors.left: searchIcon.right
                            anchors.leftMargin: 12
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            clip: true
                            focus: true
                            color: Theme.fgBright
                            selectionColor: Theme.accentAlt
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize + 1
                            font.bold: Theme.fontBold

                            onTextChanged: list.currentIndex = 0
                            onAccepted: window.launch(window.apps[list.currentIndex])

                            Keys.onEscapePressed: root.open = false
                            Keys.onUpPressed: list.decrementCurrentIndex()
                            Keys.onDownPressed: list.incrementCurrentIndex()
                            Keys.onTabPressed: list.incrementCurrentIndex()
                            Keys.onBacktabPressed: list.decrementCurrentIndex()
                        }
                    }

                    ListView {
                        id: list
                        width: parent.width
                        height: Math.min(contentHeight, 8 * 44)
                        clip: true
                        model: window.apps
                        highlightMoveDuration: 0
                        boundsBehavior: Flickable.StopAtBounds

                        highlight: Rectangle {
                            radius: 10
                            color: Theme.surfaceHover
                        }

                        delegate: Item {
                            id: row

                            required property var modelData
                            required property int index

                            width: ListView.view.width
                            height: 44

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12

                                IconImage {
                                    anchors.verticalCenter: parent.verticalCenter
                                    implicitSize: 28
                                    source: Quickshell.iconPath(row.modelData.icon, true)
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: row.modelData.name
                                    color: row.ListView.isCurrentItem ? Theme.fgBright : Theme.fg
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 2
                                    font.bold: row.ListView.isCurrentItem
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: list.currentIndex = row.index
                                onClicked: window.launch(row.modelData)
                            }
                        }
                    }

                    Text {
                        visible: window.apps.length === 0
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "No matches"
                        color: Theme.muted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                    }
                }
            }
        }
    }
}
