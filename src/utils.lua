local push = require('lib.push.push')

-- based on https://jonny.morrill.me/en/blog/gamedev-how-to-implement-a-camera-shake-effect

-- auxiliary function for shake
local function getShakeOffsets(amplitude, frequency, duration, pnoise, t)
  local s = t / 1000 * frequency
  local s0 = math.floor(s)
  local k = math.max(0, (duration - t) / duration)
  local noise = love.math.random(-1, 1)
  local d = k * amplitude * (pnoise + (s - s0) * (noise - pnoise))

  return noise, d
end

-- make camera shake based on given amplitude, frequency and duration
local function shakeCamera(camera, timer, amplitude, frequency, duration)
  -- x axis
  do
    local t, d = 0, 0
    local pnoise = love.math.random(-1, 1)
    local start_time = love.timer.getTime() * 1000
    timer:during(duration, function(dt)
      t = (love.timer.getTime() * 1000 - start_time) * dt
      pnoise, d = getShakeOffsets(amplitude, frequency, duration, pnoise, t)
      camera:move(d, 0)
    end)
  end

  -- y axis
  do
    local t, d = 0, 0
    local pnoise = love.math.random(-1, 1)
    local start_time = love.timer.getTime() * 1000
    timer:during(duration, function(dt)
      t = (love.timer.getTime() * 1000 - start_time) * dt
      pnoise, d = getShakeOffsets(amplitude, frequency, duration, pnoise, t)
      camera:move(0, d)
    end)
  end
end

local function getWindowDimensions()
  local width, height = love.window.getMode()
  return width, height
end

local function getVirtualWindowDimensions()
  local width, height = push.toGame(love.window.getMode())
  return width, height
end

local function rotate(x, y, angle)
  return x * math.cos(angle) - y * math.sin(angle), y * math.cos(angle) + x * math.sin(angle)
end

return {
  shakeCamera = shakeCamera,
  getWindowDimensions = getWindowDimensions,
  getVirtualWindowDimensions = getVirtualWindowDimensions,
  rotate = rotate,
}
