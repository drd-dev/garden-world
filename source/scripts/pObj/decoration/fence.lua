local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Fence : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Fence
Fence = class("Fence").extends("PObj") or Fence;





--create Fence image
local img <const> = gfx.image.new("images/decoration/Fence")


Fence.name = "Fence"
Fence.img = img;
Fence.icon = img;
Fence.cost = 25;


function Fence:init(angle, distance, planet)
  Fence.super.init(self, img, angle, distance, planet)
end
