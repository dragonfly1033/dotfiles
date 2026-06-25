----- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

beautiful.init("~/.config/awesome/theme.lua")

naughty.config.presets.critical.timeout = 0
-- naughty.config.presets.critical.fg = beautiful.fg_urgent
-- naughty.config.presets.critical.bg = beautiful.bg_urgent
naughty.config.presets.critical.fg = "#dddddd"
naughty.config.presets.critical.bg = "#aa0000"


local bling = require("bling")
bling.module.window_swallowing.start()

function notif(...)
    local arg = {...}
    s = ''
    for i = 1, #arg-1 do
        s = s .. tostring(arg[i]) .. ' | '
    end
    s = s .. tostring(arg[#arg])
    naughty.notify({text=tostring(s), position='top_middle', timeout=5})
end

function notif_table(t)
    for k, v in pairs(t) do
      notif(tostring(k) .. ' : ' .. tostring(v))
    end
end

require("scratchpads")
require("keys")
require("rules")
require("signals")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    bling.layout.centered,
    bling.layout.equalarea,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


awful.screen.connect_for_each_screen(function(s)

    for i = 1,9 do
        -- Each screen has its own tag table.
        awful.tag.add(tostring(i+9*(s.index-1)), {
            layout             = awful.layout.layouts[1],
            screen             = s
        })
    end
    s.tags[1]:view_only()
	awful.screen.padding(s, {top=0, bottom=0, left=0, right=0})
end)


-- beautiful.hotkeys_modifiers_fg = "#c02020"

awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false
awful.mouse.drag_to_tag.enabled = false

-- awful.spawn.single_instance("obsidian", 	   {
										-- tag = "OBS",
										-- switch_to_tags = true
										-- }, function (c)
											-- return c.class == "obsidian"
											-- end)


-- awful.spawn.once("firefox -P Weeb", {tag = "7"})
-- awful.spawn.once("firefox -P Pol",  {tag = "8"})
-- awful.spawn.once("firefox -P Main --MOZ_LOG=all:5 --MOZ_LOG_FILE="..os.getenv("HOME").."/moz_log", {tag = "1"})
-- awful.spawn.once("firefox -P Main", {tag = "1"})
-- awful.spawn.once("firefox -P Chill", {tag = "9"})
-- awful.spawn.once("firefox -P Pol", {tag = "8"})

-- awful.spawn.with_line_callback("firefox -P Main", {
--     stdout = function(line)
--         gears.debug.dump( "LINE: "..line )
--     end,
--     stderr = function(line)
--         naughty.notify { text = "ERR: "..line}
--     end
-- })


-- awful.spawn.once("alacritty --class popterm --hold --command bat -p "..os.getenv("HOME").."/Desktop/todo.md", {tag = "1"})


function panic() 
    awful.spawn.with_shell("playerctl -a pause")
    goto_tag(1)
end

awful.spawn.with_shell(os.getenv("HOME").."/bin/startup")