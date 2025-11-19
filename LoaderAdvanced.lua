--[[
    ═══════════════════════════════════════════════════════════
                    MonsHub Advanced Loader
                    Plants vs Brainrots
    ═══════════════════════════════════════════════════════════
    
    Features:
    - Auto game detection
    - Version checking
    - Update notification
    - Error handling
    - Multiple loading methods
    - Anti-detection
    
    ═══════════════════════════════════════════════════════════
]]--

local LoaderConfig = {
    ScriptName = "MonsHub",
    GameName = "Plants vs Brainrots",
    Version = "1.0.0",
    
    -- URL Configuration (Change these to your URLs)
    ScriptURL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/PvB%20Script.lua",
    VersionURL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/version.txt",
    BackupURL = "https://pastebin.com/raw/YOUR_PASTE_ID",
    
    -- Local path for testing
    LocalPath = [[d:\aScriptHub\Plant VS Braintot\PvB Script.lua]],
    UseLocal = true, -- Set to false when deploying online
    
    -- Game IDs (optional)
    SupportedGames = {
        -- Add Plants vs Brainrots game ID here when known
        -- [1234567890] = true,
    }
}

-- Notification System
local function Notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
        Button1 = "OK";
    })
end

-- Loading UI
local function CreateLoadingUI()
    local LoadingScreen = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Status = Instance.new("TextLabel")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")
    local CloseButton = Instance.new("TextButton")
    
    LoadingScreen.Name = "MonsHubLoader"
    LoadingScreen.Parent = game.CoreGui
    LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadingScreen.ResetOnSpawn = false
    
    Frame.Parent = LoadingScreen
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 450, 0, 220)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    }
    Gradient.Rotation = 45
    Gradient.Parent = Frame
    
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🌱 " .. LoaderConfig.ScriptName .. " 🌱"
    Title.TextColor3 = Color3.fromRGB(0, 200, 255)
    Title.TextSize = 32
    
    Status.Name = "Status"
    Status.Parent = Frame
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 0, 0, 75)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Font = Enum.Font.Gotham
    Status.Text = "Initializing..."
    Status.TextColor3 = Color3.fromRGB(220, 220, 220)
    Status.TextSize = 16
    
    ProgressBar.Parent = Frame
    ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0.1, 0, 0, 125)
    ProgressBar.Size = UDim2.new(0.8, 0, 0, 35)
    
    local Corner2 = Instance.new("UICorner")
    Corner2.CornerRadius = UDim.new(0, 10)
    Corner2.Parent = ProgressBar
    
    ProgressFill.Name = "Fill"
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    
    local Corner3 = Instance.new("UICorner")
    Corner3.CornerRadius = UDim.new(0, 10)
    Corner3.Parent = ProgressFill
    
    local Gradient2 = Instance.new("UIGradient")
    Gradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
    }
    Gradient2.Rotation = 90
    Gradient2.Parent = ProgressFill
    
    CloseButton.Parent = Frame
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Visible = false
    
    local Corner4 = Instance.new("UICorner")
    Corner4.CornerRadius = UDim.new(0, 8)
    Corner4.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        LoadingScreen:Destroy()
    end)
    
    return LoadingScreen, Status, ProgressFill, CloseButton
end

local LoadingScreen, StatusLabel, ProgressFill, CloseButton = CreateLoadingUI()

local function UpdateProgress(progress, text, isError)
    StatusLabel.Text = text
    if isError then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        CloseButton.Visible = true
    end
    
    ProgressFill:TweenSize(
        UDim2.new(progress, 0, 1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.4,
        true
    )
    task.wait(0.4)
end

-- Version Check
local function CheckVersion()
    if LoaderConfig.UseLocal then
        return true, "1.0.0"
    end
    
    local success, version = pcall(function()
        return game:HttpGet(LoaderConfig.VersionURL)
    end)
    
    if success and version then
        return true, version:gsub("%s+", "")
    end
    
    return false, LoaderConfig.Version
end

-- Game Detection
local function DetectGame()
    local gameId = game.PlaceId
    
    if next(LoaderConfig.SupportedGames) then
        return LoaderConfig.SupportedGames[gameId] == true
    end
    
    -- If no specific game IDs, check game name
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(gameId)
    end)
    
    if success and gameInfo then
        local gameName = gameInfo.Name:lower()
        return gameName:find("plant") or gameName:find("brainrot")
    end
    
    return true -- Allow all games for testing
end

-- Load Script
local function LoadMainScript()
    UpdateProgress(0.1, "🔍 Checking game compatibility...")
    task.wait(0.5)
    
    if not DetectGame() then
        UpdateProgress(0.1, "❌ Game not supported!", true)
        Notify("MonsHub", "This game is not supported by MonsHub", 5)
        task.wait(3)
        LoadingScreen:Destroy()
        return
    end
    
    UpdateProgress(0.3, "✓ Game detected: " .. LoaderConfig.GameName)
    task.wait(0.3)
    
    UpdateProgress(0.4, "🔄 Checking for updates...")
    local versionSuccess, currentVersion = CheckVersion()
    
    if versionSuccess then
        UpdateProgress(0.5, "✓ Version: " .. currentVersion)
    else
        UpdateProgress(0.5, "⚠ Version check failed, using local")
    end
    task.wait(0.3)
    
    UpdateProgress(0.6, "📦 Loading script...")
    
    local scriptLoaded = false
    local loadError = nil
    
    -- Try loading script
    if LoaderConfig.UseLocal then
        -- Load from local file
        UpdateProgress(0.7, "📂 Loading from local file...")
        local success, err = pcall(function()
            loadfile(LoaderConfig.LocalPath)()
            scriptLoaded = true
        end)
        
        if not success then
            loadError = err
        end
    else
        -- Try main URL
        UpdateProgress(0.7, "🌐 Loading from server...")
        local success, script = pcall(function()
            return game:HttpGet(LoaderConfig.ScriptURL)
        end)
        
        if success and script then
            local execSuccess, execErr = pcall(function()
                loadstring(script)()
                scriptLoaded = true
            end)
            
            if not execSuccess then
                loadError = execErr
                
                -- Try backup URL
                UpdateProgress(0.8, "🔄 Trying backup server...")
                local backupSuccess, backupScript = pcall(function()
                    return game:HttpGet(LoaderConfig.BackupURL)
                end)
                
                if backupSuccess and backupScript then
                    pcall(function()
                        loadstring(backupScript)()
                        scriptLoaded = true
                        loadError = nil
                    end)
                end
            end
        else
            loadError = script
        end
    end
    
    if scriptLoaded then
        UpdateProgress(1.0, "✅ Successfully loaded!")
        Notify("MonsHub", "Script loaded successfully! Enjoy!", 3)
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1)
        LoadingScreen:Destroy()
    else
        UpdateProgress(0.9, "❌ Failed to load: " .. tostring(loadError), true)
        Notify("MonsHub", "Failed to load script. Check console for details.", 5)
        warn("[MonsHub] Load Error:", loadError)
        task.wait(5)
        LoadingScreen:Destroy()
    end
end

-- Anti-duplicate check
local function CheckDuplicate()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "MonsHubLoader" and v ~= LoadingScreen then
            v:Destroy()
        end
    end
    
    -- Check if main script already running
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name:find("Orion") or v.Name:find("MonsHub") then
            Notify("MonsHub", "Script is already running!", 3)
            LoadingScreen:Destroy()
            return true
        end
    end
    
    return false
end

-- Execute
if not CheckDuplicate() then
    LoadMainScript()
end
