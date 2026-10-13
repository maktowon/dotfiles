import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import qs.login

// Session lock using the shared LoginPanel, authenticated through PAM.
// Trigger with: qs ipc call lock lock
Scope {
    id: root

    property string password: ""
    property string errorText: ""

    IpcHandler {
        target: "lock"

        function lock(): void {
            root.errorText = "";
            sessionLock.locked = true;
        }
    }

    PamContext {
        id: pam

        // Answer the password prompt with what was typed into the panel
        onPamMessage: {
            if (pam.responseRequired) pam.respond(root.password);
        }

        onCompleted: result => {
            root.password = "";
            if (result === PamResult.Success) {
                root.errorText = "";
                sessionLock.locked = false;
            } else if (result === PamResult.MaxTries) {
                root.errorText = "Too many attempts, try again later";
            } else {
                root.errorText = "Wrong password";
            }
        }

        onError: error => {
            root.password = "";
            root.errorText = `Authentication error: ${PamError.toString(error)}`;
        }
    }

    WlSessionLock {
        id: sessionLock

        // One surface per screen
        WlSessionLockSurface {
            color: "black"

            LoginPanel {
                anchors.fill: parent
                user: Quickshell.env("USER")
                userEditable: false
                busy: pam.active
                errorText: root.errorText

                onSubmitted: (user, password) => {
                    root.errorText = "";
                    root.password = password;
                    pam.start();
                }
            }
        }
    }
}
