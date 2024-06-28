local utils = require('src.utils')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.ExplodeParticle')
local colors = require('src.constants.colors')
local BoostEffect = require('src.BoostEffect')
local InfoText = require('src.InfoText')

local Boost = GameObject:extend()

function Boost:new(scene)
  local direction = ({ -1, 1 })[love.math.random(1, 2)]
  local vw, vh = utils.getVirtualWindowDimensions()
  Boost.super.new(self, vw / 2 + direction * (vw / 2 + 48), love.math.random(48, vh - 48))

  self.area = scene.area
  self.width, self.height = 12, 12
  self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
  self.collider:setObject(self)
  self.collider:setFixedRotation(true)
  self.linearVelocity = -direction * love.math.random(20, 40)
  self.collider:setAngle(math.pi / 4)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:setCollisionClass('Collectable')
end

function Boost:update(dt)
  Boost.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function Boost:draw()
  love.graphics.setColor(colors.normal.boost)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.collider:getAngle())
  love.graphics.translate(-self.x, -self.y)
  local inner = 0.5 * self.width
  local outer = 1.5 * self.width
  love.graphics.rectangle('fill', self.x - inner / 2, self.y - inner / 2, inner, inner)
  love.graphics.rectangle('line', self.x - outer / 2, self.y - outer / 2, outer, outer)
  love.graphics.pop()
  love.graphics.setColor(colors.normal.default)
end

function Boost:die()
  Boost.super.die(self)
  self.area:insert(BoostEffect(self.x, self.y))

  self.area:insert(
    InfoText(
      self.x + love.math.random(-self.width, self.width),
      self.y + love.math.random(-self.height, self.height),
      '+BOOST',
      colors.normal.boost
    )
  )
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, colors.normal.boost))
  end
end

return Boost
