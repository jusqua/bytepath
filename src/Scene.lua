local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')
local Input = require('lib.input.input')
local Ammo = require('src.Ammo')
local utils = require('src.utils')
local Boost = require('src.Boost')
local HP = require('src.HP')
local SP = require('src.SP')
local Attack = require('src.Attack')
local Rock = require('src.enemies.Rock')
local Shooter = require('src.enemies.Shooter')

local Scene = GameObject:extend()

function Scene:new(engine)
  Scene.super.new(self)

  self.engine = engine
  self.area = Area()
  self.area:generateWorld()
  self.area.world:addCollisionClass('Player')
  self.area.world:addCollisionClass('Projectile', { ignores = { 'Projectile', 'Player' } })
  self.area.world:addCollisionClass('Collectable', { ignores = { 'Collectable', 'Projectile' } })
  self.area.world:addCollisionClass('Enemy', { ignores = { 'Enemy', 'Collectable' } })
  self.area.world:addCollisionClass('EnemyProjectile', { ignores = { 'Enemy', 'Collectable', 'EnemyProjectile' } })

  local wwidth, wheight, _ = love.window.getMode()
  local vx, vy = push.toGame(wwidth / 2, wheight / 2)
  self.player = Player(vx, vy, engine, self.area)

  self.area:insert(self.player)
end

function Scene:update(dt)
  Scene.super.update(self, dt)

  self.area:update(dt)

  local virtualWidth, virtualHeight = utils.getVirtualWindowDimensions()
  if select(1, Input.pressed('p')) then
    self.area:insert(Ammo(utils.random(virtualWidth), utils.random(virtualHeight), self))
  end
  if select(1, Input.pressed('o')) then
    self.area:insert(Boost(self))
  end
  if select(1, Input.pressed('i')) then
    self.area:insert(HP(self))
  end
  if select(1, Input.pressed('u')) then
    self.area:insert(SP(self))
  end
  if select(1, Input.pressed('y')) then
    self.area:insert(Attack(self))
  end
  if select(1, Input.pressed('0')) then
    self.area:insert(Rock(self))
  end
  if select(1, Input.pressed('9')) then
    self.area:insert(Shooter(self))
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
