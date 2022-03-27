local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local message = require('status-message')
local cheatsheet = require('cheatsheet')
local vscodesheet = require('vscodesheet')

local log = hs.logger.new('supermode.lua', 'debug')

statusMessage = message.new('(^S)uper Duper Mode')

k = hs.hotkey.modal.new('ctrl', 's')
hs.hotkey.bind('ctrl', ';', function()
  k:enter()
end)


closeAllTheThings = function()
  k:exit()
end

function k:entered()

  overlayKeyboard = eventtap.new({ eventTypes.keyDown }, function(event)
    local keyPressed = hs.keycodes.map[event:getKeyCode()]
    local modifiersPressed = event:getFlags()

    -- log.d('Event keyboard detected:', hs.inspect(modifiersPressed), keyPressed )

    if keyPressed == 'c' then
      cheatsheet:show()
      closeAllTheThings()
      return true
    end

    if keyPressed == 'v' then
      vscodesheet:show()
      closeAllTheThings()
      return true
    end

    if keyPressed == '`' then
      hs.reload()
      closeAllTheThings()
      return true
    end

    -- Application launchers
    local applicationLaunchers = {
      ['1'] = "Terminal",
      ['2'] = "Google Chrome",
      ['3'] = "Sublime Text",
      ['4'] = 'TextEdit',
      ['5'] = 'Dash',
      ['6'] = 'Simplenote',
      ['7'] = 'TweetDeck',
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
      {mod='ctrl', key=';'},
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
