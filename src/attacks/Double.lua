local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Double = Object:extend()

function Double:new(player)
  self.cooldown = 0.32
  self.cost = 2
  self.abbreviation = '2'
  self.player = player
end

function Double:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.2
  local angleOffset = math.pi / 12

  table.insert(
    projectiles,
    Projectile(
      player.x + 1.5 * d * math.cos(player.angle + angleOffset),
      player.y + 1.5 * d * math.sin(player.angle + angleOffset),
      { angle = player.angle + angleOffset, area = player.area, color = colors.normal.ammo }
    )
  )
  table.insert(
    projectiles,
    Projectile(
      player.x + 1.5 * d * math.cos(player.angle - angleOffset),
      player.y + 1.5 * d * math.sin(player.angle - angleOffset),
      { angle = player.angle - angleOffset, area = player.area, color = colors.normal.ammo }
    )
  )

  return projectiles
end

return Double
