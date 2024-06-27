local utils = require('src.utils')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.ExplodeParticle')
local colors = require('src.constants.colors')
local HPEffect = require('src.HPEffect')
local InfoText = require('src.InfoText')

local HP = GameObject:extend()

function HP:new(scene)
  local direction = ({ -1, 1 })[love.math.random(1, 2)]
  local vw, vh = utils.getVirtualWindowDimensions()
  HP.super.new(self, vw / 2 + direction * (vw / 2 + 48), love.math.random(48, vh - 48))

  self.area = scene.area
  self.width, self.height = 12, 12
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.width)
  self.collider:setObject(self)
  self.collider:setFixedRotation(true)
  self.linearVelocity = -direction * love.math.random(20, 40)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:setCollisionClass('Collectable')
end

function HP:update(dt)
  HP.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function HP:draw()
  love.graphics.setColor(colors.normal.hp)
  local inner_width, inner_height = self.width, 0.3 * self.height
  love.graphics.rectangle('fill', self.x - inner_width / 2, self.y - inner_height / 2, inner_width, inner_height)
  love.graphics.rectangle('fill', self.x - inner_height / 2, self.y - inner_width / 2, inner_height, inner_width)
  love.graphics.setColor(colors.normal.default)
  love.graphics.circle('line', self.x, self.y, self.width)
end

function HP:die()
  HP.super.die(self)
  self.area:insert(HPEffect(self.x, self.y))

  self.area:insert(
    InfoText(
      self.x + love.math.random(-self.width, self.width),
      self.y + love.math.random(-self.height, self.height),
      '+HP',
      colors.normal.hp
    )
  )
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, colors.normal.hp))
  end
end

return HP
