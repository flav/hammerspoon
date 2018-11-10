
local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local drawing = require 'hs.drawing'
local screen = require 'hs.screen'
local styledtext = require 'hs.styledtext'
local log = hs.logger.new('cheatsheet.lua', 'debug')


local cheatsheet = {}

cheatsheet.new = function()
  local buildParts = function()
    local frame = screen.primaryScreen():frame()
    local messageText = io.open("cheatsheet.txt", "r"):read('*all')

    local styledTextAttributes = {
      font = { name = 'Monaco', size = 24 },
      color = { red = 0, green = 1, blue = 0, alpha=1 }
    }

    local styledText = styledtext.new(messageText, styledTextAttributes)

    local styledTextSize = drawing.getTextDrawingSize(styledText)
    local textRect = {
      x = (frame.w / 2) - (styledTextSize.w / 2) - 20,
      y = (frame.h / 2) - (styledTextSize.h / 2),
      w = ((frame.w * (15/16)) / 2) - 40, -- styledTextSize.w + 40,
      h = styledTextSize.h + 40,
    }
    local text = drawing.text(textRect, styledText) -- :setAlpha(0.9)

    local background = drawing.rectangle(
      {
        x = frame.w * (1/32),
        y = frame.h * (1/32),
        w = frame.w * (15/16),
        h = frame.h * (15/16)

      }
    )
    background:setRoundedRectRadii(10, 10)
    background:setFillColor({ red = 0, green = 0, blue = 0, alpha=0.9 })

    return background, text
  end

  return {
    _buildParts = buildParts,
    _keyboard = nil,
    show = function(self)
      self:hide()

      self.background, self.text = self._buildParts()
      self.background:show()
      self.text:show()

      self._keyboard = eventtap.new({ eventTypes.keyDown }, function(event)
          local keyPressed = hs.keycodes.map[event:getKeyCode()]
          self:hide()
          return true
      end):start()

    end,
    hide = function(self)
      if self._keyboard then
        self._keyboard:stop()
      end

      if self.background then
        self.background:delete()
        self.background = nil
      end
      if self.text then
        self.text:delete()
        self.text = nil
      end

    end
  }
end

return cheatsheet.new()
