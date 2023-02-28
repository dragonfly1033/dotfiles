local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")

client.connect_signal("request::display", function(n) 
	naughty.layout.box { 
		notification = n,
	    widget = {
			        {
			            {
			                text   = 'foobar',
			                widget = wibox.widget.textbox
			            },
			            {
			                {
			                    text   = 'foobar',
			                    widget = wibox.widget.textbox
			                },
			                bg     = '#ff00ff',
			                clip   = true,
			                shape  = gears.shape.rounded_bar,
			                widget = wibox.widget.background
			            },
			            {
			                value         = 0.5,
			                forced_height = 30,
			                forced_width  = 100,
			                widget        = wibox.widget.progressbar
			            },
			            layout = wibox.layout.fixed.vertical,
			        },
	        margins = 10,
	        widget  = wibox.container.margin
	    },
	    border_color = '#00ff00',
	    border_width = 5,
	    placement    = awful.placement.top_left,
	    shape        = gears.shape.rounded_rect,
	    visible      = true,
	} 
end)
