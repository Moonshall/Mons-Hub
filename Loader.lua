--[[
    ═══════════════════════════════════════════════════════════
                    MonsHub Loader
                    Plants vs Brainrots
                    by Yo Gurt Studios
    ═══════════════════════════════════════════════════════════
    
    How to use:
    1. Copy this entire loader script
    2. Paste into your Roblox executor
    3. Execute and enjoy!
    
    ═══════════════════════════════════════════════════════════
]]--

-- Loading screen
local LoadingScreen = Instance.new("ScreenGui")
local LoadingFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local ProgressFill = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")

LoadingScreen.Name = "MonsHubLoader"
LoadingScreen.Parent = game.CoreGui
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = LoadingScreen
LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingFrame.Size = UDim2.new(0, 400, 0, 200)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = LoadingFrame

Title.Name = "Title"
Title.Parent = LoadingFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 20)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "MonsHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28

Status.Name = "Status"
Status.Parent = LoadingFrame
Status.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 70)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Font = Enum.Font.Gotham
Status.Text = "Initializing..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.TextSize = 16

ProgressBar.Name = "ProgressBar"
ProgressBar.Parent = LoadingFrame
ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ProgressBar.BorderSizePixel = 0
ProgressBar.Position = UDim2.new(0.1, 0, 0.6, 0)
ProgressBar.Size = UDim2.new(0.8, 0, 0, 30)

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = ProgressBar

ProgressFill.Name = "ProgressFill"
ProgressFill.Parent = ProgressBar
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Size = UDim2.new(0, 0, 1, 0)

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = ProgressFill

-- Loading animation
local function UpdateProgress(progress, text)
    Status.Text = text
    ProgressFill:TweenSize(
        UDim2.new(progress, 0, 1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.3,
        true
    )
    wait(0.3)
end

-- Game detection
local function DetectGame()
    local gameId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
    
    UpdateProgress(0.2, "Detecting game: " .. gameName)
    
    -- Check if it's Plants vs Brainrots
    if gameName:lower():find("plant") or gameName:lower():find("brainrot") then
        return true
    end
    
    return true -- Load anyway for testing
end

-- Main loader function
local function LoadScript()
    UpdateProgress(0.1, "Starting MonsHub Loader...")
    wait(0.5)
    
    -- Detect game
    if not DetectGame() then
        Status.Text = "Error: Game not supported!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        wait(3)
        LoadingScreen:Destroy()
        return
    end
    
    UpdateProgress(0.4, "Checking dependencies...")
    wait(0.5)
    
    UpdateProgress(0.6, "Loading Orion Library...")
    
    -- Load the main script
    local success, err = pcall(function()
        UpdateProgress(0.8, "Loading MonsHub script...")
        
        -- Method 1: Load from file (if you're testing locally)
        -- loadfile("d:\\aScriptHub\\Plant VS Braintot\\PvB Script.lua")()
        
        -- Method 2: Load from pastebin/github (recommended for distribution)
        -- Uncomment this when you upload the script:
        -- loadstring(game:HttpGet("YOUR_RAW_SCRIPT_URL_HERE"))()
        
        -- Method 3: Load directly (for now, since file is local)
        local scriptPath = "d:\\aScriptHub\\Plant VS Braintot\\PvB Script.lua"
        if isfile and isfile(scriptPath:gsub("\\", "/"):gsub("d:/", "")) then
            loadfile(scriptPath)()
        else
            -- If file doesn't exist, try to load from the script content
            UpdateProgress(0.9, "Loading script content...")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/PvB%20Script.lua"))()
        end
    end)
    
    if success then
        UpdateProgress(1, "Successfully loaded!")
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
    else
        Status.Text = "Error: " .. tostring(err)
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        warn("MonsHub Loader Error:", err)
        wait(3)
    end
    
    -- Remove loading screen
    LoadingScreen:Destroy()
end

-- Anti-detection
local function AntiDetection()
    -- Hide from some basic detection methods
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "MonsHubLoader" and v ~= LoadingScreen then
            v:Destroy()
        end
    end
end

-- Execute
AntiDetection()
LoadScript()
