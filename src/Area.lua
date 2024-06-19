local GameObject = require('src.GameObject')
local M = require('lib.moses.moses')

local Area = GameObject:extend()

function Area:new()
  Area.super.new(self)

  self.game_objects = {}
end

function Area:update(dt)
  Area.super.update(self, dt)

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

function Area:insert(gob)
  table.insert(self.game_objects, gob)
end

function Area:get(filter)
  if not filter then
    return self.game_objects
  end

  return M.select(self.game_objects, filter)
end

return Area
