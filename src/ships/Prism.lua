local Object = require('lib.classic.classic')
local TrailParticle = require('src.particles.TrailParticle')

local Prism = Object:extend()

function Prism:new(player)
  self.player = player
  self.width = 8
  self.height = 8
  self.polygons = {
    {
      self.width,
      0, -- 1
      self.width / 3,
      -self.width, -- 2
      -self.width,
      -self.width, -- 3
      -self.width / 2,
      0, -- 4
      -self.width,
      self.width, -- 5
      self.width / 3,
      self.width, -- 6
    },
  }
end

function Prism:trails()
  local trails = {}

  local d = 0.9 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)

  table.insert(trails, TrailParticle(x, y, { color = self.player.trail_color }))

  return trails
end

return Prism
