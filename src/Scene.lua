local GameObject = require('src.GameObject')

local Scene = GameObject:extend()

function Scene:new()
  Scene.super.new(self)

  self.areas = {}
  self.active_area = nil
end

function Scene:update(dt)
  Scene.super.update(self, dt)

  if self.active_area then
    self.active_area:update(dt)
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