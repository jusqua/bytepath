local utils = require('src.utils')
local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')
local EnemyDeathEffect = require('src.effects.EnemyDeathEffect')

local Rock = GameObject:extend()

function Rock:new(scene)
  local direction = utils.pickRandom({ -1, 1 })
  local vw, vh = utils.getVirtualWindowDimensions()
  Rock.super.new(self, vw / 2 + direction * (vw / 2 + 48), utils.random(16, vh - 16))

  self.hp = 100
  self.hit_flash = false
  self.area = scene.area
  self.scene = scene
  self.size = 8
  self.score_given = 100
  self.collider = self.area.world:newPolygonCollider(utils.generateIrregularPolygon(self.size))
  self.collider:setPosition(self.x, self.y)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Enemy')
  self.collider:setFixedRotation(false)
  self.linearVelocity = -direction * utils.random(20, 40)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:applyAngularImpulse(utils.random(-100, 100))
end

function Rock:update(dt)
  Rock.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function Rock:draw()
  love.graphics.setColor(colors.normal.hp)
  if self.hit_flash then
    love.graphics.setColor(colors.normal.default)
  end
  love.graphics.polygon('line', { self.collider:getWorldPoints(self.collider.shapes.main:getPoints()) })
  love.graphics.setColor(colors.normal.default)
end

function Rock:die()
  Rock.super.die(self)
  self.area:insert(EnemyDeathEffect(self.x, self.y, self.size))
  self.scene:changeScoreBy(self.score_given)
end

function Rock:hit(damage)
  damage = damage or 100

  self.hp = self.hp - damage
  if self.hp <= 0 then
    self:die()
  else
    self.hit_flash = true
    self.timer:after(0.2, function()
      self.hit_flash = false
    end)
  end
end

return Rock
