import QtQuick
import QtQuick.Layouts
import qs

// Rounded container; children are laid out in a row
Rectangle {
    default property alias content: row.data

    height: Theme.barHeight
    implicitWidth: row.implicitWidth + Theme.pillPadding * 2
    radius: Theme.pillRadius
    color: Theme.surface

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacing
    }
}
