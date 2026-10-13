import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs
import qs.bar

// Wired: icon only. Wifi: icon + SSID. Nothing connected: red icon.
// Hover shows connection details.
IconLabel {
    id: root

    readonly property var device: Networking.devices.values.find(d => d.connected) ?? null
    readonly property bool wifi: device?.type === DeviceType.Wifi
    readonly property var network: wifi
        ? device.networks.values.find(n => n.connected) ?? null
        : device?.network ?? null
    property string ipv4: ""

    icon: !device ? Icons.netOff : wifi ? Icons.wifi : Icons.ethernet
    iconColor: device ? Theme.net : Theme.error
    text: wifi ? network?.name ?? "" : ""

    // NetworkDevice doesn't expose IPs, so ask iproute2 when the popup opens
    Process {
        id: ipProc
        command: ["ip", "-4", "-o", "addr", "show", "dev", root.device?.name ?? "lo"]
        stdout: StdioCollector {
            onStreamFinished: root.ipv4 = text.match(/inet (\S+)/)?.[1] ?? "none"
        }
    }

    BarPopup {
        id: details
        target: root
        onVisibleChanged: if (visible && root.device) ipProc.running = true

        // Widest label decides the label column
        TextMetrics {
            id: keyMetrics
            font: Qt.font({ family: Theme.fontFamily, pixelSize: Theme.fontSize, bold: Theme.fontBold })
            text: "Connection"
        }

        BarText {
            text: !root.device ? "Disconnected" : root.wifi ? "Wi-Fi" : "Ethernet"
            color: root.device ? Theme.net : Theme.error
            bottomPadding: 4
        }
        InfoRow { keyWidth: keyMetrics.advanceWidth; visible: !!root.device; key: "Connection"; value: root.network?.name ?? "-" }
        InfoRow { keyWidth: keyMetrics.advanceWidth; visible: !!root.device; key: "Interface"; value: root.device?.name ?? "-" }
        InfoRow { keyWidth: keyMetrics.advanceWidth; visible: !!root.device; key: "IPv4"; value: root.ipv4 || "..." }
        InfoRow {
            keyWidth: keyMetrics.advanceWidth
            visible: !!root.device && !root.wifi
            key: "Speed"
            value: `${root.device?.linkSpeed ?? 0} Mb/s`
        }
        InfoRow {
            keyWidth: keyMetrics.advanceWidth
            visible: root.wifi
            key: "Signal"
            value: `${Math.round((root.network?.signalStrength ?? 0) * 100)}%`
        }
    }
}
