local pd <const> = playdate
local gfx <const> = pd.graphics

---@class Cat : PObj
---@overload fun(angle: number, distance: number, planet: Planet): Cat
Cat = class("Cat").extends("PObj") or Cat;


local img <const> = gfx.imagetable.new("images/decoration/Cat")


Cat.name = "Cat"
Cat.img = img:getImage(1);
Cat.icon = img:getImage(1);
Cat.cost = 500;


local meow = pd.sound.sampleplayer.new("sound/sfx/meow")
meow:setVolume(0.25)

function Cat:init(angle, distance, planet)
  Cat.super.init(self, img:getImage(1), angle, distance, planet)

  self:setUpdatesEnabled(true);


  self.animator = gfx.animation.loop.new(250, img, true)
  meow:play(1, 1)
end

function Cat:update()
  self.image = self.animator:image()
end
