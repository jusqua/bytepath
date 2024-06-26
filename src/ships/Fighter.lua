local Object = require('lib.classic.classic')
local Moses = require('lib.moses.moses')
local TrailParticle = require('src.TrailParticle')

local Fighter = Object:extend()

function Fighter:new(player)
  self.player = player
  self.width = 12
  self.height = 12
  self.polygons = {
    {
      self.width,
      0, -- 1
      self.width / 2,
      -self.width / 2, -- 2
      -self.width / 2,
      -self.width / 2, -- 3
      -self.width,
      0, -- 4
      -self.width / 2,
      self.width / 2, -- 5
      self.width / 2,
      self.width / 2, -- 6
    },
    {
      self.width / 2,
      -self.width / 2, -- 7
      0,
      -self.width, -- 8
      -self.width - self.width / 2,
      -self.width, -- 9
      -3 * self.width / 4,
      -self.width / 4, -- 10
      -self.width / 2,
      -self.width / 2, -- 11
    },
    {
      self.width / 2,
      self.width / 2, -- 12
      -self.width / 2,
      self.width / 2, -- 13
      -3 * self.width / 4,
      self.width / 4, -- 14
      -self.width - self.width / 2,
      self.width, -- 15
      0,
      self.width, -- 16
    },
  }
end

function Fighter:trails()
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
      { radius = love.math.random(1, 3), color = self.player.trail_color }
    )
  )

  table.insert(
    trails,
    TrailParticle(
      x + offset * math.cos(self.player.angle + math.pi / 2),
      y + offset * math.sin(self.player.angle + math.pi / 2),
      { radius = love.math.random(1, 3), color = self.player.trail_color }
    )
  )

  return trails
end

return Fighter
