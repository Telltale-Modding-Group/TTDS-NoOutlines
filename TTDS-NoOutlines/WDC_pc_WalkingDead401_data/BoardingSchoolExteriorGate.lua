-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead401_data\BoardingSchoolExteriorGate_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "BoardingSchoolExteriorGate"
local kScene = "adv_boardingSchoolExteriorGate"

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if Game_GetLoaded() then
    return 
  end
  local debugID = LogicGet("Debug ID")
  if debugID == 1 then
    Game_SetSceneDialogNode("cs_outside")
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

BoardingSchoolExteriorGate = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  DlgPreloadAll(Game_GetPlayerDialog(), false)
end

if IsDebugBuild() then
  Callback_OnLogicReady:Add(OnLogicReady)
end
Game_SceneOpen(kScene, kScript)

