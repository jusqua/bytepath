local vector = require('lib.hump.vector')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.ExplodeParticle')
local colors = require('src.constants.colors')
local AmmoEffect = require('src.AmmoEffect')

local Ammo = GameObject:extend()

function Ammo:new(x, y, scene)
  Ammo.super.new(self, x, y)

  self.player = scene.player
  self.area = scene.area
  self.width, self.height = 8, 8
  self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
  self.collider:setObject(self)
  self.collider:setFixedRotation(false)
  self.angle = love.math.random(0, math.pi * 2)
  self.linearVelocity = love.math.random(10, 20)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
  self.collider:applyAngularImpulse(love.math.random(-24, 24))
  self.collider:setCollisionClass('Collectable')
end

function Ammo:update(dt)
  Ammo.super.update(self, dt)

  local target = self.player
  if target then
    local projectile_heading = vector(self.collider:getLinearVelocity()):normalized()
    local angle = math.atan2(target.y - self.y, target.x - self.x)
    local to_target_heading = vector(math.cos(angle), math.sin(angle)):normalized()
    local final_heading = (projectile_heading + 0.1 * to_target_heading):normalized()
    self.collider:setLinearVelocity(self.angle * final_heading.x, self.angle * final_heading.y)
  else
    self.collider:setLinearVelocity(
      self.linearVelocity * math.cos(self.angle),
      self.linearVelocity * math.sin(self.angle)
    )
  end
end

function Ammo:draw()
  love.graphics.setColor(colors.normal.ammo)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.collider:getAngle())
  love.graphics.translate(-self.x, -self.y)
  love.graphics.rectangle('line', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.pop()
  love.graphics.setColor(colors.normal.default)
end

function Ammo:die()
  Ammo.super.die(self)
  self.area:insert(AmmoEffect(self.x, self.y))
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, colors.normal.ammo))
  end
end

return Ammo
