local Input = require('lib.input.input')
local GameObject = require('src.GameObject')
local colors = require('src.constants.colors')
local utils = require('src.utils')

local ResolutionModule = GameObject:extend()

function ResolutionModule:new(console)
  ResolutionModule.super.new(self, 0, console.line_y)

  self.console = console

  self.resolutions = {
    '480x270',
    '960x540',
    '1440x810',
    '1920x1080',
  }
  self.selection_index = 1
  self.selection_widths = {}

  self.base_delay = 0.02
  self.console:addLine(self.base_delay, 'Available resolutions: ')
  for i, resolution in ipairs(self.resolutions) do
    self.console:addLine(self.base_delay * (i + 1), '    ' .. resolution)
    self.selection_widths[i] = self.console.font:getWidth(resolution)
  end

  self.console.timer:after(self.base_delay + self.selection_index * self.base_delay, function()
    self.active = true
  end)
end

function ResolutionModule:update(dt)
  ResolutionModule.super.update(self, dt)

  if not self.active then
    return
  end

  if select(1, Input.pressed('up')) then
    self.selection_index = self.selection_index - 1
    if self.selection_index < 1 then
      self.selection_index = #self.selection_widths
    end
  end
  if select(1, Input.pressed('down')) then
    self.selection_index = self.selection_index + 1
    if self.selection_index > #self.selection_widths then
      self.selection_index = 1
    end
  end
  if select(1, Input.pressed('return')) then
    self.active = false
    utils.resize(self.selection_index)
    self.console:addLine(self.base_delay)
    self.console:addInputLine(self.base_delay * 2)
    self:die()
  end
end

function ResolutionModule:draw()
  if not self.active then
    return
  end

  local width = self.selection_widths[self.selection_index]
  local r, g, b = unpack(colors.normal.default)
  love.graphics.setColor(r, g, b, 0.90)
  local x_offset = self.console.font:getWidth('    ')
  love.graphics.rectangle(
    'fill',
    8 + x_offset - 2,
    self.y + self.selection_index * 12,
    width + 4,
    self.console.font:getHeight()
  )
  love.graphics.setColor(r, g, b, 1)
end

return ResolutionModule
