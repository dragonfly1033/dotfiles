function notify_current_track()
    local title = mp.get_property("media-title") or mp.get_property("filename")
    local artist = mp.get_property("metadata/by-key/Artist") or ""

    if artist ~= "" then
        title = artist .. " - " .. title
    end

    os.execute("notify-send 'Now Playing' '" .. title:gsub("'", "\\'") .. "'")
end

mp.register_event("file-loaded", notify_current_track)