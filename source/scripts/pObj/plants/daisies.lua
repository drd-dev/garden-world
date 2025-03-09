local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Daisies: PObj
Daisies = class("Daisies").extends("PObj") or Daisies;


local imgtable <const> = gfx.imagetable.new("images/plants/daisies")
Daisies.img = imgtable:getImage(1);
Daisies.icon = ICON_IMAGETABLE:getImage(2);
Daisies.cost = 50;
Daisies.points = 2;

function Daisies:init(angle, distance, planet)
  Daisies.super.init(self, imgtable:getImage(1), angle, distance, planet)

  self.growTime = 10000;
  self.points = 2;
  self.pointTime = 1000;


  self.growStepTime = self.growTime / #imgtable

  self.animator = gfx.animation.loop.new(self.growStepTime, imgtable, false)
  self.noCollide = false;

  self:setUpdatesEnabled(true);

  self.fullyGrown = false;


  self.now = pd.getElapsedTime();


  self.pointAnimator = nil;
end

function Daisies:update()
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
function Daisies:grownUpdate()
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
function Daisies:onFullGrown()
end
