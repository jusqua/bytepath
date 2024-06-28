local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')

local Neutral = Object:extend()

function Neutral:new(player)
  self.cooldown = 0.24
  self.cost = 0
  self.abbreviation = 'N'
  self.player = player
end

function Neutral:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.2
  table.insert(
    projectiles,
    Projectile(
      player.x + 1.5 * d * math.cos(player.angle),
      player.y + 1.5 * d * math.sin(player.angle),
      { angle = player.angle, area = player.area }
    )
  )
  return projectiles
end

return Neutral
