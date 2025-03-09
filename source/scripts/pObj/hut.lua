local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Hut : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Hut
Hut = class("Hut").extends("PObj") or Hut;


--create hut image
local img <const> = gfx.image.new(48, 64)
gfx.pushContext(img)
local w, h = img:getSize();
gfx.setColor(gfx.kColorWhite)

gfx.fillRect(8, h - 28, w - 8 * 2, 28)
gfx.fillTriangle(0, h - 28, w, h - 28, w / 2, 10)
--chimney
gfx.fillRect(10, 8, 8, 24)

--door
gfx.setColor(gfx.kColorBlack)
gfx.fillRect(28, h - 20, w - 20 * 2, 18)

--window
gfx.fillRect(10, h - 20, 12, 8)

gfx.popContext();


Hut.icon = img;


function Hut:init(angle, distance, planet)
  Hut.super.init(self, img, angle, distance, planet)
end
