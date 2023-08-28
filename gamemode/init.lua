AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_tooltips.lua")
AddCSLuaFile("cl_buildmenu.lua")
--AddCSLuaFile("entites/effects/zombie_proj_effect.lua")
--AddCSLuaFile("entites/entites/zombie_proj.lua")
include("shared.lua")
include("entities/entities/huge_zombie_npc_nextbot.lua")
include("entities/entities/headcrab_npc_nextbot.lua")
include("entities/entities/mining_rock.lua")
include("entities/entities/beginner_proj.lua")
include("music_controller.lua")

-- This function is called when the gamemode initializes
function GM:Initialize()
    -- Your initialization code here
    print("Gamemode initialized!")
end

-- This hook is called when a player spawns into the game
function GM:PlayerSpawn(player)

    -- Give the player a crowbar
    player:Give("weapon_crowbar")
end

-- This hook is called when a player disconnects from the server
function GM:PlayerDisconnected(player)
    -- Your player disconnect code here
    print(player:Nick() .. " has disconnected!")
end

-- This hook is called when a player dies
function GM:PlayerDeath(victim, inflictor, attacker)
    -- Your player death code here
    print(victim:Nick() .. " was killed by " .. (attacker:IsPlayer() and attacker:Nick() or "something"))
	SetPlayerPower(victim, 0)
end

-- This hook is called when a player presses the "Use" key on an entity
function GM:PlayerUse(player, entity)
    -- Your player use code here
    print(player:Nick() .. " used " .. entity:GetClass())
end

-- This hook is called when a player picks up an item
function GM:PlayerPickupItem(player, item)
    -- Your player pickup item code here
    print(player:Nick() .. " picked up " .. item:GetClass())
end

-- This hook is called when a player changes their weapon
function GM:PlayerSwitchWeapon(player, oldWeapon, newWeapon)
end

-- This hook is called when a player chats
function GM:PlayerSay(player, text, teamChat)
    -- Your player chat code here
    print(player:Nick() .. " said: " .. text)
end

function GM:PlayerInitialSpawn(player)
    --setPlayerHudComponentVisible(source, "weapon", false) -- Hide the weapon displays for the newly joined player
end




