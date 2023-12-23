--[[
NOTE

If I declare local function/variable here, it won't be detected in other files even if this file is included via 'include()'.
Declare this file as module, or define function/variable as global to use them in other files.
]]
function CheckSAdmin(target)
  return IsValid(target) and target:IsPlayer() and target:IsUserGroup("superadmin")
end

function CheckSAdminConsole(target)
  return target == NULL or CheckSAdmin(target)
end

function GetPlayerByName(name)
  for _, p in ipairs(player.GetHumans()) do
    if string.lower(p:GetName()) == name then return p end
  end

  return nil
end

function GetTraceEntity(ply)
  local tr = util.GetPlayerTrace(ply)
  tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
  local trace = util.TraceLine(tr)
  if trace.Hit then return trace.Entity end
end

function HasValue(tbl, val)
  for k, v in ipairs(tbl) do
    if v == val then return true end
  end

  return false
end

function SendMessage(target, msgtype, msg)
  msgtype = msgtype or HUD_PRINTCONSOLE
  if target == NULL then
    -- target is console
    MsgN(msg)
  elseif IsValid(target) and target:IsPlayer() then
    if msgtype == HUD_PRINTCENTER then
      target:PrintMessage(HUD_PRINTCENTER, msg)
    elseif msgtype == HUD_PRINTCONSOLE then
      target:PrintMessage(HUD_PRINTCONSOLE, msg)
    elseif msgtype == HUD_PRINTTALK then
      target:PrintMessage(HUD_PRINTTALK, msg)
    end
  end
end

function RemoveEffect(ent)
  local removeType = GetConVar("sc_remove_effect"):GetInt()
  if removeType == 0 then
    RemoveEffectRemove(ent)
  elseif removeType == 1 then
    RemoveEffectDissolve(ent)
  end
end

local dissolveCounter = 0
local dissolver -- Reuse dissolver
function RemoveEffectDissolve(ent)
  -- https://developer.valvesoftware.com/wiki/Env_entity_dissolver
  local phys = ent:GetPhysicsObject()
  if IsValid(phys) then
    phys:EnableGravity(false)
  end

  ent:SetName("sc_dissolve_" .. dissolveCounter)
  if not IsValid(dissolver) then
    dissolver = ents.Create("env_entity_dissolver")
    dissolver:SetPos(ent:GetPos())
    dissolver:Spawn()
    dissolver:Activate()
    dissolver:SetKeyValue("magnitude", 100)
    dissolver:SetKeyValue("dissolvetype", 0)
  end

  dissolver:Fire("Dissolve", "sc_dissolve_" .. dissolveCounter)
  -- Use timer.Create for updating 60 sec counter
  timer.Create(
    "SCRemoveDissolveCleanup",
    60,
    1,
    function()
      if IsValid(dissolver) then
        dissolver:Remove()
      end
    end
  )
end

function RemoveEffectRemove(ent)
  if not IsValid(ent) or ent:IsPlayer() then return false end
  if CLIENT then return true end
  -- Remove all constraints to stop ropes from hanging around
  constraint.RemoveAll(ent)
  -- Remove the entity after 0.1 second
  timer.Simple(
    0.1,
    function()
      if IsValid(ent) then
        ent:Remove()
      end
    end
  )

  -- Make the entity not solid
  ent:SetNotSolid(true)
  ent:SetMoveType(MOVETYPE_NONE)
  ent:SetNoDraw(true)
  -- Show effect
  local ed = EffectData()
  ed:SetOrigin(ent:GetPos())
  ed:SetEntity(ent)
  util.Effect("entity_remove", ed, true, true)

  return true
end
