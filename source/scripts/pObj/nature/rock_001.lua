local pd <const> = playdate
local gfx <const> = pd.graphics
local random <const> = math.random

---@class Rock_001 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Rock_001
Rock_001 = class("Rock_001").extends("PObj") or Rock_001;


local imgtable <const> = gfx.imagetable.new("images/nature/rock_001")


Rock_001.img = imgtable:getImage(1);
Rock_001.cost = 5;


function Rock_001:init(angle, distance, planet)
  Rock_001.super.init(self, imgtable:getImage(1), angle, distance, planet)


  self.image = imgtable:getImage(random(1, #imgtable))
  self.flip = random(0, 1) * 2 - 1
end
