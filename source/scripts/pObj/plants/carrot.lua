local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Carrot: PObj
Carrot = class("Carrot").extends("Plant") or Carrot;


local imgtable <const> = gfx.imagetable.new("images/plants/Carrot")
Carrot.img = imgtable:getImage(1);
Carrot.icon = ICON_IMAGETABLE:getImage(1, 2);
Carrot.cost = 30;
Carrot.points = 1;
Carrot.water = 50;
Carrot.name = "Carrot"

function Carrot:init(angle, distance, planet)
  Carrot.super.init(self, imgtable, angle, distance, planet, Carrot.water, 15000)

  self.points = Carrot.points;
  self.pointTime = 1000;
end
