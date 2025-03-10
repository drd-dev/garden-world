local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Grass : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Grass
Grass = class("Grass").extends("PObj") or Grass;


local img <const> = gfx.imagetable.new("images/nature/grass")


Grass.name = "Grass"
Grass.img = img:getImage(1);
Grass.icon = img:getImage(1);
Grass.cost = 2;


function Grass:init(angle, distance, planet)
  Grass.super.init(self, img:getImage(1), angle, distance, planet)

  self:setUpdatesEnabled(true);


  self.animator = gfx.animation.loop.new(250, img, true)
end

function Grass:update()
  self.image = self.animator:image()
end
