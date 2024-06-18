local Object = require('lib.classic.classic')
local M = require('lib.moses.moses')
local Timer = require('lib.hump.timer')

local GameObject = Object:extend()

function GameObject:new(x, y)
  self.x = x or 0
  self.y = y or 0

  self.alive = true
  self.id = M.uid()
  self.timer = Timer()
end

function GameObject:update(dt)
  if self.timer then
    self.timer:update(dt)
  end
end

function GameObject:draw() end

return GameObject
