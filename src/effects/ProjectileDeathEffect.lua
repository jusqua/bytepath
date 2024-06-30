local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(x, y, size)
  ProjectileDeathEffect.super.new(self, x, y)

  self.size = size

  self.first = true
  self.timer:after(0.1, function()
    self.first = false
    self.second = true
    self.timer:after(0.15, function()
      self.second = false
      self:die()
    end)
  end)
end

function ProjectileDeathEffect:draw()
  if self.second then
    love.graphics.setColor(colors.normal.hp)
  end
  love.graphics.rectangle('fill', self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
  love.graphics.setColor(colors.normal.default)
end

return ProjectileDeathEffect
