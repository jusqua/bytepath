-- based on https://jonny.morrill.me/en/blog/gamedev-how-to-implement-a-camera-shake-effect

-- auxiliary function for shake
local function _shake(amplitude, frequency, duration, pnoise, t)
  local s = t / 1000 * frequency
  local s0 = math.floor(s)
  local k = math.max(0, (duration - t) / duration)
  local noise = love.math.random(-1, 1)
  local d = k * amplitude * (pnoise + (s - s0) * (noise - pnoise))

  return noise, d
end

-- make camera shake based on given amplitude, frequency and duration
local function shake(camera, timer, amplitude, frequency, duration)
  -- x axis
  do
    local t, d = 0, 0
    local pnoise = love.math.random(-1, 1)
    timer:during(duration, function(dt)
      t = t + dt
      pnoise, d = _shake(amplitude, frequency, duration, pnoise, t)
      camera:move(d, 0)
    end)
  end

  -- y axis
  do
    local t, d = 0, 0
    local pnoise = love.math.random(-1, 1)
    timer:during(duration, function(dt)
      t = t + dt
      pnoise, d = _shake(amplitude, frequency, duration, pnoise, t)
      camera:move(0, d)
    end)
  end
end

return {
  shake = shake,
}
