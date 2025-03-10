local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Apple: PObj
Apple = class("Apple").extends("Plant") or Apple;


local imgtable <const> = gfx.imagetable.new("images/plants/Apple")
Apple.img = imgtable:getImage(1);
Apple.icon = ICON_IMAGETABLE:getImage(3, 2);
Apple.cost = 300;
Apple.points = 10;
Apple.water = 200;
Apple.name = "Apple Tree"

function Apple:init(angle, distance, planet)
  Apple.super.init(self, imgtable, angle, distance, planet, Apple.water, 90000)
  self.points = Apple.points;
  self.pointTime = 1000;
end
