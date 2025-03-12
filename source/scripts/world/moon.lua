local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Moon : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Moon
Moon = class("Moon").extends("PObj") or Moon;


local size <const> = 220;
local halfSize <const> = size / 2;
local img <const> = gfx.image.new(size, size);

gfx.pushContext(img)
gfx.setColor(gfx.kColorWhite);
gfx.fillCircleAtPoint(halfSize, halfSize, halfSize);
gfx.popContext();


Moon.img = img


function Moon:init(angle, distance, planet)
  Moon.super.init(self, img, angle, distance, planet)
  self:setUpdatesEnabled(true)
  self.noCollide = true;
  self.speed = 0.25;
  self.static = true;
end

function Moon:update()
  self.angle += self.speed;
  if (self.angle > 360) then
    self.angle = 0
  elseif (self.angle < 0) then
    self.angle = 360
  end
end
