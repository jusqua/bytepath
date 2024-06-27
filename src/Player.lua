local Input = require('lib.input.input')
local Moses = require('lib.moses.moses')
local GameObject = require('src.GameObject')
local ShootEffect = require('src.ShootEffect')
local Projectile = require('src.Projectile')
local ExplodeParticle = require('src.ExplodeParticle')
local utils = require('src.utils')
local TickEffect = require('src.TickEffect')
local colors = require('src.constants.colors')
local ships = require('src.ships')
local Ammo = require('src.Ammo')
local Boost = require('src.Boost')

local Player = GameObject:extend()

function Player:new(x, y, engine, area)
  Player.super.new(self, x, y)

  self.engine = engine
  self.area = area

  self:attach(ships[1](self))

  self.angle = -math.pi / 2
  self.angularVelocity = 1.66 * math.pi
  self.linearVelocity = 0
  self.baseMaxLinearVelocity = 100
  self.maxLinearVelocity = self.baseMaxLinearVelocity
  self.acceleration = 100
  self.trail_color = colors.normal.skill_point

  self.maxAmmo = 100
  self.ammo = self.maxAmmo
  self.maxHP = 100
  self.hp = self.maxHP
  self.maxBoost = 100
  self.boost = self.maxBoost

  self.boosting = false
  self.can_boost = true
  self.boost_timer = 0
  self.boost_cooldown = 2

  self.timer:every(0.24, function()
    self:shoot()
  end)

  self.timer:every(5, function()
    self:tick()
  end)

  self.timer:every(0.01, function()
    local trails = self.ship:trails()

    for _, trail in ipairs(trails) do
      self.area:insert(trail)
    end
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

  self:changeBoostBy(10 * dt)
  self.boosting = false
  self.trail_color = colors.normal.skill_point

  self.boost_timer = self.boost_timer + dt
  if self.boost_timer >= self.boost_cooldown then
    self.can_boost = true
    self.boost_timer = 2
  end

  self.boosting = false
  self.maxLinearVelocity = self.baseMaxLinearVelocity
  if select(1, Input.down('up')) and self.boost > 0 and self.can_boost then
    self.boosting = true
    self.maxLinearVelocity = self.baseMaxLinearVelocity * 1.5
    self:changeBoostBy(-50 * dt)
    if self.boost <= 0 then
      self.boosting = false
      self.can_boost = false
      self.boost_timer = 0
    end
  end
  if select(1, Input.down('down')) and self.boost > 0 and self.can_boost then
    self.boosting = true
    self.maxLinearVelocity = self.baseMaxLinearVelocity * 0.5
    self:changeBoostBy(-50 * dt)
    if self.boost <= 0 then
      self.boosting = false
      self.can_boost = false
      self.boost_timer = 0
    end
  end

  if self.boosting then
    self.trail_color = colors.normal.boost
  end

  self.linearVelocity = math.min(self.linearVelocity + self.acceleration * dt, self.maxLinearVelocity)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )

  local virtualWidth, virtualHeight = utils.getVirtualWindowDimensions()
  if self.collider:enter('Collectable') then
    local collisionData = self.collider:getEnterCollisionData('Collectable')
    local object = collisionData.collider:getObject()
    if object:is(Ammo) then
      self:changeAmmoBy(5)
    elseif object:is(Boost) then
      self:changeBoostBy(25)
    end
    object:die()
  end

  if self.x < 0 or self.y < 0 or self.x > virtualWidth or self.y > virtualHeight then
    self:die()
  end
end

function Player:draw()
  love.graphics.push()

  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)
  love.graphics.translate(-self.x, -self.y)

  for _, polygon in ipairs(self.ship.polygons) do
    local points = Moses.map(polygon, function(v, k)
      if k % 2 == 1 then
        return self.x + v + love.math.random(-1, 1)
      else
        return self.y + v + love.math.random(-1, 1)
      end
    end)
    love.graphics.polygon('line', points)
  end

  love.graphics.pop()
end

function Player:shoot(amount, offset, theta, attributes)
  self.area:insert(ShootEffect(self.x, self.y, self))

  amount = amount or 1
  offset = offset or 0
  theta = theta or 0
  attributes = attributes or {}

  self:changeAmmoBy(-amount)

  local angle = self.angle + theta * (amount - 1) / 2
  local delta = offset * (amount - 1) / 2
  for i = 1, amount do
    local attr = Moses.clone(attributes)
    attr.area = self.area
    attr.angle = angle - (i - 1) * theta

    local d = self.height * 1.5
    local doff = delta * (i - 1 - (amount - 1) / 2)
    local x = self.x + d * math.cos(self.angle) + doff * math.cos(self.angle - math.pi / 2)
    local y = self.y + d * math.sin(self.angle) + doff * math.sin(self.angle - math.pi / 2)

    self.area:insert(Projectile(x, y, attr))
  end
end

function Player:die()
  Player.super.die(self)
  self.engine:shake(6, 60, 0.4)
  self.engine:slowdown(0.15, 1)
  self.engine:flash(4)
  for _ = 1, love.math.random(8, 12) do
    self.area:insert(ExplodeParticle(self.x, self.y))
  end
end

function Player:tick()
  self.area:insert(TickEffect(self.x, self.y, self))
end

function Player:changeAmmoBy(amount)
  self.ammo = math.max(0, math.min(self.ammo + amount, self.maxAmmo))
end

function Player:changeHPBy(amount)
  self.hp = math.max(0, math.min(self.hp + amount, self.maxHP))
end

function Player:changeBoostBy(amount)
  self.boost = math.max(0, math.min(self.boost + amount, self.maxBoost))
end

function Player:attach(ship)
  self.ship = ship
  self.width = self.ship.width
  self.height = self.ship.height

  if self.collider then
    self.collider:destroy()
  end
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.ship.width)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Player')
end

return Player
