default_storage = "sql"
sql = {
  driver = "SQLite3";
  database = "prosody.sqlite";
}

-- make 0.10-distributed mod_mam use sql store
archive_store = "archive2" -- Use the same data store as prosody-modules mod_mam

storage = {
  -- this makes mod_mam use the sql storage backend
  archive2 = "sql";
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"
