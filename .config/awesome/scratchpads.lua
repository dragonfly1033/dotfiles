local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local bling = require("bling")

-- pragha_scratch = bling.module.scratchpad {
--     command = "pragha -x",           -- How to spawn the scratchpad
--     rule = { instance = "spad" },                     -- The rule that the scratchpad will be searched by
--     sticky = true,                                    -- Whether the scratchpad should be sticky
--     autoclose = true,                                 -- Whether it should hide itself when losing focus
--     floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
--     ontop = true,
--     geometry = {x=500, y=44, width=969, height=981}, -- The geometry in a floating state
--     reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
--     dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
-- }
-- 
-- 
-- pavu_scratch = bling.module.scratchpad {
--     command = "alacritty --hold -e calc",           -- How to spawn the scratchpad
--     rule = { instance = "spad" },                     -- The rule that the scratchpad will be searched by
--     sticky = false,                                    -- Whether the scratchpad should be sticky
--     autoclose = true,                                 -- Whether it should hide itself when losing focus
--     floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
--     ontop = true,
--     geometry = {x=550, y=30, width=820, height=1044}, -- The geometry in a floating state
--     reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
--     dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
-- }
-- 
-- pavu_scratch:turn_on()
-- 
-- pavu_scratch:connect_signal("spawn", function (c) naughty.notify({title="on", timeout=1}) end)
-- 
-- 
