local domain = os.getenv("DOMAIN")

ssl = {
	key = "/usr/local/etc/prosody/certs/prosody.key";
	certificate = "/usr/local/etc/prosody/certs/prosody.crt";
}

VirtualHost (domain)

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers
Component ("proxy." .. domain) "proxy65"
	proxy65_address = domain
	proxy65_acl = { domain }

Component ("upload." .. domain) "http_upload"
	http_host = domain
	http_upload_file_size_limit = 10 * 1024 * 1024

Component ("muc." .. domain) "muc"
	name = "Prosody Chatrooms"
	restrict_room_creation = false
	max_history_messages = 1000
	modules_enabled = {
		"muc_mam";
	}
	muc_log_expires_after = "1y"
	muc_log_cleanup_interval = 4 * 60 * 60

