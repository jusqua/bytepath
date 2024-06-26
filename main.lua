local push = require('lib.push.push')
local Input = require('lib.input.input')
local Engine = require('src.Engine')
local constants = require('src.constants')

local engine

function love.load()
  local windowScale = 3
  local virtualWidth, virtualHeight = love.window.getMode()
  local windowWidth, windowHeight = virtualWidth * windowScale, virtualHeight * windowScale

  love.window.setMode(windowWidth, windowHeight)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setLineStyle('rough')
  love.graphics.setColor(constants.default_color)

  push.setupScreen(virtualWidth, virtualHeight, {
    upscale = 'pixel-perfect',
    canvas = true,
  })

  engine = Engine()

  Input.bind_callbacks()
end

function love.update(dt)
  engine:update(dt)

  local escape_pressed, _, _ = Input.pressed('escape')
  if escape_pressed then
    love.event.quit()
  end
end

function love.draw()
  push:start()
  engine:draw()
  push:finish()
end

function love.resize(width, height)
  push.resize(width, height)
end
