local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local ProjectileDeathEffect = require('src.ProjectileDeathEffect')

local Projectile = GameObject:extend()

function Projectile:new(x, y, attributes)
  Projectile.super.new(self, x, y)

  if attributes then
    for k, v in pairs(attributes) do
      self[k] = v
    end
  end

  self.radius = self.radius or 2.5
  self.linearVelocity = self.linearVelocity or 200
  self.angle = self.angle

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.radius)
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

  local ww, wh = push.toGame(love.window.getMode())
  if self.x < 0 or self.y < 0 or self.x > ww or self.y > wh then
    self:die()
  end
end

function Projectile:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Projectile:destroy()
  Projectile.super.destroy(self)
end

function Projectile:die()
  Projectile.super.die(self)
  self.area:insert(ProjectileDeathEffect(self.x, self.y, self.radius * 3))
end

return Projectile
