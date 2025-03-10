local pd <const> = playdate
local gfx <const> = pd.graphics

---@class SwingSet : PObj
---@overload fun(angle: number, distance: number, planet: Planet): SwingSet
SwingSet = class("SwingSet").extends("PObj") or SwingSet;





--create SwingSet image
local img <const> = gfx.image.new("images/decoration/SwingSet")


SwingSet.name = "Swing Set"
SwingSet.img = img;
SwingSet.icon = img;
SwingSet.cost = 150;


function SwingSet:init(angle, distance, planet)
  SwingSet.super.init(self, img, angle, distance, planet)
end
