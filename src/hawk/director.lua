local middle = require 'hawk/middleclass'

local Director = middle.class("Director")

function Director:initialize(scenePath)
  self.path = scenePath
  self.currentScene = nil
  self.queued = nil
end

function Director:queue(scene, ...)
  self.queued = {scene, {...}}
end

function Director:switch()
  if not self.queued then
    return self.current
  end

  local to, args = unpack(self.queued)
  self.queued = nil

  local scene = require(self.path .. "/" .. to)
  assert(scene, "Failed loading scene " .. to)

  if self.current then
    self.current:leave()
  end

  local pre = self.current

  self.current = scene(args)
  self.current:enter(pre)

  return self.current
end

function Director:active()
  return self.current
end

return Director
