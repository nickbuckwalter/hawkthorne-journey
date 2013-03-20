local director = require 'hawk/director'
local gamesave = require 'hawk/gamesave'
local i18n = require 'hawk/i18n'
local json = require 'hawk/json'
local middle = require 'hawk/middleclass'

local Application = middle.class('Application')

function Application:initialize(configurationPath)
  assert(love.filesystem.exists(configurationPath), "Can't read app configuration")
  
  local contents, _  = love.filesystem.read(configurationPath)
  self.config = json.decode(contents)

  self.gamesaves = gamesave(3)
  self.i18n = i18n("locales")
  self.director = director("scenes")
end

function Application:draw()
  local scene = self.director:active()
  if scene then scene:draw() end
end

function Application:keypressed(key)
  local scene = self.director:active()
  if scene then scene:keypressed(key) end
end

function Application:keyreleased(key)
  local scene = self.director:active()
  if scene then scene:keyreleased(key) end
end

function Application:update(dt)
  local scene = self.director:switch()
  if scene then scene:update(dt) end
end

return Application
