local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Bench : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Bench
Bench = class("Bench").extends("PObj") or Bench;





--create Bench image
local img <const> = gfx.image.new("images/decoration/Bench")

Bench.name = "Bench"
Bench.img = img;
Bench.icon = img;
Bench.cost = 50;


function Bench:init(angle, distance, planet)
  Bench.super.init(self, img, angle, distance, planet)
end
