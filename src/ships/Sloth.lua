local Object = require('lib.classic.classic')
local TrailParticle = require('src.TrailParticle')

local Sloth = Object:extend()

function Sloth:new(player)
  self.player = player
  self.width = 12
  self.height = 12
  self.polygons = {
    {
      self.width * 2 / 3,
      self.width / 6,
      self.width * 2 / 3,
      -self.width / 6,
      self.width / 6,
      -self.width * 2 / 3,
      -self.width / 6,
      -self.width * 2 / 3,
      -self.width * 2 / 3,
      -self.width / 6,
      -self.width * 2 / 3,
      self.width / 6,
      -self.width / 6,
      self.width * 2 / 3,
      self.width / 6,
      self.width * 2 / 3,
    },
    {
      self.width / 6,
      0,
      0,
      -self.width / 6,
      -self.width / 6,
      0,
      0,
      self.width / 6,
    },
  }
end

function Sloth:trails()
  local trails = {}

  local d = 0.9 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)

  table.insert(trails, TrailParticle(x, y, { color = self.player.trail_color }))

  return trails
end

return Sloth
