local pd <const> = playdate
local gfx <const> = pd.graphics

---@class SunFlower: PObj
SunFlower = class("SunFlower").extends("Plant") or SunFlower;


local imgtable <const> = gfx.imagetable.new("images/plants/sunFlower-table-16-32")
SunFlower.img = imgtable:getImage(1);
SunFlower.icon = ICON_IMAGETABLE:getImage(1);
SunFlower.cost = 25;
SunFlower.points = 1;

function SunFlower:init(angle, distance, planet)
  SunFlower.super.init(self, imgtable, angle, distance, planet, 20)

  self.growTime = 5000;
  self.points = SunFlower.points;
  self.pointTime = 1000;
end
