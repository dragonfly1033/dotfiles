local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")


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
                     size_hints_honor = false,
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
          "Pcmanfm",
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
      properties = { titlebars_enabled = false, size_hints_honor = false }
    },

    { rule_any = {class = { "popterm-large" }},
      properties = { 
      	floating = true, 
		width = 1500,
		height = 800,
		x = 210,
		y = 140,
      	placement = awful.placement.centered
      }
    },

    { rule_any = {class = { "popterm-medium" }},
      properties = { 
      	floating = true, 
		width = 1000,
		height = 600,
		x = 460,
		y = 240,
      	placement = awful.placement.centered
      }
    },

    { rule_any = {class = { "popterm-small" }},
      properties = { floating = true, placement = awful.placement.centered }
    },

    { rule_any = {class = { "firefox" }},
      properties = { floating = false, maximized = false }
    },

    { rule_any = {class = { "Pragha" }},
	  properties = { 
		floating = true,
		ontop = true, 
		width = 969, 
		height = 981,
		x = 500,
		y = 44, 
		honor_padding = false
	  }
    },

    { rule_any = {class = { "Anki" }},
	  properties = { 
		floating = true,
		ontop = true, 
		width = 1080, 
		height = 630,
		x = 420,
		y = 250, 
		honor_padding = false
	  }
    },

    { rule_any = {class = {"Polybar", "eww-bar"}},
      properties = {
      	border_width = 0,
      	floating = true,
      	tag = "WWW"
      }
    	
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}
