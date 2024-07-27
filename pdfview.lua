local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local log = hs.logger.new('pdfview.lua', 'debug')
-- lod.d("log message")

local script_path = function()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

local pdfview = {}

pdfview.new = function(cheatFile)
	local pdfFile = script_path() .. cheatFile
	local buildParts = function(self, pdfFile)
		-- https://www.hammerspoon.org/docs/hs.screen.html#mainScreen
		-- local frame = screen.mainScreen():frame()
		local frame = hs.mouse.getCurrentScreen():frame()

		local x = frame.x + frame.w * (1 / 32)
		local w = frame.w * (15 / 16)
		local y = frame.y + frame.h * (1 / 32)
		local h = frame.h * (15 / 16)

		local wv = hs.webview.new(
			hs.geometry.rect(x, y, w, h),
			{
				javaScriptEnabled = false,
				javaScriptCanOpenWindowsAutomatically = false,
				developerExtrasEnabled = false
			}
		)

		wv:allowMagnificationGestures(true)
		wv:allowTextEntry(true)
		wv:allowNewWindows(false)
		wv:allowGestures(true)
		wv:closeOnEscape(true)
		wv:deleteOnClose(true)
		wv:shadow(true)
		wv:transparent(false) -- eliminate body bgcolor css
		wv:windowStyle(31) -- hs.webview.windowMasks
		wv:level(3)     -- hs.drawing.windowLevels

		-- https://developer.apple.com/documentation/appkit/nswindow/collectionbehavior
		wv:behaviorAsLabels({
			'ignoresCycle',
			'moveToActiveSpace'
		})
		-- wv:url('file:///Users/flav/Dropbox/configs/hammerspoon/keyboard-shortcuts-macos.pdf')
		wv:url("file://" .. pdfFile)

		return wv
	end

	return {
		_buildParts = buildParts,
		_keyboard = nil,
		show = function(self)
			self:hide()

			self.webview = self:_buildParts(pdfFile)
			self.webview:show()

			self._keyboard = eventtap.new({ eventTypes.keyDown }, function(event)
				local keyPressed = hs.keycodes.map[event:getKeyCode()]

				if keyPressed == 'escape' then
					self:hide()
				end

				return true
			end):start()
		end,
		hide = function(self)
			if self._keyboard then
				self._keyboard:stop()
			end

			if self.webview then
				self.webview:delete()
				self.webview = nil
			end
		end
	}
end

return pdfview
