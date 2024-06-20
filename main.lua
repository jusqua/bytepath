local Camera = require('lib.hump.camera')
local push = require('lib.push.push')
local Input = require('lib.input.input')
local Engine = require('src.Engine')
local M = require('src.utils')

local VIRTUAL_WIDTH, WIDTH, VIRTUAL_HEIGHT, HEIGHT, WINDOW_SCALE
local engine, camera

function love.load()
  VIRTUAL_WIDTH, VIRTUAL_HEIGHT, _ = love.window.getMode()
  WINDOW_SCALE = 3
  WIDTH, HEIGHT = VIRTUAL_WIDTH * WINDOW_SCALE, VIRTUAL_HEIGHT * WINDOW_SCALE

  love.window.setMode(WIDTH, HEIGHT)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setLineStyle('rough')
  push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'pixel-perfect', canvas = true })

  engine = Engine()
  camera = Camera()

  Input.bind_callbacks()
end

function love.update(dt)
  engine:update(dt)

  camera:lockPosition(WIDTH / 2, HEIGHT / 2, Camera.smooth.damped(5))

  local escape_pressed, _, _ = Input.pressed('escape')
  if escape_pressed then
    love.event.quit()
  end

  local s_pressed, _, _ = Input.pressed('s')
  if s_pressed then
    M.shake(camera, engine.timer, 4, 60, 1)
  end
end

function love.draw()
  push:start()
  camera:attach()

  engine:draw()

  camera:detach()
  push:finish()
end

function love.resize(width, height)
  push.resize(width, height)
end
