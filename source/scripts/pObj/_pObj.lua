local pd <const> = playdate
local gfx <const> = pd.graphics
local getOrbitPosition <const> = Utils.getOrbitPosition


---@class PObj: _Sprite
---@overload fun(angle: number, distance: number, planet: Planet): PObj
PObj = class("PObj").extends(gfx.sprite) or PObj;


function PObj:init(image, angle, distance, planet)
  PObj.super.init(self)

  planet.objects[#planet.objects + 1] = self
  self.planetObjectIndex = #planet.objects


  self.image = image;
  if (self.image) then
    self:setSize(self.image:getSize())
  end

  self.planet = planet;
  self.angle = angle;
  self.distance = (distance or 0) + (self.height / 2)

  --dither
  self.dither = nil;
  self.ditherAmount = 0;


  self.static = false;

  self:moveTo(getOrbitPosition(self.planet, self.angle, self.distance * CURRENT_ZOOM))

  self:add()


  self:setUpdatesEnabled(false)
end

function PObj:remove()
  table.remove(self.planet.objects, self.planetObjectIndex)
  PObj.super.remove(self)
end
