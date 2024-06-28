local Object = require('lib.classic.classic')
local TrailParticle = require('src.TrailParticle')
local utils = require('src.utils')

local Assassin = Object:extend()

function Assassin:new(player)
  self.player = player
  self.width = 12
  self.height = 12
  self.polygons = {
    {
      self.width,
      0, -- 1
      -self.width / 3,
      -self.width / 2, -- 2
      -self.width,
      0, -- 3
      -self.width / 3,
      self.width / 2, -- 4
    },
    {
      self.width,
      0, -- 5
      self.width * 2 / 3,
      -self.width / 3, -- 6
      -self.width * 3 / 4,
      -self.width * 4 / 3, -- 7
      -self.width / 3,
      -self.width / 2, -- 8
    },
    {
      self.width,
      0, -- 9
      self.width * 2 / 3,
      self.width / 3, -- 10
      -self.width * 3 / 4,
      self.width * 4 / 3, -- 11
      -self.width / 3,
      self.width / 2, -- 12
    },
  }
end

function Assassin:trails()
  local trails = {}

  local d = 0.9 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)
  local offset = 1.3 * self.width

  table.insert(trails, TrailParticle(x, y, { radius = utils.random(1.0, 2.2), color = self.player.trail_color }))

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle - math.pi / 2),
      y + offset * math.sin(self.player.angle - math.pi / 2),
      { radius = utils.random(0.5, 1.5), color = self.player.trail_color }
    )
  )

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle + math.pi / 2),
      y + offset * math.sin(self.player.angle + math.pi / 2),
      { radius = utils.random(0.5, 1.5), color = self.player.trail_color }
    )
  )

  return trails
end

return Assassin
