local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

require("notif")

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
	if client.focus ~= nil then
		 if client.focus.class ~= "Gpick" then
    		c:emit_signal("request::activate", "mouse_enter", {raise = false})
		end
    end
end)

client.connect_signal("property::floating", function (c)
	if c.floating and c.class ~= "Polybar" and c.class ~= nil then
		c.ontop = true
	else
		c.ontop = false
	end
end)

function polybarTest(c, el)
	return c.class == "Polybar"
end

function ewwTest(c, el)
	return string.sub(c.class, 1, 3) == "eww"
end

function tagContains(table, test)
  for _, client in pairs(table) do
    if test(client) then
      return true
    end
  end
  return false
end

local function set_border(c)
	local s = awful.screen.focused()
	if c.class == nul then c.border_width = 0; return end
    if (c.maximized
        or (#s.tiled_clients == 1 and not c.floating)
        or c.fullscreen
        or polybarTest(c)
        or ewwTest(c))
    then
        c.border_width = 0
    else
        c.border_width = beautiful.border_width
    end
end

local function set_shape(c)
	if c.class == nil then return end
	if not (polybarTest(c) or ewwTest(c)) then
		if c.sticky == true then
			-- c.shape = function (cr) gears.shape.infobubble(cr, c.width, c.height, 0, 20, 0) end
			-- c.shape = function (cr) gears.shape.partially_rounded_rect(cr, c.width, c.height, false, true, true, true, 10) end
			c.shape = function (cr) gears.shape.octogon(cr, c.width, c.height, 30) end
		elseif c.floating == true then
			-- c.shape = function (cr) gears.shape.rounded_rect(cr, c.width, c.height, 10) end
			c.shape = function (cr) gears.shape.rectangle(cr, c.width, c.height) end
		else
			c.shape = function (cr) gears.shape.rectangle(cr, c.width, c.height) end
		end
	end
end

-- tag.connect_signal("property::selected", function (t) if t.selected then naughty.notify({text=t.name}) end end)

client.connect_signal("property::sticky", set_shape)
client.connect_signal("property::floating", set_shape)

client.connect_signal("property::sticky", set_border)
client.connect_signal("property::floating", set_border)
client.connect_signal("request::activate", set_border)

client.connect_signal("property:minimized", function(c) c.minimized = false end)
client.connect_signal("property:maximised", function(c) c.maximised = false end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
