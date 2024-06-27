local utf8 = require('lib.utf8')
local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')
local fonts = require('src.constants.fonts')

local InfoText = GameObject:extend()

function InfoText:new(x, y, text, color)
  InfoText.super.new(self, x, y)

  self.font = fonts.m5x7_16
  self.depth = 80
  self.text = text
  self.color = color or colors.normal.default
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
        if love.math.random(100) <= 20 then
          local r = love.math.random(#random_characters)
          self.characters[i] = utf8.sub(random_characters, r, r)
        end

        if love.math.random(100) <= 30 then
          self.bg_colors[i] = colors.all[love.math.random(#colors.all)]
        else
          self.bg_colors[i] = nil
        end

        if love.math.random(100) <= 5 then
          self.fg_colors[i] = colors.all[love.math.random(#colors.all)]
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

  love.graphics.setColor(colors.normal.default)
end

return InfoText
