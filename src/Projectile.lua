local GameObject = require('src.GameObject')

local Projectile = GameObject:extend()

function Projectile:new(x, y, entity, attributes)
  local d = entity and entity.height * 1.5
  local nx = x + d * math.cos(entity.angle)
  local ny = y + d * math.sin(entity.angle)

  Projectile.super.new(self, nx, ny)

  self.attributes = attributes or {}
  self.radius = self.attributes.radius or 2.5
  self.linearVelocity = self.attributes.linearVelocity or 200
  self.angle = entity.angle
  self.collider = entity.area.world:newCircleCollider(self.x, self.y, self.radius)
  self.collider:setObject(self)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
end

function Projectile:update(dt)
  Projectile.super.update(self, dt)

  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )
end

function Projectile:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Projectile:destroy()
  Projectile.super.destroy(self)
end

return Projectile
