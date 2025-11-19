--[[
    Simple Loader - MonsHub for Plants vs Brainrots
    One-line execution loader
]]--

-- Simple one-line loader (copy this to executor)
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/PvB%20Script.lua"))()

--[[
    ALTERNATIVE: Load from local file (for testing)
    If you're testing locally, use this instead:
]]--

-- loadfile([[d:\aScriptHub\Plant VS Braintot\PvB Script.lua]])()

--[[
    ALTERNATIVE: Load with error handling
]]--

--[[
local success, result = pcall(function()
    return loadstring(game:HttpGet("YOUR_RAW_SCRIPT_URL_HERE"))()
end)

if not success then
    game.StarterGui:SetCore("SendNotification", {
        Title = "MonsHub Loader";
        Text = "Failed to load script: " .. tostring(result);
        Duration = 5;
    })
end
]]--
