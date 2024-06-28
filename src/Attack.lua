local Moses = require('lib.moses.moses')
local utf8 = require('lib.utf8')
local utils = require('src.utils')
local GameObject = require('src.GameObject')
local ExplodeParticle = require('src.ExplodeParticle')
local colors = require('src.constants.colors')
local fonts = require('src.constants.fonts')
local AttackEffect = require('src.AttackEffect')
local InfoText = require('src.InfoText')
local attacks = require('src.attacks')

local Attack = GameObject:extend()

function Attack:new(scene)
  local direction = utils.pickRandom({ -1, 1 })
  local vw, vh = utils.getVirtualWindowDimensions()
  Attack.super.new(self, vw / 2 + direction * (vw / 2 + 48), love.math.random(48, vh - 48))

  self.attack = utils.pickRandom(Moses.select(Moses.keys(attacks), function(e)
    return e ~= 'Neutral'
  end))
  self.instance = attacks[self.attack](scene.player)
  self.font = fonts.m5x7_16
  self.characters = {}

  self.d = 0
  for i = 1, #self.instance.abbreviation do
    local char = utf8.sub(self.instance.abbreviation, i, i)
    table.insert(self.characters, char)
    self.d = self.d + self.font:getWidth(char)
  end
  self.d = -self.d / 2

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

function Attack:update(dt)
  Attack.super.update(self, dt)

  self.collider:setLinearVelocity(self.linearVelocity, 0)
end

function Attack:draw()
  love.graphics.setColor(self.instance.color)
  love.graphics.setFont(self.font)

  local width = 0
  for i = 1, #self.characters do
    if i > 1 then
      for j = 1, i - 1 do
        width = width + self.font:getWidth(self.characters[j])
      end
    end

    love.graphics.print(self.characters[i], self.x + self.d + width, self.y, 0, 1, 1, 0, self.font:getHeight() / 2)
  end

  love.graphics.push()

  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.collider:getAngle())
  love.graphics.translate(-self.x, -self.y)

  local inner = 1.2 * self.width
  local outer = 1.5 * self.width
  love.graphics.rectangle('line', self.x - outer / 2, self.y - outer / 2, outer, outer)
  love.graphics.setColor(colors.normal.default)
  love.graphics.rectangle('line', self.x - inner / 2, self.y - inner / 2, inner, inner)

  love.graphics.pop()
end

function Attack:die()
  Attack.super.die(self)
  self.area:insert(AttackEffect(self.x, self.y, self.instance.color))

  self.area:insert(
    InfoText(
      self.x + utils.random(-self.width, self.width),
      self.y + utils.random(-self.height, self.height),
      self.attack,
      self.instance.color
    )
  )
  for _ = 1, love.math.random(4, 8) do
    self.area:insert(ExplodeParticle(self.x, self.y, self.instance.color))
  end
end

return Attack
