local M = require('lib.moses.moses')
local windfield = require('lib.windfield.windfield')
local GameObject = require('src.GameObject')

local Area = GameObject:extend()

function Area:new()
  Area.super.new(self)

  self.world = nil
  self.game_objects = {}
end

function Area:update(dt)
  Area.super.update(self, dt)

  if self.world then
    self.world:update(dt)
  end

  for i = #self.game_objects, 1, -1 do
    local gob = self.game_objects[i]
    gob:update(dt)

    if not gob.alive then
      gob:destroy()
      table.remove(self.game_objects, i)
    end
  end
end

function Area:draw()
  if self.world then
    self.world:draw(0)
  end

  for _, gob in ipairs(self.game_objects) do
    gob:draw()
  end
end

function Area:destroy()
  for i = #self.game_objects, 1, -1 do
    self.game_objects[i]:destroy()
    table.remove(self.game_objects, i)
  end
  self.game_objects = {}

  if self.world then
    self.world:destroy()
    self.world = nil
  end
end

function Area:insert(gob)
  table.insert(self.game_objects, gob)
end

function Area:get(arg)
  if not arg then
    return self.game_objects
  elseif type(arg) == 'table' then
    return M.select(self.game_objects, function(e)
      for _, class in ipairs(arg) do
        if e:is(class) then
          return true
        end
      end
      return false
    end)
  elseif type(arg) == 'function' then
    return M.select(self.game_objects, arg)
  end
end

function Area:query(x, y, radius, classes)
  return M.select(self:get(classes), function(e)
    local d = math.sqrt(math.pow(x - e.x, 2) + math.pow(y - e.y, 2))
    return d <= radius
  end)
end

function Area:closest(x, y, radius, classes)
  return M.reduce(self:query(x, y, radius, classes), function(a, b)
    return a > b and b or a
  end)
end

function Area:generateWorld()
  self.world = windfield.newWorld(0, 0)
end

return Area
