local pd <const> = playdate
local gfx <const> = pd.graphics

---@class ResourceUI : _Sprite
ResourceUI = class("ResourceUI").extends(gfx.sprite) or ResourceUI;

function ResourceUI:init()
  ResourceUI.super.init(self)

  self:setSize(64, 18)
  self:setIgnoresDrawOffset(true)
  self:setZIndex(Z_INDEX.UI_FRONT)
  self:moveTo(pd.display:getWidth() - self.width / 2, 10);
  self:add();

  self.sunImg = gfx.image.new("images/ui/sun")
end

function ResourceUI:update()
  self:markDirty();
end

function ResourceUI:draw(x, y, width, height)
  gfx.clear(gfx.kColorBlack);



  gfx.setColor(gfx.kColorWhite)
  gfx.setLineWidth(1)
  gfx.drawRect(x, y, width, height)
  self.sunImg:draw(x + 1, y + 1)
  gfx.setFont(FONT.MiniMono)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawTextAligned(SaveManager.saveData.points .. "", x + 18, y + 5, kTextAlignment.left)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
end
