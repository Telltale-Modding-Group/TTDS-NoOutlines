-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead402_data\BoardingSchoolExteriorDamaged_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
require("AI_PlayerProjectile.lua")

local kScript = "BoardingSchoolExteriorDamaged"
local kScene = "adv_boardingSchoolExteriorDamaged"
local mbAnimatingTextColors = false
local mbClementineWillBurn = false

local OnLogicReady = function()
  -- function num : 0_0 , upvalues : _ENV
  if IsPlatformNX() then
    for _,agentName in ipairs(SceneGetAgentNames(Game_GetScene())) do
      if StringStartsWith(agentName, "Zombie") then
        AgentSetProperty(agentName, "Render EnvLight Shadow Cast Enable", false)
      else
        if StringStartsWith(agentName, "light_ENV_P_fire") or StringStartsWith(agentName, "light_ENV_P_torch") or StringStartsWith(agentName, "light_ENV_P_campfire") then
          AgentSetProperty(agentName, "EnvLight - Shadow Type", "eLightEnvShadowType_None")
        end
      end
    end
  end
  do
    if Game_GetLoaded() then
      return 
    end
    Episode_SetAbelArm()
    Episode_SetAJShirt()
    Episode_SetLouisDamage()
    Episode_SetZombieGrave()
    AgentSetState("Abel", "noseBloody")
    AgentSetState("Abel", "footStab")
    if LogicGet("3 - Slashed Abel\'s Hand") then
      AgentSetState("Abel", "handSlash")
    end
    AgentSetState("Horse", "ReinsOff")
    if LogicGet("Debug ID") == 1 then
      Game_SetSceneDialogNode("cs_leftGateOpen")
    end
  end
end

BoardingSchoolExteriorDamaged_ClemLeaveTrigger = function(agent, trigger)
  -- function num : 0_1 , upvalues : _ENV, mbClementineWillBurn
  if AgentGetName(agent) ~= "Clementine" then
    return 
  else
    mbClementineWillBurn = false
  end
end

BoardingSchoolExteriorDamaged_BurnThisZombie = function(agent, trigger)
  -- function num : 0_2 , upvalues : _ENV, mbClementineWillBurn
  if not agent then
    return 
  end
  if AgentGetName(agent) == "Clementine" then
    AgentSetProperty("ui_panicMeter_vignette", "Render Constant Alpha", 0)
    AgentHide("ui_panicMeter_vignette", false)
    mbClementineWillBurn = true
    local past = GetTotalTime()
    local present = past
    local future = present + 3
    while present < future and mbClementineWillBurn do
      present = present + GetFrameTime()
      AgentSetProperty("ui_panicMeter_vignette", "Render Constant Alpha", Clamp(present - past / future - past + 0.3, 0, 1))
      WaitForNextFrame()
    end
    while Game_GetMode() == eModeCutscene and mbClementineWillBurn do
      WaitForNextFrame()
      WaitForNextFrame()
    end
    if mbClementineWillBurn and AgentGetProperty("Clementine", "AI Player - AI Agents Active") then
      local incr = 1
      local kStr = "trigger_zombiesCatchFire0"
      mbClementineWillBurn = false
      while AgentExistsInScene(kStr .. incr, AgentGetScene(agent)) do
        AgentSetProperty(kStr .. incr, "Trigger Enabled", false)
        incr = incr + 1
        WaitForNextFrame()
      end
      local check = Game_RunSceneDialog("cs_clemDiesByFire")
      if not check then
        print("\"cs_clemDiesByFire\" does not exist! Fix it, fix it, fix it.")
        return 
      end
    else
      do
        do
          local bsGarbage = AgentGetProperty("ui_panicMeter_vignette", "Render Constant Alpha")
          while bsGarbage > 0 do
            bsGarbage = bsGarbage - 0.04
            if bsGarbage < 0 then
              AgentHide("ui_panicMeter_vignette", true)
            end
            AgentSetProperty("ui_panicMeter_vignette", "Render Constant Alpha", bsGarbage)
            WaitForNextFrame()
          end
          AgentSetProperty("ui_panicMeter_vignette", "Render Constant Alpha", 0)
          WaitForNextFrame()
          if StringStartsWith(AgentGetName(agent), "Zombie") then
            if not AgentGetProperty(agent, "AI Agent - Player Used Interaction Prompt 1 Enable") then
              return 
            end
            local zombieController = ChorePlayOnAgent("adv_boardingSchoolExteriorDamaged_zombieCatchesFire.chore", agent)
            while AgentHasProperty(agent, "AI Agent - Dead") and not AgentGetProperty(agent, "AI Agent - Dead") do
              WaitForNextFrame()
            end
            ControllerKill(zombieController)
            WaitForNextFrame()
            local value = AgentGetProperty(agent, "Emitters - Global Intensity")
            while value and value > 0 do
              value = value - 0.02
              WaitForNextFrame()
              AgentSetProperty(agent, "Emitters - Global Intensity", value)
            end
            AgentSetProperty(agent, "Emitters - Global Intensity", 0)
            AgentSetProperty(agent, "Emitters - Enabled", false)
          else
            do
              do return  end
            end
          end
        end
      end
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

BoardingSchoolExteriorDamaged = function()
  -- function num : 0_3 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  DlgPreloadAll(Game_GetPlayerDialog(), false)
  SceneAdd("ui_panicMeter.scene")
end

BoardingSchoolExteriorDamaged_EndEpisode = function()
  -- function num : 0_4 , upvalues : _ENV
  WDAchievements_Unlock("achievement_21")
  Menu_EndEpisode("402", false)
  Menu_EndEpisode_CheckUpsell("403")
end

BoardingSchoolExteriorDamaged_AnimateTextColor = function(tokenAgent, textAgent)
  -- function num : 0_5 , upvalues : _ENV, mbAnimatingTextColors
  local thread = function()
    -- function num : 0_5_0 , upvalues : _ENV, textAgent, mbAnimatingTextColors, tokenAgent
    local kTokenAlpha = "material_ui_useable_token_actionActive_m - Alpha"
    local chore = ChorePlayOnAgent("ui_activeCrosshairText_fade.chore", textAgent)
    ControllerPause(chore)
    do
      while mbAnimatingTextColors do
        local pct = 0
        if AgentGetProperty(tokenAgent, "material_ui_useable_token_actionActive_m - Visible") then
          pct = AgentGetProperty(tokenAgent, kTokenAlpha)
        end
        ControllerSetTime(chore, pct)
        WaitForNextFrame()
      end
      ControllerKill(chore)
    end
  end

  ThreadStart(thread)
end

BoardingSchoolExteriorDamaged_SetAnimatingTextColors = function(bEnable)
  -- function num : 0_6 , upvalues : mbAnimatingTextColors
  if bEnable == mbAnimatingTextColors then
    return 
  end
  mbAnimatingTextColors = bEnable
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

