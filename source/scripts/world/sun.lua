local pd <const> = playdate
local gfx <const> = pd.graphics
local easeOutExpo <const> = Utils.easeOutExpo
local random <const> = math.random

---@class Sun : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Sun
Sun = class("Sun").extends(gfx.sprite) or Sun;


local size <const> = 400;
local halfSize <const> = size / 2;
local img <const> = gfx.image.new(size, size, gfx.kColorClear);

gfx.pushContext(img)
gfx.setColor(gfx.kColorWhite);
gfx.fillCircleAtPoint(halfSize, halfSize, halfSize);
gfx.popContext();

Sun.img = img


function Sun:init()
  Sun.super.init(self, img)
  self:setCenter(0.5, 0.5)
  self:moveTo(-100, pd.display:getHeight() / 2)
  self:setZIndex(Z_INDEX.PLANET);
  self:add()
  -- self:setImage(img)
end

function Sun:update()
  local newX = easeOutExpo(-100, -250, CURRENT_ZOOM)
  self:moveTo(newX, self.y);
end
