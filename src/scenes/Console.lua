local Input = require('lib.input.input')
local Moses = require('lib.moses.moses')
local GameObject = require('src.GameObject')
local utils = require('src.utils')
local colors = require('src.constants.colors')
local fonts = require('src.constants.fonts')
local modules = require('src.modules')

local Console = GameObject:extend()

function Console:new(engine)
  Console.super.new(self)

  self.engine = engine
  self.lines = {}
  self.line_y = 8
  self.font = fonts.m5x7_16
  self.base_input_text = { '[', colors.normal.skill_point, 'root', colors.normal.default, ']arch~ ' }
  self.inputting = false
  self.input_text = {}
  self.cursor_visible = true

  self.modules = {}

  local vw, vh = utils.getVirtualWindowDimensions()
  self.engine.camera:lookAt(vw / 2, vh / 2)

  self:addInputLine(1)

  self.timer:every(0.5, function()
    self.cursor_visible = not self.cursor_visible
  end)
end

function Console:update(dt)
  Console.super.update(self, dt)

  for i = #self.modules, 1, -1 do
    local module = self.modules[i]
    if module.alive then
      module:update(dt)
    else
      table.remove(self.modules, i)
    end
  end

  if self.inputting then
    if select(1, Input.pressed('return')) then
      self.inputting = false
      local input_text = ''
      for _, character in ipairs(self.input_text) do
        input_text = input_text .. character
      end
      self.input_text = {}
      if input_text == '' then
        self:addInputLine(0.1)
      elseif modules[input_text] then
        table.insert(self.modules, modules[input_text](self))
      end
    end
    if select(1, Input.down('backspace', 0.02, 0.1)) then
      table.remove(self.input_text, #self.input_text)
      self:updateText()
    end
  end
end

function Console:draw()
  for _, line in ipairs(self.lines) do
    love.graphics.draw(line.text, line.x, line.y)
  end

  for _, module in ipairs(self.modules) do
    module:draw()
  end

  if self.inputting and self.cursor_visible then
    local r, g, b = unpack(colors.normal.default)
    love.graphics.setColor(r, g, b, 0.90)
    local input_text = ''
    for _, character in ipairs(self.input_text) do
      input_text = input_text .. character
    end
    local x = 8 + self.font:getWidth('[root]arch~ ' .. input_text)
    love.graphics.rectangle('fill', x, self.lines[#self.lines].y, self.font:getWidth('w'), self.font:getHeight())
    love.graphics.setColor(r, g, b, 1)
  end
end

function Console:addLine(delay, text)
  delay = delay or 0
  text = text or { '' }
  self.timer:after(delay, function()
    table.insert(self.lines, { x = 8, y = self.line_y, text = love.graphics.newText(self.font, text) })
    self.line_y = self.line_y + 12
    self:scroll()
  end)
end

function Console:addInputLine(delay)
  delay = delay or 0
  self.timer:after(delay, function()
    table.insert(self.lines, { x = 8, y = self.line_y, text = love.graphics.newText(self.font, self.base_input_text) })
    self.line_y = self.line_y + 12
    self.inputting = true
    self:scroll()
  end)
end

function Console:textinput(t)
  if self.inputting then
    table.insert(self.input_text, t)
    self:updateText()
  end
end

function Console:scroll()
  local _, vh = utils.getVirtualWindowDimensions()
  local font_height = self.font:getHeight()
  if self.line_y + font_height > vh then
    local offset = self.line_y + font_height - vh
    self.line_y = self.line_y - offset
    for i = #self.lines, 1, -1 do
      local line = self.lines[i]
      self.timer:tween(0.05, line, { y = line.y - offset }, 'linear')
    end
  end
end

function Console:updateText()
  local base_input_text = Moses.clone(self.base_input_text)
  local input_text = ''
  for _, character in ipairs(self.input_text) do
    input_text = input_text .. character
  end
  table.insert(base_input_text, input_text)
  self.lines[#self.lines].text:set(base_input_text)
end

function Console:destroy()
  Console.super.destroy(self)
end

function Console:die()
  Console.super.die(self)
end

return Console
