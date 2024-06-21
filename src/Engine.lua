local GameObject = require('src.GameObject')
local Scene = require('src.Scene')

local Engine = GameObject:extend()

function Engine:new()
  Engine.super.new(self)

  self.scene = Scene()
end

function Engine:update(dt)
  Engine.super.update(self, dt)

  if self.scene then
    self.scene:update(dt)
  end
end

function Engine:draw()
  if self.scene then
    self.scene:draw()
  end
end

function Engine:attach(scene)
  if self.scene then
    self.scene:destroy()
  end

  self.scene = scene
end

return Engine
