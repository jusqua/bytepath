local GameObject = require('src.GameObject')
local constants  = require('src.constants')

local AmmoEffect = GameObject:extend()

function AmmoEffect:new(x, y)
  AmmoEffect.super.new(self, x, y)

  self.width, self.height = 8, 8
  self.alpha = 1
  self.timer:tween(0.5, self, { alpha = 0, width = 12, height = 12 }, 'in-out-quad', function ()
    self:die()
  end)
end

function AmmoEffect:draw()
  local r, g, b = unpack(constants.ammo_color)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.pi / 4)
  love.graphics.translate(-self.x, -self.y)
  love.graphics.setColor(r, g, b, self.alpha)
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(constants.default_color)
  love.graphics.pop()
end

return AmmoEffect
