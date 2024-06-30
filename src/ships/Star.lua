local Object = require('lib.classic.classic')
local TrailParticle = require('src.particles.TrailParticle')
local utils = require('src.utils')

local Star = Object:extend()

function Star:new(player)
  self.player = player
  self.width = 12
  self.height = 12
  self.polygons = {}

  local scale = 0.7
  for k = -1, 1, 2 do
    table.insert(self.polygons, {})
    for i = -1, 1, 2 do
      for j = -1 * i, 1 * i, 2 * i do
        local x, y = utils.rotate(i * self.width * scale, j * self.width * scale, -k * math.deg(30))
        table.insert(self.polygons[#self.polygons], x)
        table.insert(self.polygons[#self.polygons], y)
      end
    end
  end
end

function Star:trails()
  local trails = {}

  local d = 0.9 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)
  local offset = 0.2 * self.width

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle - math.pi / 2),
      y + offset * math.sin(self.player.angle - math.pi / 2),
      { radius = utils.random(1, 3), color = self.player.trail_color }
    )
  )

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle + math.pi / 2),
      y + offset * math.sin(self.player.angle + math.pi / 2),
      { radius = utils.random(1, 3), color = self.player.trail_color }
    )
  )

  return trails
end

return Star
