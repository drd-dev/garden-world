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

import "scripts/ui/objectPlacer"
import "scripts/camera"


local pd <const> = playdate
local gfx <const> = pd.graphics

gfx.setBackgroundColor(gfx.kColorBlack)

Planet(1000)
ObjectPlacer();
CAMERA = Camera();

function pd.update()
  gfx.sprite.update()
  pd.timer.updateTimers()
  Particles:update()

  pd.drawFPS(0, 0)
end
