local pd <const> = playdate
local gfx <const> = pd.graphics
local getOrbitPosition <const> = Utils.getOrbitPosition


---@class Planet : _Sprite
Planet = class("Planet").extends(gfx.sprite) or Planet


function Planet:init(size)
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
end

function Planet:update()
  CURRENT_ZOOM = Utils.clamp(CURRENT_ZOOM, ZOOM_MIN, ZOOM_MAX);

  --update planetary values
  self.size = self.startSize * CURRENT_ZOOM;
  self.radius = self.size / 2;
  self.planetX = self.x + self.halfWidth;

  self.planetY = self.centerY + (self.size * 0.53)
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


    image:drawRotated(object.x, object.y, a, CURRENT_ZOOM);
    gfx.setColor(gfx.kColorWhite);
  end
end
