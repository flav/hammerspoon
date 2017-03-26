local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local message = require('status-message')
-- local log = hs.logger.new('supermode.lua', 'debug')

statusMessage = message.new('(^S)uper Duper Mode')

k = hs.hotkey.modal.new('ctrl', 's')

closeAllTheThings = function()
  k:exit()
end

function k:entered()

  overlayKeyboard = eventtap.new({ eventTypes.keyDown }, function(event)
    local keyPressed = hs.keycodes.map[event:getKeyCode()]
    local modifiersPressed = event:getFlags()

    -- log.d('Event keyboard detected:', hs.inspect(modifiersPressed), keyPressed )

    local quitTriggers = {
      {mod='', key='escape'},
      {mod='', key='q'},
      {mod='ctrl', key='s'},
      {mod='ctrl', key='['},
    }
    for k,v in pairs(quitTriggers) do
      if v.key == keyPressed then
        if not (v.mod == nil or v.mod == '') then
          if modifiersPressed[v.mod] then
            closeAllTheThings()
            return true
          end
        else
          closeAllTheThings()
          return true
        end
      end
    end

    local replacements = {
      h = 'left',
      j = 'down',
      k = 'up',
      l = 'right',
    }
    local keystroke = replacements[keyPressed]
    if keystroke then
      event:setKeyCode(hs.keycodes.map[keystroke])
      return false
    end

    -- not special to us - don't emmit the key
    -- TODO: possible alert here - screen flash since no keys will work
    return true
  end):start()

  statusMessage:show()
end

function k:exited()
	overlayKeyboard:stop()
  statusMessage:hide()
end
