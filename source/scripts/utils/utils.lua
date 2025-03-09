local pi <const> = math.pi
local cos <const> = math.cos
local sin <const> = math.sin
local rad <const> = math.rad
local Mathmax <const> = math.max
local Mathmin <const> = math.min

---@class Utils: _Object
Utils = class("Utils").extends() or Utils;

function Utils.clamp(value, min, max)
  return Mathmax(Mathmin(value, max), min)
end

function Utils.getOrbitPosition(planet, angle, offset)
  local planetX = planet.planetX
  local planetY = planet.planetY
  local radius = planet.radius
  local degrees = rad(angle + planet.planetRotation)
  offset = offset or 0

  local x = planetX + (radius + offset) * cos(degrees)
  local y = planetY + (radius + offset) * sin(degrees)
  return x, y
end
