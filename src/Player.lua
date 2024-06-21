local Input = require('lib.input.input')
local GameObject = require('src.GameObject')

local Player = GameObject:extend()

function Player:new(x, y, world)
  Player.super.new(self, x, y)

  local radius = 12
  self.width = radius
  self.height = radius
  self.collider = world:newCircleCollider(self.x, self.y, self.width)

  self.angle = -math.pi / 2
  self.angularVelocity = 1.66 * math.pi
  self.linearVelocity = 0
  self.maxLinearVelocity = 100
  self.acceleration = 100
end

function Player:update(dt)
  Player.super.update(self, dt)

  if select(1, Input.down('left')) then
    self.angle = self.angle - self.angularVelocity * dt
  end
  if select(1, Input.down('right')) then
    self.angle = self.angle + self.angularVelocity * dt
  end

  self.linearVelocity = math.min(self.linearVelocity + self.acceleration * dt, self.maxLinearVelocity)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
end

function Player:draw()
  love.graphics.circle('line', self.x, self.y, self.width)
end

return Player
