local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')
local Input = require('lib.input.input')
local Ammo = require('src.Ammo')
local utils = require('src.utils')

local Scene = GameObject:extend()

function Scene:new(engine)
  Scene.super.new(self)

  self.engine = engine
  self.area = Area()
  self.area:generateWorld()
  self.area.world:addCollisionClass('Player')
  self.area.world:addCollisionClass('Projectile', { ignores = { 'Projectile' } })
  self.area.world:addCollisionClass('Collectable', { ignores = { 'Collectable', 'Projectile' } })

  local wwidth, wheight, _ = love.window.getMode()
  local vx, vy = push.toGame(wwidth / 2, wheight / 2)
  self.player = Player(vx, vy, engine, self.area)

  self.area:insert(self.player)
end

function Scene:update(dt)
  Scene.super.update(self, dt)

  self.area:update(dt)

  if select(1, Input.down('p')) then
    local virtualWidth, virtualHeight = utils.getVirtualWindowDimensions()
    self.area:insert(Ammo(love.math.random(0, virtualWidth), love.math.random(0, virtualHeight), self))
  end

  if self.player and not self.player.alive then
    self.player = nil
  end
end

function Scene:draw()
  self.area:draw()
end

function Scene:destroy()
  self.area:destroy()
  self.area = nil
  self.player:destroy()
  self.player = nil
  self.engine = nil
end

return Scene
