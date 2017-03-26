hs.window.animationDuration = 0

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.w = max.w
  f.y = max.y
  f.h = max.h / 2
  win:setFrame(f)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.w = max.w
  f.y = max.y + (max.h / 2)
  f.h = max.h / 2
  win:setFrame(f)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = 0
  f.y = 0
  f.w = max.w/2
  f.h = max.h/2
  win:setFrame(f)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = 0
  f.y = max.h/2
  f.w = max.w/2
  f.h = max.h/2
  win:setFrame(f)
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function hs.window.downRight(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.w/2
  f.y = max.h/2
  f.w = max.w/2
  f.h = max.h/2

  win:setFrame(f)
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function hs.window.upRight(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.w/2
  f.y = 0
  f.w = max.w/2
  f.h = max.h/2
  win:setFrame(f)
end

-- +--------------+
-- |  |        |  |
-- |  |  HERE  |  |
-- |  |        |  |
-- +---------------+
function hs.window.centerWithFullHeight(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.w * 3/32
  f.w = max.w * 26/32
  f.y = max.y
  f.h = max.h * 15/16
  win:setFrame(f)
end

function hs.window.nextScreen(win)
  local currentScreen = win:screen()
  local allScreens = hs.screen.allScreens()
  currentScreenIndex = hs.fnutils.indexOf(allScreens, currentScreen)
  nextScreenIndex = currentScreenIndex + 1

  if allScreens[nextScreenIndex] then
    win:moveToScreen(allScreens[nextScreenIndex])
  else
    win:moveToScreen(allScreens[1])
  end
end


windowLayoutMode = hs.hotkey.modal.new()

local message = require('status-message')
windowLayoutMode.statusMessage = message.new('Window Layout Mode')
windowLayoutMode.entered = function()
  windowLayoutMode.statusMessage:show()
end
windowLayoutMode.exited = function()
  windowLayoutMode.statusMessage:hide()
end

-- =============================================================================
-- =============================================================================
-- =============================================================================

-- local log = hs.logger.new('windowmode.lua', 'debug')

function windowMover (xy, amount)
  return function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    f[xy] = f[xy] + amount
    win:setFrame(f)
  end
end

moveSpeed = 30
moveLeft = windowMover('x', -moveSpeed)
windowLayoutMode:bind('', 'h', nil, moveLeft, moveLeft)

moveDown = windowMover('y', moveSpeed)
windowLayoutMode:bind('', 'j', nil, moveDown, moveDown)

moveUp = windowMover('y', -moveSpeed)
windowLayoutMode:bind('', 'k', nil, moveUp, moveUp)

moveRight = windowMover('x', moveSpeed)
windowLayoutMode:bind('', 'l', nil, moveRight, moveRight)



shrinkLeft = windowMover('w', -moveSpeed)
windowLayoutMode:bind({'shift'}, 'h', nil, shrinkLeft, shrinkLeft)

grownDown = windowMover('h', moveSpeed)
windowLayoutMode:bind({'shift'}, 'j', nil, grownDown, grownDown)

shrinkUp = windowMover('h', -moveSpeed)
windowLayoutMode:bind({'shift'}, 'k', nil, shrinkUp, shrinkUp)

growRight = windowMover('w', moveSpeed)
windowLayoutMode:bind({'shift'}, 'l', nil, growRight, growRight)




windowLayoutMode:bind({'ctrl'}, 'h', function()
  hs.window.focusedWindow():left()
end)
windowLayoutMode:bind({'ctrl'}, 'j', function()
  hs.window.focusedWindow():down()
end)
windowLayoutMode:bind({'ctrl'}, 'k', function()
  hs.window.focusedWindow():up()
end)
windowLayoutMode:bind({'ctrl'}, 'l', function()
  hs.window.focusedWindow():right()
end)


windowLayoutMode:bind({'ctrl'}, 'return', function()
  hs.window.focusedWindow():maximize()
end)
windowLayoutMode:bind({'ctrl'}, 'space', function()
  hs.window.focusedWindow():centerWithFullHeight()
end)



-- =============================================================================
-- =============================================================================
-- =============================================================================

-- Bind the given key to call the given function and exit WindowLayout mode
function windowLayoutMode.bindWithAutomaticExit(mode, key, fn)
  mode:bind({}, key, function()
    -- mode:exit()
    fn()
  end)
end

windowLayoutMode:bindWithAutomaticExit('i', function()
  hs.window.focusedWindow():upLeft()
end)

windowLayoutMode:bindWithAutomaticExit('o', function()
  hs.window.focusedWindow():upRight()
end)

windowLayoutMode:bindWithAutomaticExit(',', function()
  hs.window.focusedWindow():downLeft()
end)

windowLayoutMode:bindWithAutomaticExit('.', function()
  hs.window.focusedWindow():downRight()
end)

windowLayoutMode:bindWithAutomaticExit('n', function()
  hs.window.focusedWindow():nextScreen()
end)


return windowLayoutMode
