local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Hut : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Hut
Hut = class("Hut").extends("PObj") or Hut;





--create hut image
local img <const> = gfx.image.new("images/buildings/hut")


Hut.name = "Home"
Hut.img = img;
Hut.icon = img;
Hut.cost = 100;


function Hut:init(angle, distance, planet)
  Hut.super.init(self, img, angle, distance, planet)
end
