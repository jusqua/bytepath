local Camera = require('lib.hump.camera')
local GameObject = require('src.GameObject')
local Scene = require('src.Scene')
local utils = require('src.utils')

local Engine = GameObject:extend()

function Engine:new()
  Engine.super.new(self)

  self.scene = Scene()
  self.camera = Camera()
end

function Engine:update(dt)
  Engine.super.update(self, dt)

  if self.scene then
    self.scene:update(dt)
  end

  local w, h = utils.getWindowDimensions()
  self.camera:lockPosition(w / 2, h / 2, Camera.smooth.damped(5))
end

function Engine:draw()
  self.camera:attach()
  if self.scene then
    self.scene:draw()
  end
  self.camera:detach()
end

function Engine:attach(scene)
  if self.scene then
    self.scene:destroy()
  end

  self.scene = scene
end

return Engine
