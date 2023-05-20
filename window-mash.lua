-- hs.window.animationDuration = 0
local log = hs.logger.new('supermode.lua', 'debug')

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    moveWindow()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    moveWindow(true)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:fullFrame()

    f.x = max.w * 3 / 32
    f.w = max.w * 26 / 32
    f.y = max.y
    f.h = max.h * 15 / 16
    win:setFrame(f)
end)

moveWindow = function(isRight)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screenSize = win:screen():frame()

    local halfVertScreen = screenSize.w / 2
    local splitPercent = .5

    local addForRight = 0;
    if (isRight) then
        addForRight = halfVertScreen
    end

    -- is half size -- and -- on same side as key
    if f.w == halfVertScreen and f.x == addForRight then

        -- toggle between top quarter or bottom quarter
        if f.h == screenSize.h then
            f.y = screenSize.y
        else
            f.y = (f.y + (screenSize.h * splitPercent) + 1) % screenSize.h
        end

        f.h = screenSize.h * splitPercent
    else

        -- window is loose - bind it to a side
        f.x = (screenSize.x + addForRight)
        f.y = screenSize.y
        f.w = halfVertScreen
        f.h = screenSize.h
    end

    win:setFrame(f)
end
