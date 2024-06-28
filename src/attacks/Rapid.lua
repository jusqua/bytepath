local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')

local Rapid = Object:extend()

function Rapid:new(player)
  self.cooldown = 0.12
  self.cost = 1
  self.abbreviation = 'R'
  self.player = player
end

function Rapid:projectiles()
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

return Rapid
