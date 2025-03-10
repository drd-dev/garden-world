local pd <const> = playdate
local gfx <const> = pd.graphics

---@class StreetLamp : PObj
---@overload fun(angle: number, distance: number, planet: Planet): StreetLamp
StreetLamp = class("StreetLamp").extends("PObj") or StreetLamp;


local imgTable <const> = gfx.imagetable.new("images/decoration/street_lamp")
local img <const> = imgTable:getImage(1)


StreetLamp.name = "Lamp"
StreetLamp.img = img;
StreetLamp.icon = img;
StreetLamp.cost = 50;


function StreetLamp:init(angle, distance, planet)
  StreetLamp.super.init(self, img, angle, distance, planet)

  self:setUpdatesEnabled(true);

  self.animator = gfx.animation.loop.new(250, imgTable, true)
end

function StreetLamp:update()
  self.image = self.animator:image()
end
