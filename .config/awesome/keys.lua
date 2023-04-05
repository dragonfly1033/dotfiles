local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local hotkeys = require("awful.hotkeys_popup")
local hotkeys_popup = hotkeys.widget.new(
			{width=550, height=750})

ALT = 'Mod1'
modkey = "Mod4"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
popterm = "alacritty --class popterm"
file_manager = "pcmanfm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

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


    -- Standard program
    awful.key({ ALT,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ ALT,  "Shift"  }, "Return", function () awful.spawn(popterm) end,
              {description = "open a floating terminal", group = "launcher"}),
    awful.key({ ALT,           }, "e", function () awful.spawn(file_manager) end,
              {description = "open file manager", group = "launcher"}),
    awful.key({ ALT,           }, "c", function () awful.spawn("snippets") end,
              {description = "snippets prompt", group = "launcher"}),
              
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

    awful.key({ modkey,           }, "n", function () 
    												local screen = awful.screen.focused()
    												local tags = screen.tags
    												local lenTags = #tags
    												local curIndex = screen.selected_tag.index

    												awful.tag.add(tostring(lenTags+1), {
    														screen=screen,
    														layout=awful.layout.suit.tile, 
    														volatile=true, 
    														index=curIndex+1
    												}) 
    											end,
              {description = "new tag", group = "layout"}),
              
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

    awful.key({ ALT, "Shift" }, "m",  function (c) c.maximised = not c.maximised end,
              {description = "toggle maximised", group = "client"}),          

    awful.key({ ALT, }, "m", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),            
              
    awful.key({ ALT,           }, "p",      function (c) c.sticky = not c.sticky end,
              {description = "toggle pin", group = "client"}),

    awful.key({ ALT,           }, "F11", function (c) c.fullscreen = not c.fullscreen end,
              {description = "toggle fullscreen", group = "client"})

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
