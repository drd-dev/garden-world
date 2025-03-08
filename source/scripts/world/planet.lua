local pd <const> = playdate
local gfx <const> = pd.graphics
local lerp <const> = pd.math.lerp
local clamp <const> = Utils.clamp
local getOrbitPosition <const> = Utils.getOrbitPosition


---@class Planet : _Sprite
Planet = class("Planet").extends(gfx.sprite) or Planet


function Planet:init(size)
  Planet.super.init(self)


  self:setCenter(0, 0);
  self:moveTo(0, 0);
  self:setSize(pd.display:getSize());
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

  self.crankSensitivity = SETTINGS.CRANK_SENSITIVITY;
  self.zoomSpeed = SETTINGS.ZOOM_SPEED;

  self.objects = {}


  local count = 20;
  for i = 0, 360, 360 / count do
    Hut(i, 0, self);
  end
end

function Planet:update()
  local cranks = pd.getCrankChange();
  if (cranks ~= 0) then
    self:markDirty();
  end

  self.planetRotation += cranks * self.crankSensitivity;

  if (pd.buttonIsPressed(pd.kButtonDown)) then
    CURRENT_ZOOM -= self.zoomSpeed;
    self:markDirty();
  elseif (pd.buttonIsPressed(pd.kButtonUp)) then
    CURRENT_ZOOM += self.zoomSpeed;
    self:markDirty();
  end

  CURRENT_ZOOM = Utils.clamp(CURRENT_ZOOM, 0.25, 1.5);

  --update planetary values
  self.size = self.startSize * CURRENT_ZOOM;
  self.radius = self.size / 2;
  self.planetX = self.x + self.halfWidth;

  self.planetY = lerp(self.centerY, self.centerY + (self.size * 0.45), CURRENT_ZOOM - 0.25);
end

function Planet:draw(x, y, width, height)
  gfx.clear()
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
  for i, object in ipairs(self.objects) do
    local angle = object.angle;
    local distance = object.distance;
    ---@type _Image
    local image = object.image;
    local x, y = getOrbitPosition(self, angle, distance * CURRENT_ZOOM);


    image:drawRotated(x, y, angle + 90 + self.planetRotation, CURRENT_ZOOM);
  end
end
