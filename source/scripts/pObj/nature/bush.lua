local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Bush : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Bush
Bush = class("Bush").extends("PObj") or Bush;


local img <const> = gfx.image.new(32, 24)

gfx.pushContext(img)
gfx.setColor(gfx.kColorWhite);
---draw a few circles to represent a bush
gfx.fillCircleAtPoint(16, 12, 10);
gfx.fillCircleAtPoint(24, 16, 8);
gfx.fillCircleAtPoint(8, 16, 8);

gfx.popContext();

Bush.img = img;
Bush.icon = img;
Bush.cost = 2;


function Bush:init(angle, distance, planet)
  Bush.super.init(self, img, angle, distance, planet)
end
