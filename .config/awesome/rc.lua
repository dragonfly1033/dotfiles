----- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys = require("awful.hotkeys_popup")
local hotkeys_popup = hotkeys.widget.new(
			{width=550, height=750})
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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/arch/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.magnifier,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
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
    awful.tag({ "WWW", "DEV", "ETC", "ANI", "PRN", "TRM"}, s, awful.layout.layouts[1])

end)

ALT = 'Mod1'

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",  function() hotkeys_popup:show_help() end,
              {description="show help", group="awesome"}),
    awful.key({ ALT,           }, "Tab",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ ALT,   "Shift" }, "Tab",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ ALT,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ ALT,           }, "F11", function (c) c.fullscreen = not c.fullscreen end,
              {description = "go back", group = "tag"}),

    -- Layout manipulation
    awful.key({ modkey,           }, "Up", function ()
            awful.client.swap.bydirection('up') end, {
            description = "swap client up", 
            group = "client"}
    ),
    awful.key({ modkey,           }, "Down", function ()
            awful.client.swap.bydirection('down') end, {
            description = "swap client down", 
            group = "client"}
    ),
    awful.key({ modkey,           }, "Left", function ()
            awful.client.swap.bydirection('left') end, {
            description = "swap client left", 
            group = "client"}
    ),
    awful.key({ modkey,           }, "Right", function ()
            awful.client.swap.bydirection('right') end, {
            description = "swap client right", 
            group = "client"}
    ),


    -- Standard program
    awful.key({ ALT,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

	-- layout manipulation
    awful.key({ ALT,   }, "d",     function () awful.tag.incmwfact( 0.05)     end,
              {description = "increase master width factor", group = "layout"}),
              
    awful.key({ ALT,  }, "a",     function () awful.tag.incmwfact(-0.05)      end,
              {description = "decrease master width factor", group = "layout"}),
              
    awful.key({ ALT,  }, "w",     function () awful.client.incwfact( 0.05)    end,
              {description = "increase height of client", group = "layout"}),
              
    awful.key({ ALT,  }, "s",     function () awful.client.incwfact(-0.05)    end,
              {description = "decrease height of client", group = "layout"}),

    awful.key({ ALT, "Control" }, "w",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
              
    awful.key({ ALT, "Control" }, "s",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
              
    awful.key({ ALT, "Shift"   }, "w",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
              
    awful.key({ ALT, "Shift"   }, "s",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
              
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
              
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    -- Prompt
    awful.key({ ALT },         "x",     function () awful.spawn.with_shell('rofi -show run -sort -i') end,
              {description = "run prompt", group = "launcher"})
)

clientkeys = gears.table.join(
    
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill() end,
              {description = "close", group = "client"}),
              
    awful.key({ ALT,  }, "f",  awful.client.floating.toggle       ,
              {description = "toggle floating", group = "client"}),
              
    awful.key({ ALT, }, "m", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),            
              
    awful.key({ ALT,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag", group = "tag"}),
        -- Move client to tag.
        awful.key({ ALT,  }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag", group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ ALT, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag", group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
		if c.class ~= "Polybar" then
        	c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    end),
    awful.button({ ALT }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ ALT, "Shift" }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)	
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }}, 
      properties = { titlebars_enabled = false }
    },

    { rule = {name = "polybar-example_Virtual-1"},
      properties = {border_width = 0}
    	
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("property::floating", function (c)
	if c.floating then
		c.ontop = true
	else
		c.ontop = false
	end
end)

client.connect_signal("property:minimized", function(c) c.minimized = false end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- beautiful.hotkeys_modifiers_fg = "#c02020"

awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false
awful.mouse.drag_to_tag.enabled = false


awful.spawn.with_shell("/home/arch/scripts/startup.sh")
