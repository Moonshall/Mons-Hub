--[[
    ═══════════════════════════════════════════════════════════════
                    🌱 MonsHub Loader v2.0 🌱
                    Plants vs Brainrots
    ═══════════════════════════════════════════════════════════════
    
    Features:
    ✓ 70+ Features
    ✓ Enhanced UI
    ✓ God Mode & Instant Kill
    ✓ Auto Farm Everything
    ✓ Fly & NoClip
    ✓ ESP System
    ✓ Discord Webhook
    ✓ Teleport System
    
    Discord: discord.gg/monshub
    
    ═══════════════════════════════════════════════════════════════
]]--

-- Loading notification
local function notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
        Icon = "rbxassetid://7733955511";
    })
end

-- Create loading GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local LoadingText = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local Progress = Instance.new("Frame")
local Corner = Instance.new("UICorner")
local Corner2 = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MonsHubLoader"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.Size = UDim2.new(0, 400, 0, 200)

Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 20)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌱 MonsHub v2.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.TextSize = 28

LoadingText.Parent = Frame
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 0, 0, 80)
LoadingText.Size = UDim2.new(1, 0, 0, 30)
LoadingText.Font = Enum.Font.Gotham
LoadingText.Text = "Loading script..."
LoadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingText.TextSize = 16

ProgressBar.Parent = Frame
ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ProgressBar.BorderSizePixel = 0
ProgressBar.Position = UDim2.new(0.1, 0, 0, 140)
ProgressBar.Size = UDim2.new(0.8, 0, 0, 30)

Corner2.CornerRadius = UDim.new(0, 10)
Corner2.Parent = ProgressBar

Progress.Parent = ProgressBar
Progress.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
Progress.BorderSizePixel = 0
Progress.Size = UDim2.new(0, 0, 1, 0)

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 10)
Corner3.Parent = Progress

-- Loading animation
local steps = {
    {text = "Initializing...", progress = 0.2},
    {text = "Loading UI Library...", progress = 0.4},
    {text = "Setting up features...", progress = 0.6},
    {text = "Connecting to game...", progress = 0.8},
    {text = "Almost done...", progress = 1.0}
}

spawn(function()
    for _, step in ipairs(steps) do
        LoadingText.Text = step.text
        Progress:TweenSize(
            UDim2.new(step.progress, 0, 1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.5,
            true
        )
        wait(0.5)
    end
    
    LoadingText.Text = "✓ Loaded Successfully!"
    wait(1)
    ScreenGui:Destroy()
end)

-- Load main script
wait(1)
local success, error = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Moonshall/Mons-Hub/main/PvB%20Script%20v2.0.lua"))()
end)

if not success then
    notify("⚠️ Error", "Failed to load script. Please try again.", 10)
    warn("MonsHub Error:", error)
else
    notify("✓ MonsHub Loaded", "Plants vs Brainrots v2.0 - Enjoy!", 5)
end
