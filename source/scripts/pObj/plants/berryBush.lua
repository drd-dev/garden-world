local pd <const> = playdate
local gfx <const> = pd.graphics

---@class BerryBush: PObj
BerryBush = class("BerryBush").extends("PObj") or BerryBush;


local imgtable <const> = gfx.imagetable.new("images/plants/BerryBush")
BerryBush.img = imgtable:getImage(1);
BerryBush.icon = ICON_IMAGETABLE:getImage(3);
BerryBush.cost = 100;
BerryBush.points = 5;

function BerryBush:init(angle, distance, planet)
  BerryBush.super.init(self, imgtable:getImage(1), angle, distance, planet)

  self.growTime = 20000;
  self.points = 5;
  self.pointTime = 1000;


  self.growStepTime = self.growTime / #imgtable

  self.animator = gfx.animation.loop.new(self.growStepTime, imgtable, false)
  self.noCollide = false;

  self:setUpdatesEnabled(true);

  self.fullyGrown = false;


  self.now = pd.getElapsedTime();


  self.pointAnimator = nil;
end

function BerryBush:update()
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
function BerryBush:grownUpdate()
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
function BerryBush:onFullGrown()
end
