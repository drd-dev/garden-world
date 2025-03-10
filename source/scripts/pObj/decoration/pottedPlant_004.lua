local pd <const> = playdate
local gfx <const> = pd.graphics

---@class PottedPlant_004 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): PottedPlant_004
PottedPlant_004 = class("PottedPlant_004").extends("PObj") or PottedPlant_004;





--create PottedPlant_004 image
local img <const> = gfx.imagetable.new("images/decoration/PottedPlant"):getImage(4)


PottedPlant_004.name = "Potted Plant 4"
PottedPlant_004.img = img;
PottedPlant_004.icon = img;
PottedPlant_004.cost = 25;


function PottedPlant_004:init(angle, distance, planet)
  PottedPlant_004.super.init(self, img, angle, distance, planet)
end
