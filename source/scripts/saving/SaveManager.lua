local pd <const> = playdate
local gfx <const> = pd.graphics
local dataStore <const> = pd.datastore;

---@class SaveManager: _Object
SaveManager = class("SaveManager").extends() or SaveManager;


local defaultSaveData <const> = {
  points = 0,
  objects = {},
  settings = {
    buttonSwap = false,
  }
}

SaveManager.saveData = table.deepcopy(defaultSaveData)



function SaveManager.save()
  --loop through all instanced objects and save their data
  local objects = {}
  for _, object in ipairs(INSTANCED_OBJS) do
    local objData = {
      type = object.className,
      angle = object.angle,
    }

    --plant specifics
    if (object:isa(Plant)) then
      objData.water = object.currentWater
      objData.fullyGrown = object.fullyGrown
    end


    table.insert(objects, objData)
  end


  SaveManager.saveData.objects = objects
  dataStore.write(SaveManager.saveData, "saveData")
end

function SaveManager.load()
  print("loading data")
  local data = dataStore.read("saveData") or {};
  --deep compare the data to the default data and patch in any missing values
  for key, value in pairs(defaultSaveData) do
    if (not data[key]) then
      data[key] = value
    elseif (type(value) == "table") then
      for subKey, subValue in pairs(value) do
        if (not data[key][subKey]) then
          data[key][subKey] = subValue
        end
      end
    end
  end

  SaveManager.saveData = table.deepcopy(data)
  return SaveManager.saveData;
end

function SaveManager.resetSave()
  SaveManager.saveData = table.deepcopy(defaultSaveData)
  INSTANCED_OBJS = {}
  SaveManager.save()
end

function pd.gameWillTerminate()
  SaveManager.save()
end

function pd.deviceWillLock()
  SaveManager.save()
end

function pd.deviceWillSleep()
  SaveManager.save()
end
