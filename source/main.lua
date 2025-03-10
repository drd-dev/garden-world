-- Corelibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/sprites"
import "CoreLibs/math"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/animation"
import "CoreLibs/nineslice"

--libraries
import "scripts/libraries/pdParticles"

import "scripts/utils/utils"
import "scripts/global"
import "scripts/world/planet"

--Planetary Objects
import "scripts/pObj/_pObj"
import "scripts/pObj/hut"
import "scripts/pObj/street_lamp"
import "scripts/pObj/nature/grass"
import "scripts/pObj/nature/bush"
import "scripts/pObj/nature/rock_001"
import "scripts/pObj/nature/cloud"
import "scripts/pObj/nature/flower_001"

--plants
import "scripts/pObj/plants/_plant"
import "scripts/pObj/plants/sunFlower"
import "scripts/pObj/plants/daisies"
import "scripts/pObj/plants/berryBush"


-- UI
import "fonts/fonts"
import "scripts/ui/objectPlacer"
import "scripts/camera"
import "scripts/ui/resourceUI"


local pd <const> = playdate
local gfx <const> = pd.graphics

gfx.setBackgroundColor(gfx.kColorBlack)

Planet(1000)
ObjectPlacer();
CAMERA = Camera();
ResourceUI();

local music = pd.sound.sampleplayer.new("sound/music/KleptoLindaMountainA")
local wind = pd.sound.sampleplayer.new("sound/music/Eerie Wind Loop A")
music:play(0, 1)
wind:play(0, 1);

function pd.update()
  gfx.sprite.update()
  pd.timer.updateTimers()
  Particles:update()

  music:setVolume(CURRENT_ZOOM / ZOOM_MAX)
  wind:setVolume(0.5 - (CURRENT_ZOOM / ZOOM_MAX))

  pd.drawFPS(0, 0)
end
