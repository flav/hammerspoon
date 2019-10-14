
utcTime = hs.menubar.new()
hs.timer.doEvery(1, function ()
  utcTime:setTitle(os.date("!%H:%M Z"))
  utcTime:setTooltip('\n(' .. os.time() .. ')\n')
end)
