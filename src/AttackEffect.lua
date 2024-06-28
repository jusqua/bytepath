local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')
local utils = require('src.utils')

local AttackEffect = GameObject:extend()

function AttackEffect:new(x, y, color)
  AttackEffect.super.new(self, x, y)

  self.width, self.height = 12, 12
  self.color = colors.normal.default
  self.timer:after(0.2, function()
    self.color = color
    self.timer:after(0.35, function()
      self:die()
    end)
  end)

  self.visible = true
  self.timer:after(0.2, function()
    self.timer:every(0.05, function()
      self.visible = not self.visible
    end, 6)
    self.timer:after(0.35, function()
      self.visible = true
    end)
  end)

  self.scale = 1
  self.timer:tween(0.35, self, { scale = 2 }, 'in-out-cubic')
end

function AttackEffect:draw()
  if not self.visible then
    return
  end

  local inner = 1.3 * self.width * self.scale
  local outer = 1.5 * self.width * self.scale

  love.graphics.push()
  utils.rotateAtPosition(self.x, self.y, math.pi / 4)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('line', self.x - outer / 2, self.y - outer / 2, outer, outer)
  love.graphics.setColor(colors.normal.default)
  love.graphics.rectangle('line', self.x - inner / 2, self.y - inner / 2, inner, inner)
  love.graphics.pop()
end

return AttackEffect
