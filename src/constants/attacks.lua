local colors = require('src.constants.colors')
local Projectile = require('src.Projectile')

return {
  neutral = {
    cooldown = 0.24,
    cost = 0,
    abbreviation = 'N',
    projectiles = function(player)
      local projectiles = {}
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
    end,
  },
  double = {
    cooldown = 0.32,
    cost = 2,
    abbreviation = '2',
    projectiles = function(player)
      local projectiles = {}
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
    end,
  },
}
