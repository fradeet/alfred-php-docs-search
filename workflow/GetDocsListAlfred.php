<?php
require_once __DIR__ . "/AlfredAdapter.php";

$docs = getPHPDocsListAlfred(getenv("DOC_LANG") ?: "en");
echo json_encode($docs, JSON_UNESCAPED_UNICODE);
