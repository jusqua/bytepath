local GameObject = require('src.GameObject')
local utils = require('src.utils')
local enemies = require('src.enemies')
local resources = require('src.resources')

local Director = GameObject:extend()

function Director:new(scene)
  Director.super.new(self)

  self.scene = scene
  self.round = 1
  self.round_duration = 22
  self.round_timer = 0

  self.round_to_points = {}
  self.round_to_points[1] = 16
  for i = 2, 1024, 4 do
    self.round_to_points[i] = self.round_to_points[i - 1] + 8
    self.round_to_points[i + 1] = self.round_to_points[i]
    self.round_to_points[i + 2] = math.floor(self.round_to_points[i + 1] / 1.5)
    self.round_to_points[i + 3] = math.floor(self.round_to_points[i + 2] * 2)
  end

  self.enemies_to_points = {
    ['Rock'] = 1,
    ['Shooter'] = 2,
  }
  self.enemy_spawn_chances = {
    [1] = utils.chanceList({ 'Rock', 1 }),
    [2] = utils.chanceList({ 'Rock', 8 }, { 'Shooter', 4 }),
    [3] = utils.chanceList({ 'Rock', 8 }, { 'Shooter', 8 }),
    [4] = utils.chanceList({ 'Rock', 4 }, { 'Shooter', 8 }),
  }
  for i = 5, 1024 do
    self.enemy_spawn_chances[i] = utils.chanceList(
      { 'Rock', love.math.random(2, 12) },
      { 'Shooter', love.math.random(2, 12) }
    )
  end
  self:setEnemySpawns()

  self.resources_spawn_chances = utils.chanceList({ 'Boost', 28 }, { 'HealthPoint', 14 }, { 'SkillPoint', 58 })
  self.resources_spawn_time = 16
  self.timer:after(self.resources_spawn_time, function()
    local resource = self.resources_spawn_chances:next()
    self.scene.area:insert(resources[resource](self.scene))
  end)

  self.attack_spawn_rate = 30
  self.timer:after(self.attack_spawn_rate, function()
    self.scene.area:insert(resources.Attack(self.scene))
  end)
end

function Director:update(dt)
  Director.super.update(self, dt)

  self.round_timer = self.round_timer + dt
  if self.round_timer == self.round_duration then
    self.round_timer = self.round_timer - self.round_duration
    self.round = self.round + 1
    self:setEnemySpawns()
  end
end

function Director:setEnemySpawns()
  local points = self.round_to_points[self.round]

  local enemy_list = {}
  while points > 0 do
    local enemy = self.enemy_spawn_chances[self.round]:next()
    local _points = points - self.enemies_to_points[enemy]
    if _points < 0 then
      enemy = 'Rock'
      while points > 0 do
        points = points - self.enemies_to_points[enemy]
        table.insert(enemy_list, enemy)
      end
    else
      points = _points
      table.insert(enemy_list, enemy)
    end
  end

  local enemy_spawn_times = {}
  for i = 1, #enemy_list do
    enemy_spawn_times[i] = utils.random(0, self.round_duration)
  end
  table.sort(enemy_spawn_times, function(a, b)
    return a < b
  end)

  for i = 1, #enemy_spawn_times do
    self.timer:after(enemy_spawn_times[i], function()
      self.scene.area:insert(enemies[enemy_list[i]])
    end)
  end
end

return Director
