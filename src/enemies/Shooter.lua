local utils = require('src.utils')
local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')
local EnemyProjectile = require('src.EnemyProjectile')
local EnemyDeathEffect = require('src.effects.EnemyDeathEffect')
local PreAttackEffect = require('src.effects.PreAttackEffect')

local Shooter = GameObject:extend()

function Shooter:new(scene)
  local direction = utils.pickRandom({ -1, 1 })
  local vw, vh = utils.getVirtualWindowDimensions()
  Shooter.super.new(self, vw / 2 + direction * (vw / 2 + 48), utils.random(16, vh - 16))

  self.hp = 100
  self.hit_flash = false
  self.area = scene.area
  self.scene = scene
  self.score_given = 150
  local w, h = 12, 6
  self.width, self.height = w, h
  self.collider = self.area.world:newPolygonCollider({ w, 0, -w / 2, h, -w, 0, -w / 2, -h })
  self.collider:setPosition(self.x, self.y)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Enemy')
  self.collider:setFixedRotation(false)
  local angle = direction == 1 and math.pi or 0
  self.collider:setAngle(angle)
  self.collider:setFixedRotation(true)
  self.linearVelocity = -direction * utils.random(20, 40)
  self.collider:setLinearVelocity(self.linearVelocity, 0)
  self.collider:applyAngularImpulse(utils.random(-100, 100))

  local d = 1.4 * w
  self.timer:every(utils.random(3, 5), function()
    self.area:insert(
      PreAttackEffect(
        self.x + d * math.cos(angle),
        self.y + d * math.sin(angle),
        { entity = self, color = colors.normal.hp, duration = 1, area = self.area }
      )
    )
    self.timer:after(1, function()
      self.area:insert(EnemyProjectile(self.x + d * math.cos(angle), self.y + d * math.sin(angle), {
        area = self.area,
        angle = math.atan2(scene.player.y - self.y, scene.player.x - self.x),
        linearVelocity = utils.random(80, 100),
        radius = 3.5,
      }))
    end)
  end)
end

function Shooter:update(dt)
  Shooter.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function Shooter:draw()
  love.graphics.setColor(colors.normal.hp)
  if self.hit_flash then
    love.graphics.setColor(colors.normal.default)
  end
  love.graphics.polygon('line', { self.collider:getWorldPoints(self.collider.shapes.main:getPoints()) })
  love.graphics.setColor(colors.normal.default)
end

function Shooter:die()
  Shooter.super.die(self)
  self.area:insert(EnemyDeathEffect(self.x, self.y, self.width, self.height))
  self.scene:changeScoreBy(self.score_given)
end

function Shooter:hit(damage)
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

return Shooter
