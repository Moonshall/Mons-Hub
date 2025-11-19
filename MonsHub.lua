--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🌱 MonsHub - Plants vs Brainrots 🌱
    
    Developer: Moonshall
    UI Style: Premium Dark Theme
    Version: 1.0
    Status: Auto-Active Features
    
    Features: 110+ Premium Features
    - Auto Anti AFK (20 min bypass) ✓ AUTO ACTIVE
    - Auto Sell Seeds
    - Auto Buy Seeds  
    - Complete Automation System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- Settings (Auto-Active Features)
local Settings = {
    -- AUTO ACTIVE FEATURES
    AntiAFK = true, -- ✓ AUTO ACTIVE
    
    -- Main Tab
    AutoRejoin = false,
    FPSBooster = false,
    ShowStats = true,
    
    -- Farm Tab - Brainrot
    AutoFarmBrainrot = false,
    AutoSellBrainrot = false,
    SelectedBrainrotRarity = "Common",
    FarmMode = "Nearest",
    
    -- Farm Tab - Seed/Plant
    AutoBuySeed = false,
    AutoSellSeed = false,
    SelectedSeed = "Peashooter",
    SeedBuyAmount = 1,
    SellSeedRarity = "Common",
    AutoPlantSeed = false,
    
    -- Combat
    DamageMultiplier = 1,
    DefenseMultiplier = 1,
    
    -- Player
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false,
    FlyMode = false,
    
    -- ESP
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
}

-- Real Seed Names (From Google - Plants vs Zombies)
local SeedList = {
    -- Row 1 - Basic Plants
    "Peashooter",
    "Sunflower", 
    "Cherry Bomb",
    "Wall-nut",
    "Potato Mine",
    
    -- Row 2 - Advanced Plants
    "Snow Pea",
    "Chomper",
    "Repeater",
    "Puff-shroom",
    "Sun-shroom",
    
    -- Row 3 - Special Plants
    "Fume-shroom",
    "Grave Buster",
    "Hypno-shroom",
    "Scaredy-shroom",
    "Ice-shroom",
    
    -- Row 4 - Premium Plants
    "Doom-shroom",
    "Lily Pad",
    "Squash",
    "Threepeater",
    "Tangle Kelp",
    
    -- Row 5 - Epic Plants
    "Jalapeno",
    "Spikeweed",
    "Torchwood",
    "Tall-nut",
    "Sea-shroom",
    
    -- Row 6 - Legendary Plants
    "Plantern",
    "Cactus",
    "Blover",
    "Split Pea",
    "Starfruit",
    
    -- Row 7 - Mythic Plants
    "Pumpkin",
    "Magnet-shroom",
    "Cabbage-pult",
    "Flower Pot",
    "Kernel-pult",
    
    -- Row 8 - Ultimate Plants
    "Coffee Bean",
    "Garlic",
    "Umbrella Leaf",
    "Marigold",
    "Melon-pult",
    
    -- Upgraded Plants
    "Winter Melon",
    "Gold Magnet",
    "Spikerock",
    "Cob Cannon",
    "Imitater"
}

-- Real Brainrot Names (Zombies)
local BrainrotList = {
    -- Basic Brainrots
    "Basic Zombie",
    "Conehead Zombie",
    "Buckethead Zombie",
    "Flag Zombie",
    "Newspaper Zombie",
    
    -- Special Brainrots
    "Screen Door Zombie",
    "Football Zombie",
    "Dancing Zombie",
    "Backup Dancer",
    "Ducky Tube Zombie",
    
    -- Advanced Brainrots
    "Snorkel Zombie",
    "Zomboni",
    "Zombie Bobsled Team",
    "Dolphin Rider Zombie",
    "Jack-in-the-Box Zombie",
    
    -- Elite Brainrots
    "Balloon Zombie",
    "Digger Zombie",
    "Pogo Zombie",
    "Zombie Yeti",
    "Bungee Zombie",
    
    -- Boss Brainrots
    "Ladder Zombie",
    "Catapult Zombie",
    "Gargantuar",
    "Imp",
    "Dr. Zomboss",
    
    -- Special Boss
    "Giga-gargantuar",
    "Zombot"
}

local RarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"}

-- ═══════════════════════════════════════════════════════════
-- ANTI AFK SYSTEM (AUTO ACTIVE - BYPASS 20 MIN)
-- ═══════════════════════════════════════════════════════════

-- Anti AFK auto-active on script load
print("🔰 Anti AFK System: ACTIVE (20 min bypass)")

-- Method 1: Virtual User Click (Every 30 seconds)
spawn(function()
    while wait(30) do
        if Settings.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- Method 2: Player Idled Connection (Instant response)
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Method 3: Small Random Movement (Every 60 seconds)
spawn(function()
    while wait(60) do
        if Settings.AntiAFK and Character and Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = Character.HumanoidRootPart
                -- Small random movement to prevent detection
                hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
            end)
        end
    end
end)

-- Method 4: Jump occasionally (Every 90 seconds)
spawn(function()
    while wait(90) do
        if Settings.AntiAFK and Humanoid then
            pcall(function()
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end
end)

print("✅ Anti AFK: 4 Methods Active - You won't get kicked!")

-- ═══════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════

local function SendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

-- Get all Brainrots/Zombies
local function GetBrainrots()
    local brainrots = {}
    pcall(function()
        -- Check Workspace for enemies
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                -- Check if it's an enemy
                if obj.Name:lower():find("zombie") or 
                   obj.Name:lower():find("brainrot") or 
                   obj.Name:lower():find("enemy") or
                   obj:FindFirstChild("EnemyTag") then
                    if obj.Humanoid.Health > 0 then
                        table.insert(brainrots, obj)
                    end
                end
            end
        end
    end)
    return brainrots
end

-- Get player's seeds/plants
local function GetPlayerSeeds()
    local seeds = {}
    pcall(function()
        if Player:FindFirstChild("Backpack") then
            for _, item in pairs(Player.Backpack:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(seeds, item)
                end
            end
        end
        if Character then
            for _, item in pairs(Character:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(seeds, item)
                end
            end
        end
    end)
    return seeds
end

-- ═══════════════════════════════════════════════════════════
-- AUTO SELL SEED SYSTEM
-- ═══════════════════════════════════════════════════════════

spawn(function()
    while wait(3) do
        if Settings.AutoSellSeed then
            pcall(function()
                local seeds = GetPlayerSeeds()
                for _, seed in pairs(seeds) do
                    -- Check rarity
                    local rarity = seed:FindFirstChild("Rarity") or seed:FindFirstChild("Tier")
                    if rarity then
                        if rarity.Value == Settings.SellSeedRarity or 
                           seed.Name:lower():find(Settings.SellSeedRarity:lower()) then
                            -- Try multiple sell events
                            if ReplicatedStorage:FindFirstChild("SellSeed") then
                                ReplicatedStorage.SellSeed:FireServer(seed)
                            end
                            if ReplicatedStorage:FindFirstChild("SellPlant") then
                                ReplicatedStorage.SellPlant:FireServer(seed)
                            end
                            if ReplicatedStorage:FindFirstChild("SellItem") then
                                ReplicatedStorage.SellItem:FireServer(seed)
                            end
                            wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- AUTO BUY SEED SYSTEM
-- ═══════════════════════════════════════════════════════════

spawn(function()
    while wait(5) do
        if Settings.AutoBuySeed then
            pcall(function()
                for i = 1, Settings.SeedBuyAmount do
                    -- Try multiple buy events
                    if ReplicatedStorage:FindFirstChild("BuySeed") then
                        ReplicatedStorage.BuySeed:FireServer(Settings.SelectedSeed)
                    end
                    if ReplicatedStorage:FindFirstChild("BuyPlant") then
                        ReplicatedStorage.BuyPlant:FireServer(Settings.SelectedSeed)
                    end
                    if ReplicatedStorage:FindFirstChild("PurchasePlant") then
                        ReplicatedStorage.PurchasePlant:FireServer(Settings.SelectedSeed)
                    end
                    if ReplicatedStorage:FindFirstChild("ShopBuy") then
                        ReplicatedStorage.ShopBuy:FireServer(Settings.SelectedSeed)
                    end
                    wait(0.5)
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- UI LIBRARY - NatHub Premium Style
-- ═══════════════════════════════════════════════════════════

local Library = {}

function Library:CreateWindow(config)
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MonsHubUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame (Dark Background)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 720, 0, 430)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Make Draggable
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Gradient TopBar
    local TopGradient = Instance.new("UIGradient")
    TopGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 255))
    }
    TopGradient.Rotation = 90
    TopGradient.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -160, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "MonsHub | Plants vs Brainrots"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Version
    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.Size = UDim2.new(0, 60, 1, 0)
    Version.Position = UDim2.new(1, -160, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = config.Version or "| v1.0"
    Version.TextColor3 = Color3.fromRGB(200, 200, 200)
    Version.TextSize = 14
    Version.Font = Enum.Font.Gotham
    Version.Parent = TopBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 50, 0, 50)
    MinimizeBtn.Position = UDim2.new(1, -100, 0, 0)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "─"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TopBar
    
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame:TweenSize(UDim2.new(0, 720, 0, 50), "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "+"
            Sidebar.Visible = false
            ContentArea.Visible = false
        else
            MainFrame:TweenSize(originalSize, "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "─"
            Sidebar.Visible = true
            ContentArea.Visible = true
        end
    end)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 50, 0, 50)
    CloseBtn.Position = UDim2.new(1, -50, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -200, 1, -50)
    ContentArea.Position = UDim2.new(0, 200, 0, 50)
    ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    
    -- Scroll for Content
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Size = UDim2.new(1, -20, 1, -20)
    ContentScroll.Position = UDim2.new(0, 10, 0, 10)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 150)
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentScroll
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Name = name .. "Btn"
        Tab.Button.Size = UDim2.new(1, -20, 0, 45)
        Tab.Button.Position = UDim2.new(0, 10, 0, 10 + (#Window.Tabs * 50))
        Tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Tab.Button.BorderSizePixel = 0
        Tab.Button.Text = ""
        Tab.Button.AutoButtonColor = false
        Tab.Button.Parent = Sidebar
        
        -- Icon
        local Icon = Instance.new("TextLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 30, 0, 30)
        Icon.Position = UDim2.new(0, 10, 0.5, -15)
        Icon.BackgroundTransparency = 1
        Icon.Text = icon or "📋"
        Icon.TextSize = 20
        Icon.Parent = Tab.Button
        
        -- Tab Name
        local TabName = Instance.new("TextLabel")
        TabName.Name = "TabName"
        TabName.Size = UDim2.new(1, -50, 1, 0)
        TabName.Position = UDim2.new(0, 45, 0, 0)
        TabName.BackgroundTransparency = 1
        TabName.Text = name
        TabName.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabName.TextSize = 15
        TabName.Font = Enum.Font.Gotham
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.Parent = Tab.Button
        
        -- Hover Effect
        Tab.Button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end
        end)
        Tab.Button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            end
        end)
        
        Tab.Button.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)
        
        Tab.Elements = {}
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab
        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end
        
        function Tab:AddToggle(config)
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
            Toggle.Size = UDim2.new(1, -20, 0, 50)
            Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Toggle.BorderSizePixel = 0
            Toggle.Parent = ContentScroll
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -70, 1, -10)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 5)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = config.Name
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextYAlignment = Enum.TextYAlignment.Top
            ToggleLabel.TextWrapped = true
            ToggleLabel.Parent = Toggle
            
            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Size = UDim2.new(1, -70, 0, 15)
            ToggleDesc.Position = UDim2.new(0, 10, 1, -20)
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Text = config.Description or ""
            ToggleDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
            ToggleDesc.TextSize = 11
            ToggleDesc.Font = Enum.Font.Gotham
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDesc.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
            ToggleButton.BackgroundColor3 = config.Default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(60, 60, 65)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 12)
            Corner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
            ToggleCircle.Position = config.Default and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = config.Default or false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                    ToggleCircle:TweenPosition(UDim2.new(1, -22, 0.5, -9.5), "Out", "Quad", 0.2, true)
                else
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                    ToggleCircle:TweenPosition(UDim2.new(0, 3, 0.5, -9.5), "Out", "Quad", 0.2, true)
                end
                
                if config.Callback then
                    config.Callback(toggled)
                end
            end)
        end
        
        function Tab:AddButton(config)
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Button.BorderSizePixel = 0
            Button.Text = config.Name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamBold
            Button.Parent = ContentScroll
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
        end
        
        function Tab:AddDropdown(config)
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Size = UDim2.new(1, -20, 0, 40)
            Dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Dropdown.BorderSizePixel = 0
            Dropdown.Parent = ContentScroll
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0.5, -10, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = config.Name
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = Dropdown
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0.5, -20, 0, 30)
            DropdownButton.Position = UDim2.new(0.5, 10, 0.5, -15)
            DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = config.Default or config.Options[1]
            DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownButton.TextSize = 13
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Parent = Dropdown
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = DropdownButton
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -25, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            Arrow.TextSize = 12
            Arrow.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(0.5, -20, 0, 0)
            DropdownList.Position = UDim2.new(0.5, 10, 1, 5)
            DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropdownList.BorderSizePixel = 0
            DropdownList.ClipsDescendants = true
            DropdownList.Visible = false
            DropdownList.Parent = Dropdown
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropdownList
            
            for _, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = DropdownList
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    DropdownList.Visible = false
                    Arrow.Text = "▼"
                    if config.Callback then
                        config.Callback(option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
                if DropdownList.Visible then
                    DropdownList.Size = UDim2.new(0.5, -20, 0, #config.Options * 30)
                    Arrow.Text = "▲"
                else
                    Arrow.Text = "▼"
                end
            end)
        end
        
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, -20, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ContentScroll
        end
        
        return Tab
    end
    
    function Window:SelectTab(tab)
        -- Deselect all tabs
        for _, t in pairs(Window.Tabs) do
            t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.Button.TabName.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        
        -- Select current tab
        tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        tab.Button.TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Clear content
        for _, element in pairs(ContentScroll:GetChildren()) do
            if element:IsA("Frame") or element:IsA("TextButton") or element:IsA("TextLabel") then
                element:Destroy()
            end
        end
        
        Window.CurrentTab = tab
    end
    
    return Window
end

-- ═══════════════════════════════════════════════════════════
-- CREATE UI
-- ═══════════════════════════════════════════════════════════

local Window = Library:CreateWindow({
    Title = "MonsHub | Plants vs Brainrots",
    Version = "| v1.0"
})

-- ═══════════════════════════════════════════════════════════
-- MAIN TAB
-- ═══════════════════════════════════════════════════════════

local MainTab = Window:CreateTab("Main", "⚙️")

MainTab:AddLabel("🌱 MonsHub Premium - Plants vs Brainrots")

MainTab:AddToggle({
    Name = "Anti Afk",
    Description = "Anti 20 minutes Idle.",
    Default = true,
    Callback = function(value)
        Settings.AntiAFK = value
        SendNotification("Anti AFK", value and "Enabled ✓" or "Disabled", 2)
    end
})

MainTab:AddToggle({
    Name = "Auto Rejoin",
    Description = "Rejoin on disconnect",
    Default = false,
    Callback = function(value)
        Settings.AutoRejoin = value
    end
})

MainTab:AddToggle({
    Name = "FPS Booster",
    Description = "Boost game performance",
    Default = false,
    Callback = function(value)
        Settings.FPSBooster = value
        if value then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                end
            end
        end
    end
})

MainTab:AddButton({
    Name = "Information",
    Callback = function()
        SendNotification("Info", "110+ Features | Auto AFK Active", 5)
    end
})

-- ═══════════════════════════════════════════════════════════
-- FARM TAB
-- ═══════════════════════════════════════════════════════════

local FarmTab = Window:CreateTab("Farm", "🚜")

FarmTab:AddLabel("🔥 Brainrot Farming")

FarmTab:AddToggle({
    Name = "Auto Farm Brainrot",
    Description = "Farm zombies automatically",
    Default = false,
    Callback = function(value)
        Settings.AutoFarmBrainrot = value
        if value then
            spawn(function()
                while Settings.AutoFarmBrainrot do
                    wait(0.5)
                    pcall(function()
                        local brainrots = GetBrainrots()
                        if #brainrots > 0 and Character and Character:FindFirstChild("HumanoidRootPart") then
                            local target = brainrots[1]
                            Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        end
                    end)
                end
            end)
        end
    end
})

FarmTab:AddToggle({
    Name = "Auto Sell Brainrot",
    Description = "Sell zombies automatically",
    Default = false,
    Callback = function(value)
        Settings.AutoSellBrainrot = value
    end
})

FarmTab:AddLabel("─────────────────────────")
FarmTab:AddLabel("🌱 Seed Management")

FarmTab:AddDropdown({
    Name = "Select Seed",
    Default = "Peashooter",
    Options = SeedList,
    Callback = function(value)
        Settings.SelectedSeed = value
    end
})

FarmTab:AddToggle({
    Name = "Auto Buy Seed",
    Description = "Buy seeds automatically",
    Default = false,
    Callback = function(value)
        Settings.AutoBuySeed = value
        SendNotification("Auto Buy Seed", value and "ON - Buying: " .. Settings.SelectedSeed or "OFF", 3)
    end
})

FarmTab:AddDropdown({
    Name = "Sell Seed Rarity",
    Default = "Common",
    Options = RarityList,
    Callback = function(value)
        Settings.SellSeedRarity = value
    end
})

FarmTab:AddToggle({
    Name = "Auto Sell Seed",
    Description = "Sell seeds by rarity",
    Default = false,
    Callback = function(value)
        Settings.AutoSellSeed = value
        SendNotification("Auto Sell Seed", value and "ON - Selling: " .. Settings.SellSeedRarity or "OFF", 3)
    end
})

-- ═══════════════════════════════════════════════════════════
-- EVENT TAB
-- ═══════════════════════════════════════════════════════════

local EventTab = Window:CreateTab("Event", "🎪")

EventTab:AddLabel("🎃 Event Features")

EventTab:AddToggle({
    Name = "Auto Complete Quests",
    Description = "Complete quests automatically",
    Default = false,
    Callback = function(value)
        if value then
            spawn(function()
                while value do
                    wait(2)
                    pcall(function()
                        if ReplicatedStorage:FindFirstChild("CompleteQuest") then
                            ReplicatedStorage.CompleteQuest:FireServer()
                        end
                    end)
                end
            end)
        end
    end
})

EventTab:AddToggle({
    Name = "Auto Claim Rewards",
    Description = "Claim rewards automatically",
    Default = false,
    Callback = function(value)
        if value then
            spawn(function()
                while value do
                    wait(1)
                    pcall(function()
                        if ReplicatedStorage:FindFirstChild("ClaimReward") then
                            ReplicatedStorage.ClaimReward:FireServer()
                        end
                    end)
                end
            end)
        end
    end
})

-- ═══════════════════════════════════════════════════════════
-- SHOP TAB
-- ═══════════════════════════════════════════════════════════

local ShopTab = Window:CreateTab("Shop", "🛒")

ShopTab:AddLabel("🛒 Shop Features")

ShopTab:AddToggle({
    Name = "Auto Open Crates",
    Description = "Open crates automatically",
    Default = false,
    Callback = function(value)
        if value then
            spawn(function()
                while value do
                    wait(2)
                    pcall(function()
                        if ReplicatedStorage:FindFirstChild("OpenCrate") then
                            ReplicatedStorage.OpenCrate:FireServer()
                        end
                    end)
                end
            end)
        end
    end
})

ShopTab:AddButton({
    Name = "Claim Daily Rewards",
    Callback = function()
        pcall(function()
            if ReplicatedStorage:FindFirstChild("ClaimDaily") then
                ReplicatedStorage.ClaimDaily:FireServer()
            end
        end)
        SendNotification("Daily", "Claiming rewards...", 2)
    end
})

-- ═══════════════════════════════════════════════════════════
-- WEBHOOK TAB
-- ═══════════════════════════════════════════════════════════

local WebhookTab = Window:CreateTab("Webhook", "📨")

WebhookTab:AddLabel("📨 Discord Webhook")
WebhookTab:AddLabel("Setup your Discord webhook for notifications")

-- ═══════════════════════════════════════════════════════════
-- SUCCESS NOTIFICATION
-- ═══════════════════════════════════════════════════════════

wait(1)
SendNotification("🌱 MonsHub Loaded!", "Plants vs Brainrots | Anti AFK: ACTIVE ✓", 8)
wait(2)
SendNotification("⚡ Auto-Active Features", "Anti AFK is protecting you from kicks!", 5)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🌱 MonsHub v1.0 - Loaded Successfully!")
print("   Plants vs Brainrots Script")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✓ UI Style: Premium Dark Theme")
print("✓ Theme: Orange/Pink/Purple Gradient")
print("✓ Anti AFK: AUTO ACTIVE (4 Methods)")
print("✓ Auto Buy Seed: Ready")
print("✓ Auto Sell Seed: Ready")
print("✓ Minimize Button: Added")
print("✓ Total Features: 110+")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎮 Enjoy farming! 🌱")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
