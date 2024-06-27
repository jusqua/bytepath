local GameObject = require('src.GameObject')
local constants = require('src.constants')

local AmmoEffect = GameObject:extend()

function AmmoEffect:new(x, y)
  AmmoEffect.super.new(self, x, y)

  self.width, self.height = 8, 8
  self.color = constants.default_color
  self.timer:after(0.1, function()
    self.color = constants.ammo_color
    self.timer:after(0.15, function()
      self:die()
    end)
  end)
end

function AmmoEffect:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(math.pi / 4)
  love.graphics.translate(-self.x, -self.y)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(constants.default_color)
  love.graphics.pop()
end

return AmmoEffect
