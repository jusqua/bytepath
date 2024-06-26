local GameObject = require('src.GameObject')

local TickEffect = GameObject:extend()

function TickEffect:new(x, y, parent)
  TickEffect.super.new(self, x, y)

  self.width, self.height = 48, 32
  self.offset = 0
  self.parent = parent
  self.timer:tween(0.13, self, { height = 0, offset = self.height }, 'in-out-cubic', function()
    self:die()
  end)
end

function TickEffect:update(dt)
  TickEffect.super.update(self, dt)
  if self.parent then
    self.x = self.parent.x
    self.y = self.parent.y - self.offset
  end
end

function TickEffect:draw()
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function TickEffect:destroy()
  TickEffect.super.destroy(self)
  self.parent = nil
end

return TickEffect
