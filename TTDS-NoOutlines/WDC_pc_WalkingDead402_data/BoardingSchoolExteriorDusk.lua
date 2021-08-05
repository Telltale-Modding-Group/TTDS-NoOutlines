-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead402_data\BoardingSchoolExteriorDusk_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
require("AI_PlayerProjectile.lua")
local kScript = "BoardingSchoolExteriorDusk"
local kScene = "adv_boardingSchoolExteriorDusk"
local kWalkbox = "adv_boardingSchoolExteriorDusk.wbox"

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if IsPlatformNX() then
    Episode_SetFireShadows()
  end
  BoardingSchoolExteriorDusk_UpdateWalkbox()
  if Game_GetLoaded() then
    return 
  end
  Episode_SetAJShirt()
  Episode_SetLouisDamage()
  if LogicGet("Debug ID") == 1 then
    Game_SetSceneDialogNode("cs_truthOrDare")
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

BoardingSchoolExteriorDusk = function()
  -- function num : 0_1 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  DlgPreloadAll(Game_GetPlayerDialog(), false)
  if Game_GetSkipEnterCutscenes() then
    Game_RunSceneDialog("logic_freeWalk", false)
  end
end

BoardingSchoolExteriorDusk_UpdateWalkbox = function()
  -- function num : 0_2 , upvalues : _ENV, kWalkbox
  WalkBoxesEnableAll(kWalkbox)
  local idle = AgentGetProperty("Louis", "Walk Animation - Idle")
  if idle then
    idle = ResourceGetName(idle)
  end
  if not AgentIsHidden("Louis") then
    if idle == "adv_boardingSchoolExteriorDusk_louisShooting.chore" then
      WalkBoxesDisableAreaAroundAgent(kWalkbox, "dummy_louisWalkboxBlockerShooting", 0.01)
    else
      if idle == "adv_boardingSchoolExteriorDusk_louisPickingUp.chore" then
        WalkBoxesDisableAreaAroundAgent(kWalkbox, "dummy_louisWalkboxBlockerStandingAround", 0.01)
      end
    end
  end
  Episode_SetZombieGrave()
end

BoardingSchoolExteriorDusk_CleanUpAuxiliaryChore = function()
  -- function num : 0_3 , upvalues : _ENV
  local controller = ControllerFind("zombat_clemStrafeBowNockedToDrawn.chore")
  while ControllerIsPlaying(controller) do
    WaitForNextFrame()
  end
  AgentSetProperty("Clementine", "Walk Animator - Auxiliary Chore", "")
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

