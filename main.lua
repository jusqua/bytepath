local push = require('lib.push.push')
local Input = require('lib.input.input')
local Engine = require('src.Engine')
local colors = require('src.constants.colors')

local engine

function love.load()
  local windowScale = 3
  local virtualWidth, virtualHeight = love.window.getMode()
  local windowWidth, windowHeight = virtualWidth * windowScale, virtualHeight * windowScale

  love.window.setMode(windowWidth, windowHeight)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setLineStyle('rough')
  love.graphics.setColor(colors.normal.default)
  love.mouse.setVisible(false)

  push.setupScreen(virtualWidth, virtualHeight, {
    upscale = 'pixel-perfect',
    canvas = true,
  })

  engine = Engine()

  Input.bind_callbacks()
end

function love.update(dt)
  engine:update(dt)
end

function love.draw()
  push:start()
  engine:draw()
  push:finish()
end

function love.resize(width, height)
  push.resize(width, height)
end

function love.textinput(t)
  if engine.scene and engine.scene.textinput then
    engine.scene:textinput(t)
  end
end
