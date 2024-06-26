local GameObject = require('src.GameObject')

local NewGameObject = GameObject:extend()

function NewGameObject:new(x, y)
  NewGameObject.super.new(self, x, y)
end

function NewGameObject:update(dt)
  NewGameObject.super.update(self, dt)
end

function NewGameObject:draw() end

function NewGameObject:destroy()
  NewGameObject.super.destroy(self)
end

return NewGameObject
