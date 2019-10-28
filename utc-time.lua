
utcTime = hs.menubar.new()

-- capture the response from `doEvery` so it will not be garbage collected
-- http://www.hammerspoon.org/go/#variablelife
utcTimer = hs.timer.doEvery(1, function ()
  utcTime:setTitle(os.date("!%H:%M Z"))
  utcTime:setTooltip('\n(' .. os.time() .. ')\n')
end)
