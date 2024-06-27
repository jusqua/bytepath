local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local TrailParticle = GameObject:extend()

function TrailParticle:new(x, y, opts)
  TrailParticle.super.new(self, x, y)

  self.radius = opts.radius or love.math.random(2, 4)
  self.color = opts.color or colors.normal.default

  self.timer:tween(opts.duration or love.math.random(0.15, 0.25), self, { radius = 0 }, 'in-cubic', function()
    self:die()
  end)
end

function TrailParticle:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.x, self.y, self.radius)
  love.graphics.setColor(colors.normal.default)
end

function TrailParticle:destroy()
  TrailParticle.super.destroy(self)
  self.parent = nil
end

return TrailParticle
