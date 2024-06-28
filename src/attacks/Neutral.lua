local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Neutral = Object:extend()

function Neutral:new(player)
  self.cooldown = 0.24
  self.cost = 0
  self.abbreviation = 'N'
  self.player = player
  self.color = colors.normal.hp
end

function Neutral:projectiles()
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

return Neutral
