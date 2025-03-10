local pd <const> = playdate
local gfx <const> = pd.graphics

---@class PottedPlant_002 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): PottedPlant_002
PottedPlant_002 = class("PottedPlant_002").extends("PObj") or PottedPlant_002;





--create PottedPlant_002 image
local img <const> = gfx.imagetable.new("images/decoration/PottedPlant"):getImage(2)


PottedPlant_002.name = "Potted Plant 2"
PottedPlant_002.img = img;
PottedPlant_002.icon = img;
PottedPlant_002.cost = 25;


function PottedPlant_002:init(angle, distance, planet)
  PottedPlant_002.super.init(self, img, angle, distance, planet)
end
