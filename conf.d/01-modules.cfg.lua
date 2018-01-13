plugin_paths = { "/usr/local/lib/prosody/custom-modules/" };

modules_enabled = {
    -- Generally required
    "roster"; -- Allow users to have a roster. Recommended ;)
    "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
    "tls"; -- Add support for secure TLS on c2s/s2s connections
    "dialback"; -- s2s dialback support
    "disco"; -- Service discovery

    -- Not essential, but recommended
    "blocklist"; -- simple modern protocol for blocking remote JIDs (XEP-0191)
    "private"; -- Private XML storage (for room bookmarks, etc.)
    "vcard"; -- Allow users to set vCards

    -- These are commented by default as they have a performance impact
    --"compression"; -- Stream compression (Debian: requires lua-zlib module to work)

    -- Nice to have
    "version"; -- Replies to server version requests
    "uptime"; -- Report how long server has been running
    "time"; -- Let others know the time here on this server
    "ping"; -- Replies to XMPP pings with pongs
    "pep"; -- Enables users to publish their mood, activity, playing music and more
    "register"; -- Allow users to register on this server using a client and change passwords

    -- Admin interfaces
    "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
    --"admin_telnet"; -- Opens telnet console interface on localhost port 5582

    -- HTTP modules
    --"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    --"http_files"; -- Serve static files from a directory over HTTP

    -- Other specific functionality
    "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
    --"groups"; -- Shared roster support
    --"announce"; -- Send announcement to all online users
    --"welcome"; -- Welcome users who register accounts
    --"watchregistrations"; -- Alert admins of registrations
    --"motd"; -- Send a message to users when they log in
    --"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
};

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "offline"; -- Store offline messages
    -- "c2s"; -- Handle client connections
    -- "s2s"; -- Handle server-to-server connections
};
