local pd <const> = playdate
local gfx <const> = pd.graphics
local random <const> = math.random

---@class Camera : _Sprite
Camera = class("Camera").extends(gfx.sprite) or Camera

function Camera:init()
  self:add();

  self.planet = PLANET;


  self.crankSensitivity = SETTINGS.CRANK_SENSITIVITY;
  self.zoomSpeed = SETTINGS.ZOOM_SPEED;

  --screenshake
  self.shaking = false;
  self.shakeAmount = 0;
  self.shakeTime = 0;
end

function Camera:update()
  local cranks = pd.getCrankChange();
  if (cranks ~= 0) then
    self.planet:markDirty();
  end

  self.planet.planetRotation += cranks * self.crankSensitivity;

  if (pd.buttonIsPressed(pd.kButtonDown)) then
    CURRENT_ZOOM -= self.zoomSpeed;
    self.planet:markDirty();
  elseif (pd.buttonIsPressed(pd.kButtonUp)) then
    CURRENT_ZOOM += self.zoomSpeed;
    self.planet:markDirty();
  end


  if (self.shaking) then
    gfx.setDrawOffset(random(-self.shakeAmount, self.shakeAmount), random(-self.shakeAmount, self.shakeAmount));
  end
end

function Camera:applyScreenShake(amount, time)
  if (self.shaking) then return end;
  self.shaking = true;
  self.shakeAmount = amount;

  pd.timer.new(time, function()
    self.shaking = false;
    self.shakeAmount = 0;
  end)
end
