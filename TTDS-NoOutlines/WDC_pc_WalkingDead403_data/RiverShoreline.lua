local kScript = "RiverShoreline"
local kScene = "adv_riverShoreline"

local OnSetGameMode = function(oldMode, newMode)
  AgentHide("ui_fxOverlay_binoculars", newMode == eModeCutscene)
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


function RiverShoreline()
    
  ModifyScene(kScene)
    
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
end

function RiverShoreline_BinocularsEnable(bEnable)
  if bEnable then
    Callback_OnSetGameMode:Add(OnSetGameMode)
  else
    Callback_OnSetGameMode:Remove(OnSetGameMode)
  end
  AgentHide("ui_fxOverlay_binoculars", not bEnable)
end
Game_SceneOpen(kScene, kScript)
