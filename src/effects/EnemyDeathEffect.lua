local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(x, y, width, height)
  EnemyDeathEffect.super.new(self, x, y)

  self.width = width
  self.height = height or width

  self.depth = 75
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
  local w, h = self.width * 2, self.height * 2
  love.graphics.rectangle('fill', self.x - w / 2, self.y - h / 2, w, h)
  love.graphics.setColor(colors.normal.default)
end

return EnemyDeathEffect
