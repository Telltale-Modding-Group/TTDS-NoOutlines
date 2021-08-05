-- Decompiled using luadec 2.2 rev:  for Lua 5.2 from https://github.com/viruscamp/luadec
-- Command line: A:\Work\MODDING\Github\TTDS-NoOutlines\WDC_pc_WalkingDead402_data\ForestTile_temp.lua 

-- params : ...
-- function num : 0 , upvalues : _ENV
local kScript = "ForestTile"
local kScene = "adv_forestTile"
local mbDebugText = false

local DebugPrint = function(mesg, verbosity, bError)
  -- function num : 0_0 , upvalues : mbDebugText, _ENV
  if not mbDebugText then
    return 
  end
  Print(mesg, verbosity, bError)
end

local OnKeyChange = function(key, value)
  -- function num : 0_1 , upvalues : _ENV, DebugPrint
  if key == "AI Player - Interaction Enable" and AgentGetProperty("James", "AI Agent - AI Agent Enable") then
    DebugPrint("setting James pathing to " .. tostring(value))
    AgentSetProperty("James", "AI Agent - Pathing Enable", value)
  end
end

local OnLogicReady = function()
  -- function num : 0_2 , upvalues : _ENV, OnKeyChange
  PropertyAddKeyCallback(AgentGetProperties("Clementine"), "AI Player - Interaction Enable", OnKeyChange)
  if Game_GetLoaded() then
    return 
  end
  Episode_SetAbelArm()
  AgentSetProperty("James", "Current State", "headMask")
  local debugID = LogicGet("Debug ID")
  if debugID == 1 then
    Game_SetSceneDialogNode("cs_postKick")
  else
    if debugID == 2 then
      Game_SetSceneDialogNode("cs_lost")
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

ForestTile = function()
  -- function num : 0_3 , upvalues : _ENV
  
  ModifyScene(kScene)
  
  DlgPreloadAll(Game_GetPlayerDialog(), false)
end

ForestTile_SpawnJames = function()
  -- function num : 0_4 , upvalues : _ENV, DebugPrint
  local PositionIsValid = function()
    -- function num : 0_4_0 , upvalues : _ENV, DebugPrint
    if AgentIsOnScreen("James") then
      DebugPrint("invalid: James is on-screen")
      return false
    else
      if AgentDistanceToAgent("Clementine", "James") < 6 or AgentDistanceToAgent("Clementine", "James") > 10 then
        DebugPrint("invalid: James is too close to Clem")
        return false
      end
    end
    DebugPrint("position OK")
    return true
  end

  local i = 0
  while not PositionIsValid() do
    local multipliers = {1, -1}
    local requestedPos = Vector(0, 0, 0)
    requestedPos.x = RandomInt(6, 15) * multipliers[RandomInt(1, 2)]
    requestedPos.z = RandomInt(6, 15) * multipliers[RandomInt(1, 2)]
    local pos = WalkBoxesPosOnWalkBoxes(AgentLocalToWorld("Clementine", requestedPos), 0, "adv_forestTile.wbox")
    DebugPrint("trying to spawn James at " .. tostring(pos))
    AgentSetWorldPos("James", pos)
    i = i + 1
    if i >= 30 then
      DebugPrint("couldn\'t find a good position after " .. i .. " tries; giving up :(")
      break
    end
  end
  do
    AgentFacePos("James", AgentGetWorldPos("Clementine"))
    AgentSetProperty("James", "AI Agent - AI Agent Enable", true)
    AgentHide("James", false)
  end
end

Callback_OnLogicReady:Add(OnLogicReady)
Game_SceneOpen(kScene, kScript)

