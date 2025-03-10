local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Plant : PObj
---@overload fun(imagetable: _ImageTable, angle: number, distance: number, planet: Planet, water: number)
Plant = class("Plant").extends("PObj") or Plant;

Plant.name = "New Plant"
Plant.cost = 25;
Plant.points = 1;
Plant.water = 20;

function Plant:init(imagetable, angle, distance, planet, water)
  Plant.super.init(self, imagetable:getImage(1), angle, distance, planet)

  self.imagetable = imagetable;
  self.growTime = 10000;
  self.points = 2;
  self.pointTime = 1000;
  self.water = water or 20; -- the number of time a plant will produce before needing to be watered.


  self.currentWater = self.water;
  self.fullyGrown = false;
  self.growStepTime = self.growTime / #imagetable
  self.animator = gfx.animation.loop.new(self.growStepTime, self.imagetable, false)

  self:setUpdatesEnabled(true);
  self.now = pd.getElapsedTime();
  self.pointAnimator = nil;
end

function Plant:update()
  Plant.super.update(self)
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
function Plant:grownUpdate()
  local time = pd.getElapsedTime();
  if (self.currentWater > 0 and time - self.now > (self.pointTime / 1000)) then
    self.now = pd.getElapsedTime();
    POINTS += self.points;
    self.pointAnimator = gfx.animator.new(500, -5, 0);
    self.currentWater -= 1;
  end

  if (time - self.now > 0.5) then
    self.pointAnimator = nil;
  end
end

---caled once when the plant fully grows
function Plant:onFullGrown()
end

function Plant:waterPlant()
  print("watered plant")
  self.currentWater = self.water;
end
