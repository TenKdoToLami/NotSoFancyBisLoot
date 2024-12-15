local window                                        --  Global variable to hold the window frame
local lastWindowPosX, lastWindowPosY = 0, 0         --  Default to numeric position values (top-left corner)
local lastOption = ""

--  Namespace for function
NotSoFancyBisLoot = NotSoFancyBisLoot or {}


function NotSoFancyBisLoot.setupWindow(option, open)
    local newWindow = CreateFrame("Frame", nil, UIParent)
    newWindow:SetSize(150, 400)

    --  Set the position of the window. If the position was saved, use it; otherwise, default to top-left
    newWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", lastWindowPosX, lastWindowPosY)

    newWindow:SetMovable(true)                     --   Make the window movable
    newWindow:EnableMouse(true)                    --   Allow the window to be mouse-interactive
    newWindow:SetClampedToScreen(true)             --   Prevent the window from going off-screen

    --  Set the window's level and strata to ensure it is on top
    newWindow:SetFrameStrata("FULLSCREEN_DIALOG")  --   This ensures the window appears above most other UI elements
    newWindow:SetFrameLevel(100)                   --   Adjust this level to ensure it overlays on top of other UI elements

    --  Create a title for the window (optional)
    local title = newWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", newWindow, "TOP", 0, -10)
    title:SetText(option)


    --  Make the window draggable by clicking and holding the title
    newWindow:SetScript("OnMouseDown", function(self)
        self:StartMoving()
    end)
    newWindow:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        --  Store the top-left position of the window when the user stops moving it
        local x, y = self:GetLeft(), self:GetTop()
        lastWindowPosX = x
        lastWindowPosY = y
    end)


    --  Create a close button at the top right corner
    local closeButton = CreateFrame("Button", nil, newWindow, "UIPanelButtonTemplate")
    closeButton:SetSize(20, 20)
    closeButton:SetPoint("TOPRIGHT", newWindow, "TOPRIGHT", -5, -5)
    closeButton:SetText("X")
    

    --  Close button on click
    closeButton:SetScript("OnClick", function()
        newWindow:Hide()
        open.value = false                          -- Update the open parameter to reflect the window is now closed
    end)

    return newWindow
end


function NotSoFancyBisLoot.createItemButton(window, itemLink, col, row, buttonSize, spacing, offsetX, offsetY)
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


function NotSoFancyBisLoot.createItemWindow(itemLinks, option, open)
    
    --  If the window is already created and visible, return (do nothing)
    if window and window:IsShown() and lastOption == option then
        return open                                 -- Exit if the window is already shown
    end

    window = NotSoFancyBisLoot.setupWindow(option, open)

    local rows = 9
    local columns = 3
    local buttonSize = 50
    local spacing = 0
    local offsetX = 0
    local offsetY = -30
    

    --  Iterate through the itemLinks and create buttons for each
    for row = 1, rows do
        for col = 1, columns do
            local index = (row - 1) * columns + col
            local itemLink = itemLinks[option][index]

            if itemLink ~= "" then
                NotSoFancyBisLoot.createItemButton(window, itemLink, col, row, buttonSize, spacing, offsetX, offsetY)
            end
        end
    end

    -- Show the window
    lastOption = option
    window:Show()
    open.value = true                                   -- Set the open parameter to true since the window is now open
    return open                                         -- Return the updated open state
end

function NotSoFancyBisLoot.hideItemWindow(open)
    window:Hide()
    open.value = false                                  -- Ensure open is false when hiding the window
end
