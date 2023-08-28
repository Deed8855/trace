include("shared.lua")

-- Initialize the trace entity and use key variables
local traceEntity = nil
local useKey = false

-- Table of entity descriptions
local entityDescriptions = {
    ["mining_rock"] = {
        "This is a physics prop. You can pick it up and move it around using the Physics Gun.",
        "Press and hold the E key while using the Physics Gun to rotate the prop."
    },
    ["huge_zombie_npc_nextbot"] = {
        "This is a Roaming Zombie, he will throw projectiles at you.",
        "He is known for being attracted to mines."
    },
    ["npc_zombie"] = {
        "This is a zombie NPC. They are hostile and will attack you on sight.",
        "Use your weapons to defend yourself against them."
    }
}

-- Override the HUDPaint hook to draw the text description
hook.Add("HUDPaint", "DrawTextDescription", function()
    -- Check if the player is looking at a valid entity and pressing the E key
    if IsValid(traceEntity) and useKey then
        -- Get the class of the trace entity
        local class = traceEntity:GetClass()

        -- Check if there is a description for this class of entity
        if entityDescriptions[class] then
            -- Set the text description
            local lines = entityDescriptions[class]

            -- Set the position and size of the text box
            local x = ScrW() / 2
            local y = ScrH() / 2 + 50
            local w, h = surface.GetTextSize(lines[1])
            local lineHeight = h + 5

            -- Draw the black background box
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(x - w / 2 - 5, y - h / 2 - 5, w + 10, #lines * lineHeight + 10)

            -- Draw the text description
            for i, line in ipairs(lines) do
                draw.SimpleText(line, "DermaDefault", x, y + (i - 1) * lineHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
end)

-- Override the Think hook to update the trace entity
hook.Add("Think", "UpdateTraceEntity", function()
    -- Perform a trace to find the entity that the player is looking at
    local trace = util.TraceLine({
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 100,
        filter = LocalPlayer()
    })

    -- Update the trace entity variable
    traceEntity = trace.Entity

    -- Update the use key variable
    useKey = input.IsKeyDown(KEY_E)
end)



-- Override the Think hook to update the trace entity
hook.Add("Think", "UpdateTraceEntity", function()
    -- Perform a trace to find the entity that the player is looking at
    local trace = util.TraceLine({
        start = LocalPlayer():GetShootPos(),
        endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 100,
        filter = LocalPlayer()
    })

    -- Update the trace entity variable
    traceEntity = trace.Entity

    -- Update the use key variable
    useKey = input.IsKeyDown(KEY_E)
end)
