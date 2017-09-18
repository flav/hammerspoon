local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local message = require('status-message')
local windowLayoutMode = require('windowmode')

-- local log = hs.logger.new('supermode.lua', 'debug')

statusMessage = message.new('(^S)uper Duper Mode')

k = hs.hotkey.modal.new('ctrl', 's')


closeAllTheThings = function()
  windowLayoutMode:exit()
  k:exit()
end

function k:entered()
  inWindowMode = false;

  overlayKeyboard = eventtap.new({ eventTypes.keyDown }, function(event)
    local keyPressed = hs.keycodes.map[event:getKeyCode()]
    local modifiersPressed = event:getFlags()

    -- log.d('Event keyboard detected:', hs.inspect(modifiersPressed), keyPressed )

    -- Application launchers
    local applicationLaunchers = {
      ['1'] = "iTerm",
      ['2'] = "Google Chrome",
      ['3'] = "Sublime Text",
      ['4'] = 'TextEdit',
      ['5'] = 'Dash',
      ['6'] = 'Simplenote',
      ['7'] = 'Twitter',
      ['8'] = 'Mail',
      ['0'] = "Slack",
    }
    if applicationLaunchers[keyPressed] then
      hs.application.launchOrFocus(applicationLaunchers[keyPressed])
      closeAllTheThings()
      return true
    end

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

    if keyPressed == 'w' then
      inWindowMode = true
      statusMessage:hide()
      windowLayoutMode:enter()
      return true
    end
    if inWindowMode then
      -- let window mode triggers take over
      return false
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

    -- see how this feels: if a key is hit which is not defined in this mode
    -- we break out of SD mode and carry on
    closeAllTheThings()
    return false
  end):start()

  statusMessage:show()
end

function k:exited()
	overlayKeyboard:stop()
  statusMessage:hide()
end
