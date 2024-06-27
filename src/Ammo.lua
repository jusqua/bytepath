local GameObject = require('src.GameObject')
local constants = require('src.constants')

local Ammo = GameObject:extend()

function Ammo:new(x, y, area)
  Ammo.super.new(self, x, y)

  self.area = area
  self.width, self.height = 8, 8
  self.collider = area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
  self.collider:setObject(self)
  self.collider:setFixedRotation(false)
  self.angle = love.math.random(0, math.pi * 2)
  self.linearVelocity = love.math.random(10, 20)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
  self.collider:applyAngularImpulse(love.math.random(-24, 24))
end

function Ammo:draw()
  love.graphics.setColor(constants.ammo_color)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.collider:getAngle())
  love.graphics.translate(-self.x, -self.y)
  love.graphics.rectangle('line', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.pop()
  love.graphics.setColor(constants.default_color)
end

return Ammo
