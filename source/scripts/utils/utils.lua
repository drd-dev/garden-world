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

function Utils.checkAngleForObjects(angle, width, padding)
  padding = padding or 1;
  local planet = PLANET
  local radius = planet.radius -- Planet's radius (must be defined)
  local objects = planet.objects

  -- Convert the new object's center angle from degrees to radians.
  local angleRad = rad(angle)

  -- Convert the new object's linear width to an angular half-width in radians.
  local halfAngularWidth = (width + padding / 2) / radius
  local minCheck = angleRad - halfAngularWidth
  local maxCheck = angleRad + halfAngularWidth

  local foundObjs = {};

  local freeSpace = true;


  for key, obj in pairs(objects) do
    if (not obj) then return end;
    -- Convert the object's center angle from degrees to radians.
    local objAngleRad = rad(obj.angle)
    -- Convert the object's linear width to its angular half-width (radians).
    local objHalfAngularWidth = (obj.width / 2) / radius
    local objLeftAngle = objAngleRad - objHalfAngularWidth
    local objRightAngle = objAngleRad + objHalfAngularWidth



    -- Check if the angular intervals overlap.
    if (maxCheck > objLeftAngle and minCheck < objRightAngle) then
      if (not obj.static and not obj.noCollide) then
        freeSpace = false;
      end
      foundObjs[#foundObjs + 1] = obj
    else
    end
  end
  return freeSpace, foundObjs
end
