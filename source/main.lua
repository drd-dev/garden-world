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



--utils and things
import "scripts/saving/saveManager"
SaveManager.load();
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
import "scripts/pObj/decoration/swingSet"
import "scripts/pObj/decoration/trashcan"
import "scripts/pObj/decoration/fountain"
import "scripts/pObj/decoration/pottedPlant_001"
import "scripts/pObj/decoration/pottedPlant_002"
import "scripts/pObj/decoration/pottedPlant_003"
import "scripts/pObj/decoration/pottedPlant_004"
import "scripts/pObj/decoration/pottedPlant_005"

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

gfx.setFont(FONT.MiniMono)

gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
  backgroundImage:draw(0, 0)
end)


--setup system menu
local menu = pd.getSystemMenu()
menu:addMenuItem("Reset save", function()
  SaveManager.resetSave();
  playdate.restart()
end)

menu:addCheckmarkMenuItem("Swap A/B", SaveManager.saveData.settings.buttonSwap, function()
  SaveManager.saveData.settings.buttonSwap = not SaveManager.saveData.settings.buttonSwap
  SaveManager.save()
end)



local mainMenu = true;
local controlsShown = false;
local mainMenuImage = gfx.image.new("images/ui/mainMenu")
gfx.pushContext(mainMenuImage)
gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
local text = "v" .. pd.metadata.version
local textWidth = gfx.getTextSize(text)
local padding = 5;
gfx.drawText(text, pd.display:getWidth() - textWidth - padding, padding);
gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
gfx.drawText(text, pd.display:getWidth() - textWidth - padding - 1, padding - 1);
gfx.popContext()

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
music:setVolume(1.5)
local wind = pd.sound.sampleplayer.new("sound/music/Eerie Wind Loop A")
wind:setVolume(1.5)
music:play(0, 1)
wind:play(0, 1);

function pd.update()
  gfx.sprite.update()
  pd.timer.updateTimers()
  Particles:update()

  music:setVolume(CURRENT_ZOOM / ZOOM_MAX)
  wind:setVolume(0.5 - (CURRENT_ZOOM / ZOOM_MAX))

  --slowly rotate on mainMenu
  if (mainMenu) then
    PLANET.planetRotation += 0.015
  end


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
