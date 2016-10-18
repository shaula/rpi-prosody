-- see example config at https://hg.prosody.im/0.9/file/0.9.10/prosody.cfg.lua.dist
-- easily extendable by putting into different config files within conf.d folder

admins = {};

use_libevent = true; -- improves performance

allow_registration = true;

c2s_require_encryption = true;
s2s_secure_auth = true;

authentication = "internal_hashed";

daemonize = false;

log = {
    {levels = {min = "info"}, to = "console"};
};

Include "conf.d/*.cfg.lua";
