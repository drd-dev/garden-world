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



import "scripts/utils/utils"
import "scripts/global"
import "scripts/world/planet"

--Planetary Objects
import "scripts/pObj/_pObj"
import "scripts/pObj/hut"


local pd <const> = playdate
local gfx <const> = pd.graphics

gfx.setBackgroundColor(gfx.kColorBlack)

Planet(500)


function pd.update()
  gfx.sprite.update()

  pd.drawFPS(0, 0)
end
