local Camera = require('lib.hump.camera')
local GameObject = require('src.GameObject')
local Scene = require('src.Scene')
local utils = require('src.utils')
local colors = require('src.constants.colors')

local Engine = GameObject:extend()

function Engine:new()
  Engine.super.new(self)

  self.slow_factor = 1
  self.slow_handler = nil
  self.flash_frames = 0
  self.sp = 0

  self.scene = Scene(self)
  self.camera = Camera()
end

function Engine:update(dt)
  self.timer:update(dt * self.slow_factor)

  if self.scene then
    self.scene:update(dt * self.slow_factor)
  end

  local w, h = utils.getWindowDimensions()
  self.camera:lockPosition(w / 2, h / 2, Camera.smooth.damped(6))
end

function Engine:draw()
  if self.flash_frames > 0 then
    self.flash_frames = self.flash_frames - 1
    love.graphics.setColor(colors.normal.background)
    love.graphics.rectangle('fill', 0, 0, utils.getVirtualWindowDimensions())
  end

  love.graphics.setColor(colors.normal.default)
  self.camera:attach()
  if self.scene then
    self.scene:draw()
  end
  self.camera:detach()
end

function Engine:shake(amplitude, frequency, duration)
  utils.shakeCamera(self.camera, self.timer, amplitude, frequency, duration)
end

function Engine:slowdown(factor, duration)
  self.slow_factor = factor

  if self.slow_handler then
    self.timer:cancel(self.slow_handler)
    self.slow_handler = nil
  end

  self.slow_handler = self.timer:tween(duration, self, { slow_factor = 1 }, 'in-out-cubic')
end

function Engine:flash(frames)
  self.flash_frames = frames
end

function Engine:attach(scene)
  if self.scene then
    self.scene:destroy()
  end

  self.scene = scene
end

function Engine:changeSPBy(amount)
  self.sp = math.max(0, self.sp + amount)
end

return Engine
