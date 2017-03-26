
-- Use Control+` to reload Hammerspoon config
hs.hotkey.bind({'ctrl'}, '`', nil, function()
  hs.reload()
end)


local weather = require("hs-weather")
weather.start({
  geolocation= false,
  location="Ann Arbor, MI",
  refresh=1800,
  units="F"
})


require("mouseinthemiddle")

require("supermode")

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()
