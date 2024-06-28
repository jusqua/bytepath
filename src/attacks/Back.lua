local Object = require('lib.classic.classic')
local Projectile = require('src.Projectile')
local colors = require('src.constants.colors')

local Back = Object:extend()

function Back:new(player)
  self.cooldown = 0.32
  self.cost = 2
  self.abbreviation = 'Ba'
  self.player = player
  self.color = colors.normal.skill_point
end

function Back:projectiles()
  local projectiles = {}
  local player = self.player
  local d = player.width * 1.8
  local x, y = player.x, player.y
  local offset = math.pi
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
      x + d * math.cos(angle + offset),
      y + d * math.sin(angle + offset),
      { angle = angle + offset, area = area, color = color }
    )
  )

  return projectiles
end

return Back
