import "scripts/ui/cursor"

local pd <const> = playdate
local gfx <const> = pd.graphics
local rad <const> = math.rad
--_@class ObjectPlacer: _Sprite
ObjectPlacer = class("ObjectPlacer").extends(gfx.sprite) or ObjectPlacer

function ObjectPlacer:init()
  ObjectPlacer.super.init(self)

  self.planet = PLANET

  self:setSize(240, 32)
  self:setZIndex(Z_INDEX.UI_BACK)
  self:setCenter(0.5, 0)
  self:moveTo(pd.display:getWidth() / 2, 5)
  self:setIgnoresDrawOffset(true);
  self:add()


  --particles
  self.particles = ParticleCircle(self.x, self.y + 130)
  self.particles:setMode(Particles.modes.DECAY);
  self.particles:setSpeed(2, 5);
  self.particles:setSize(35, 55)
  self.particles:setColor(gfx.kColorWhite)
  self.particles:setDecay(3)



  self.objects = {
    Hut,
    Bush
  }

  self.selectedObject = 1


  self.placementImg = gfx.image.new(100, 100, gfx.kColorClear)
  gfx.pushContext(self.cursorImg)
  gfx.setColor(gfx.kColorWhite)
  --draw a downward pointing arrow
  gfx.drawLine(0, 0, 16, 32)
  gfx.drawLine(32, 0, 16, 32)

  gfx.popContext()

  self.cursor = Cursor();
  self.cursor:setIcon(self.objects[self.selectedObject].img);
end

function ObjectPlacer:update()
  if (CURRENT_ZOOM > ZOOM_MAX - 0.75) then
    self:setVisible(true)
    self.cursor:setVisible(true)
  else
    self:setVisible(false)
    self.cursor:setVisible(false)
  end

  if (pd.buttonJustPressed(pd.kButtonB) and self:isVisible()) then
    local widthCheck = self.objects[self.selectedObject].img:getSize();
    if (self:checkSpace(270 - self.planet.planetRotation, widthCheck, 2)) then
      self:placeObject()
    end
  end


  if (pd.buttonJustPressed(pd.kButtonLeft) and self:isVisible()) then
    self:prevObject()
  end

  if (pd.buttonJustPressed(pd.kButtonRight) and self:isVisible()) then
    self:nextObject()
  end

  self:markDirty();

  self:handleCursor();
end

function ObjectPlacer:handleCursor()
  local x, y = Utils.getOrbitPosition(self.planet, 270 - self.planet.planetRotation, 32)
  self.cursor:moveTo(x, y)
end

function ObjectPlacer:draw(x, y, width, height)
  gfx.clear(gfx.kColorClear)
  gfx.setLineWidth(1)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawRect(0, 0, self.width, 32)
end

function ObjectPlacer:checkSpace(angle, width, padding)
  padding = padding or 1;
  local planet = self.planet
  local radius = planet.radius -- Planet's radius (must be defined)
  local objects = planet.objects

  -- Convert the new object's center angle from degrees to radians.
  local angleRad = rad(angle)

  -- Convert the new object's linear width to an angular half-width in radians.
  local halfAngularWidth = (width + padding / 2) / radius
  local minCheck = angleRad - halfAngularWidth
  local maxCheck = angleRad + halfAngularWidth

  for i = 1, #objects do
    local obj = objects[i]
    -- Convert the object's center angle from degrees to radians.
    local objAngleRad = rad(obj.angle)
    -- Convert the object's linear width to its angular half-width (radians).
    local objHalfAngularWidth = (obj.width / 2) / radius
    local objLeftAngle = objAngleRad - objHalfAngularWidth
    local objRightAngle = objAngleRad + objHalfAngularWidth



    -- Check if the angular intervals overlap.
    if (maxCheck > objLeftAngle and minCheck < objRightAngle) then
      return false
    end
  end
  return true
end

function ObjectPlacer:placeObject()
  if (self.cursor.placementAnimator) then return end
  local speed = 500;
  self.cursor:placeObject(speed)
  pd.timer.new(speed, function()
    CAMERA:applyScreenShake(2, 100)
    self.particles:add(20)
    local planet = self.planet
    local angle = 270 - planet.planetRotation
    self.objects[self.selectedObject](angle, 0, planet)
    planet:markDirty()
  end)
end

function ObjectPlacer:nextObject()
  self.selectedObject += 1;
  if (self.selectedObject > #self.objects) then
    self.selectedObject = 1
  end
  self.cursor:setIcon(self.objects[self.selectedObject].img)
end

function ObjectPlacer:prevObject()
  self.selectedObject -= 1;
  if (self.selectedObject < 1) then
    self.selectedObject = #self.objects
  end
  self.cursor:setIcon(self.objects[self.selectedObject].img)
end
