include("shared.lua")
include("cl_tooltips.lua")
include("cl_buildmenu.lua")

-- Initialize the last power variable
local lastPower = GetPlayerPower(LocalPlayer())

local function UpdatePowerBar()
    local power = GetPlayerPower(LocalPlayer())
    local barWidth = math.Clamp(power / (1000 / 150), 0, 150) -- Making the bar longer
    
    local barHeight = 20 -- Height of the power bar
    local backgroundWidth = 160 -- Width of the background
    local barX = ScrW() - 10 - backgroundWidth -- X-coordinate of the bar's top-left corner
    local barY = ScrH() - 30 -- Y-coordinate of the bar's top-left corner
    
    -- Draw a grey background
    surface.SetDrawColor(100, 100, 100, 200)
    surface.DrawRect(barX, barY, backgroundWidth, barHeight)
    
    -- Smoothly transition the power bar from the last power to the new power
    local transitionSpeed = 5 -- Set the speed of the transition
    lastPower = Lerp(FrameTime() * transitionSpeed, lastPower, power)
    
    -- Draw the power bar on top of the background
    surface.SetDrawColor(173, 216, 230, 255) -- Light blue color
    surface.DrawRect(barX + 5, barY + 5, math.Clamp(lastPower / (1000 / 150), 0, 150), barHeight - 10)
end

hook.Add("HUDPaint", "DrawPowerBar", UpdatePowerBar)



-- Override the HUDShouldDraw hook to block the ammo HUD
hook.Add("HUDShouldDraw", "BlockAmmoHUD", function(name)
    if name == "CHudAmmo" or name == "CHudSecondaryAmmo" then
        return false
    end
end)

-- Override the HUDShouldDraw hook to block the health HUD
hook.Add("HUDShouldDraw", "BlockHealthHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)

-- Initialize the last health variable
local lastHealth = 0

hook.Add("HUDPaint", "CustomHealthHUD", function()
    local player = LocalPlayer()
    if not IsValid(player) then return end -- Check if the player is valid

    -- Get the player's current health
    local health = player:Health()
    if not health then return end -- Check if the health value is valid

    -- Set the width and height of the HUD elements
    local width = 200
    local height = 20

    -- Set the position of the HUD elements
    local x = 50
    local y = ScrH() - 50

    -- Draw the grey background rectangle with border designs
    surface.SetDrawColor(128, 128, 128, 255) -- Set the color to grey
    surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 4) -- Draw the outer border
    surface.DrawOutlinedRect(x - 2, y - 2, width + 4, height + 4) -- Draw the inner border

    -- Draw the black background bar
    surface.SetDrawColor(0, 0, 0, 200) -- Set the color to black
    surface.DrawRect(x, y, width, height) -- Draw the rectangle

    -- Smoothly transition the health bar from the last health to the new health
    local transitionSpeed = 5 -- Set the speed of the transition
    lastHealth = Lerp(FrameTime() * transitionSpeed, lastHealth, health)

    -- Set the color of the health bar based on the player's current health
    local healthColor = Color(0, 255, 0, 255) -- Green color by default
    if lastHealth <= 50 then
        local t = (50 - lastHealth) / 50
        healthColor = Color(255 * t, 255 * (1 - t), 0, 255)
    end

    -- Draw the health bar
    surface.SetDrawColor(healthColor)
    surface.DrawRect(x, y, width * (lastHealth / 100), height) -- Draw the rectangle

    -- Draw the health text
    draw.SimpleText(math.Round(lastHealth) .. "%", "DermaDefault", x + width / 2, y + height / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)