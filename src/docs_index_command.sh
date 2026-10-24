curl -sG 'https://www.php.net/js/search-index.php' \
  --data-urlencode "lang=${args[--language]}" |
  if [[ "${args[--output-format]}" == alfred ]]; then
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
