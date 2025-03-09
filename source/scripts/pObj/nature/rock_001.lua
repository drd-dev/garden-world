local pd <const> = playdate
local gfx <const> = pd.graphics
local random <const> = math.random

---@class Rock_001 : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Rock_001
Rock_001 = class("Rock_001").extends("PObj") or Rock_001;


local img <const> = gfx.image.new("images/nature/rock_001")


Rock_001.img = img;


function Rock_001:init(angle, distance, planet)
  Rock_001.super.init(self, img, angle, distance, planet)
  self.flip = random(0, 1) * 2 - 1
end
