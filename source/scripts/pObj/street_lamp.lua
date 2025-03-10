local pd <const> = playdate
local gfx <const> = pd.graphics

---@class StreetLamp : PObj
---@overload fun(angle: number, distance: number, planet: Planet): StreetLamp
StreetLamp = class("StreetLamp").extends("PObj") or StreetLamp;


local img <const> = gfx.image.new("images/decoration/street_lamp_001")

StreetLamp.img = img;
StreetLamp.icon = img;
StreetLamp.cost = 50;


function StreetLamp:init(angle, distance, planet)
  StreetLamp.super.init(self, img, angle, distance, planet)
end
