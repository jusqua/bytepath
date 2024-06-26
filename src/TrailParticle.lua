local GameObject = require('src.GameObject')
local constants = require('src.constants')

local TrailParticle = GameObject:extend()

function TrailParticle:new(x, y, radius, duration, color)
  TrailParticle.super.new(self, x, y)

  self.radius = radius or love.math.random(4, 6)
  self.color = color or constants.default_color

  self.timer:tween(duration or love.math.random(0.3, 0.5), self, { radius = 0 }, 'linear', function()
    self:die()
  end)
end

function TrailParticle:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.x, self.y, self.radius)
  love.graphics.setColor(constants.default_color)
end

function TrailParticle:destroy()
  TrailParticle.super.destroy(self)
  self.parent = nil
end

return TrailParticle
