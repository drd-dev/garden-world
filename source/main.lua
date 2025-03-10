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

--nature
import "scripts/pObj/_pObj"
import "scripts/pObj/nature/grass"
import "scripts/pObj/nature/rock_001"
import "scripts/pObj/nature/cloud"


--decorations
import "scripts/pObj/decoration/hut"
import "scripts/pObj/decoration/street_lamp"
import "scripts/pObj/decoration/bush"
import "scripts/pObj/decoration/bench"
import "scripts/pObj/decoration/fence"
import "scripts/pObj/decoration/icyStatue"
import "scripts/pObj/decoration/cat"

--plants
import "scripts/pObj/plants/_plant"
import "scripts/pObj/plants/sunFlower"
import "scripts/pObj/plants/daisies"
import "scripts/pObj/plants/berryBush"
import "scripts/pObj/plants/carrot"
import "scripts/pObj/plants/oak"
import "scripts/pObj/plants/apple"


-- UI
import "fonts/fonts"
import "scripts/ui/objectPlacer"
import "scripts/camera"
import "scripts/ui/resourceUI"


local pd <const> = playdate
local gfx <const> = pd.graphics

-- gfx.setBackgroundColor(gfx.kColorBlack)
local backgroundImage = gfx.image.new("images/background")
assert(backgroundImage, "No backgroundImage")

gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
  backgroundImage:draw(0, 0)
end)



local mainMenu = true;
local controlsShown = false;
local mainMenuImage = gfx.image.new("images/ui/mainMenu")
local controlsImage = gfx.image.new("images/ui/controls")
local mainMenuSprite = gfx.sprite.new(mainMenuImage)
mainMenuSprite:setCenter(0, 0)
mainMenuSprite:moveTo(0, 0)
mainMenuSprite:setZIndex(Z_INDEX.UI_FRONT)
mainMenuSprite:add()


local function StartGame()
  print("starting game")
  local sound = pd.sound.sampleplayer.new("sound/sfx/sfx_menu_start.wav")
  sound:setVolume(0.25)
  sound:play(1, 1)
  mainMenuSprite:remove()
  ObjectPlacer();
  CAMERA = Camera();
  ResourceUI();
end


Planet(1000)


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

  if (mainMenu == true and pd.buttonJustPressed(pd.kButtonA)) then
    if (controlsShown == false) then
      controlsShown = true;
      mainMenuSprite:setImage(controlsImage)
    else
      mainMenu = false;
      StartGame();
    end
  end
end
