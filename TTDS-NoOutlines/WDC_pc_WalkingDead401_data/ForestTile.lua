-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead401_data\ForestTile_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "ForestTile"
local kScene = "adv_forestTile"
local mStationExitFunc = nil

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if Game_GetLoaded() then
    return 
  end
  if LogicGet("2 - Entered ForestShack") then
    Game_SetSceneDialogNode("cs_fromShack")
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

ForestTile = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
end

ForestTile_OnButtonExit = function()
  -- function num : 0_2 , upvalues : _ENV
  ForestTile_OverrideStationExit(false)
  Station_Activate(false)
  Station_Exit()
  Game_RunSceneDialog("cs_funTimeOver")
end

ForestTile_OverrideStationExit = function(bOverride)
  -- function num : 0_3 , upvalues : mStationExitFunc, _ENV
  if bOverride and not mStationExitFunc then
    mStationExitFunc = Station_OnButtonExit
    Station_OnButtonExit = ForestTile_OnButtonExit
  end
  if mStationExitFunc then
    Station_OnButtonExit = mStationExitFunc
    mStationExitFunc = nil
  end
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

