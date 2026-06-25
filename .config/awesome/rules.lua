local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")


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
                     tag = function (c) return awful.screen.preferred(c).selected_tag end,
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

    { rule_any = {class = { "Tk", "Display", "MEGAsync", "goog", "Min" }}, 
      properties = { floating = true }
    },

    { rule_any = {class = { "Min" }},
      properties = {
      	floating = true,
      	width = 920,
      	height = 750,
      	x = 500,
      	y = 165,
      	screen = awful.screen.preferred,
      	tag = function (c) return awful.screen.preferred(c).selected_tag end,
      	placement = awful.placement.centered
      }
    	
    },


    { rule_any = {class = { "popterm-large" }},
      properties = { 
      	floating = true, 
		width = 1500,
		height = 800,
		x = 210,
		y = 140,
		screen = awful.screen.preferred,
		tag = function (c) return awful.screen.preferred(c).selected_tag end,
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
		screen = awful.screen.preferred,
		tag = function (c) return awful.screen.preferred(c).selected_tag end,
      	placement = awful.placement.centered
      }
    },

    { rule_any = {class = { "popterm-small" }},
      properties = { 
        floating = true, 
        screen = awful.screen.preferred,
        tag = function (c) return awful.screen.preferred(c).selected_tag end,
        placement = awful.placement.centered 
      }
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
		screen = awful.screen.preferred,
        tag = function (c) return awful.screen.preferred(c).selected_tag end,
		screen = awful.screen.preferred,
		honor_padding = false
	  }
	},

    { rule_any = {class = { "pavucontrol" }},
	  properties = { 
		floating = true,
		ontop = true, 
		width = 820, 
		height = 1044,
		x = 550,
		y = 30, 
		screen = awful.screen.preferred,
		tag = function (c) return awful.screen.preferred(c).selected_tag end,
		screen = awful.screen.preferred,
		honor_padding = false
	  } 
    },

    { rule_any = {class = {"Polybar", "eww-bar"}},
      properties = {
      	border_width = 0,
      	floating = true,
      	tags = {"1", "10"}
      }
    	
    },

    { rule_any = {name = {"message"}},
      properties = {
      	border_width = 5,
      	screen = awful.screen.preferred,
      	tag = function (c) return awful.screen.preferred(c).selected_tag end,
      	placement = awful.placement.centered
      }
    	
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}
