local kScript = "BoardingSchoolDormNight"
local kScene = "adv_boardingSchoolDormNight"
local mWalkboxUpdateThread
local OnLogicReady = function()
  AgentSetWorldPos("obj_skullBoar", Vector(13.679837, 1.451824, -7.128535))
  AgentSetWorldRotFromQuat("obj_skullBoar", Quaternion(-0.008629, -0.710944, 0.01977, 0.702918))
  if Game_GetLoaded() then
    return
  end
  Episode_SetUpCollectibles()
  Episode_SetLouisDamage()
  if LogicGet("Debug ID") == 1 then
    Game_SetSceneDialogNode("cs_nightmare")
  end
  AgentSetState("AJ", "bodyBuckshotB")
  AgentSetState("Horse", "horseBlack")
end
local UpdateWalkboxTris = function()
  while true do
    WalkBoxesDisableAreaAroundAgent("adv_boardingSchoolDormNight_nightmare.wbox", "dummy_triDisabler", 0.01)
    WaitForNextFrame()
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


function BoardingSchoolDormNight()
    
  ModifyScene(kScene)
    
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
  Load("env_boardingSchoolDormNight_act3_use_candle_1.chore")
  Load("sk62_clementine400StandA_toCrouch.anm")
  Load("sk62_clementine400StandA_turnLeft90ToWalk.anm")
  Load("sk62_clementine400SupineLookUpBed_toSit.anm")
  Load("sk63_idle_ajSupineLayBackBed.anm")
  Load("sk63_tennysonWalk_turnRight90.anm")
  Load("obj_mapBattlePlansBlankBoardingSchool.d3dtx")
  Load("lightSettings_boardingSchoolDormNight_act3_timeLapse.chore")
  Load("sk62_action_clementine400TakeOffHat.chore")
  Load("sk62_action_clementine400TakeOffHat.anm")
  Load("sk62_action_clementine400GoToBed.anm")
  Load("sk62_clementine400SleepBed_toSupineLookUpBed.anm")
  Load("sk62_idle_clementine400SleepBed.chore")
  Load("sk62_idle_clementine400SleepBed.anm")
  Load("sk63_ajStandA_turnRight90ToWalk.anm")
end
function BoardingSchoolDormNight_ShowCollectibleSlots()
  AgentHide("obj_logicalSlotFlytrap", not Collectible_GetFound("Flytrap"))
  AgentHide("obj_logicalSlotMushroom", not Collectible_GetFound("Mushroom"))
  AgentHide("obj_logicalSlotSkullBoar", not Collectible_GetFound("Skull Boar"))
end
function BoardingSchoolDormNight_WalkboxUpdate(bEnable)
  bEnable = bEnable ~= false
  if bEnable == ThreadIsRunning(mWalkboxUpdateThread) then
    return
  end
  if bEnable then
    mWalkboxUpdateThread = ThreadStart(UpdateWalkboxTris)
  else
    mWalkboxUpdateThread = ThreadKill(mWalkboxUpdateThread)
  end
end
Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)
