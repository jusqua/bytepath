local Input = require('lib.input.input')
local Moses = require('lib.moses.moses')
local GameObject = require('src.GameObject')
local ShootEffect = require('src.ShootEffect')
local Projectile = require('src.Projectile')
local ExplodeParticle = require('src.ExplodeParticle')
local utils = require('src.utils')
local TickEffect = require('src.TickEffect')
local constants = require('src.constants')
local Fighter = require('src.ships.Fighter')

local Player = GameObject:extend()

function Player:new(x, y, engine, area)
  Player.super.new(self, x, y)

  self.engine = engine
  self.area = area

  self:attach(Fighter(self))

  self.angle = -math.pi / 2
  self.angularVelocity = 1.66 * math.pi
  self.linearVelocity = 0
  self.baseMaxLinearVelocity = 100
  self.maxLinearVelocity = self.baseMaxLinearVelocity
  self.acceleration = 100
  self.trail_color = constants.skill_point_color

  self.timer:every(0.24, function()
    self:shoot()
  end)

  self.timer:every(5, function()
    self:tick()
  end)

  self.timer:every(0.01, function()
    self:boost()
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

  self.maxLinearVelocity = self.baseMaxLinearVelocity
  self.trail_color = constants.skill_point_color
  if select(1, Input.down('up')) then
    self.maxLinearVelocity = self.baseMaxLinearVelocity * 1.5
    self.trail_color = constants.boost_color
  end
  if select(1, Input.down('down')) then
    self.maxLinearVelocity = self.baseMaxLinearVelocity * 0.5
    self.trail_color = constants.boost_color
  end

  self.linearVelocity = math.min(self.linearVelocity + self.acceleration * dt, self.maxLinearVelocity)
  self.collider:setLinearVelocity(
    self.linearVelocity * math.cos(self.angle),
    self.linearVelocity * math.sin(self.angle)
  )

  local virtualWidth, virtualHeight = utils.getVirtualWindowDimensions()
  if self.x < 0 or self.y < 0 or self.x > virtualWidth or self.y > virtualHeight then
    self:die()
  end
end

function Player:draw()
  love.graphics.push()

  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)
  love.graphics.translate(-self.x, -self.y)

  self.ship:draw()

  love.graphics.pop()
end

function Player:shoot(amount, offset, theta, attributes)
  self.area:insert(ShootEffect(self.x, self.y, self))

  amount = amount or 1
  offset = offset or 0
  theta = theta or 0
  attributes = attributes or {}

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

function Player:boost()
  local trails = self.ship:trails()

  for _, trail in ipairs(trails) do
    self.area:insert(trail)
  end
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
end

return Player
