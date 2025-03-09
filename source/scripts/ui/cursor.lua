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

function Cursor:setIcon(icon)
  self.icon = icon;

  self:setImage(self.icon);
  self:setImageDrawMode(gfx.kDrawModeXOR)
end
