local screen = require 'hs.screen'
local mouseCircle = nil
local mouseCircleTimer = nil

function mouseCenter()
    local frame = screen.primaryScreen():frame()
    local center = {
        x = (frame.w / 2),
        y = (frame.h / 2)
    }

    hs.mouse.setAbsolutePosition(center)

    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end

    mousepoint = hs.mouse.getAbsolutePosition()

    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40, mousepoint.y - 40, 80, 80))
    mouseCircle:setStrokeColor({
        ["red"] = 0,
        ["blue"] = 0,
        ["green"] = 1,
        ["alpha"] = 1
    })
    mouseCircle:setFillColor({
        ["red"] = 81 / 255,
        ["green"] = 187 / 255,
        ["blue"] = 70 / 255,
        ["alpha"] = 0.5
    })
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after a few seconds
    mouseCircleTimer = hs.timer.doAfter(1, function()
        mouseCircle:delete()
        mouseCircle = nil
    end)

end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", mouseCenter)
