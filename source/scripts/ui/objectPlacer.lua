import "scripts/ui/cursor"

local pd <const> = playdate
local gfx <const> = pd.graphics
local checkAngleForObjects <const> = Utils.checkAngleForObjects
local getOrbitPosition <const> = Utils.getOrbitPosition
local random <const> = math.random



TOOL_MODE = {
  SHOVEL = 1,
  PLACE = 2,
  WATER = 3
}

---@class ObjectPlacer: _Sprite
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
  self.particles = ParticleCircle(self.x, self.y + 160)
  self.particles:setMode(Particles.modes.DECAY);
  self.particles:setSpeed(2, 5);
  self.particles:setSize(35, 55)
  self.particles:setColor(gfx.kColorWhite)
  self.particles:setDecay(3)



  self.mode = TOOL_MODE.SHOVEL;


  --tools
  self.shovelImage = gfx.image.new("images/tools/shovel")
  self.wateringCanImage = gfx.image.new("images/tools/wateringCan")



  --sound
  self.digSound = pd.sound.sampleplayer.new("sound/sfx/shovel/Harvesting Crit A")
  self.digSound:setVolume(0.5)
  self.plantSound = pd.sound.sampleplayer.new("sound/sfx/Plant A")
  self.waterSound = pd.sound.sampleplayer.new("sound/sfx/Water Splash")

  self.objects = {
    --plants
    SunFlower,
    Daisies,
    BerryBush,
    --decorations
    Hut,
    Bush,
    Grass,

  }

  self.selectedObject = 1


  self.placementImg = gfx.image.new(100, 100, gfx.kColorClear)

  self.cursor = Cursor();
  self.cursor:setIcon(self.shovelImage)
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
    self.mode += 1;
    if (self.mode > 3) then
      self.mode = 1
    end


    if (self.mode == TOOL_MODE.SHOVEL) then
      self.cursor:setIcon(self.shovelImage)
    elseif (self.mode == TOOL_MODE.WATER) then
      self.cursor:setIcon(self.wateringCanImage)
    elseif (self.mode == TOOL_MODE.PLACE) then
      self.cursor:setIcon(self.objects[self.selectedObject].icon, self.objects[self.selectedObject].cost,
        self.objects[self.selectedObject].points)
    end
  end



  --place object
  if (pd.buttonJustPressed(pd.kButtonA) and self:isVisible() and self.mode == TOOL_MODE.PLACE) then
    local object = self.objects[self.selectedObject]
    local widthCheck = object.img:getSize();
    if (POINTS >= object.cost and checkAngleForObjects((270 - self.planet.planetRotation) % 360, widthCheck, 2)) then
      self:placeObject()
    end
  end


  --remove object
  if (pd.buttonJustPressed(pd.kButtonA) and self.mode == TOOL_MODE.SHOVEL) then
    self:removeObject();
  end


  --water object
  if (pd.buttonJustPressed(pd.kButtonA) and self.mode == TOOL_MODE.WATER) then
    self:water();
  end


  if (pd.buttonJustPressed(pd.kButtonLeft) and self:isVisible() and self.mode == TOOL_MODE.PLACE) then
    self:prevObject()
  end

  if (pd.buttonJustPressed(pd.kButtonRight) and self:isVisible() and self.mode == TOOL_MODE.PLACE) then
    self:nextObject()
  end

  self:markDirty();

  self:handleCursor();
end

function ObjectPlacer:handleCursor()
  local x, y = getOrbitPosition(self.planet, (270 - self.planet.planetRotation) % 360, 32)
  self.cursor:moveTo(x, y)
end

function ObjectPlacer:placeObject()
  if (self.cursor.placementAnimator) then return end
  local speed = 500;
  local object = self.objects[self.selectedObject]
  self.cursor:animate(speed)
  pd.timer.new(speed, function()
    CAMERA:applyScreenShake(2, 100)
    POINTS -= object.cost;
    self.particles:add(20)
    local planet = self.planet
    local angle = (270 - planet.planetRotation) % 360;
    object(angle, 0, planet)
    planet:markDirty()
    self.plantSound:play(1, 1)
  end)
end

function ObjectPlacer:nextObject()
  self.selectedObject += 1;
  if (self.selectedObject > #self.objects) then
    self.selectedObject = 1
  end
  self.cursor:setIcon(self.objects[self.selectedObject].icon, self.objects[self.selectedObject].cost,
    self.objects[self.selectedObject].points)
end

function ObjectPlacer:prevObject()
  self.selectedObject -= 1;
  if (self.selectedObject < 1) then
    self.selectedObject = #self.objects
  end
  self.cursor:setIcon(self.objects[self.selectedObject].icon, self.objects[self.selectedObject].cost,
    self.objects[self.selectedObject].points)
end

function ObjectPlacer:removeObject()
  if (self.cursor.placementAnimator) then return end
  local speed = 500;
  self.cursor:animate(speed)
  pd.timer.new(speed, function()
    local found, objs = checkAngleForObjects((270 - self.planet.planetRotation) % 360, 10, 0)

    --objs forloop
    if (objs and #objs > 0) then
      self.particles:add(4)
      for index, obj in ipairs(objs) do
        if (obj.removable) then
          obj:remove();
          self.digSound:play(1, random(90, 110) * 0.01)
          if (obj.cost) then
            POINTS += obj.cost;
          end
        end
      end
    else
      self.digSound:play(1, 0.75)
    end
  end);
end

function ObjectPlacer:water()
  if (self.cursor.placementAnimator) then return end
  local speed = 500;
  self.cursor:animate(speed)

  pd.timer.new(speed, function()
    local found, objs = checkAngleForObjects((270 - self.planet.planetRotation) % 360, 20, 0)

    if (objs and #objs > 0) then
      self.waterSound:play(1, 1)
      self.particles:add(4)
      for index, obj in ipairs(objs) do
        if (obj:isa(Plant)) then
          obj:waterPlant();
        end
      end
    end
  end);
end
