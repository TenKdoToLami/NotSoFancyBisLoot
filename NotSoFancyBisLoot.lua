
local open = {value = false } -- Global variable to track if the window is open


-- Slash command to open/close the item window
SLASH_NSFBL1 = "/NSFBL"
SlashCmdList["NSFBL"] = function()
    -- Example usage: 
    -- Call the function and pass a table with item links

    if open.value then
        -- If the window is already open, hide it
        NotSoFancyBisLoot.hideItemWindow(open)
    else
        -- Otherwise, create the window and show it
        NotSoFancyBisLoot.createItemWindow(itemLinks,open)
    end
end
