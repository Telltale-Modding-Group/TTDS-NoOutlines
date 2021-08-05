-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead404_data\ForestBarn_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "ForestBarn"
local kScene = "adv_forestBarn"
local kWalkbox = "adv_forestBarn.wbox"
local mDisableTriZombies = {}

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if Game_GetLoaded() then
    return 
  end
  local debugID = LogicGet("Debug ID")
  if debugID == 0 then
    return 
  end
  if debugID > 1 then
    Dialog_Run("env_forestBarn_act2", "logic_setPlayer", false)
  end
  if debugID == 1 then
    Game_SetSceneDialogNode("cs_shutIn")
  else
    if debugID == 2 then
      Game_SetSceneDialogNode("cs_slowEmDown")
    else
      Game_SetSceneDialogNode("cs_endOfTheLine")
    end
  end
end

--a custom function that makes it easier to change properties on a scene agent
Custom_AgentSetProperty = function(agentName, propertyString, propertyValue, sceneObject)

    --find the agent within the scene
    local agent = AgentFindInScene(agentName, sceneObject)
    
    --get the runtime properties of that agent
    local agent_props = AgentGetRuntimeProperties(agent)
    
    --set the given (propertyString) on the agent to (propertyValue)
    PropertySet(agent_props, propertyString, propertyValue)
end

--removes an agent from a scene
Custom_RemoveAgent = function(agentName, sceneObj)
    --check if the agent exists
    if AgentExists(AgentGetName(agentName)) then
        --find the agent
        local agent = AgentFindInScene(agentName, sceneObj)
        
        --destroy the agent
        AgentDestroy(agent)
   end
end

--our main function which we will do our scene modifications in
ModifyScene = function(sceneObj)

    --set some properties on the scene
    local sceneName = sceneObj .. ".scene"
    Custom_AgentSetProperty(sceneName, "Generate NPR Lines", false, sceneObj)
    Custom_AgentSetProperty(sceneName, "Screen Space Lines - Enabled", false, sceneObj)
    
    --removes the green-brown graduated filter on the scene
    Custom_RemoveAgent("module_post_effect", sceneObj)
    
    --force graphic black off in this scene
    local prefs = GetPreferences()
    PropertySet(prefs, "Enable Graphic Black", false)
    PropertySet(prefs, "Render - Graphic Black Enabled", false)
end

ForestBarn = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  Episode_SetClemState()
end

ForestBarn_DisableZombieTri = function(zombie)
  -- function num : 0_2 , upvalues : _ENV, mDisableTriZombies, kWalkbox
  if (table.contains)(mDisableTriZombies, zombie) then
    TableRemove(mDisableTriZombies, zombie)
    WaitForNextFrame()
    Print("Zombie was already in table\n\n")
  end
  WalkBoxesDisableAreaAroundAgent(kWalkbox, zombie)
  ;
  (table.insert)(mDisableTriZombies, zombie)
end

ForestBarn_EnableZombieTri = function(zombie)
  -- function num : 0_3 , upvalues : mDisableTriZombies, _ENV, kWalkbox
  if #mDisableTriZombies == 0 then
    Print("The table is empty!\n\n")
    return 
  end
  if zombie then
    if (table.contains)(mDisableTriZombies, zombie) then
      Print("Stunning an already stunned zombie.\n\n")
      WalkBoxesEnableAreaAroundAgent(kWalkbox, zombie)
    else
      Print(zombie .. " isn\'t in the table yet!\n\n")
      return 
    end
  else
    WalkBoxesEnableAreaAroundAgent(kWalkbox, mDisableTriZombies[1])
    ;
    (table.remove)(mDisableTriZombies, 1)
    Print("Index 1 has been removed from the table!\n\n")
  end
end

ForestBarn_EnableDeadZombieTri = function(zombie)
  -- function num : 0_4 , upvalues : _ENV, kWalkbox, mDisableTriZombies
  if zombie then
    WalkBoxesEnableAreaAroundAgent(kWalkbox, zombie)
    TableRemove(mDisableTriZombies, zombie)
    Print(zombie .. " has been removed from the table!\n\n")
  end
end

ForestBarn_KillZombieBG = function(agent)
  -- function num : 0_5 , upvalues : _ENV
  if not agent then
    return 
  end
  WaitForNextFrame()
  for _,controller in ipairs(AgentGetControllers(agent)) do
    local chore = ControllerGetChore(controller)
    if chore and StringStartsWith(ResourceGetName(chore), "zombat_bgSweepedAJZombie") then
      ControllerFadeOut(controller, 0.5, true)
      while ControllerGetContribution(controller) > 0 do
        WaitForNextFrame()
      end
      ControllerKill(controller)
    end
  end
end

if IsDebugBuild() then
  Callback_OnLogicReady:Add(OnLogicReady)
end
Game_SceneOpen(kScene, kScript)

