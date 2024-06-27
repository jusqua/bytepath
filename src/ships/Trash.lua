local Object = require('lib.classic.classic')
local TrailParticle = require('src.TrailParticle')

local Trash = Object:extend()

function Trash:new(player)
  self.player = player
  self.width = 10
  self.height = 10
  self.polygons = {
    {
      self.width,
      self.width,
      -self.width,
      -self.width,
      -self.width,
      self.width,
      self.width,
      -self.width,
    },
    {
      0,
      0,
      self.width * 0.75,
      self.width * 0.75,
      -self.width * 0.75,
      self.width * 0.75,
    },
    {
      0,
      0,
      self.width * 0.75,
      -self.width * 0.75,
      -self.width * 0.75,
      -self.width * 0.75,
    },
  }
end

function Trash:trails()
  local trails = {}

  local d = 1.2 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)
  local offset = 0.3 * self.width

  table.insert(trails, TrailParticle(x, y, { color = self.player.trail_color, duration = love.math.random(0.25, 0.3) }))

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle - math.pi / 2),
      y + offset * math.sin(self.player.angle - math.pi / 2),
      { color = self.player.trail_color }
    )
  )

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle + math.pi / 2),
      y + offset * math.sin(self.player.angle + math.pi / 2),
      { color = self.player.trail_color }
    )
  )

  return trails
end

return Trash
