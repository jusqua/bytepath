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
  self.score = 0
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

  self.director:update(dt)
  self.area:update(dt)

  if self.player and not self.player.alive then
    self.player = nil
  end
end

function Stage:draw()
  self.area:draw()
end

function Stage:destroy()
  Stage.super.destroy(self)
  self.area:destroy()
  self.area = nil
  self.engine = nil
end

function Stage:finish()
  self.engine.timer:after(1, function()
    self.engine:attach(Stage(self.engine))
  end)
end

function Stage:changeScoreBy(amount)
  self.score = self.score + amount
end

return Stage
