local Engine = require('src.Engine')

local engine

function love.load()
  engine = Engine()
end

function love.update(dt)
  engine:update(dt)

  if love.keyboard.isDown('escape') then
    love.event.quit()
  end
end

function love.draw()
  engine:draw()
end
