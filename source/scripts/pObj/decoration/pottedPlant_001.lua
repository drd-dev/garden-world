local pd <const> = playdate
local gfx <const> = pd.graphics

---@class PottedPlant_001 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): PottedPlant_001
PottedPlant_001 = class("PottedPlant_001").extends("PObj") or PottedPlant_001;





--create PottedPlant_001 image
local img <const> = gfx.imagetable.new("images/decoration/PottedPlant"):getImage(1)


PottedPlant_001.name = "Potted Plant 1"
PottedPlant_001.img = img;
PottedPlant_001.icon = img;
PottedPlant_001.cost = 25;


function PottedPlant_001:init(angle, distance, planet)
  PottedPlant_001.super.init(self, img, angle, distance, planet)
end
