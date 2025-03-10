local pd <const> = playdate
local gfx <const> = pd.graphics

---@class BerryBush: PObj
BerryBush = class("BerryBush").extends("Plant") or BerryBush;


local imgtable <const> = gfx.imagetable.new("images/plants/BerryBush")
BerryBush.img = imgtable:getImage(1);
BerryBush.icon = ICON_IMAGETABLE:getImage(3);
BerryBush.cost = 100;
BerryBush.points = 1;
BerryBush.water = 50;
BerryBush.name = "BERRY BUSH"

function BerryBush:init(angle, distance, planet)
  BerryBush.super.init(self, imgtable, angle, distance, planet, BerryBush.water)

  self.growTime = 20000;
  self.points = BerryBush.points;
  self.pointTime = 1000;
end
