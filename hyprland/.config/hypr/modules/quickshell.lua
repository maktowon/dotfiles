-- quickshell.lua

--------------------
---- QUICKSHELL ----
--------------------

hl.config({
    misc = {
        allow_session_lock_restore = true, -- lets a restarted quickshell re-take a lock if it crashed
    },
})

-- Quickshell bar and its popups open/close instantly
hl.layer_rule({
    name     = "quickshell-no-anim",
    match    = { namespace = "quickshell" },
    no_anim  = true,
})
