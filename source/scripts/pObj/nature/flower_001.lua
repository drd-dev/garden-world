local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Flower_001 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Flower_001
Flower_001 = class("Flower_001").extends("PObj") or Flower_001;


local img <const> = gfx.image.new("images/nature/flower_001")

Flower_001.img = img;


function Flower_001:init(angle, distance, planet)
  Flower_001.super.init(self, img, angle, distance, planet)
end
