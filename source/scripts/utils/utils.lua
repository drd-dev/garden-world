local pi <const> = math.pi
local cos <const> = math.cos
local sin <const> = math.sin


---@class Utils: _Object
Utils = class("Utils").extends() or Utils;

function Utils.clamp(value, min, max)
  return math.max(math.min(value, max), min)
end

function Utils.getOrbitPosition(planet, angle, offset)
  local planetX = planet.planetX
  local planetY = planet.planetY
  local radius = planet.radius
  local degrees = (angle + planet.planetRotation) * (pi / 180)
  offset = offset or 0

  local x = planetX + (radius + offset) * cos(degrees)
  local y = planetY + (radius + offset) * sin(degrees)
  return x, y
end
