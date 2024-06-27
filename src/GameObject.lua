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
  self.collider = nil
  self.depth = 50
  self.createdAt = love.timer.getTime()
end

function GameObject:update(dt)
  if self.timer then
    self.timer:update(dt)
  end
  if self.collider then
    self.x, self.y = self.collider:getPosition()
  end
end

function GameObject:destroy()
  self.timer = nil

  if self.collider then
    self.collider:destroy()
  end

  self.collider = nil
end

function GameObject:draw() end

function GameObject:die()
  self.alive = false
end

return GameObject
