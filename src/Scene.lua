local push = require('lib.push.push')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')

local Scene = GameObject:extend()

function Scene:new()
  Scene.super.new(self)

  self.areas = {}
  self.active_area = nil

  self:insert(Area())
  self.active_area:generateWorld()

  local wwidth, wheight, _ = love.window.getMode()
  local vx, vy = push.toGame(wwidth / 2, wheight / 2)
  self.player = Player(vx, vy, self.active_area.world)

  self.active_area:insert(self.player)
end

function Scene:update(dt)
  Scene.super.update(self, dt)

  if self.active_area then
    self.active_area:update(dt)
  end

  if not self.player.alive then
    self.player = nil
  end
end

function Scene:draw()
  if self.active_area then
    self.active_area:draw()
  end
end

function Scene:attach(area)
  if self.areas[area.id] then
    self.active_area = area
  end
end

function Scene:insert(area)
  self.areas[area.id] = area
  self:attach(area)
end

return Scene
