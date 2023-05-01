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

require("keys")
require("rules")
require("signals")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.magnifier,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.fair,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
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

    -- Each screen has its own tag table.
    awful.tag({ "WWW", "2", "3", "4", "POL", "ANI", "7", "8", "9"}, s, awful.layout.layouts[1])
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


-- awful.spawn.once("firefox -P Weeb", {tag = "ANI"})
-- awful.spawn.once("firefox -P Pol",  {tag = "POL"})
awful.spawn.once("firefox -P Main", {tag = "WWW"})
-- awful.spawn.once("alacritty --class popterm --hold --command bat -p "..os.getenv("HOME").."/Desktop/todo.md", {tag = "WWW"})

awful.spawn.with_shell(os.getenv("HOME").."/bin/startup")
