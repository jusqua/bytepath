local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')

local ExitModule = GameObject:extend()

function ExitModule:new(console)
  ExitModule.super.new(self)

  console:addLine()
  console:addLine(0.1, 'Exiting...')
  console:addLine(0.5, { colors.normal.skill_point, 'Thanks for your time!' })

  console.engine.timer:after(1, function()
    love.event.quit()
  end)
end

return ExitModule
