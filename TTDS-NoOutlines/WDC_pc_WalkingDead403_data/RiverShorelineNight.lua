-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead403_data\RiverShorelineNight_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
require("AI_PlayerProjectile.lua")
local kScript = "RiverShorelineNight"
local kScene = "adv_riverShorelineNight"
local mFlashlightThread, mFlashlightController = nil, nil

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if Game_GetLoaded() then
    return 
  end
  local debugID = LogicGet("Debug ID")
  if debugID > 0 then
    Game_SetSceneDialog("env_riverShorelineNight_act2Action")
    if debugID == 1 then
      Game_SetSceneDialogNode("cs_followMe")
    else
      Game_SetSceneDialogNode("cs_climbPier")
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

RiverShorelineNight = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  Episode_SetClemButton()
end

RiverShorelineNight_EnableFlashlightTracking = function(bEnable)
  -- function num : 0_2 , upvalues : _ENV, mFlashlightController
  if bEnable == ControllerIsPlaying(mFlashlightController) then
    return 
  end
  local scene = Game_GetScene()
  if bEnable then
    mFlashlightController = ChorePlay("adv_riverShorelineNight_flashlightPointAtClem.chore", 9910)
    ControllerSetLooping(mFlashlightController, true)
    ControllerSetContribution(mFlashlightController, 0)
    local t = 0
    while t <= 1 do
      ControllerSetContribution(mFlashlightController, (math.min)(1, t))
      t = t + GetFrameTime() * SceneGetTimeScale(scene)
      WaitForNextFrame()
    end
  else
    do
      local t = 1
      while t > 0 do
        ControllerSetContribution(mFlashlightController, (math.max)(0, t))
        t = t - GetFrameTime() * SceneGetTimeScale(scene)
        WaitForNextFrame()
      end
      mFlashlightController = ControllerKill(mFlashlightController)
    end
  end
end

RiverShorelineNight_FlashlightChoreIsPlaying = function()
  -- function num : 0_3 , upvalues : _ENV, mFlashlightController
  return ControllerIsPlaying(mFlashlightController)
end

if IsDebugBuild() then
  Callback_OnLogicReady:Add(OnLogicReady)
end
Game_SceneOpen(kScene, kScript)
SceneAdd("ui_notification")

