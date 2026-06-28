<?php
require_once __DIR__ .
    "/script/library/AlfredSFType/AlfredScriptFilterType.php";

const PHP_DOC_SEARCH_INDEX_URL = "https://www.php.net/js/search-index.php";

/** Define a custom error handler to avoid warning messages break result extraction in Alfred */
set_error_handler(function ($severity, $message, $file, $line) {
    if (!(error_reporting() & $severity)) {
        return false;
    }
    fwrite(
        STDERR,
        sprintf("[%s] %s in %s:%d\n", $severity, $message, $file, $line),
    );
    return true;
});

function requestPHPDocsList(?string $lang = "en"): string|false
{
    $url = PHP_DOC_SEARCH_INDEX_URL . "?" . http_build_query(["lang" => $lang]);
    return file_get_contents($url);
}

function getPHPDocsListAlfred(string $locale): AlfredSF|false
{
    $docs = requestPHPDocsList($locale);
    if ($docs) {
        $items = [];
        $docs = json_decode($docs, true);
        echo $docs[0];
        foreach ($docs as $item) {
            $items[] = new AlfredSFItem(
                $item->name,
                // "subtitle" => $item->type . " - " . $item->description,
                // "arg" =>
                //     "https://www.php.net/manual/" .
                //     $locale .
                //     "/" .
                //     $item->name .
                //     ".php",
            );
        }
        return new AlfredSF($items);
    }
    return false;
}
