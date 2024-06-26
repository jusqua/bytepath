local GameObject = require('src.GameObject')
local utils = require('src.utils')
local colors = require('src.constants.colors')

local ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(x, y, color)
  ExplodeParticle.super.new(self, x, y)

  self.color = color or colors.normal.default
  self.angle = utils.random(0, math.pi * 2)
  self.linearVelocity = utils.random(75, 150)
  self.size = utils.random(2, 3)
  self.lineWidth = 2
  self.timer:tween(utils.random(0.3, 0.5), self, { linearVelocity = 0, size = 0, lineWidth = 0 }, 'linear', function()
    self:die()
  end)
end

function ExplodeParticle:update(dt)
  ExplodeParticle.super.update(self, dt)
  self.x = self.x + self.linearVelocity * math.cos(self.angle) * dt
  self.y = self.y + self.linearVelocity * math.sin(self.angle) * dt
end

function ExplodeParticle:draw()
  love.graphics.push()
  utils.rotateAtPosition(self.x, self.y, self.angle)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(self.color)
  love.graphics.line(self.x - self.size, self.y, self.x + self.size, self.y)
  love.graphics.setColor(colors.normal.default)
  love.graphics.setLineWidth(1)
  love.graphics.pop()
end

return ExplodeParticle
