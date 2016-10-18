default_storage = "sql"
sql = {
  driver = "SQLite3";
  database = "prosody.sqlite";
}

storage = {
  -- this makes mod_mam use the sql storage backend
  archive2 = "sql";
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"
