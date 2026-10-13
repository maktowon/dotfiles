import Quickshell.Io
import QtQuick
import qs
import qs.bar

// CPU and RAM usage from /proc, sampled every 2s
Row {
    id: root

    property int cpu: 0
    property int mem: 0
    property var lastCpu: null

    spacing: Theme.spacing

    function usageColor(p) {
        return p >= 90 ? Theme.error : p >= 70 ? Theme.warning : Theme.fg;
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: {
            // cpu  user nice system idle iowait irq softirq steal
            const f = text().split("\n")[0].trim().split(/\s+/).slice(1, 9).map(Number);
            const idle = f[3] + f[4];
            const total = f.reduce((a, b) => a + b, 0);
            if (root.lastCpu) {
                const dt = total - root.lastCpu.total;
                if (dt > 0) root.cpu = Math.round(100 * (1 - (idle - root.lastCpu.idle) / dt));
            }
            root.lastCpu = { idle, total };
        }
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: {
            const kb = key => Number(text().match(new RegExp(`${key}:\\s+(\\d+)`))[1]);
            root.mem = Math.round(100 * (1 - kb("MemAvailable") / kb("MemTotal")));
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
        }
    }

    IconLabel {
        icon: Icons.memory
        iconColor: Theme.mem
        text: `${root.mem}%`
        textColor: root.usageColor(root.mem)
    }

    IconLabel {
        icon: Icons.cpu
        iconColor: Theme.cpu
        text: `${root.cpu}%`
        textColor: root.usageColor(root.cpu)
    }
}
