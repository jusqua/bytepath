local GameObject = require('src.GameObject')

local Engine = GameObject:extend()

function Engine:new()
  Engine.super.new(self)

  self.scenes = {}
  self.active_scene = nil
end

function Engine:update(dt)
  if self.active_scene then
    self.active_scene:update(dt)
  end
end

function Engine:draw()
  if self.active_scene then
    self.active_scene:draw()
  end
end

return Engine
