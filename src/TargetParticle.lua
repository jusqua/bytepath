local utils = require('src.utils')
local colors = require('src.constants.colors')
local GameObject = require('src.GameObject')

local TargetParticle = GameObject:extend()

function TargetParticle:new(x, y, opts)
  TargetParticle.super.new(self, x, y)

  self.radius = opts.radius or utils.random(2, 3)
  self.color = opts.color or colors.normal.default

  local target_x, target_y = opts.target_x, opts.target_y
  local duration = opts.during or utils.random(0.1, 0.3)

  self.timer:tween(duration, self, { radius = 0, x = target_x, y = target_y }, 'in-out-cubic', function()
    self:die()
  end)
end

function TargetParticle:draw()
  love.graphics.setColor(self.color)
  local size = self.radius * 2
  love.graphics.rectangle('fill', self.x - size / 2, self.y - size / 2, size, size)
  love.graphics.setColor(colors.normal.default)
end

return TargetParticle
