local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Triple = Object:extend()

function Triple:new(player)
  self.cooldown = 0.32
  self.cost = 3
  self.abbreviation = '3'
  self.player = player
  self.color = colors.normal.boost
end

function Triple:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.8
  local offset = math.pi / 12
  local color = self.color
  local angle = player.angle
  local area = player.area
  local x, y = player.x, player.y

  table.insert(
    projectiles,
    Projectile(x + d * math.cos(angle), y + d * math.sin(angle), { angle = angle, area = area, color = color })
  )
  table.insert(
    projectiles,
    Projectile(
      x + d * math.cos(angle + offset),
      y + d * math.sin(angle + offset),
      { angle = angle + offset, area = area, color = color }
    )
  )
  table.insert(
    projectiles,
    Projectile(
      x + d * math.cos(angle - offset),
      y + d * math.sin(angle - offset),
      { angle = angle - offset, area = area, color = color }
    )
  )

  return projectiles
end

return Triple
