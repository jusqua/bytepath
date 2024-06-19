local GameObject = require('src.GameObject')

local Engine = GameObject:extend()

function Engine:new()
  Engine.super.new(self)

  self.scenes = {}
  self.active_scene = nil
end

function Engine:update(dt)
  Engine.super.update(self, dt)

  if self.active_scene then
    self.active_scene:update(dt)
  end
end

function Engine:draw()
  if self.active_scene then
    self.active_scene:draw()
  end
end

function Engine:attach(scene)
  if self.scenes[scene.id] then
    self.active_scene = scene
  end
end

function Engine:insert(scene)
  self.scenes[scene.id] = scene
  self:attach(scene)
end

return Engine
