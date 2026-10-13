import Quickshell
import QtQuick
import qs

// Full-screen login UI shared by the lock screen and the greetd greeter.
// It only collects input; the owner does the actual authentication.
Item {
    id: root

    property string user: "maktowon"
    property bool userEditable: true
    property bool busy: false
    property string errorText: ""

    signal submitted(string user, string password)

    function focusPassword() {
        passwordField.input.forceActiveFocus();
    }

    function submit() {
        if (busy || passwordField.text === "") return;
        const password = passwordField.text;
        passwordField.text = "";
        root.submitted(userField.text, password);
    }

    Component.onCompleted: focusPassword()

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("../assets/wallpaper.png")
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    // Dim the wallpaper so the panel stands out
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        opacity: 0.45
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Column {
        anchors.centerIn: parent
        spacing: 28

        // Date & time
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(clock.date, "HH:mm")
                color: Theme.fgBright
                font.family: Theme.fontFamily
                font.pixelSize: 96
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
                color: Theme.accentAlt
                font.family: Theme.fontFamily
                font.pixelSize: 22
                font.bold: true
            }
        }

        // Credentials: username pill, then [show] [password pill] [login]
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            LoginField {
                id: userField
                icon: Icons.user
                text: root.user
                input.readOnly: !root.userEditable
                input.activeFocusOnTab: root.userEditable
                onAccepted: root.focusPassword()
            }

            // [password pill] [login] [show password]
            Row {
                spacing: 8

                LoginField {
                    id: passwordField
                    // Row matches the username pill's total width
                    implicitWidth: userField.width - 2 * (revealButton.width + parent.spacing)
                    icon: Icons.lock
                    masked: !revealButton.revealed
                    input.enabled: !root.busy
                    onAccepted: root.submit()
                }

                CircleButton {
                    icon: root.busy ? Icons.hourglass : Icons.arrowRight
                    iconColor: Theme.accent
                    onClicked: root.submit()
                }

                CircleButton {
                    id: revealButton
                    property bool revealed: false
                    icon: revealed ? Icons.eyeOff : Icons.eye
                    iconColor: Theme.accentAlt
                    onClicked: {
                        revealed = !revealed;
                        root.focusPassword();
                    }
                }
            }

            // Always takes one line of space so the layout doesn't jump
            Text {
                width: userField.width
                text: root.errorText || " "
                color: Theme.error
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: true
            }
        }
    }

    // Power options
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32
        spacing: 16

        Repeater {
            model: [
                { icon: Icons.sleep, color: Theme.accent, cmd: ["systemctl", "suspend"] },
                { icon: Icons.restart, color: Theme.nord12, cmd: ["systemctl", "reboot"] },
                { icon: Icons.power, color: Theme.error, cmd: ["systemctl", "poweroff"] },
            ]

            CircleButton {
                required property var modelData

                icon: modelData.icon
                iconColor: modelData.color
                onClicked: Quickshell.execDetached(modelData.cmd)
            }
        }
    }
}
