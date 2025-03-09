local pd <const> = playdate
local gfx <const> = pd.graphics
local random <const> = math.random

---@class Cloud : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Cloud
Cloud = class("Cloud").extends("PObj") or Cloud;


local imgtable <const> = gfx.imagetable.new("images/nature/cloud-table-64-32")


Cloud.img = imgtable:getImage(1);


function Cloud:init(angle, distance, planet)
  Cloud.super.init(self, imgtable:getImage(random(1, #imgtable)), angle, distance, planet)

  self:setUpdatesEnabled(true)
  self.distance = random(100, 200)
  self.noCollide = true;

  self.speed = random(10, 30) / self.distance / 2

  --get a random -1 or 1
  self.flip = random(0, 1) * 2 - 1
  self.removable = false;
end

function Cloud:update()
  self.angle = self.angle + self.speed
end
