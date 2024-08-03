---@param className string
local function _AddHooks(className)
  ---@param save ISave
  saverestore.AddSaveHook(className .. "_SaveData", function(save)
    local saveData = {}
    for _, v in pairs(player.GetHumans()) do ---@cast v Player
      local wep = v:GetWeapon(className)
      if IsValid(wep) then saveData[v:SteamID64()] = wep:GetSecondaryMode() end ---@diagnostic disable-line undefined-field
    end

    saverestore.WriteTable(saveData, save)
  end)

  ---@param save IRestore
  saverestore.AddRestoreHook(className .. "_SaveData", function(save)
    if game.MapLoadType() == "transition" then
      local saveData = saverestore.ReadTable(save)
      for k, v in pairs(saveData) do
        local p = player.GetBySteamID64(k)
        if IsValid(p) then
          local wpn = p:GetWeapon(className)
          if IsValid(wpn) then wpn:SetSecondaryMode(v) end ---@diagnostic disable-line undefined-field
        end
      end
    end
  end)

  ---@param target Entity
  ---@param dmginfo CTakeDamageInfo
  hook.Add("EntityTakeDamage", className .. "_GrenadeBehavior", function(target, dmginfo)
    if target:GetClass() == "npc_grenade_frag" and target:GetName():StartsWith(className .. "_grenade_") and (dmginfo:GetDamageType() == DMG_BLAST or dmginfo:GetDamageType() == DMG_BURN) then
      --return true
      dmginfo:SetDamage(0)
    end
  end)

  if SERVER then
    util.AddNetworkString(className .. "_ChangeMode")
  end
end

--
_AddHooks("scaw_pistol")
