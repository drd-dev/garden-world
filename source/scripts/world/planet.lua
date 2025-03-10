local pd <const> = playdate
local gfx <const> = pd.graphics
local getOrbitPosition <const> = Utils.getOrbitPosition
local random <const> = math.random
local checkAngleForObjects <const> = Utils.checkAngleForObjects


---@class Planet : _Sprite
Planet = class("Planet").extends(gfx.sprite) or Planet


function Planet:init(size)
  PLANET = self;
  Planet.super.init(self)


  self:setCenter(0, 0);
  self:setSize(pd.display:getSize());

  self:moveTo(0, 0);
  self:setZIndex(Z_INDEX.PLANET);
  self:add()

  self.lineWidth = 10;


  self.startSize = size;
  self.size = self.startSize;
  self.radius = self.size / 2;



  self.halfWidth = self.width / 2;
  self.halfHeight = self.height / 2;



  self.centerY = self.y + self.halfHeight;
  self.planetX = self.x + self.halfWidth;
  self.planetY = self.centerY;

  self.planetRotation = 0;


  self.objects = {}


  self:populatePlanet();
end

function Planet:update()
  CURRENT_ZOOM = Utils.clamp(CURRENT_ZOOM, ZOOM_MIN, ZOOM_MAX);

  --update planetary values
  self.size = self.startSize * CURRENT_ZOOM;
  self.radius = self.size / 2;
  self.planetX = self.x + self.halfWidth;

  self.planetY = self.centerY + (self.size * 0.54)

  self:markDirty()
end

function Planet:draw(x, y, width, height)
  -- gfx.clear(gfx.kColorClear)
  self:drawPlanet(x, y, width, height);
  self:drawObjects();
end

function Planet:drawPlanet(x, y, width, height)
  gfx.setColor(gfx.kColorWhite);
  gfx.setLineWidth(self.lineWidth * CURRENT_ZOOM);
  --outer edge
  gfx.drawCircleAtPoint(self.planetX, self.planetY, self.radius);

  --mantle and layers
  gfx.setDitherPattern(0.5, gfx.image.kDitherTypeBayer8x8);
  gfx.fillCircleAtPoint(self.planetX, self.planetY, self.radius);



  gfx.setColor(gfx.kColorWhite);

  --core
  gfx.fillCircleAtPoint(self.planetX, self.planetY, (self.radius / 2) * 1.5);
  gfx.setColor(gfx.kColorBlack);
  gfx.fillCircleAtPoint(self.planetX, self.planetY, (self.radius / 4));
end

function Planet:drawObjects()
  for i, object in pairs(self.objects) do
    local angle = object.angle;
    local distance = object.distance;
    ---@type _Image
    local image = object.image;
    local imgW, imgH = image:getSize();

    if (object.dither) then
      image = image:fadedImage(object.ditherAmount, object.dither);
    end


    --change angle if not static
    local a = angle + 90;
    if (not object.static) then
      a += self.planetRotation
    else
      angle -= self.planetRotation
    end


    local x, y = getOrbitPosition(self, angle, distance * CURRENT_ZOOM);
    object.x = x
    object.y = y


    image:drawRotated(object.x, object.y, a, CURRENT_ZOOM * object.flip, CURRENT_ZOOM);


    if (object.points and object.pointAnimator and CURRENT_ZOOM > 0.75) then
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite);
      gfx.drawTextAligned("$" .. object.points, object.x, (object.y - imgH - 5) - object.pointAnimator:currentValue(),
        kTextAlignment.center);
      gfx.setImageDrawMode(gfx.kDrawModeCopy);
    elseif (object.currentWater and object.currentWater <= 0 and CURRENT_ZOOM > 0.75) then
      ICON_IMAGETABLE:getImage(4):drawRotated(object.x, (object.y - imgH - 8), 0);
    end


    gfx.setColor(gfx.kColorWhite);
  end
end

function Planet:populatePlanet()
  local objs = {
    Rock_001,
    Grass,
    Grass,
    Grass,
    Grass,
    Grass,
    Grass,
  }


  local numObjects = 50;
  for i = 1, numObjects do
    local angle = math.random(0, 360);

    --check the space
    if (checkAngleForObjects(angle, 32, 2)) then
      local object = nil;
      local index = random(1, #objs);

      object = objs[index](angle, 0, self);
    end
  end;



  --add clouds
  local cloudCount = 15;
  for i = 1, cloudCount do
    local angle = random(0, 360);
    local distance = random(100, 200);
    local cloud = Cloud(angle, distance, self);
  end
end
