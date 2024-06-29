local vector = require('lib.hump.vector')
local push = require('lib.push.push')
local colors = require('src.constants.colors')
local GameObject = require('src.GameObject')
local ProjectileDeathEffect = require('src.ProjectileDeathEffect')
local utils = require('src.utils')

local EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(x, y, attributes)
  EnemyProjectile.super.new(self, x, y)

  if attributes then
    for k, v in pairs(attributes) do
      self[k] = v
    end
  end

  self.damage = 10
  self.radius = self.radius or 2.5
  self.linearVelocity = self.linearVelocity or 200
  self.angle = self.angle
  self.color = attributes.color or colors.normal.hp

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
  self.collider:setObject(self)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
  self.collider:setCollisionClass('EnemyProjectile')
end

function EnemyProjectile:update(dt)
  EnemyProjectile.super.update(self, dt)

  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )

  if self.collider:enter('Player') then
    local collisionData = self.collider:getEnterCollisionData('Player')
    local object = collisionData.collider:getObject()
    object:hit(self.damage)
  end

  local ww, wh = push.toGame(love.window.getMode())
  if self.x < 0 or self.y < 0 or self.x > ww or self.y > wh then
    self:die()
  end
end

function EnemyProjectile:draw()
  love.graphics.push()
  utils.rotateAtPosition(self.x, self.y, vector(self.collider:getLinearVelocity()):angleTo())
  love.graphics.setLineWidth(self.radius * 0.75)
  love.graphics.setColor(self.color)
  love.graphics.line(self.x - 2 * self.radius, self.y, self.x + 2 * self.radius, self.y)
  love.graphics.setColor(colors.normal.default)
  love.graphics.setLineWidth(1)
  love.graphics.pop()
end

function EnemyProjectile:destroy()
  EnemyProjectile.super.destroy(self)
end

function EnemyProjectile:die()
  EnemyProjectile.super.die(self)
  self.area:insert(ProjectileDeathEffect(self.x, self.y, self.radius * 3))
end

return EnemyProjectile
