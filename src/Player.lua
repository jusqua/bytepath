local Input = require('lib.input.input')
local Moses = require('lib.moses.moses')
local GameObject = require('src.GameObject')
local ShootEffect = require('src.ShootEffect')
local Projectile = require('src.Projectile')

local Player = GameObject:extend()

function Player:new(x, y, area)
  Player.super.new(self, x, y)

  local radius = 12
  self.width = radius
  self.height = radius
  self.area = area
  self.collider = area.world:newCircleCollider(self.x, self.y, self.width)

  self.angle = -math.pi / 2
  self.angularVelocity = 1.66 * math.pi
  self.linearVelocity = 0
  self.maxLinearVelocity = 100
  self.acceleration = 100

  self.timer:every(0.24, function()
    self:shoot(3, 8, math.pi / 6)
  end)
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

function Player:shoot(amount, offset, theta, attributes)
  self.area:insert(ShootEffect(self.x, self.y, self))

  local angle = self.angle + theta * (amount - 1) / 2
  local delta = offset * (amount - 1) / 2
  for i = 1, amount do
    local attr = Moses.clone(attributes or {})
    attr.area = self.area
    attr.angle = angle - (i - 1) * theta

    local d = self.height * 1.5
    local doff = delta * (i - 1 - (amount - 1) / 2)
    local x = self.x + d * math.cos(self.angle) + doff * math.cos(self.angle - math.pi / 2)
    local y = self.y + d * math.sin(self.angle) + doff * math.sin(self.angle - math.pi / 2)

    self.area:insert(Projectile(x, y, attr))
  end
end

return Player