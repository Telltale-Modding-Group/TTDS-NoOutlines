-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead402_data\BoardingSchoolExterior_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
require("OpeningCredits.lua")
local kScript = "BoardingSchoolExterior"
local kScene = "adv_boardingSchoolExterior"

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  AgentSetState("Clementine", "headHatless")
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

BoardingSchoolExterior = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
  Load("env_boardingSchoolExterior_act1_amb_ajWalk_1.chore")
  Load("sk61_fingers_batmanGM200SplayA.anm")
  Load("env_boardingSchoolExterior_act1_cs_funerals_1.chore")
  Load("sk62_clementine400Walk_turnLeft90ToStandA.anm")
  Load("sk62_wd400GMStandA_lookBehindLeft_add.anm")
  Load("ruby_headEyeGesture_lookAwayLeftLong_add.anm")
  Load("sk35_idle_rosieSit.anm")
  Load("sk61_louisStandA_weightShiftB_add.anm")
  Load("sk62_violetArmsX_quickBreath_add.anm")
  Load("sk62_clementine400StandA_weightShiftD_add.anm")
  Load("tennyson_headEyeGesture_lookAwayLeftLong_add.anm")
  Load("violet_phoneme_SH_sadA.anm")
  Load("env_boardingSchoolExterior_act1_bg_funeral_1.chore")
  Load("sk62_clementine400StandA_coupleStepsForward.anm")
  Load("violet_headEyeGesture_lookAwayRightLong_add.anm")
  Load("violet_headEyeGesture_eyeDartGlanceRight_add.anm")
  Load("violet_headGesture_nodYesQuick_add.anm")
  Load("ruby_headEyeGesture_eyeDartGlanceRight_add.anm")
  Load("sk61_louisStandA_lookBehindLeft_add.anm")
  Load("sk61_louisStandA_weightShiftDShort_add.anm")
  Load("violet_headEyeGesture_lookAwayLeftLong_add.anm")
  Load("sk62_clementine400StandA_normalBreath_add.anm")
end

BoardingSchoolExterior_WaitForLine = function()
  -- function num : 0_2 , upvalues : _ENV
  local initialID = Subtitle_GetCurrentID()
  if initialID == -1 then
    return 
  end
  while initialID == Subtitle_GetCurrentID() do
    WaitForNextFrame()
  end
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

