GM.Name = "Your Gamemode Name"
GM.Author = "Your Name"
GM.Email = "Your Email"
GM.Website = "Your Website"

-- Define shared functions and variables here

-- In shared.lua
function SetPlayerPower(player, power)
    player:SetNWInt("Power", power)
end

function GetPlayerPower(player)
    return player:GetNWInt("Power", 0)
end
