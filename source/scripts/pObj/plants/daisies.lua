local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Daisies: PObj
Daisies = class("Daisies").extends("Plant") or Daisies;


local imgtable <const> = gfx.imagetable.new("images/plants/daisies")
Daisies.img = imgtable:getImage(1);
Daisies.icon = ICON_IMAGETABLE:getImage(2);
Daisies.cost = 50;
Daisies.points = 2;

function Daisies:init(angle, distance, planet)
  Daisies.super.init(self, imgtable, angle, distance, planet, 20)

  self.growTime = 10000;
  self.points = 2;
  self.pointTime = 1000;
end
