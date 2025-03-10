local pd <const> = playdate
local gfx <const> = pd.graphics

---@class IcyStatue : PObj
---@overload fun(angle: number, distance: number, planet: Planet): IcyStatue
IcyStatue = class("IcyStatue").extends("PObj") or IcyStatue;





--create IcyStatue image
local img <const> = gfx.image.new("images/decoration/icyDudeStatue")


IcyStatue.name = "Icy Dude Statue"
IcyStatue.img = img;
IcyStatue.icon = img;
IcyStatue.cost = 1000;


function IcyStatue:init(angle, distance, planet)
  IcyStatue.super.init(self, img, angle, distance, planet)
end
