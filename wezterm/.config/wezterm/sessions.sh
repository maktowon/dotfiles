#!/bin/sh
# session menu for wezterm (opened with leader s)
#   o / enter  open the session
#   d          delete the session, the menu stays open
#   j / k      move
#   q / esc    close
# opening works by setting a user var that wezterm.lua listens for (user-var-changed)

panes() { wezterm cli --prefer-mux list | awk 'NR > 1'; }

# the session this menu was opened from (the one it's running in)
current() { panes | awk -v p="$WEZTERM_PANE" '$3 == p { print $4 }'; }

case "$1" in
  list)
    cur=$(current)
    panes | awk -v cur="$cur" '
      { n[$4]++ }
      END {
        for (w in n)
          printf "%s\t%d pane%s%s\n", w, n[w], (n[w] == 1 ? "" : "s"), (w == cur ? "\t[current]" : "")
      }' | sort
    ;;
  delete)
    # never delete the session the menu runs in, that would kill the menu too
    [ "$2" = "$(current)" ] && exit 0
    panes | awk -v ws="$2" '$4 == ws { print $3 }' | while read -r id; do
      wezterm cli --prefer-mux kill-pane --pane-id "$id"
    done
    ;;
  *)
    ws=$("$0" list | fzf --no-input --reverse --no-sort --delimiter='\t' \
      --header 'o/enter open · d delete · j/k move · q/esc close' \
      --bind 'j:down,k:up,q:abort,o:accept' \
      --bind "d:execute-silent('$0' delete {1})+reload('$0' list)" |
      cut -f1)
    [ -n "$ws" ] || exit 0
    printf '\033]1337;SetUserVar=switch_workspace=%s\007' "$(printf %s "$ws" | base64 | tr -d '\n')"
    # give wezterm a moment to read the user var before this pane closes
    sleep 0.3
    ;;
esac
