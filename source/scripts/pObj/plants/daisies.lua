local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Daisies: PObj
Daisies = class("Daisies").extends("Plant") or Daisies;


local imgtable <const> = gfx.imagetable.new("images/plants/daisies")
Daisies.img = imgtable:getImage(1);
Daisies.icon = ICON_IMAGETABLE:getImage(2);
Daisies.cost = 50;
Daisies.points = 2;
Daisies.water = 35;
Daisies.name = "DAISIES"

function Daisies:init(angle, distance, planet)
  Daisies.super.init(self, imgtable, angle, distance, planet, Daisies.water, 10000)

  self.points = Daisies.points;
  self.pointTime = 1000;
end
