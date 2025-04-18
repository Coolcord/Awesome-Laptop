local wibox = require("wibox")
local awful = require("awful")
 
volumewidget = wibox.widget.textbox()
volumewidget:set_align("right")
 
function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()
 
   local volume = string.match(status, "(%d?%d?%d)%%")
   if volume then
     volume = string.format("% 3d", volume)
     status = string.match(status, "%[(o[^%]]*)%]")

     if string.find(status, "on", 1, true) then
         -- For the volume numbers
         volume = "V:" .. volume .. "%"
     else
         -- For the mute button
         volume = "V:" .. volume .. "M"
     end
   else
     volume = "V: N/A"
   end
   widget:set_markup(volume)
end
 
update_volume(volumewidget)
 
mytimer = timer({ timeout = 2 })
mytimer:connect_signal("timeout", function () update_volume(volumewidget) end)
mytimer:start()

