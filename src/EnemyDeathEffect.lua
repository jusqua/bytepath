local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(x, y, width, height)
  EnemyDeathEffect.super.new(self, x, y)

  self.width = width
  self.height = height

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

function EnemyDeathEffect:draw()
  if self.second then
    love.graphics.setColor(colors.normal.hp)
  end
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(colors.normal.default)
end

return EnemyDeathEffect
