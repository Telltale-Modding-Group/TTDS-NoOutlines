-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead401_data\BoardingSchoolExteriorNight_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "BoardingSchoolExteriorNight"
local kScene = "adv_boardingSchoolExteriorNight"
local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if Game_GetLoaded() then
    return 
  end
  local act = LogicGet(kAct)
  if act == 2 then
    Game_SetSceneDialog("env_boardingSchoolExteriorNight_act2")
  else
    if act == 3 then
      Game_SetSceneDialog("env_boardingSchoolExteriorNight_act3")
    end
  end
end

BoardingSchoolExteriorNight = function()
  -- function num : 0_1 , upvalues : _ENV
  if Game_GetSkipEnterCutscenes() and LogicGet(kAct) ~= 2 then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
  if not Game_GetLoaded() and LogicGet(kAct) > 1 then
    AgentHide("obj_flowersMeadowCranesbill", true)
    PropertyRemove(AgentGetProperties("group_freewalkADVManager"), "Group - Idle")
    local characters = {"Clementine", "AJ", "Aasim", "Brody", "Louis", "Marlon", "Mitch", "Omar", "Rosie", "Ruby", "Tennyson", "Violet", "Willy"}
    for _,character in ipairs(characters) do
      PropertyRemove(AgentGetProperties(character), kIdleAnim)
      AgentDetach(character)
    end
  end
end

BoardingSchoolExteriorNight_EnableCollision = function(bEnable)
  -- function num : 0_2 , upvalues : _ENV
  local kCollisionsEnabled = "Collisions Enabled"
  local characters = {"AJ", "Aasim", "Brody", "Louis", "Marlon", "Omar", "Ruby", "Tennyson", "Violet"}
  for _,character in ipairs(characters) do
    local props = AgentGetProperties(character)
    if bEnable then
      PropertySet(props, kCollisionsEnabled, true)
    else
      PropertyRemove(props, kCollisionsEnabled)
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

BoardingSchoolExteriorNight_EndEpisode = function()
  -- function num : 0_3 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  WDAchievements_Unlock("achievement_20")
  Menu_EndEpisode("401", false)
  Menu_EndEpisode_CheckUpsell("401")
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

