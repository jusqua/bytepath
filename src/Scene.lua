local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')

local Scene = GameObject:extend()

function Scene:new()
  Scene.super.new(self)

  self.area = Area()
  self.area:generateWorld()

  local wwidth, wheight, _ = love.window.getMode()
  local vx, vy = push.toGame(wwidth / 2, wheight / 2)
  self.player = Player(vx, vy, self.area)

  self.area:insert(self.player)
end

function Scene:update(dt)
  Scene.super.update(self, dt)

  self.area:update(dt)

  if not self.player.alive then
    self.player = nil
  end
end

function Scene:draw()
  self.area:draw()
end

function Scene:destroy()
  self.area:destroy()
  self.area = nil
end

return Scene
