#!/usr/bin/env bash
# ==============================================================================
# Mit csinál: Rövid összefoglalót ír ki a gépről.
# Hogyan kell hívni: ./rendszerinfo.sh [fajlnev]
# Mit ad vissza: 0 ha sikeres, 1 ha a megadott fájl nem írható.
# ==============================================================================

KIMENET="/dev/stdout"

if [ -n "$1" ]; then
    KIMENET="$1"
    if [ -e "$KIMENET" ] && [ ! -w "$KIMENET" ] || [ ! -e "$KIMENET" ] && [ ! -w "$(dirname "$KIMENET")" ]; then
        echo "Hiba: A megadott célfájl ($KIMENET) nem írható!" >&2
        exit 1
    fi
fi

{
    printf "%-30s %s\n" "Hosztnév:" "$(hostname)"
    printf "%-30s %s\n" "Kernelverzió:" "$(uname -r)"
    printf "%-30s %s\n" "Uptime:" "$(awk '{print int($1/3600)"h "int(($1%3600)/60)"m"}' /proc/uptime)"
    printf "%-30s %s\n" "Bejelentkezett felhasználó:" "$(whoami)"
    printf "%-30s %s\n" "Home könyvtár mérete:" "$(du -sh "$HOME" | cut -f1)"
    printf "%-30s %s\n" "Szabad lemezhely a / -on:" "$(df -h / | awk 'NR==2 {print $4}')"
    printf "%-30s %s\n" "Futó folyamatok ska:" "$(ps -e | wc -l)"
} > "$KIMENET"

exit 0
