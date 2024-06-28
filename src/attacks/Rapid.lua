local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Rapid = Object:extend()

function Rapid:new(player)
  self.cooldown = 0.12
  self.cost = 1
  self.abbreviation = 'R'
  self.player = player
  self.color = colors.normal.default
end

function Rapid:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.8
  local color = self.color
  local angle = player.angle
  local area = player.area
  local x, y = player.x, player.y

  table.insert(
    projectiles,
    Projectile(x + d * math.cos(angle), y + d * math.sin(angle), { angle = angle, area = area, color = color })
  )
  return projectiles
end

return Rapid
