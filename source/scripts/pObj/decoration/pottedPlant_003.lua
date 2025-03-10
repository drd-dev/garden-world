local pd <const> = playdate
local gfx <const> = pd.graphics

---@class PottedPlant_003 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): PottedPlant_003
PottedPlant_003 = class("PottedPlant_003").extends("PObj") or PottedPlant_003;





--create PottedPlant_003 image
local img <const> = gfx.imagetable.new("images/decoration/PottedPlant"):getImage(3)


PottedPlant_003.name = "Potted Plant 3"
PottedPlant_003.img = img;
PottedPlant_003.icon = img;
PottedPlant_003.cost = 25;


function PottedPlant_003:init(angle, distance, planet)
  PottedPlant_003.super.init(self, img, angle, distance, planet)
end
