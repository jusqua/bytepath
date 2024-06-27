local utf8 = require('lib.utf8')
local Moses = require('lib.moses.moses')
local GameObject = require('src.GameObject')
local constants = require('src.constants')
local fonts = require('src.fonts')

local InfoText = GameObject:extend()

function InfoText:new(x, y, text, color)
  InfoText.super.new(self, x, y)

  local default_colors = {
    constants.default_color,
    constants.hp_color,
    constants.ammo_color,
    constants.boost_color,
    constants.skill_point_color,
  }
  local negative_colors = {
    { 1 - constants.default_color[1], 1 - constants.default_color[2], 1 - constants.default_color[3] },
    { 1 - constants.hp_color[1], 1 - constants.hp_color[2], 1 - constants.hp_color[3] },
    { 1 - constants.ammo_color[1], 1 - constants.ammo_color[2], 1 - constants.ammo_color[3] },
    { 1 - constants.boost_color[1], 1 - constants.boost_color[2], 1 - constants.boost_color[3] },
    { 1 - constants.skill_point_color[1], 1 - constants.skill_point_color[2], 1 - constants.skill_point_color[3] },
  }
  local all_colors = Moses.append(default_colors, negative_colors)

  self.font = fonts.m5x7_16
  self.depth = 80
  self.text = text
  self.color = color or constants.default_color
  self.characters = {}
  for i = 1, #self.text do
    table.insert(self.characters, utf8.sub(self.text, i, i))
  end

  self.visible = true
  self.fg_colors = {}
  self.bg_colors = {}

  self.timer:after(0.7, function()
    self.timer:every(0.035, function()
      local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|ABCDEFGHIJKLMNOPQRSTUVWYXZ'
      for i = 1, #self.characters do
        if love.math.random(1, 20) <= 1 then
          local r = love.math.random(#random_characters)
          self.characters[i] = utf8.sub(random_characters, r, r)
        end

        if love.math.random(1, 20) <= 1 then
          self.bg_colors[i] = all_colors[love.math.random(#all_colors)]
        else
          self.bg_colors[i] = nil
        end

        if love.math.random(1, 20) <= 2 then
          self.fg_colors[i] = all_colors[love.math.random(#all_colors)]
        else
          self.fg_colors[i] = nil
        end
      end
    end)

    self.timer:every(0.05, function()
      self.visible = not self.visible
    end, 6)

    self.timer:after(0.35, function()
      self.visible = true
    end)
  end)

  self.timer:after(1.1, function()
    self:die()
  end)
end

function InfoText:update(dt)
  InfoText.super.update(self, dt)
end

function InfoText:draw()
  if not self.visible then
    return
  end

  love.graphics.setFont(self.font)

  for i = 1, #self.characters do
    local width = 0
    if i > 1 then
      for j = 1, i - 1 do
        width = width + self.font:getWidth(self.characters[j])
      end
    end

    if self.bg_colors[i] then
      love.graphics.setColor(self.bg_colors[i])
      love.graphics.rectangle(
        'fill',
        self.x + width,
        self.y - self.font:getHeight() / 2,
        self.font:getWidth(self.characters[i]),
        self.font:getHeight()
      )
    end

    love.graphics.setColor(self.fg_colors[i] or self.color)
    love.graphics.print(self.characters[i], self.x + width, self.y, 0, 1, 1, 0, self.font:getHeight() / 2)
  end

  love.graphics.setColor(constants.default_color)
end

function InfoText:destroy()
  InfoText.super.destroy(self)
end

function InfoText:die()
  InfoText.super.die(self)
end

return InfoText
