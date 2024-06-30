local utils = require('src.utils')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.particles.ExplodeParticle')
local colors = require('src.constants.colors')
local HealthPointEffect = require('src.effects.HealthPointEffect')
local InfoText = require('src.InfoText')

local HealthPoint = GameObject:extend()

function HealthPoint:new(scene)
  local direction = utils.pickRandom({ -1, 1 })
  local vw, vh = utils.getVirtualWindowDimensions()
  HealthPoint.super.new(self, vw / 2 + direction * (vw / 2 + 48), utils.random(48, vh - 48))

  self.area = scene.area
  self.width, self.height = 12, 12
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.width)
  self.collider:setObject(self)
  self.collider:setFixedRotation(true)
  self.linearVelocity = -direction * utils.random(20, 40)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:setCollisionClass('Collectable')
end

function HealthPoint:update(dt)
  HealthPoint.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function HealthPoint:draw()
  love.graphics.setColor(colors.normal.hp)
  local inner_width, inner_height = self.width, 0.3 * self.height
  love.graphics.rectangle('fill', self.x - inner_width / 2, self.y - inner_height / 2, inner_width, inner_height)
  love.graphics.rectangle('fill', self.x - inner_height / 2, self.y - inner_width / 2, inner_height, inner_width)
  love.graphics.setColor(colors.normal.default)
  love.graphics.circle('line', self.x, self.y, self.width)
end

function HealthPoint:die()
  HealthPoint.super.die(self)
  self.area:insert(HealthPointEffect(self.x, self.y))

  self.area:insert(
    InfoText(
      self.x + utils.random(-self.width, self.width),
      self.y + utils.random(-self.height, self.height),
      '+HEALTH',
      colors.normal.hp
    )
  )
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, colors.normal.hp))
  end
end

return HealthPoint
