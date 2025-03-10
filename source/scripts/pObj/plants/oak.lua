local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Oak: PObj
Oak = class("Oak").extends("Plant") or Oak;


local imgtable <const> = gfx.imagetable.new("images/plants/Oak")
Oak.img = imgtable:getImage(1);
Oak.icon = ICON_IMAGETABLE:getImage(2, 2);
Oak.cost = 200;
Oak.points = 5;
Oak.water = 150;
Oak.name = "Oak Tree"

function Oak:init(angle, distance, planet)
  Oak.super.init(self, imgtable, angle, distance, planet, Oak.water, 60000)
  self.points = Oak.points;
  self.pointTime = 1000;
end
