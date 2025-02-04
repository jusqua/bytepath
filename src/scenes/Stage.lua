local push = require('lib.push.push')
local Input = require('lib.input.input')
local GameObject = require('src.GameObject')
local Area = require('src.Area')
local Player = require('src.Player')
local Director = require('src.Director')
local fonts = require('src.constants.fonts')
local colors = require('src.constants.colors')
local utils = require('src.utils')

local Stage = GameObject:extend()

function Stage:new(engine)
  Stage.super.new(self)

  self.engine = engine
  self.area = Area()
  self.score = 0
  self.font = fonts.m5x7_16
  self.area:generateWorld()
  self.area.world:addCollisionClass('Player')
  self.area.world:addCollisionClass('Projectile', { ignores = { 'Projectile', 'Player' } })
  self.area.world:addCollisionClass('Collectable', { ignores = { 'Collectable', 'Projectile' } })
  self.area.world:addCollisionClass('Enemy', { ignores = { 'Enemy', 'Collectable' } })
  self.area.world:addCollisionClass('EnemyProjectile', { ignores = { 'Enemy', 'Collectable', 'EnemyProjectile' } })

  local wwidth, wheight, _ = love.window.getMode()
  local vx, vy = push.toGame(wwidth / 2, wheight / 2)
  self.player = Player(vx, vy, engine, self.area)
  self.director = Director(self)
  self.game_over = false
  self.paused = false

  self.area:insert(self.player)

  self.player_max_health_points = self.player.max_health_point
  self.player_max_ammo = self.player.max_ammo
  self.player_max_boost = self.player.max_boost
  self.player_cycle_cooldown = self.player.cycle_cooldown
end

function Stage:update(dt)
  Stage.super.update(self, dt)

  if not self.game_over and select(1, Input.pressed('escape')) then
    self.paused = not self.paused
  end

  if self.game_over or self.paused then
    if select(1, Input.pressed('q')) then
      self.engine:attach(self.engine.scenes.Console(self.engine))
    elseif select(1, Input.pressed('r')) then
      self.engine:attach(self.engine.scenes.Stage(self.engine))
    end
  end

  if self.paused then
    return
  end

  if self.director then
    self.director:update(dt)
  end

  if self.area then
    self.area:update(dt)
  end

  if self.player and not self.player.alive then
    self.player = nil
  end
end

function Stage:draw()
  self.area:draw()

  local vw, vh = utils.getVirtualWindowDimensions()
  love.graphics.setFont(self.font)

  -- score counter
  love.graphics.setColor(colors.normal.default)
  love.graphics.print(
    tostring(self.score),
    vw - 20,
    10,
    0,
    1,
    1,
    math.floor(self.font:getWidth(tostring(self.score)) / 2),
    self.font:getHeight() / 2
  )

  -- health point gauge bar
  local r, g, b = unpack(colors.normal.hp)
  local cur, max = self.player and self.player.health_point or 0, self.player_max_health_points
  local gauge_text = cur .. '/' .. max
  local title = 'HEALTH'
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle('fill', vw / 2 - 52, vh - 16, 48 * (cur / max), 4)
  love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
  love.graphics.rectangle('line', vw / 2 - 52, vh - 16, 48, 4)
  love.graphics.print(
    title,
    vw / 2 - 52 + 24,
    vh - 16,
    0,
    1,
    1,
    math.floor(self.font:getWidth(title) / 2),
    math.floor(self.font:getHeight())
  )
  love.graphics.print(
    gauge_text,
    vw / 2 - 52 + 24,
    vh - 6,
    0,
    1,
    1,
    math.floor(self.font:getWidth(gauge_text) / 2),
    math.floor(self.font:getHeight() / 2)
  )

  -- cicle gauge bar
  r, g, b = 1, 1, 1
  cur, max = self.player and self.player.cycle_timer or 0, self.player_cycle_cooldown
  title = 'CYCLE'
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle('fill', vw / 2 + 4, vh - 16, 48 * (cur / max), 4)
  love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
  love.graphics.rectangle('line', vw / 2 + 4, vh - 16, 48, 4)
  love.graphics.print(
    title,
    vw / 2 + 4 + 24,
    vh - 16,
    0,
    1,
    1,
    math.floor(self.font:getWidth(title) / 2),
    math.floor(self.font:getHeight())
  )

  -- ammo gauge bar
  r, g, b = unpack(colors.normal.ammo)
  cur, max = self.player and self.player.ammo or 0, self.player_max_ammo
  gauge_text = cur .. '/' .. max
  title = 'AMMO'
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle('fill', vw / 2 - 52, 16, 48 * (cur / max), 4)
  love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
  love.graphics.rectangle('line', vw / 2 - 52, 16, 48, 4)
  love.graphics.print(
    gauge_text,
    vw / 2 - 52 + 24,
    16,
    0,
    1,
    1,
    math.floor(self.font:getWidth(gauge_text) / 2),
    math.floor(self.font:getHeight())
  )
  love.graphics.print(
    title,
    vw / 2 - 52 + 24,
    26,
    0,
    1,
    1,
    math.floor(self.font:getWidth(title) / 2),
    math.floor(self.font:getHeight() / 2)
  )

  -- boost gauge bar
  r, g, b = unpack(colors.normal.boost)
  cur, max = self.player and self.player.boost or 0, self.player_max_boost
  title = 'BOOST'
  gauge_text = math.floor(cur) .. '/' .. max
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle('fill', vw / 2 + 4, 16, 48 * (cur / max), 4)
  love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
  love.graphics.rectangle('line', vw / 2 + 4, 16, 48, 4)
  love.graphics.print(
    gauge_text,
    vw / 2 + 4 + 24,
    16,
    0,
    1,
    1,
    math.floor(self.font:getWidth(gauge_text) / 2),
    math.floor(self.font:getHeight())
  )
  love.graphics.print(
    title,
    vw / 2 + 4 + 24,
    26,
    0,
    1,
    1,
    math.floor(self.font:getWidth(title) / 2),
    math.floor(self.font:getHeight() / 2)
  )

  love.graphics.setColor(colors.normal.default)

  if self.game_over or self.paused then
    title = self.game_over and 'GAME OVER' or 'PAUSED'
    love.graphics.print(
      title,
      vw / 2,
      vh / 2 - self.font:getHeight(),
      0,
      1,
      1,
      math.floor(self.font:getWidth(title) / 2),
      math.floor(self.font:getHeight() / 2)
    )
    title = 'Press [R] to restart simulation or [Q] to return to console'
    love.graphics.print(
      title,
      vw / 2,
      vh / 2 + self.font:getHeight(),
      0,
      1,
      1,
      math.floor(self.font:getWidth(title) / 2),
      math.floor(self.font:getHeight() / 2)
    )
  end
end

function Stage:destroy()
  Stage.super.destroy(self)
  self.area:destroy()
  self.area = nil
  self.engine = nil
  self.director = nil
end

function Stage:finish()
  self.engine.timer:after(0.5, function()
    self.game_over = true
    self.paused = false
  end)
end

function Stage:changeScoreBy(amount)
  self.score = self.score + amount
end

return Stage
