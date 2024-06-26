local GameObject = require('src.GameObject')

local ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(x, y)
  ExplodeParticle.super.new(self, x, y)

  self.angle = love.math.random(0, math.pi * 2)
  self.linearVelocity = love.math.random(75, 150)
  self.size = love.math.random(2, 3)
  self.lineWidth = 2
  self.timer:tween(
    love.math.random(0.3, 0.5),
    self,
    { linearVelocity = 0, size = 0, lineWidth = 0 },
    'linear',
    function()
      self:die()
    end
  )
end

function ExplodeParticle:update(dt)
  ExplodeParticle.super.update(self, dt)
  self.x = self.x + self.linearVelocity * math.cos(self.angle) * dt
  self.y = self.y + self.linearVelocity * math.sin(self.angle) * dt
end

function ExplodeParticle:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)
  love.graphics.translate(-self.x, -self.y)
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.line(self.x - self.size, self.y, self.x + self.size, self.y)
  love.graphics.setLineWidth(1)
  love.graphics.pop()
end

return ExplodeParticle
