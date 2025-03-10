import "scripts/ui/cursor"

local pd <const> = playdate
local gfx <const> = pd.graphics
local checkAngleForObjects <const> = Utils.checkAngleForObjects
local getOrbitPosition <const> = Utils.getOrbitPosition
local random <const> = math.random



TOOL_MODE = {
  SHOVEL = 1,
  PLANT = 2,
  WATER = 3,
  DECORATE = 4
}

---@class ObjectPlacer: _Sprite
ObjectPlacer = class("ObjectPlacer").extends(gfx.sprite) or ObjectPlacer

function ObjectPlacer:init()
  ObjectPlacer.super.init(self)

  self.planet = PLANET

  self:setSize(240, 38)
  self:setZIndex(Z_INDEX.UI_BACK)
  self:setCenter(0.5, 0)
  self:moveTo(pd.display:getWidth() / 2, 0)
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

  self.sunImg = gfx.image.new("images/ui/sun")


  --sound
  self.digSound = pd.sound.sampleplayer.new("sound/sfx/shovel/Harvesting Crit A")
  self.digSound:setVolume(0.5)
  self.plantSound = pd.sound.sampleplayer.new("sound/sfx/Plant A")
  self.waterSound = pd.sound.sampleplayer.new("sound/sfx/Water Splash")

  self.plants = {
    --plants
    SunFlower,
    Daisies,
    BerryBush,
  }

  self.decorations = {
    Hut,
    Bush,
    Grass,
    StreetLamp
  }

  self.selctedPlant = 1
  self.selctedDecoration = 1;


  self.placementImg = gfx.image.new(100, 100, gfx.kColorClear)

  self.cursor = Cursor();
  self.cursor:setIcon(self.shovelImage)
end

function ObjectPlacer:draw(x, y, width, height)
  local boxHeight = 18;

  gfx.clear(gfx.kColorClear)

  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, width, boxHeight)
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(x + 1, y + 1, width - 2, boxHeight - 2)

  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  local text = ""
  if (self.mode == TOOL_MODE.PLANT) then
    text = "PLANT"
  elseif (self.mode == TOOL_MODE.WATER) then
    text = "WATER"
  elseif (self.mode == TOOL_MODE.SHOVEL) then
    text = "DIG"
  elseif (self.mode == TOOL_MODE.DECORATE) then
    text = "DECORATE"
  end
  gfx.drawTextAligned(text, x + width / 2, y + boxHeight / 2 - 3, kTextAlignment.center)

  gfx.setFont(FONT.NanoSans)
  gfx.drawTextAligned("B-SWAP ", x + 2, y + boxHeight + 2, kTextAlignment.left)
  local textWidth = gfx.getTextSize("A-USE")
  gfx.drawTextAligned("A-USE", x + width - textWidth, y + boxHeight + 2, kTextAlignment.left)

  gfx.setFont(FONT.MiniMono)
  local object = nil;
  if (self.mode == TOOL_MODE.PLANT) then
    object = self.plants[self.selctedPlant]
  elseif (self.mode == TOOL_MODE.DECORATE) then
    object = self.decorations[self.selctedDecoration]
  end

  if (object) then
    self.sunImg:draw(x + 6, y + boxHeight / 2 - 8)
    gfx.drawTextAligned(object.cost, x + 24, y + boxHeight / 2 - 4, kTextAlignment.left)


    if (object.points) then
      ICON_IMAGETABLE:getImage(4):draw(x + width - 32, y + boxHeight / 2 - 10)
      gfx.drawTextAligned(object.points, x + width - 16, y + boxHeight / 2 - 4, kTextAlignment.left)
    end
  end

  gfx.setImageDrawMode(gfx.kDrawModeCopy)
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
    if (self.mode > 4) then
      self.mode = 1
    end


    if (self.mode == TOOL_MODE.SHOVEL) then
      self.cursor:setIcon(self.shovelImage)
    elseif (self.mode == TOOL_MODE.WATER) then
      self.cursor:setIcon(self.wateringCanImage)
    elseif (self.mode == TOOL_MODE.PLANT) then
      self.cursor:setIcon(self.plants[self.selctedPlant].icon, true)
    elseif (self.mode == TOOL_MODE.DECORATE) then
      self.cursor:setIcon(self.decorations[self.selctedDecoration].icon, true);
    end
  end



  --place object
  if (pd.buttonJustPressed(pd.kButtonA) and self:isVisible() and self.mode == TOOL_MODE.PLANT) then
    local object = self.plants[self.selctedPlant]
    local widthCheck = object.img:getSize();
    if (POINTS >= object.cost and checkAngleForObjects((270 - self.planet.planetRotation) % 360, widthCheck, 2)) then
      self:placeObject()
    end
  end

  if (pd.buttonJustPressed(pd.kButtonA) and self:isVisible() and self.mode == TOOL_MODE.DECORATE) then
    local object = self.decorations[self.selctedDecoration]
    local widthCheck = object.img:getSize();
    if (POINTS >= object.cost and checkAngleForObjects((270 - self.planet.planetRotation) % 360, widthCheck, 2)) then
      self:placeDecoration()
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


  if (pd.buttonJustPressed(pd.kButtonLeft) and self:isVisible() and self.mode == TOOL_MODE.PLANT) then
    self:prevObject()
  end

  if (pd.buttonJustPressed(pd.kButtonRight) and self:isVisible() and self.mode == TOOL_MODE.PLANT) then
    self:nextObject()
  end

  if (pd.buttonJustPressed(pd.kButtonLeft) and self:isVisible() and self.mode == TOOL_MODE.DECORATE) then
    self:prevDecoration()
  end

  if (pd.buttonJustPressed(pd.kButtonRight) and self:isVisible() and self.mode == TOOL_MODE.DECORATE) then
    self:nextDecoration()
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
  local object = self.plants[self.selctedPlant]
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

function ObjectPlacer:placeDecoration()
  if (self.cursor.placementAnimator) then return end
  local speed = 500;
  local object = self.decorations[self.selctedDecoration]
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
  self.selctedPlant += 1;
  if (self.selctedPlant > #self.plants) then
    self.selctedPlant = 1
  end
  self.cursor:setIcon(self.plants[self.selctedPlant].icon, true)
end

function ObjectPlacer:prevObject()
  self.selctedPlant -= 1;
  if (self.selctedPlant < 1) then
    self.selctedPlant = #self.plants
  end
  self.cursor:setIcon(self.plants[self.selctedPlant].icon, true)
end

function ObjectPlacer:nextDecoration()
  self.selctedDecoration += 1;
  if (self.selctedDecoration > #self.decorations) then
    self.selctedDecoration = 1
  end
  self.cursor:setIcon(self.decorations[self.selctedDecoration].icon, true);
end

function ObjectPlacer:prevDecoration()
  self.selctedDecoration -= 1;
  if (self.selctedDecoration < 1) then
    self.selctedDecoration = #self.decorations
  end
  self.cursor:setIcon(self.decorations[self.selctedDecoration].icon, true)
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
