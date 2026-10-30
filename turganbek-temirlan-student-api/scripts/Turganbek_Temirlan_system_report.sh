#!/bin/bash
# Turganbek_Temirlan_system_report.sh
# Prints a system report and appends it to the student's personal log file.
#
# Usage: ./Turganbek_Temirlan_system_report.sh [log_file]
#   log_file  optional path of the log file
#             (default: ../logs/Turganbek_Temirlan_system_report.log, relative to this script)

STUDENT_NAME="Turganbek Temirlan"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/../logs/Turganbek_Temirlan_system_report.log}"

LOG_FILE="$(realpath -m "$LOG_FILE")"
mkdir -p "$(dirname "$LOG_FILE")"

report() {
    echo "=============================================="
    echo "SYSTEM REPORT"
    echo "=============================================="
    echo "Student full name : $STUDENT_NAME"
    echo "Date and time     : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "Current user      : $(whoami)"
    echo

    echo "--- Operating system and kernel ---"
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "OS     : ${PRETTY_NAME:-unknown}"
    else
        echo "OS     : $(uname -s)"
    fi
    echo "Kernel : $(uname -r)"
    echo

    echo "--- CPU information ---"
    if command -v lscpu >/dev/null 2>&1; then
        lscpu | grep -E '^(Architecture|CPU\(s\)|Model name)'
    else
        grep -m1 'model name' /proc/cpuinfo
        echo "CPU cores: $(grep -c '^processor' /proc/cpuinfo)"
    fi
    echo

    echo "--- Memory information ---"
    free -h
    echo

    echo "--- Disk usage ---"
    df -h
    echo

    echo "--- Available disk space ---"
    df -h --output=source,avail,target / 2>/dev/null || df -h /
    echo "=============================================="
    echo
}

# tee -a prints to the terminal AND appends to the log file (does not overwrite old reports).
report | tee -a "$LOG_FILE"

echo "Report saved to: $LOG_FILE"
