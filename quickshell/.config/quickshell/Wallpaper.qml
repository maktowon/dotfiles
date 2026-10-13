import Quickshell
import Quickshell.Wayland
import QtQuick

// Draws the wallpaper on the background layer of one screen
PanelWindow {
    required property var modelData
    screen: modelData

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "qs-wallpaper"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("assets/wallpaper.png")
        fillMode: Image.PreserveAspectCrop
        smooth: false // flat art, keep the edges crisp when upscaling
    }
}
