local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
require("scratchpads")
local beautiful = require("beautiful")
local hotkeys = require("awful.hotkeys_popup")
local hotkeys_popup = hotkeys.widget.new(
			{width=550, height=750})


function eww_show_toggle(name, variable)
	if variable then
		variable = false
		awful.spawn("eww close "..name)
	else
		variable = true
		awful.spawn("eww open "..name)
	end
	return variable
end

ALT = 'Mod1'
modkey = "Mod4"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
poptermS = "alacritty --class popterm-small"
poptermM = "alacritty --class popterm-medium"
poptermL = "alacritty --class popterm-large"
file_manager = "pcmanfm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

bar_state = false
bar_auto = true
toggles_menu_state = false
power_menu_state = false

tag_notification = nil

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

    awful.key({ ALT,   "Shift"  }, "g", function () 
    										if awful.screen.focused().selected_tag.gap ~= 0 then
    											awful.screen.focused().selected_tag.gap = 0
											else
    											awful.screen.focused().selected_tag.gap = beautiful.useless_gap
											end
    									end,
              {description = "toggle gaps", group = "layout"}),

    -- Standard program
    awful.key({ ALT,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
              
    awful.key({ ALT,  "Shift"  }, "Return", function () awful.spawn(poptermM) end,
              {description = "open a floating terminal", group = "scratch"}),
    awful.key({ ALT,  "Shift"  }, "m", function () awful.spawn('pragha -x') end,
              {description = "Pragha popup", group = "scratch"}),
    awful.key({ ALT,  "Shift"  }, "c", function () awful.spawn(poptermS.." --hold -e calc") end,
              {description = "Calculator popup", group = "scratch"}),
    awful.key({ ALT,  "Shift"   }, "h", function () awful.spawn(poptermL.." -e btop") end,
              {description = "btop prompt", group = "scratch"}),
    awful.key({ ALT,  "Shift"   }, "p", function () awful.spawn('pavucontrol') end,
              {description = "pavucontrol", group = "scratch"}),
    awful.key({ ALT,  "Shift"   }, "t", function () toggles_menu_state = eww_show_toggle("toggles", toggles_menu_state) end,
              {description = "toggles", group = "scratch"}),    
    awful.key({ ALT,  "Shift"   }, "l", function () power_menu_state = eww_show_toggle("power_menu", power_menu_state) end,
              {description = "power menu", group = "scratch"}),
              
    awful.key({ ALT,           }, "e", function () awful.spawn(file_manager) end,
              {description = "open file manager", group = "launcher"}),
    awful.key({ ALT,           }, "v", function () awful.spawn("snippets") end,
              {description = "snippets prompt", group = "launcher"}),
    awful.key({ ALT,           }, "g", function () awful.spawn("search") end,
              {description = "search prompt", group = "launcher"}),
              
    awful.key({ modkey, "Control" }, "r", function () awful.spawn("awesome_restart") end,
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


    awful.key({ ALT, "Shift" }, "w",     function () 
    									c = client.focus
    									if c == nil then return end
    									geom = c:geometry()
    									
										if client.focus.floating then
											c:geometry({
												x = geom.x,
												y = 0,
												width = geom.width,
												height = geom.y + geom.height
											})
										end
    							  end,
              {description = "stick top of window to top of screen", group = "layout"}),

    awful.key({ ALT, "Shift" }, "a",     function () 
    									c = client.focus
    									if c == nil then return end
    									geom = c:geometry()
    									    
										if client.focus.floating then
											c:geometry({
												x = 0,
												y = geom.y,
												width = geom.x + geom.width,
												height = geom.height
											})
										end
    							  end,
              {description = "stick left of window to left of screen", group = "layout"}),

    awful.key({ ALT, "Shift" }, "s",     function () 
    									c = client.focus
    									if c == nil then return end
    									geom = c:geometry()
    									    
										if client.focus.floating then
											c:geometry({
												x = geom.x,
												y = geom.y,
												width = geom.width,
												height = 1080 - geom.y
											})
										end
    							  end,
              {description = "stick bottom of window to bottom of screen", group = "layout"}),

    awful.key({ ALT, "Shift" }, "d",     function () 
    									c = client.focus
    									if c == nil then return end
    									geom = c:geometry()
    									    
										if client.focus.floating then
											c:geometry({
												x = geom.x,
												y = geom.y,
												width = 1920 - geom.x,
												height = geom.height
											})
										end
    							  end,
              {description = "stick right of window to right of screen", group = "layout"}),                        
              

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

--     awful.key({ modkey,           }, "n", function () 
--     												local screen = awful.screen.focused()
--     												local tags = screen.tags
--     												local lenTags = #tags
--     												local curIndex = screen.selected_tag.index
-- 
--     												awful.tag.add(tostring(lenTags+1), {
--     														screen=screen,
--     														layout=awful.layout.suit.tile, 
--     														volatile=true, 
--     														index=curIndex+1
--     												}) 
--     											end,
--               {description = "new tag", group = "tag"}),
              
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    -- Prompt
    awful.key({ ALT },         "x",     function () awful.spawn.with_shell('rofi -show run -sort -i') end,
              {description = "run prompt", group = "launcher"}),    

    awful.key({ ALT },         "b",     function () 
    										if bar_status then
    											awful.spawn.with_shell('polybar-msg cmd hide') 
    											bar_status = false
    											bar_auto = true
    										else
    											awful.spawn.with_shell('polybar-msg cmd show') 
    											bar_status = true
    											bar_auto = false   											
    										end
    									end,
              {description = "toggle bar", group = "launcher"})
)

function auto_bar_handler()
	if bar_auto then
		if mouse.coords().y <= 2 then
			awful.spawn("polybar-msg cmd show", false)
			bar_status = true
		else
			awful.spawn("polybar-msg cmd hide", false)
			bar_status = false
		end	
	end	
end

function tag_notify(t) 
	if t.selected and not bar_status then  
		if tag_notification == nil then
			tag_notification = naughty.notify({
				text=t.name,
				position="top_middle",
				timeout=0.5,
				height = 100,
				font="Fira Code Bold 48",
				border_width=10,
				margin=20,
				destroy=function() tag_notification = nil end
			}) 
		else
			naughty.replace_text(tag_notification, t.name, "")
			naughty.reset_timeout(tag_notification, 0.5)
		end
	end
end 

todo_timer = gears.timer({
	timeout = 0.2,
	call_now = true,
	autostart = true,
	callback = auto_bar_handler
})

tag.connect_signal("property::selected", function (t) tag_notify(t) end)

-- polybar_hide = {}
-- 
-- for i=1,#awful.screen.focused().tags do
-- 	polybar_hide[i] = false
-- end
-- 
-- function handle_polybar(tag)
-- 	if polybar_hide[tag.index] then
-- 		awful.spawn("polybar-msg cmd hide")
-- 	else
-- 		awful.spawn("polybar-msg cmd show")
-- 	end	
-- end

clientkeys = gears.table.join(
    
    awful.key({ modkey, "Shift"   }, "c",      function (c) 
    												if c.name ~= "Pragha Music Player" then 
    													c:kill() 
    												else
    													awful.spawn("pragha -x")
    												end 
    											end,
              {description = "close (except scratchpads)", group = "client"}),
              
    awful.key({ modkey, "Control", "Shift"   }, "c",      function (c) c:kill() end,
              {description = "close", group = "client"}),          
    awful.key({ ALT,  }, "f",  awful.client.floating.toggle       ,
              {description = "toggle floating", group = "client"}),

    awful.key({ ALT }, "m",  function (c) 
    							c.maximized = not c.maximized 
    							-- polybar_hide[c.first_tag.index] = c.maximized
    							-- handle_polybar(awful.screen.focused().selected_tag)
    						end,
              {description = "toggle maximized", group = "client"}),          

    awful.key({ ALT, "Control" }, "m", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),            
              
    awful.key({ ALT,           }, "p",      function (c) 
    											if c.sticky then
    												c:move_to_tag(awful.screen.focused().selected_tag)
    											end
    											c.sticky = not c.sticky 
    										end,
              {description = "toggle pin", group = "client"}),

    awful.key({ ALT,           }, "F11", function (c) c.fullscreen = not c.fullscreen end,
              {description = "toggle fullscreen", group = "client"}),

	awful.key({ ALT,           }, "`", 
				function (c)  
					local screen = awful.screen.focused()
					local tags = screen.tags
					local tag = screen.selected_tag.index
					-- for i=#tags,tag+1,-1 do -- for last free
					for i=tag+1,#tags,1 do -- for next free
						if #tags[i]:clients() == 0 then
							c:move_to_tag(tags[i])
							return
						end
					end
				end,
              {description = "move client to next free tag", group = "client"}),

	awful.key({ ALT,  "Shift"  }, "`", 
				function (c)  
					local screen = awful.screen.focused()
					local tags = screen.tags
					local tag = screen.selected_tag.index
					-- for i=1,tag-1 do -- for first free
					for i=tag-1,1,-1 do -- for prev free
						if #tags[i]:clients() == 0 then
							c:move_to_tag(tags[i])
							return
						end
					end
				end,
              {description = "move client to prev free tag", group = "client"})

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
