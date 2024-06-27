local GameObject = require('src.GameObject')
local constants = require('src.constants')

local BoostEffect = GameObject:extend()

function BoostEffect:new(x, y)
  BoostEffect.super.new(self, x, y)

  self.width, self.height = 12, 12
  self.color = constants.default_color
  self.timer:after(0.2, function()
    self.color = constants.boost_color
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

function BoostEffect:draw()
  if not self.visible then
    return
  end

  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.pi / 4)
  love.graphics.translate(-self.x, -self.y)
  love.graphics.setColor(self.color)
  local inner = self.width
  local outer = 2 * self.width * self.scale
  love.graphics.rectangle('fill', self.x - inner / 2, self.y - inner / 2, inner, inner)
  love.graphics.rectangle('line', self.x - outer / 2, self.y - outer / 2, outer, outer)
  love.graphics.setColor(constants.default_color)
  love.graphics.pop()
end

return BoostEffect
