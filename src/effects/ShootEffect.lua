local GameObject = require('src.GameObject')
local utils = require('src.utils')

local ShootEffect = GameObject:extend()

function ShootEffect:new(x, y, entity)
  local d = entity and entity.height * 1.2 or 0
  local angle = entity and entity.angle or 0
  local nx = x + d * math.cos(angle)
  local ny = y + d * math.sin(angle)

  ShootEffect.super.new(self, nx, ny)

  self.entity = entity
  self.d = d
  self.side = 8

  self.timer:tween(0.1, self, { side = 0 }, 'in-out-cubic', function()
    self.alive = false
  end)
end

function ShootEffect:update(dt)
  ShootEffect.super.update(self, dt)

  if self.entity then
    self.x = self.entity.x + self.d * math.cos(self.entity.angle)
    self.y = self.entity.y + self.d * math.sin(self.entity.angle)
  end
end

function ShootEffect:draw()
  love.graphics.push()
  if self.entity then
    utils.rotateAtPosition(self.x, self.y, self.entity.angle + math.pi / 4)
  end
  love.graphics.rectangle('fill', self.x - self.side / 2, self.y - self.side / 2, self.side, self.side)
  love.graphics.pop()
end

function ShootEffect:destroy()
  ShootEffect.super.destroy(self)
end

return ShootEffect
