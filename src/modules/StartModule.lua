local GameObject = require('src.GameObject')
local Stage = require('src.scenes.Stage')

local StartModule = GameObject:extend()

function StartModule:new(console)
  StartModule.super.new(self)

  console:addLine()
  console:addLine(0.02, 'Starting simulation...')

  console.engine.timer:after(0.2, function()
    console.engine:attach(Stage(console.engine))
  end)
end

return StartModule
