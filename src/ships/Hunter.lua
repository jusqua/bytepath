local Object = require('lib.classic.classic')
local TrailParticle = require('src.particles.TrailParticle')
local utils = require('src.utils')

local Hunter = Object:extend()

function Hunter:new(player)
  self.player = player
  self.width = 12
  self.height = 12
  self.polygons = {
    {
      self.width * 0.7,
      0,
      self.width,
      -self.width * 0.3,
      self.width * 0.7,
      -self.width * 0.7,
      -self.width * 0.7,
      -self.width * 0.7,
      -self.width,
      -self.width * 0.5,
      -self.width,
      self.width * 0.5,
      -self.width * 0.7,
      self.width * 0.7,
      self.width * 0.7,
      self.width * 0.7,
      self.width,
      self.width * 0.3,
    },
    {
      0,
      -self.width,
      self.width * 0.5,
      -self.width * 0.7,
      -self.width * 0.5,
      -self.width * 0.7,
    },
    {
      0,
      self.width,
      self.width * 0.5,
      self.width * 0.7,
      -self.width * 0.5,
      self.width * 0.7,
    },
  }
end

function Hunter:trails()
  local trails = {}

  local d = 1.2 * self.width
  local x = self.player.x - d * math.cos(self.player.angle)
  local y = self.player.y - d * math.sin(self.player.angle)

  table.insert(trails, TrailParticle(x, y, { radius = utils.random(3, 6), color = self.player.trail_color }))

  return trails
end

return Hunter
