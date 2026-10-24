set -o pipefail

verbose_log "GET https://www.php.net/js/search-index.php?lang=${args[--language]}"
curl -fsSG --connect-timeout 10 --max-time 60 'https://www.php.net/js/search-index.php' \
  --data-urlencode "lang=${args[--language]}" |
  if [[ "${args[--output-format]}" == alfred ]]; then
    verbose_log "Generating Alfred results..."
    jq --arg language "${args[--language]}" '
      {items: map({
        title: .name,
        subtitle: ([.type, .description] | map(select(. != null and . != "" and . != "0")) | join(" - ") | gsub("^\\s+|\\s+$"; "")),
        arg: ("https://www.php.net/manual/" + $language + "/" + .id + ".php"),
        uid: .id
      }), cache: {seconds: 86400, loosereload: true}}
    '
  else
    cat
  fi
