local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local HeathPointEffect = GameObject:extend()

function HeathPointEffect:new(x, y)
  HeathPointEffect.super.new(self, x, y)

  self.width, self.height = 12, 12
  self.color = colors.normal.default
  self.timer:after(0.2, function()
    self.color = colors.normal.hp
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

  self.outer_scale = 1
  self.inner_scale = 1
  self.timer:tween(0.35, self, { inner_scale = 1.2, outer_scale = 1.8 }, 'in-out-cubic')
end

function HeathPointEffect:draw()
  if not self.visible then
    return
  end

  love.graphics.setColor(self.color)
  local inner_width, inner_height = self.width * self.inner_scale, 0.3 * self.height * self.inner_scale
  love.graphics.rectangle('fill', self.x - inner_width / 2, self.y - inner_height / 2, inner_width, inner_height)
  love.graphics.rectangle('fill', self.x - inner_height / 2, self.y - inner_width / 2, inner_height, inner_width)
  love.graphics.setColor(colors.normal.default)
  love.graphics.circle('line', self.x, self.y, self.width * self.outer_scale)
end

return HeathPointEffect
