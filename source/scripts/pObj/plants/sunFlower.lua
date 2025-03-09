local pd <const> = playdate
local gfx <const> = pd.graphics

---@class SunFlower: PObj
SunFlower = class("SunFlower").extends("PObj") or SunFlower;


local imgtable <const> = gfx.imagetable.new("images/plants/sunFlower-table-16-32")
SunFlower.img = imgtable:getImage(1);
SunFlower.icon = ICON_IMAGETABLE:getImage(1);
SunFlower.cost = 25;
SunFlower.points = 1;

function SunFlower:init(angle, distance, planet)
  SunFlower.super.init(self, imgtable:getImage(1), angle, distance, planet)

  self.growTime = 5000;
  self.points = 1;
  self.pointTime = 1000;


  self.growStepTime = self.growTime / #imgtable

  self.animator = gfx.animation.loop.new(self.growStepTime, imgtable, false)
  self.noCollide = false;

  self:setUpdatesEnabled(true);

  self.fullyGrown = false;


  self.now = pd.getElapsedTime();


  self.pointAnimator = nil;
end

function SunFlower:update()
  if (not self.animator:isValid()) then
    if (not self.fullyGrown) then
      self.fullyGrown = true;
      self:onFullGrown();
    else
      self:grownUpdate();
    end
  else
    self.image = self.animator:image()
  end
end

--called every update once the plant is grown
function SunFlower:grownUpdate()
  local time = pd.getElapsedTime();
  if (time - self.now > (self.pointTime / 1000)) then
    self.now = pd.getElapsedTime();
    POINTS += self.points;
    self.pointAnimator = gfx.animator.new(500, -5, 0);
  end

  if (time - self.now > 0.5) then
    self.pointAnimator = nil;
  end
end

---caled once when the plant fully grows
function SunFlower:onFullGrown()
end
