local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')
local Director = require('src.Director')

local Stage = GameObject:extend()

function Stage:new(engine)
  Stage.super.new(self)

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
  self.director = Director(self)

  self.area:insert(self.player)
end

function Stage:update(dt)
  Stage.super.update(self, dt)

  self.area:update(dt)

  if self.player and not self.player.alive then
    self.player = nil
  end
end

function Stage:draw()
  self.area:draw()
end

function Stage:destroy()
  self.area:destroy()
  self.area = nil
  self.player:destroy()
  self.player = nil
  self.engine = nil
end

return Stage
