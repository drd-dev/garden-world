local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Fountain : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Fountain
Fountain = class("Fountain").extends("PObj") or Fountain;


local img <const> = gfx.imagetable.new("images/decoration/Fountain")


Fountain.name = "Fountain"
Fountain.img = img:getImage(1);
Fountain.icon = img:getImage(1);
Fountain.cost = 750;

function Fountain:init(angle, distance, planet)
  Fountain.super.init(self, img:getImage(1), angle, distance, planet)

  self:setUpdatesEnabled(true);


  self.animator = gfx.animation.loop.new(350, img, true)
end

function Fountain:update()
  self.image = self.animator:image()
end
