local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Double = Object:extend()

function Double:new(player)
  self.cooldown = 0.32
  self.cost = 2
  self.abbreviation = 'Ba'
  self.player = player
  self.color = colors.normal.skill_point
end

function Double:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.8
  local x, y = player.x, player.y
  local angle = player.angle
  local area = player.area
  local color = self.color

  table.insert(
    projectiles,
    Projectile(x + d * math.cos(angle), y + d * math.sin(angle), { angle = angle, area = area, color = color })
  )

  table.insert(
    projectiles,
    Projectile(
      x + d * math.cos(angle + math.pi),
      y + d * math.sin(angle + math.pi),
      { angle = angle + math.pi, area = area, color = color }
    )
  )

  return projectiles
end

return Double
