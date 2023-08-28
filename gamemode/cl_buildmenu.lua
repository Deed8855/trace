include("shared.lua")

-- Initialize the show menu variable
local showMenu = false
local items = {}
local scrollOffset = 0

-- Table of item costs
local itemCosts = {
    ["Door"] = 10,
    ["Wall"] = 5,
    ["Generator"] = 50,
    ["Beginner Weapon"] = 20,
    ["Advanced Weapon"] = 40,
    ["Shield"] = 30,
    ["Armor"] = 25,
    ["Health Pack"] = 15,
    ["Ammo Pack"] = 10,
    ["Grenade"] = 5,
    ["Flashlight"] = 2,
    ["Night Vision Goggles"] = 10,
    ["Gas Mask"] = 8,
    ["Radio"] = 5,
    ["Compass"] = 2,
    ["Map"] = 1,
    ["Binoculars"] = 5,
    ["Rope"] = 3,
    ["Grappling Hook"] = 10,
    ["Parachute"] = 15,
    ["Jetpack"] = 50,
    ["Boots"] = 10,
    ["Gloves"] = 5,
    ["Helmet"] = 15,
    ["Backpack"] = 10,
    ["Tent"] = 20,
    ["Sleeping Bag"] = 10,
    ["Campfire"] = 5,
    ["Cooking Pot"] = 3,
    ["Water Bottle"] = 1
}

-- Override the HUDPaint hook to draw the purchase menu
hook.Add("HUDPaint", "DrawPurchaseMenu", function()
	-- Check if the show menu variable is true
	if showMenu then
		-- Set the position and size of the menu
		local x = ScrW() * 0.1
		local y = ScrH() * 0.1
		local w = ScrW() * 0.8
		local h = ScrH() * 0.8
		local lineHeight = draw.GetFontHeight("DermaDefault") + 10

		-- Draw the background of the menu
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawRect(x, y, w, h)

		-- Draw the title of the menu
		draw.SimpleText("Purchase Menu", "DermaLarge", x + w / 2, y + 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Draw the list of items
		local items = {
			"Door",
			"Wall",
			"Generator",
			"Beginner Weapon",
			"Advanced Weapon",
			"Shield",
			"Armor",
			"Health Pack",
			"Ammo Pack",
			"Grenade",
			"Flashlight",
			"Night Vision Goggles",
			"Gas Mask",
			"Radio",
			"Compass",
			"Map",
			"Binoculars",
			"Rope",
			"Grappling Hook",
			"Parachute",
			"Jetpack",
			"Boots",
			"Gloves",
			"Helmet",
			"Backpack",
			"Tent",
			"Sleeping Bag",
			"Campfire",
			"Cooking Pot",
			"Water Bottle"
        }
        local maxItemsPerColumn=math.floor((h-y-50)/lineHeight)
        local numColumns=math.ceil(#items/maxItemsPerColumn)
        local columnWidth=(w-50)/numColumns
        for i,item in ipairs(items) do
            local column=math.floor((i-1)/maxItemsPerColumn)
            local row=(i-1)%maxItemsPerColumn
            local textX=x+25+column*columnWidth
            local textY=y+50+row*lineHeight

            -- Check if the mouse cursor is over this item
            if gui.MouseX() >= textX and gui.MouseX() <= textX + surface.GetTextSize(item) and gui.MouseY() >= textY and gui.MouseY() <= textY + lineHeight then
                -- Highlight this item with a slow fade to a blueish color
                draw.SimpleText(item, "DermaDefault", textX, textY, Color(0,127,255,255), TEXT_ALIGN_LEFT)

                -- Draw the cost of this item in a small dialogue box that moves with the cursor
                local costText="Cost: "..tostring(itemCosts[item]).." Energy"
                local costBoxW,costBoxH=surface.GetTextSize(costText)
                local costBoxX=gui.MouseX()+15
                local costBoxY=gui.MouseY()+15
                draw.RoundedBox(4,costBoxX,costBoxY,costBoxW+10,costBoxH+10,Color(50,50,50,200))
                draw.SimpleText(costText,"DermaDefault",costBoxX+5,costBoxY+5,Color(255,255,255,255),TEXT_ALIGN_LEFT)
            else
                -- Draw this item normally in white color
                draw.SimpleText(item,"DermaDefault",textX,textY,Color(255,255,255,255),TEXT_ALIGN_LEFT)
            end
        end
    end
end)

-- Function to wrap a long line of text to multiple lines with a specified maximum width
function wrapText(text,maxWidth)
    local words=string.Explode(" ",text)
    local lines={}
    local currentLine=""
    for i,word in ipairs(words) do
        if i>1 and surface.GetTextSize(currentLine.." "..word)>maxWidth then
            table.insert(lines,currentLine)
            currentLine=""
        end

        if currentLine=="" then
            currentLine=word
        else
            currentLine=currentLine.." "..word
        end
    end

    if currentLine~="" then
        table.insert(lines,currentLine)
    end

    return lines
end




-- Function to wrap a long line of text to multiple lines with a specified maximum width
function wrapText(text, maxWidth)
	local words = string.Explode(" ", text)
	local lines = {}
	local currentLine = ""
	for i, word in ipairs(words) do
		if i > 1 and surface.GetTextSize(currentLine .. " " .. word) > maxWidth then
			table.insert(lines, currentLine)
			currentLine = ""
		end
		
		if currentLine == "" then
			currentLine = word
		else 
			currentLine = currentLine .. " " .. word 
		end 
	end
	
	if currentLine ~= "" then 
		table.insert(lines, currentLine) 
	end
	
	return lines 
end 


-- Override the Think hook to handle the Q key press and release
hook.Add("Think", "HandleQKeyPressAndRelease", function()
    -- Check if the player is holding down the Q key
    if input.IsKeyDown(KEY_Q) then
        -- Set the show menu variable to true
        showMenu = true
		gui.EnableScreenClicker(true)
    else
        -- Set the show menu variable to false
        showMenu = false
		gui.EnableScreenClicker(false)
    end
end)