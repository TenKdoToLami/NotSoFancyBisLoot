local window  -- Global variable to hold the window frame
local lastWindowPosX, lastWindowPosY = 0, 0  -- Default to numeric position values (top-left corner)

NotSoFancyBisLoot = NotSoFancyBisLoot or {}

function NotSoFancyBisLoot.createItemWindow(itemLinks, open)
    -- If the window is already created and visible, return (do nothing)
    if window and window:IsShown() then
        return open  -- Exit if the window is already shown
    end

    -- Create a frame for the window
    window = CreateFrame("Frame", nil, UIParent)
    window:SetSize(150, 400)  -- Set the size of the window (width, height)
    
    -- Set the position of the window. If the position was saved, use it; otherwise, default to top-left
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", lastWindowPosX, lastWindowPosY)

    window:SetMovable(true)  -- Make the window movable
    window:EnableMouse(true)  -- Allow the window to be mouse-interactive
    window:SetClampedToScreen(true)  -- Prevent the window from going off-screen

    -- Set the window's level and strata to ensure it is on top
    window:SetFrameStrata("FULLSCREEN_DIALOG")  -- This ensures the window appears above most other UI elements
    window:SetFrameLevel(100)  -- Adjust this level to ensure it overlays on top of other UI elements

    -- Create a title for the window (optional)
    local title = window:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", window, "TOP", 0, -10)
    title:SetText("Item Grid")

    -- Make the window draggable by clicking and holding the title
    window:SetScript("OnMouseDown", function(self)
        self:StartMoving()
    end)
    window:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        -- Store the top-left position of the window when the user stops moving it
        local x, y = self:GetLeft(), self:GetTop()
        lastWindowPosX = x
        lastWindowPosY = y
    end)

    -- Create a close button at the top right corner
    local closeButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    closeButton:SetSize(20, 20)
    closeButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", -5, -5)
    closeButton:SetText("X")
    
    -- Close button on click
    closeButton:SetScript("OnClick", function()
        window:Hide()
        open.value = false  -- Update the open parameter to reflect the window is now closed
    end)

    -- Iterate through the itemLinks and create buttons for each
    local rows = 9
    local columns = 3
    local buttonSize = 50  -- Size of each button
    local spacing = 0  -- Spacing between buttons
    local offsetX = 0  -- Offset for positioning buttons
    local offsetY = -30  -- Offset for positioning buttons (starting from below the title)

    for row = 1, rows do
        for col = 1, columns do
            local index = (row - 1) * columns + col
            local itemLink = itemLinks[index]

            if itemLink ~= "" then
                -- Create a button for the item
                local button = CreateFrame("Button", nil, window)
                button:SetSize(buttonSize, buttonSize)  -- Set the button size
                button:SetPoint("TOPLEFT", window, "TOPLEFT", offsetX + (col - 1) * (buttonSize + spacing), offsetY - (row - 1) * (buttonSize + spacing))

                -- Set the button icon using the item texture
                local icon = button:CreateTexture(nil, "ARTWORK")
                icon:SetAllPoints(button)  -- Make the icon fill the button
                icon:SetTexture(GetItemIcon(itemLink))  -- Set the item's icon

                -- Tooltip handling on mouse enter (when hovering over the button)
                button:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(button, "ANCHOR_CURSOR_RIGHT")
                    GameTooltip:SetHyperlink(itemLink)
                    GameTooltip:Show()
                end)

                -- Hide the tooltip on mouse leave
                button:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            end
        end
    end

    -- Show the window
    window:Show()
    open.value = true  -- Set the open parameter to true since the window is now open
    return open  -- Return the updated open state
end

function NotSoFancyBisLoot.hideItemWindow(open)
    window:Hide()
    open.value = false  -- Ensure open is false when hiding the window
end
