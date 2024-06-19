local GameObject = require('src.GameObject')

local Area = GameObject:extend()

function Area:new()
  Area.super.new(self)

  self.game_objects = {}
end

function Area:update(dt)
  Area.super.update(self, dt)

  for id, gob in pairs(self.game_objects) do
    gob:update(dt)

    if not gob.alive then
      self.game_objects[id] = nil
    end
  end
end

function Area:draw()
  for _, gob in pairs(self.game_objects) do
    gob:draw()
  end
end

function Area:insert(gob)
  self.game_objects[gob.id] = gob
end

return Area
