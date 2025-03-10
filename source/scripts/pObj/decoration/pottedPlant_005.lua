local pd <const> = playdate
local gfx <const> = pd.graphics

---@class PottedPlant_005 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): PottedPlant_005
PottedPlant_005 = class("PottedPlant_005").extends("PObj") or PottedPlant_005;





--create PottedPlant_005 image
local img <const> = gfx.imagetable.new("images/decoration/PottedPlant"):getImage(5)


PottedPlant_005.name = "Potted Plant 5"
PottedPlant_005.img = img;
PottedPlant_005.icon = img;
PottedPlant_005.cost = 25;


function PottedPlant_005:init(angle, distance, planet)
  PottedPlant_005.super.init(self, img, angle, distance, planet)
end
