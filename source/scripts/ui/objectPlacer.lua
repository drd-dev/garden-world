import "scripts/ui/cursor"

local pd <const> = playdate
local gfx <const> = pd.graphics
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
    Hut
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
    if (self:checkSpace(270 - self.planet.planetRotation, 32)) then
      self:placeObject()
    end
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

function ObjectPlacer:checkSpace(angle, width)
  local planet = self.planet
  local objects = planet.objects
  local halfWidth = width / 2

  local minCheck = angle - halfWidth
  local maxCheck = angle + halfWidth


  for i = 1, #objects do
    local obj = objects[i]
    local objAngle = obj.angle
    local objWidth = obj.width

    local objLeftAngle = objAngle - objWidth / 2
    local objRightAngle = objAngle + objWidth / 2

    --make sure the object isnt in the bounds of the check
    if (objLeftAngle < minCheck and objRightAngle > maxCheck and not obj.static) then
      return false
    end
  end

  return true
end

function ObjectPlacer:placeObject()
  local speed = 500;
  self.cursor:placeObject(speed)
  pd.timer.new(speed, function()
    CAMERA:applyScreenShake(2, 100)
    self.particles:add(20)
    local planet = self.planet
    local angle = 270 - planet.planetRotation
    Hut(angle, 0, planet)
    planet:markDirty()
  end)
end
