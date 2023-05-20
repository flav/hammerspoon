local cs = require('cheatsheet')

local utcsheet = cs.new('utc.md')
utcsheet.preProcessMessageText = function(message)
    local messageText = ""
    local i = -2 -- two lines of headers
    local currentHour = tonumber(os.date("%H"))
    local currentTimeCursor = ""
    for str in string.gmatch(message, "([^\n]+)\n") do
        if i == currentHour then
            currentTimeCursor = " <-- " .. os.date("%I:%M %p") .. " / " .. os.date("!%H:%M Z")
        else
            currentTimeCursor = ""
        end
        messageText = messageText .. str .. currentTimeCursor .. "\n"
        i = i + 1
    end
    return messageText
end

return utcsheet
