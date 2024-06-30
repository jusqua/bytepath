local push = require('lib.push.push')

local function random(min, max)
  min, max = min or 0, max or 1
  return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

-- based on https://jonny.morrill.me/en/blog/gamedev-how-to-implement-a-camera-shake-effect

-- auxiliary function for shake
local function getShakeOffsets(amplitude, frequency, duration, pnoise, t)
  local s = t / 1000 * frequency
  local s0 = math.floor(s)
  local k = math.max(0, (duration - t) / duration)
  local noise = random(-1, 1)
  local d = k * amplitude * (pnoise + (s - s0) * (noise - pnoise))

  return noise, d
end

-- make camera shake based on given amplitude, frequency and duration
local function shakeCamera(camera, timer, amplitude, frequency, duration)
  -- x axis
  do
    local t, d = 0, 0
    local pnoise = random(-1, 1)
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
    local pnoise = random(-1, 1)
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

local function createColor(r, g, b)
  return { r / 255, g / 255, b / 255 }
end

local function createNegativeColor(color)
  local r, g, b = unpack(color)
  return { 1 - r, 1 - g, 1 - b }
end

local function pickRandom(t)
  return t[love.math.random(1, #t)]
end

local function rotateAtPosition(x, y, angle)
  love.graphics.translate(x, y)
  love.graphics.rotate(angle)
  love.graphics.translate(-x, -y)
end

local function rotateAtPositionAndScale(x, y, angle, sx, sy)
  love.graphics.translate(x, y)
  love.graphics.rotate(angle)
  love.graphics.scale(sx, sy or sx)
  love.graphics.translate(-x, -y)
end

local function generateIrregularPolygon(size, amount)
  amount = amount or 8

  local points = {}
  for i = 1, amount do
    local angle_interval = 2 * math.pi / amount
    local distance = size + random(-size / 4, size / 4)
    local angle = (i - 1) * angle_interval + random(-angle_interval / 4, angle_interval / 4)
    table.insert(points, distance * math.cos(angle))
    table.insert(points, distance * math.sin(angle))
  end

  return points
end

local function chanceList(...)
  return {
    chance_list = {},
    chance_definitions = { ... },
    next = function(self)
      if #self.chance_list == 0 then
        for _, chance_definition in ipairs(self.chance_definitions) do
          for _ = 1, chance_definition[2] do
            table.insert(self.chance_list, chance_definition[1])
          end
        end
      end
      return table.remove(self.chance_list, love.math.random(1, #self.chance_list))
    end,
  }
end

local function resize(scale)
  local vw, vh = getVirtualWindowDimensions()
  local w, h = vw * scale, vh * scale
  love.window.setMode(w, h)
  push.resize(w, h)
end

return {
  shakeCamera = shakeCamera,
  getWindowDimensions = getWindowDimensions,
  getVirtualWindowDimensions = getVirtualWindowDimensions,
  rotate = rotate,
  createColor = createColor,
  createNegativeColor = createNegativeColor,
  random = random,
  pickRandom = pickRandom,
  rotateAtPosition = rotateAtPosition,
  rotateAtPositionAndScale = rotateAtPositionAndScale,
  generateIrregularPolygon = generateIrregularPolygon,
  chanceList = chanceList,
  resize = resize,
}
