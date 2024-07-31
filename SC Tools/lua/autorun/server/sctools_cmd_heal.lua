require("sctools")
local GetPlayerByName = sctools.command.GetPlayerByName
local IsSuperAdmin = sctools.IsSuperAdmin
local SendMessage = sctools.SendMessage
local SuggestPlayer = sctools.command.SuggestPlayer
--
--[[
################
#     HEAL     #
################
]]
---@param ply Player
---@param args table
local function Heal(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC Heal] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    p:SetHealth(p:GetMaxHealth())
    if p ~= ply then SendMessage(Format("[SC Heal] Healed %s.", p:GetName()), ply) end
    SendMessage("[SC Heal] You are healed.", p, HUD_PRINTTALK)
  end
end

local function HealComplete(_, args)
  return SuggestPlayer("sc_heal", args)
end

concommand.Add("sc_heal", Heal, HealComplete, "Heal player.", FCVAR_NONE)
--[[
####################
#     OVERHEAL     #
####################
]]
---@param ply Player
---@param args table
local function OverHeal(ply, _, args, _)
  if not IsSuperAdmin(ply) then return end
  if #args > 1 then SendMessage("[SC Heal] Only first player will be processed.", ply) end
  local p = #args == 1 and GetPlayerByName(args[1]) or ply
  if IsValid(p) and p:IsPlayer() then
    p:SetHealth(p:GetMaxHealth())
    p:SetArmor(p:GetMaxArmor())
    if p ~= ply then SendMessage(Format("[SC Heal] Overhealed %s.", p:GetName()), ply) end
    SendMessage("[SC Heal] You are overhealed.", p, HUD_PRINTTALK)
  end
end

---@param args string
---@return table
local function OverHealComplete(_, args)
  return SuggestPlayer("sc_overheal", args)
end

concommand.Add("sc_overheal", OverHeal, OverHealComplete, "Overheal player.", FCVAR_NONE)
