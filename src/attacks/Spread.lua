local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')
local utils = require('src.utils')

local Spread = Object:extend()

function Spread:new(player)
  self.cooldown = 0.16
  self.cost = 1
  self.abbreviation = 'RS'
  self.player = player
  self.color = colors.normal.default

  player.timer:every(0.2, function()
    self.color = utils.pickRandom(colors.all)
  end)
end

function Spread:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.8
  local angle = player.angle
  local x, y = player.x, player.y
  local area = player.area
  local color = self.color
  local offset = utils.random(-math.pi / 8, math.pi / 8)

  table.insert(
    projectiles,
    Projectile(
      x + d * math.cos(angle + offset),
      y + d * math.sin(angle + offset),
      { angle = angle + offset, area = area, color = color }
    )
  )
  return projectiles
end

return Spread
