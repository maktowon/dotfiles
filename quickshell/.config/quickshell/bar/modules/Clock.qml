import Quickshell
import QtQuick
import qs
import qs.bar

Row {
    spacing: Theme.spacing

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    IconLabel {
        icon: Icons.clock
        iconColor: Theme.clock
        text: Qt.formatDateTime(clock.date, "HH:mm")
        textColor: Theme.fgBright
    }

    IconLabel {
        icon: Icons.calendar
        iconColor: Theme.date
        text: Qt.formatDateTime(clock.date, "ddd dd MMM")
    }
}
