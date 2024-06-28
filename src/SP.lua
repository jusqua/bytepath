local utils = require('src.utils')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.ExplodeParticle')
local colors = require('src.constants.colors')
local BoostEffect = require('src.BoostEffect')
local InfoText = require('src.InfoText')

local SP = GameObject:extend()

function SP:new(scene)
  local direction = ({ -1, 1 })[love.math.random(1, 2)]
  local vw, vh = utils.getVirtualWindowDimensions()
  SP.super.new(self, vw / 2 + direction * (vw / 2 + 48), love.math.random(48, vh - 48))

  self.area = scene.area
  self.width, self.height = 12, 12
  self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
  self.collider:setObject(self)
  self.collider:setFixedRotation(true)
  self.collider:setAngle(math.pi / 4)
  self.linearVelocity = -direction * love.math.random(20, 40)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:setCollisionClass('Collectable')
end

function SP:update(dt)
  SP.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function SP:draw()
  love.graphics.setColor(colors.normal.skill_point)
  love.graphics.push()
  utils.rotateAtPosition(self.x, self.y, self.collider:getAngle())
  local inner = 0.5 * self.width
  local outer = 1.5 * self.width
  love.graphics.rectangle('fill', self.x - inner / 2, self.y - inner / 2, inner, inner)
  love.graphics.rectangle('line', self.x - outer / 2, self.y - outer / 2, outer, outer)
  love.graphics.pop()
  love.graphics.setColor(colors.normal.default)
end

function SP:die()
  SP.super.die(self)
  self.area:insert(BoostEffect(self.x, self.y, colors.normal.skill_point))

  self.area:insert(
    InfoText(
      self.x + love.math.random(-self.width, self.width),
      self.y + love.math.random(-self.height, self.height),
      '+SP',
      colors.normal.skill_point
    )
  )
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, colors.normal.skill_point))
  end
end

return SP
