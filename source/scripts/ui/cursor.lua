local pd <const> = playdate
local gfx <const> = pd.graphics
local getOrbitPosition <const> = Utils.getOrbitPosition
local clamp <const> = Utils.clamp
local lerp <const> = pd.math.lerp


---@class Cursor: _Sprite
Cursor = class("Cursor").extends(gfx.sprite) or Cursor


function Cursor:init()
  Cursor.super.init(self)

  self.planet = PLANET;

  self:setSize(100, 100)
  self:setCenter(0.5, 0.5)
  self:setZIndex(Z_INDEX.UI_MID)
  self:setIgnoresDrawOffset(true);
  self:add()

  self.icon = nil;
  self.sunImg = gfx.image.new("images/ui/sun")

  self.centerX = self.width / 2;
  self.centerY = self.height / 2;

  self.crankAcceleration = 0;

  self:setImage(self.icon);


  self.hoverHeight = 48

  self.placementAnimator = nil
  self.ended = false;
end

function Cursor:update()
  local _, accel = pd.getCrankChange();
  accel = clamp(accel, -15, 15);



  local distance = self.hoverHeight;
  if (self.placementAnimator) then
    ---@diagnostic disable-next-line: cast-local-type
    distance += self.placementAnimator:currentValue();
    accel = 0;

    if (self.placementAnimator:ended()) then
      self.placementAnimator = nil;
    end
  end

  self.crankAcceleration = lerp(self.crankAcceleration, -accel, 0.1);



  self:moveTo(getOrbitPosition(self.planet, (270 - self.planet.planetRotation) + self.crankAcceleration / 6,
    distance * CURRENT_ZOOM))

  self:setScale(CURRENT_ZOOM);
  self:setRotation(self.crankAcceleration)
end

---@param speed number animation speed
function Cursor:animate(speed)
  speed = speed or 500;
  self.placementAnimator = gfx.animator.new(speed, 0, -self.hoverHeight / 3, pd.easingFunctions.inBack);
  self.placementAnimator.reverses = true;
end

function Cursor:setIcon(icon, arrows)
  arrows = arrows or false;
  self.icon = icon;


  local iconW, iconH = icon:getSize();

  local img = gfx.image.new(iconW + 32, iconH)


  local imgW, imgH = img:getSize();

  gfx.pushContext(img)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite);
  gfx.setColor(gfx.kColorWhite)

  gfx.setFont(FONT.NanoSans)
  if (cost) then
    gfx.drawTextAligned("COST: " .. cost, imgW / 2, 1, kTextAlignment.center)
  end

  if (points) then
    gfx.drawTextAligned("PROD: " .. points, imgW / 2, 10, kTextAlignment.center)
  end
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
  self.icon:draw(imgW / 2 - (iconW / 2), imgH - iconH);


  if (arrows) then
    gfx.drawTriangle(0, imgH / 2, 8, imgH / 2 - 4, 8, imgH / 2 + 4)
    gfx.drawTriangle(imgW, imgH / 2, imgW - 8, imgH / 2 - 4, imgW - 8, imgH / 2 + 4)
  end
  gfx.popContext()

  self:setImage(img);

  self:setImageDrawMode(gfx.kDrawModeXOR)

  self.hoverHeight = 12 + (iconH / 2)
end
