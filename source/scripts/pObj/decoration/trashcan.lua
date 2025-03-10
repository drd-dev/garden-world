local pd <const> = playdate
local gfx <const> = pd.graphics

---@class TrashCan : PObj
---@overload fun(angle: number, distance: number, planet: Planet): TrashCan
TrashCan = class("TrashCan").extends("PObj") or TrashCan;





--create TrashCan image
local img <const> = gfx.image.new("images/decoration/TrashCan")


TrashCan.name = "Trash Can"
TrashCan.img = img;
TrashCan.icon = img;
TrashCan.cost = 25;


function TrashCan:init(angle, distance, planet)
  TrashCan.super.init(self, img, angle, distance, planet)
end
