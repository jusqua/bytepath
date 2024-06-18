local GameObject = require('src.GameObject')

local Area = GameObject:extend()

function Area:new()
  Area.super.new(self)

  self.game_objects = {}
end

function Area:update(dt)
  for i = #self.game_objects, 1, -1 do
    local gob = self.game_objects[i]
    gob:update(dt)

    if not gob.alive then
      table.remove(self.game_objects, i)
    end
  end
end

function Area:draw()
  for _, gob in ipairs(self.game_objects) do
    gob:draw()
  end
end

return Area
