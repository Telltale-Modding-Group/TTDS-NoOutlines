require("Constellation.lua")

local kScript = "BellTower"
local kScene = "adv_bellTower"
local mVioletClimbingThread

local OnLogicReady = function()
  if Game_GetLoaded() then
    return
  end
  if LogicGet("Debug ID") == 1 then
    Game_SetSceneDialogNode("cs_astrology")
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

function BellTower()
    ModifyScene(kScene)
end

function BellTower_VioletClimbEnable(bEnable, chore)
  if bEnable then
    mVioletClimbingThread = ChorePlay(chore, -1000)
  else
    mVioletClimbingThread = ControllerKill(mVioletClimbingThread)
  end
end

function BellTower_WaitAndStopBackground()
  local initialID = Subtitle_GetCurrentID()
  while true do
    local id = Subtitle_GetCurrentID()
    if id ~= initialID and id ~= -1 and SubtitleGetAgentName(id) ~= "Violet" then
      break
    end
    WaitForNextFrame()
  end
  Dialog_StopBackground()
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)
