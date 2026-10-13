import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import qs.login

// greetd greeter: `qs -p greeter.qml`, started by /etc/greetd/hyprland.lua.
// Run it outside greetd to preview; Escape quits the preview.
ShellRoot {
    id: root

    readonly property var sessionCommand: ["start-hyprland"]
    property string password: ""
    property string errorText: Greetd.available ? "" : "Preview mode (greetd not running) - Esc to quit"
    property bool busy: false

    Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            if (responseRequired) {
                Greetd.respond(root.password);
                root.password = "";
            } else if (error) {
                root.errorText = message;
            }
        }

        function onAuthFailure(message) {
            root.busy = false;
            root.errorText = "Wrong password";
        }

        function onReadyToLaunch() {
            Greetd.launch(root.sessionCommand);
        }

        function onError(error) {
            root.busy = false;
            root.errorText = error;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            readonly property bool primary: modelData === Quickshell.screens[0]

            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-greeter"
            WlrLayershell.keyboardFocus: primary ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            LoginPanel {
                anchors.fill: parent
                busy: root.busy
                errorText: root.errorText

                Keys.onEscapePressed: if (!Greetd.available) Qt.quit()

                onSubmitted: (user, password) => {
                    if (!Greetd.available) return;
                    root.errorText = "";
                    root.busy = true;
                    root.password = password;
                    if (Greetd.state !== GreetdState.Inactive) Greetd.cancelSession();
                    Greetd.createSession(user);
                }
            }
        }
    }
}
