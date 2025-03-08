local pd <const> = playdate
local gfx <const> = pd.graphics
local getOrbitPosition <const> = Utils.getOrbitPosition


---@class PObj: _Sprite
---@overload fun(angle: number, distance: number, planet: Planet): PObj
PObj = class("PObj").extends(gfx.sprite) or PObj;


function PObj:init(image, angle, distance, planet)
  PObj.super.init(self, image)
  planet.objects[#planet.objects + 1] = self
  self.planetObjectIndex = #planet.objects


  self.image = image;

  self.planet = planet;
  self.angle = angle;
  self.distance = (distance or 0) + (self.height / 2)

  self:setCenter(0.5, 0.5);
  self:moveTo(getOrbitPosition(self.planet, self.angle, self.distance))
  self:setZIndex(Z_INDEX.P_OBJS);
  self:add()
  self:setScale(CURRENT_ZOOM)


  self:setUpdatesEnabled(false)


  self.lastZoom = -1
  self.lastPlanetRot = -1
end

function PObj:remove()
  table.remove(self.planet.objects, self.planetObjectIndex)
  PObj.super.remove(self)
end
