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


-- Set up a http file upload because proxy65 is not working in muc
-- Component (domain) "http_upload"
-- is set-up via modules_enabled
