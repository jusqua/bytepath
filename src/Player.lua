local GameObject = require('src.GameObject')

local Player = GameObject:extend()

function Player:new(x, y)
  Player.super.new(self, x, y)
end

function Player:update(dt)
  Player.super.update(self, dt)
end

function Player:draw()
  love.graphics.circle('line', self.x, self.y, 25)
end

return Player
