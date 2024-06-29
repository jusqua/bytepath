local utils = require('src.utils')
local GameObject = require('src.GameObject')
local TargetParticle = require('src.TargetParticle')

local PreAttackEffect = GameObject:extend()

function PreAttackEffect:new(x, y, opts)
  PreAttackEffect.super.new(self, x, y)

  local area = opts.area
  local color = opts.color
  local duration = opts.duration
  local entity = opts.entity

  self.timer:every(0.02, function()
    if entity and entity.alive then
      local d = 1.4 * entity.width
      local angle = entity.collider:getAngle()
      local ex, ey = entity.x, entity.y
      self.x = ex + d * math.cos(angle)
      self.y = ey + d * math.sin(angle)
    end

    area:insert(
      TargetParticle(
        self.x + utils.random(-20, 20),
        self.y + utils.random(-20, 20),
        { target_x = self.x, target_y = self.y, color = color, duration = duration }
      )
    )
  end)

  self.timer:after(duration - duration / 4, function()
    self:die()
  end)
end

return PreAttackEffect
