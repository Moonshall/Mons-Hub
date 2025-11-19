--[[
    MonsHub Script for Plants vs Brainrots
    Game: Plants vs Brainrots by Yo Gurt Studios
    Created: 2025
    Features: Auto Farm Brainrot, Auto Move Plant, Auto Gear, Event Support, and more
]]--

-- Load WindUI from GitHub
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moonshall/Mons-Hub/main/WindUI-main/src/Init.lua"))()

local Window = WindUI:CreateWindow({
    Title = "MonsHub | Plants vs Brainrots",
    Icon = "rbxassetid://10723415903",
    Author = "MonsHub Team",
    Folder = "MonsHubPvBR",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = false,
    KeySettings = {
        Key = "MonsHub2025",
        Note = "Join our Discord for the key!",
        SaveKey = true,
        FileName = "MonsHubKey"
    }
})

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    -- Main Tab
    AntiAFK = false,
    
    -- Farm Tab - Brainrot Section
    AutoFarmBrainrot = false,
    AutoEquipBestDelay = 2,
    AutoEquipBestBrainrot = false,
    
    -- Farm Tab - Plant Section
    AutoMovePlant = false,
    SelectedBrainrotRarity = "Common",
    SelectedPlant = "Peashooter",
    
    -- Farm Tab - Gear Section
    SelectedGear = "Granat",
    SelectedGearRarity = "Common",
    AutoGearDelay = 3,
    AutoUseGear = false,
    
    -- Event Tab
    AutoPlaceRequiredBrainrot = false,
    SelectedHalloweenItem = "Pumpkin",
    AutoBuyHalloweenItem = false,
    
    -- Shop Tab
    AutoSpin = false,
    AutoOpenCrate = false,
    AutoMerge = false,
    SelectedCrate = "Basic Crate",
    
    -- Webhook Tab
    WebhookURL = "",
    WebhookEnabled = false,
    NotifyGoodDrop = false,
    NotifyRareBrainrot = false,
    
    -- Other Settings
    InfiniteJump = false,
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false,
    ESPBrainrots = false,
    ESPPlants = false
}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Rarity List
local BrainrotRarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"}
local PlantList = {"Peashooter", "Sunflower", "CherryBomb", "WallNut", "PotatoMine", "SnowPea", "Chomper", "Repeater", "PuffShroom", "SunShroom"}
local GearList = {"Granat", "Shovel", "Fertilizer", "PlantFood", "IceBlock", "Cherry", "Garlic"}
local HalloweenItems = {"Pumpkin", "Candy", "Ghost", "Witch Hat", "Spider Web"}
local CrateList = {"Basic Crate", "Silver Crate", "Gold Crate", "Diamond Crate", "Mythic Crate"}

-- Anti-AFK System
spawn(function()
    while wait(60) do
        if Settings.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

Player.Idled:connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Functions
local function GetBrainrots(specificRarity)
    local brainrots = {}
    for _, folder in pairs(Workspace:GetChildren()) do
        if folder.Name:find("Brainrot") or folder.Name:find("Enemy") or folder.Name:find("Mob") or folder.Name == "Enemies" then
            for _, enemy in pairs(folder:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    if specificRarity then
                        -- Check rarity
                        local rarity = enemy:FindFirstChild("Rarity") or enemy:FindFirstChild("RarityValue")
                        if rarity and rarity.Value == specificRarity then
                            table.insert(brainrots, enemy)
                        elseif enemy.Name:find(specificRarity) then
                            table.insert(brainrots, enemy)
                        end
                    else
                        table.insert(brainrots, enemy)
                    end
                end
            end
        end
    end
    -- Cari di Workspace langsung
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj.Name:find("Brainrot") then
            if obj.Humanoid.Health > 0 then
                if specificRarity then
                    local rarity = obj:FindFirstChild("Rarity") or obj:FindFirstChild("RarityValue")
                    if rarity and rarity.Value == specificRarity then
                        table.insert(brainrots, obj)
                    elseif obj.Name:find(specificRarity) then
                        table.insert(brainrots, obj)
                    end
                else
                    table.insert(brainrots, obj)
                end
            end
        end
    end
    return brainrots
end

local function GetBrainrotRarity(brainrot)
    if brainrot:FindFirstChild("Rarity") then
        return brainrot.Rarity.Value
    elseif brainrot:FindFirstChild("RarityValue") then
        return brainrot.RarityValue.Value
    end
    
    -- Check by name
    for _, rarity in pairs(BrainrotRarities) do
        if brainrot.Name:find(rarity) then
            return rarity
        end
    end
    
    return "Common"
end

local function GetDrops()
    local drops = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Coin") or obj.Name:find("Money") or obj.Name:find("Drop") or obj.Name:find("Reward") then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(drops, obj)
            end
        end
    end
    return drops
end

local function GetPlants()
    local plants = {}
    if Workspace:FindFirstChild("Plants") then
        for _, plant in pairs(Workspace.Plants:GetChildren()) do
            table.insert(plants, plant)
        end
    end
    -- Cari di player's plot/garden
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Plant") and (obj:IsA("Model") or obj:IsA("Part")) then
            table.insert(plants, obj)
        end
    end
    return plants
end

local function TeleportTo(position)
    if HumanoidRootPart and typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function AttackBrainrot(brainrot)
    if brainrot and brainrot:FindFirstChild("Humanoid") and brainrot.Humanoid.Health > 0 then
        pcall(function()
            -- Coba berbagai remote event yang mungkin
            if ReplicatedStorage:FindFirstChild("Attack") then
                ReplicatedStorage.Attack:FireServer(brainrot)
            end
            if ReplicatedStorage:FindFirstChild("DamageEnemy") then
                ReplicatedStorage.DamageEnemy:FireServer(brainrot, 999999)
            end
            if ReplicatedStorage:FindFirstChild("Combat") then
                ReplicatedStorage.Combat:FireServer(brainrot)
            end
            if ReplicatedStorage:FindFirstChild("Hit") then
                ReplicatedStorage.Hit:FireServer(brainrot)
            end
            -- Damage langsung (jika bisa)
            if Settings.InstantKill then
                brainrot.Humanoid.Health = 0
            end
        end)
    end
end

local function BuySeed(seedName)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("BuySeed") then
            ReplicatedStorage.BuySeed:FireServer(seedName)
        end
        if ReplicatedStorage:FindFirstChild("PurchaseSeed") then
            ReplicatedStorage.PurchaseSeed:FireServer(seedName)
        end
        if ReplicatedStorage:FindFirstChild("Shop") then
            ReplicatedStorage.Shop:FireServer("BuySeed", seedName)
        end
    end)
end

local function PlacePlant(position, seedName)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("PlacePlant") then
            ReplicatedStorage.PlacePlant:FireServer(position, seedName)
        end
        if ReplicatedStorage:FindFirstChild("PlantSeed") then
            ReplicatedStorage.PlantSeed:FireServer(seedName, position)
        end
    end)
end

local function UpgradePlant(plant)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("UpgradePlant") then
            ReplicatedStorage.UpgradePlant:FireServer(plant)
        end
        if ReplicatedStorage:FindFirstChild("Upgrade") then
            ReplicatedStorage.Upgrade:FireServer(plant)
        end
        if plant:FindFirstChild("Upgrade") then
            plant.Upgrade:FireServer()
        end
    end)
end

local function EquipBestBrainrot()
    pcall(function()
        local bestBrainrot = nil
        local bestPower = 0
        
        -- Cek inventory player
        if Player:FindFirstChild("Backpack") then
            for _, item in pairs(Player.Backpack:GetChildren()) do
                if item:FindFirstChild("Power") or item:FindFirstChild("Damage") then
                    local power = item.Power and item.Power.Value or item.Damage.Value
                    if power > bestPower then
                        bestPower = power
                        bestBrainrot = item
                    end
                end
            end
        end
        
        if bestBrainrot then
            if ReplicatedStorage:FindFirstChild("EquipBrainrot") then
                ReplicatedStorage.EquipBrainrot:FireServer(bestBrainrot)
            end
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid:EquipTool(bestBrainrot)
            end
        end
    end)
end

local function MovePlantToRow(plantName, row)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("MovePlant") then
            ReplicatedStorage.MovePlant:FireServer(plantName, row)
        end
        if ReplicatedStorage:FindFirstChild("PlaceAt") then
            ReplicatedStorage.PlaceAt:FireServer(plantName, row)
        end
    end)
end

local function GetBrainrotRow(brainrot)
    if brainrot:FindFirstChild("Row") then
        return brainrot.Row.Value
    end
    if brainrot:FindFirstChild("Lane") then
        return brainrot.Lane.Value
    end
    -- Detect by position
    local pos = brainrot:FindFirstChild("HumanoidRootPart")
    if pos then
        local z = pos.Position.Z
        return math.floor((z + 50) / 10) -- Adjust based on game layout
    end
    return 1
end

local function StartInvasion()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("StartInvasion") then
            ReplicatedStorage.StartInvasion:FireServer()
        end
        if ReplicatedStorage:FindFirstChild("StartWave") then
            ReplicatedStorage.StartWave:FireServer()
        end
        if ReplicatedStorage:FindFirstChild("StartBattle") then
            ReplicatedStorage.StartBattle:FireServer()
        end
        if ReplicatedStorage:FindFirstChild("BeginWave") then
            ReplicatedStorage.BeginWave:FireServer()
        end
    end)
end

local function UseGear(gearName, target)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("UseGear") then
            ReplicatedStorage.UseGear:FireServer(gearName, target)
        end
        if ReplicatedStorage:FindFirstChild("ActivateGear") then
            ReplicatedStorage.ActivateGear:FireServer(gearName, target)
        end
        if ReplicatedStorage:FindFirstChild("UseItem") then
            ReplicatedStorage.UseItem:FireServer(gearName, target)
        end
    end)
end

local function BuyHalloweenItem(itemName)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("BuyEventItem") then
            ReplicatedStorage.BuyEventItem:FireServer(itemName)
        end
        if ReplicatedStorage:FindFirstChild("PurchaseHalloween") then
            ReplicatedStorage.PurchaseHalloween:FireServer(itemName)
        end
    end)
end

local function SendWebhook(title, description, color)
    if not Settings.WebhookEnabled or Settings.WebhookURL == "" then
        return
    end
    
    local data = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color or 65280,
            ["footer"] = {
                ["text"] = "MonsHub | Plants vs Brainrots"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    
    pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        request({
            Url = Settings.WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

local function GetPlayerMoney()
    local money = 0
    pcall(function()
        if Player:FindFirstChild("leaderstats") then
            if Player.leaderstats:FindFirstChild("Money") then
                money = Player.leaderstats.Money.Value
            elseif Player.leaderstats:FindFirstChild("Cash") then
                money = Player.leaderstats.Cash.Value
            elseif Player.leaderstats:FindFirstChild("Coins") then
                money = Player.leaderstats.Coins.Value
            end
        end
    end)
    return money
end

-- Auto Farm Brainrot
spawn(function()
    while wait(0.5) do
        if Settings.AutoFarmBrainrot then
            pcall(function()
                local brainrots = GetBrainrots()
                if #brainrots > 0 then
                    for _, brainrot in pairs(brainrots) do
                        if brainrot and brainrot:FindFirstChild("HumanoidRootPart") then
                            AttackBrainrot(brainrot)
                            
                            -- Check for good drops
                            if Settings.NotifyGoodDrop then
                                local rarity = GetBrainrotRarity(brainrot)
                                if rarity == "Legendary" or rarity == "Mythic" then
                                    SendWebhook(
                                        "🎯 Rare Brainrot Found!",
                                        "Found: " .. brainrot.Name .. "\nRarity: " .. rarity,
                                        15844367
                                    )
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Equip Best Brainrot
spawn(function()
    while wait(Settings.AutoEquipBestDelay or 2) do
        if Settings.AutoEquipBestBrainrot then
            pcall(function()
                EquipBestBrainrot()
            end)
        end
    end
end)

-- Auto Move Plant
spawn(function()
    while wait(1) do
        if Settings.AutoMovePlant and Settings.SelectedPlant then
            pcall(function()
                local brainrots = GetBrainrots(Settings.SelectedBrainrotRarity)
                if #brainrots > 0 then
                    for _, brainrot in pairs(brainrots) do
                        local row = GetBrainrotRow(brainrot)
                        MovePlantToRow(Settings.SelectedPlant, row)
                        wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- Auto Use Gear
spawn(function()
    while wait(Settings.AutoGearDelay or 3) do
        if Settings.AutoUseGear and Settings.SelectedGear then
            pcall(function()
                local brainrots = GetBrainrots(Settings.SelectedGearRarity)
                if #brainrots > 0 then
                    local target = brainrots[1]
                    UseGear(Settings.SelectedGear, target)
                end
            end)
        end
    end
end)

-- Auto Collect Drops (Money/Coins)
spawn(function()
    while wait(0.2) do
        if Settings.AutoCollectDrops then
            pcall(function()
                local drops = GetDrops()
                for _, drop in pairs(drops) do
                    if drop and drop:IsA("BasePart") then
                        -- Teleport ke drop
                        TeleportTo(drop.Position)
                        wait(0.1)
                        -- Coba collect via touch atau fireserver
                        if drop:FindFirstChild("Touched") then
                            firetouchinterest(HumanoidRootPart, drop, 0)
                            wait(0.05)
                            firetouchinterest(HumanoidRootPart, drop, 1)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Start Invasion
spawn(function()
    while wait(2) do
        if Settings.AutoStartInvasion then
            pcall(function()
                StartInvasion()
            end)
        end
    end
end)

-- Auto Upgrade Plants
spawn(function()
    while wait(3) do
        if Settings.AutoUpgradePlants then
            pcall(function()
                local plants = GetPlants()
                for _, plant in pairs(plants) do
                    UpgradePlant(plant)
                    wait(0.2)
                end
            end)
        end
    end
end)

-- Auto Buy Seeds
spawn(function()
    while wait(5) do
        if Settings.AutoBuySeeds and Settings.SelectedSeed then
            pcall(function()
                BuySeed(Settings.SelectedSeed)
            end)
        end
    end
end)

-- Auto Buy Halloween Item
spawn(function()
    while wait(2) do
        if Settings.AutoBuyHalloweenItem and Settings.SelectedHalloweenItem then
            pcall(function()
                BuyHalloweenItem(Settings.SelectedHalloweenItem)
            end)
        end
    end
end)

-- Auto Place Required Brainrot (Event)
spawn(function()
    while wait(3) do
        if Settings.AutoPlaceRequiredBrainrot then
            pcall(function()
                if ReplicatedStorage:FindFirstChild("PlaceRequiredBrainrot") then
                    ReplicatedStorage.PlaceRequiredBrainrot:FireServer()
                end
                if ReplicatedStorage:FindFirstChild("AutoCardEvent") then
                    ReplicatedStorage.AutoCardEvent:FireServer()
                end
            end)
        end
    end
end)

-- Infinite Money Loop
spawn(function()
    while wait(1) do
        if Settings.InfiniteMoney then
            pcall(function()
                -- Coba manipulasi money via remote
                if ReplicatedStorage:FindFirstChild("AddMoney") then
                    ReplicatedStorage.AddMoney:FireServer(999999)
                end
                if ReplicatedStorage:FindFirstChild("GiveMoney") then
                    ReplicatedStorage.GiveMoney:FireServer(999999)
                end
                if ReplicatedStorage:FindFirstChild("UpdateMoney") then
                    ReplicatedStorage.UpdateMoney:FireServer(999999)
                end
            end)
        end
    end
end)

-- NoClip
spawn(function()
    while wait() do
        if Settings.NoClip then
            pcall(function()
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- ESP System
local function CreateESP(target, name, color)
    if not target:FindFirstChild("ESP_Highlight") then
        pcall(function()
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = color or Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = target
            
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESP_Billboard"
            billboardGui.Size = UDim2.new(0, 150, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = target
            
            if target:FindFirstChild("HumanoidRootPart") then
                billboardGui.Adornee = target.HumanoidRootPart
            elseif target:FindFirstChild("Head") then
                billboardGui.Adornee = target.Head
            else
                billboardGui.Adornee = target:FindFirstChildWhichIsA("Part")
            end
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = name
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Parent = billboardGui
            
            -- Distance label
            if target:FindFirstChild("HumanoidRootPart") then
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextScaled = true
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.Parent = billboardGui
                
                spawn(function()
                    while distanceLabel and distanceLabel.Parent do
                        if target and target:FindFirstChild("HumanoidRootPart") and HumanoidRootPart then
                            local distance = (target.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                            distanceLabel.Text = string.format("%.1f studs", distance)
                        end
                        wait(0.5)
                    end
                end)
            end
        end)
    end
end

local function RemoveESP(target)
    pcall(function()
        if target:FindFirstChild("ESP_Highlight") then
            target.ESP_Highlight:Destroy()
        end
        if target:FindFirstChild("ESP_Billboard") then
            target.ESP_Billboard:Destroy()
        end
    end)
end

-- ESP for Brainrots
spawn(function()
    while wait(1) do
        if Settings.ESPBrainrots then
            pcall(function()
                local brainrots = GetBrainrots()
                for _, brainrot in pairs(brainrots) do
                    CreateESP(brainrot, "Brainrot", Color3.fromRGB(255, 0, 0))
                end
            end)
        else
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                        obj:Destroy()
                    end
                end
            end)
        end
    end
end)

-- ESP for Plants
spawn(function()
    while wait(2) do
        if Settings.ESPPlants then
            pcall(function()
                local plants = GetPlants()
                for _, plant in pairs(plants) do
                    CreateESP(plant, "Plant", Color3.fromRGB(0, 255, 0))
                end
            end)
        end
    end
end)

-- ESP for Drops
spawn(function()
    while wait(1.5) do
        if Settings.ESPDrops then
            pcall(function()
                local drops = GetDrops()
                for _, drop in pairs(drops) do
                    CreateESP(drop, "Drop", Color3.fromRGB(255, 255, 0))
                end
            end)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- GUI Tabs
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "home",
    Color = Color3.fromRGB(255, 255, 255)
})

local FarmTab = Window:Tab({
    Name = "Farm",
    Icon = "zap",
    Color = Color3.fromRGB(255, 170, 0)
})

local EventTab = Window:Tab({
    Name = "Event",
    Icon = "calendar",
    Color = Color3.fromRGB(255, 100, 255)
})

local ShopTab = Window:Tab({
    Name = "Shop",
    Icon = "shopping-cart",
    Color = Color3.fromRGB(100, 200, 255)
})

local WebhookTab = Window:Tab({
    Name = "Webhook",
    Icon = "send",
    Color = Color3.fromRGB(88, 101, 242)
})

local PlayerTab = Window:Tab({
    Name = "Player",
    Icon = "user",
    Color = Color3.fromRGB(100, 255, 100)
})

local MiscTab = Window:Tab({
    Name = "Misc",
    Icon = "settings",
    Color = Color3.fromRGB(150, 150, 150)
})

-- ═══════════════════════════════════════
-- TAB MAIN
-- ═══════════════════════════════════════

local MainSection = MainTab:Section({
    Name = "Main Features"
})

MainSection:Label({
    Text = "🌱 MonsHub - Plants vs Brainrots",
    Color = Color3.fromRGB(0, 255, 150)
})

MainSection:Toggle({
    Name = "Anti AFK (20 Minutes)",
    Default = false,
    Callback = function(Value)
        Settings.AntiAFK = Value
        Window:Notify({
            Title = "Anti AFK",
            Description = "Anti AFK has been " .. (Value and "enabled" or "disabled"),
            Duration = 3
        })
    end
})

MainSection:Label({
    Text = "Menjaga akun tidak auto-disconnect saat idle",
    Color = Color3.fromRGB(150, 150, 150)
})

-- ═══════════════════════════════════════
-- TAB FARM
-- ═══════════════════════════════════════

-- Section: Brainrot
local BrainrotSection = FarmTab:Section({
    Name = "🔥 Brainrot Section"
})

BrainrotSection:Toggle({
    Name = "Auto Farm Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarmBrainrot = Value
        Window:Notify({
            Title = "Auto Farm Brainrot",
            Description = "Otomatis farming Brainrot: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

BrainrotSection:Slider({
    Name = "Auto Equip Best Delay",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(Value)
        Settings.AutoEquipBestDelay = Value
    end
})

BrainrotSection:Toggle({
    Name = "Auto Equip Best Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoEquipBestBrainrot = Value
        Window:Notify({
            Title = "Auto Equip",
            Description = "Auto equip best Brainrot: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

-- Section: Plant
local PlantSection = FarmTab:Section({
    Name = "🌱 Plant Section"
})

PlantSection:Label({
    Text = "Auto Move",
    Color = Color3.fromRGB(150, 255, 150)
})

PlantSection:Dropdown({
    Name = "Select Brainrot Rarity",
    Options = BrainrotRarities,
    Default = "Common",
    Callback = function(Value)
        Settings.SelectedBrainrotRarity = Value
    end
})

PlantSection:Dropdown({
    Name = "Select Plant",
    Options = PlantList,
    Default = "Peashooter",
    Callback = function(Value)
        Settings.SelectedPlant = Value
    end
})

PlantSection:Toggle({
    Name = "Auto Move Plant",
    Default = false,
    Callback = function(Value)
        Settings.AutoMovePlant = Value
        Window:Notify({
            Title = "Auto Move Plant",
            Description = "Otomatis pindah tanaman ke row Brainrot: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

-- Section: Gear
local GearSection = FarmTab:Section({
    Name = "🛠 Gear Section"
})

GearSection:Dropdown({
    Name = "Select Gear To Use",
    Options = GearList,
    Default = "Granat",
    Callback = function(Value)
        Settings.SelectedGear = Value
    end
})

GearSection:Dropdown({
    Name = "Select Brainrot Rarity",
    Options = BrainrotRarities,
    Default = "Common",
    Callback = function(Value)
        Settings.SelectedGearRarity = Value
    end
})

GearSection:Slider({
    Name = "Auto Gear Delay",
    Min = 1,
    Max = 10,
    Default = 3,
    Callback = function(Value)
        Settings.AutoGearDelay = Value
    end
})

GearSection:Toggle({
    Name = "Auto Use Gear",
    Default = false,
    Callback = function(Value)
        Settings.AutoUseGear = Value
        Window:Notify({
            Title = "Auto Use Gear",
            Description = "Otomatis pakai gear: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

-- ═══════════════════════════════════════
-- TAB EVENT
-- ═══════════════════════════════════════

-- Section: Card Event
local CardSection = EventTab:Section({
    Name = "📇 Card Event"
})

CardSection:Toggle({
    Name = "Auto Place Required Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoPlaceRequiredBrainrot = Value
        Window:Notify({
            Title = "Card Event",
            Description = "Auto place Brainrot: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

CardSection:Label({
    Text = "Menaruh Brainrot yang diperlukan untuk event Card",
    Color = Color3.fromRGB(150, 150, 150)
})

-- Section: Halloween Event
local HalloweenSection = EventTab:Section({
    Name = "🎃 Halloween Event"
})

HalloweenSection:Dropdown({
    Name = "Select Item To Buy",
    Options = HalloweenItems,
    Default = "Pumpkin",
    Callback = function(Value)
        Settings.SelectedHalloweenItem = Value
    end
})

HalloweenSection:Toggle({
    Name = "Auto Buy Item",
    Default = false,
    Callback = function(Value)
        Settings.AutoBuyHalloweenItem = Value
        Window:Notify({
            Title = "Halloween Event",
            Description = "Auto buy item: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

-- Farm Tab (Keep for compatibility)
FarmTab:AddToggle({
    Name = "Auto Farm Money",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarmMoney = Value
        Settings.AutoFarmBrainrot = Value
        Settings.AutoCollectDrops = Value
        Window:Notify({
            Title = "Auto Farm",
            Description = "Auto Farm Money has been " .. (Value and "enabled" or "disabled"),
            Duration = 3
        })
    end    
})

-- ═══════════════════════════════════════
-- TAB SHOP
-- ═══════════════════════════════════════

local ShopSection = ShopTab:Section({
    Name = "🛒 Shop Features"
})

ShopSection:Toggle({
    Name = "Auto Spin",
    Default = false,
    Callback = function(Value)
        Settings.AutoSpin = Value
        spawn(function()
            while Settings.AutoSpin do
                wait(1)
                pcall(function()
                    if ReplicatedStorage:FindFirstChild("Spin") then
                        ReplicatedStorage.Spin:FireServer()
                    end
                end)
            end
        end)
        Window:Notify({
            Title = "Auto Spin",
            Description = "Auto spin: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

ShopSection:Dropdown({
    Name = "Select Crate",
    Options = CrateList,
    Default = "Basic Crate",
    Callback = function(Value)
        Settings.SelectedCrate = Value
    end
})

ShopSection:Toggle({
    Name = "Auto Open Crate",
    Default = false,
    Callback = function(Value)
        Settings.AutoOpenCrate = Value
        spawn(function()
            while Settings.AutoOpenCrate do
                wait(2)
                pcall(function()
                    if ReplicatedStorage:FindFirstChild("OpenCrate") then
                        ReplicatedStorage.OpenCrate:FireServer(Settings.SelectedCrate)
                    end
                end)
            end
        end)
        Window:Notify({
            Title = "Auto Open Crate",
            Description = "Auto open crate: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

ShopSection:Toggle({
    Name = "Auto Merge Items",
    Default = false,
    Callback = function(Value)
        Settings.AutoMerge = Value
        spawn(function()
            while Settings.AutoMerge do
                wait(3)
                pcall(function()
                    if ReplicatedStorage:FindFirstChild("MergeItems") then
                        ReplicatedStorage.MergeItems:FireServer()
                    end
                    if ReplicatedStorage:FindFirstChild("AutoMerge") then
                        ReplicatedStorage.AutoMerge:FireServer()
                    end
                end)
            end
        end)
        Window:Notify({
            Title = "Auto Merge",
            Description = "Auto merge items: " .. (Value and "ON" or "OFF"),
            Duration = 3
        })
    end
})

FarmTab:AddToggle({
    Name = "Auto Collect Drops/Money",
    Default = false,
    Callback = function(Value)
        Settings.AutoCollectDrops = Value
        Window:Notify({
            Title = "Auto Collect",
            Description = "Auto Collect Drops has been " .. (Value and "enabled" or "disabled"),
            Duration = 3
        })
    end    
})

-- ═══════════════════════════════════════
-- TAB WEBHOOK
-- ═══════════════════════════════════════

local WebhookSection = WebhookTab:Section({
    Name = "📨 Discord Webhook"
})

WebhookSection:Input({
    Name = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(Value)
        Settings.WebhookURL = Value
        Window:Notify({
            Title = "Webhook",
            Description = "Webhook URL has been set!",
            Duration = 3
        })
    end
})

WebhookSection:Toggle({
    Name = "Enable Webhook",
    Default = false,
    Callback = function(Value)
        Settings.WebhookEnabled = Value
        Window:Notify({
            Title = "Webhook",
            Description = "Webhook: " .. (Value and "Enabled" or "Disabled"),
            Duration = 3
        })
    end
})

WebhookSection:Toggle({
    Name = "Notify Good Drop",
    Default = false,
    Callback = function(Value)
        Settings.NotifyGoodDrop = Value
    end
})

WebhookSection:Toggle({
    Name = "Notify Rare Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.NotifyRareBrainrot = Value
    end
})

WebhookSection:Button({
    Name = "Test Webhook",
    Callback = function()
        SendWebhook(
            "🧪 Test Webhook",
            "MonsHub webhook is working!\nGame: Plants vs Brainrots",
            3447003
        )
        Window:Notify({
            Title = "Webhook Test",
            Description = "Test message sent to Discord!",
            Duration = 3
        })
    end
})

WebhookSection:Label({
    Text = "Kirim notifikasi ke Discord untuk drop bagus & rare Brainrot",
    Color = Color3.fromRGB(150, 150, 150)
})

FarmTab:AddToggle({
    Name = "Auto Start Invasion/Wave",
    Default = false,
    Callback = function(Value)
        Settings.AutoStartInvasion = Value
        Window:Notify({
            Title = "Auto Invasion",
            Description = "Auto Start Invasion has been " .. (Value and "enabled" or "disabled"),
            Duration = 3
        })
    end    
})

FarmTab:AddButton({
    Name = "Start Invasion/Wave Now",
    Callback = function()
        StartInvasion()
        OrionLib:MakeNotification({
            Name = "Invasion",
            Content = "Starting invasion/wave...",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

FarmTab:AddToggle({
    Name = "Infinite Money (May not work)",
    Default = false,
    Callback = function(Value)
        Settings.InfiniteMoney = Value
    end    
})

-- Plant Tab
PlantTab:AddToggle({
    Name = "Auto Upgrade Plants",
    Default = false,
    Callback = function(Value)
        Settings.AutoUpgradePlants = Value
        OrionLib:MakeNotification({
            Name = "Auto Upgrade",
            Content = "Auto Upgrade Plants has been " .. (Value and "enabled" or "disabled"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

PlantTab:AddButton({
    Name = "Upgrade All Plants (One-Time)",
    Callback = function()
        local plants = GetPlants()
        for _, plant in pairs(plants) do
            UpgradePlant(plant)
        end
        OrionLib:MakeNotification({
            Name = "Upgrade",
            Content = "Upgraded " .. #plants .. " plants!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

PlantTab:AddDropdown({
    Name = "Select Seed to Buy",
    Default = "Peashooter",
    Options = {"Peashooter", "Sunflower", "CherryBomb", "WallNut", "PotatoMine", "SnowPea", "Chomper", "Repeater", "PuffShroom", "SunShroom", "FumeShroom", "GraveBuster", "HypnoShroom", "ScaredyShroom", "IceShroom", "DoomShroom", "LilyPad", "Squash", "Threepeater", "TangleKelp", "Jalapeno", "Spikeweed", "Torchwood", "TallNut"},
    Callback = function(Value)
        Settings.SelectedSeed = Value
    end    
})

PlantTab:AddToggle({
    Name = "Auto Buy Selected Seed",
    Default = false,
    Callback = function(Value)
        Settings.AutoBuySeeds = Value
    end    
})

PlantTab:AddButton({
    Name = "Buy Selected Seed (One-Time)",
    Callback = function()
        if Settings.SelectedSeed then
            BuySeed(Settings.SelectedSeed)
            OrionLib:MakeNotification({
                Name = "Buy Seed",
                Content = "Buying " .. Settings.SelectedSeed,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})

PlantTab:AddButton({
    Name = "Buy All Seeds (One-Time)",
    Callback = function()
        local seeds = {"Peashooter", "Sunflower", "CherryBomb", "WallNut", "PotatoMine", "SnowPea", "Chomper", "Repeater"}
        for _, seed in pairs(seeds) do
            BuySeed(seed)
            wait(0.5)
        end
        OrionLib:MakeNotification({
            Name = "Buy All",
            Content = "Buying all seeds...",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

-- ═══════════════════════════════════════
-- TAB PLAYER
-- ═══════════════════════════════════════

local PlayerSection = PlayerTab:Section({
    Name = "👤 Player Settings"
})

PlayerSection:Slider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(Value)
        Settings.WalkSpeed = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerSection:Slider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(Value)
        Settings.JumpPower = Value
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

PlayerSection:Toggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Settings.InfiniteJump = Value
    end
})

PlayerSection:Toggle({
    Name = "NoClip",
    Default = false,
    Callback = function(Value)
        Settings.NoClip = Value
    end
})

local VisualsSection = PlayerTab:Section({
    Name = "👁 Visuals"
})

VisualsSection:Toggle({
    Name = "ESP Brainrots",
    Default = false,
    Callback = function(Value)
        Settings.ESPBrainrots = Value
        if not Value then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end
})

VisualsSection:Toggle({
    Name = "ESP Plants",
    Default = false,
    Callback = function(Value)
        Settings.ESPPlants = Value
    end
})

-- Maintain WalkSpeed and JumpPower
spawn(function()
    while wait() do
        if Humanoid then
            if Humanoid.WalkSpeed ~= Settings.WalkSpeed then
                Humanoid.WalkSpeed = Settings.WalkSpeed
            end
            if Humanoid.JumpPower ~= Settings.JumpPower then
                Humanoid.JumpPower = Settings.JumpPower
            end
        end
    end
end)

-- Visuals Tab
VisualsTab:AddToggle({
    Name = "ESP Brainrots (Enemies)",
    Default = false,
    Callback = function(Value)
        Settings.ESPBrainrots = Value
        if not Value then
            -- Clear all ESP
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
        end
    end    
})

VisualsTab:AddToggle({
    Name = "ESP Plants",
    Default = false,
    Callback = function(Value)
        Settings.ESPPlants = Value
    end    
})

VisualsTab:AddToggle({
    Name = "ESP Drops/Money",
    Default = false,
    Callback = function(Value)
        Settings.ESPDrops = Value
    end    
})

VisualsTab:AddToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = true
        end
    end    
})

VisualsTab:AddButton({
    Name = "Remove All ESP",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                obj:Destroy()
            end
        end
        OrionLib:MakeNotification({
            Name = "ESP",
            Content = "All ESP removed",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

-- Teleport Tab
TeleportTab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        pcall(function()
            if Workspace:FindFirstChild("SpawnLocation") then
                TeleportTo(Workspace.SpawnLocation.Position)
            elseif Workspace:FindFirstChild("Spawns") then
                local spawn = Workspace.Spawns:GetChildren()[1]
                if spawn then
                    TeleportTo(spawn.Position)
                end
            end
        end)
    end    
})

TeleportTab:AddButton({
    Name = "Teleport to Shop",
    Callback = function()
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("shop") and obj:IsA("BasePart") then
                    TeleportTo(obj.Position)
                    break
                end
            end
        end)
    end    
})

TeleportTab:AddButton({
    Name = "Teleport to Garden/Plot",
    Callback = function()
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj.Name:lower():find("garden") or obj.Name:lower():find("plot")) and obj:IsA("BasePart") then
                    TeleportTo(obj.Position)
                    break
                end
            end
        end)
    end    
})

TeleportTab:AddDropdown({
    Name = "Teleport to Biome",
    Default = "Grassland",
    Options = {"Grassland", "Desert", "Jungle", "Snow", "Cave", "Beach"},
    Callback = function(Value)
        Settings.SelectedBiome = Value
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find(Value:lower()) and obj:IsA("BasePart") then
                    TeleportTo(obj.Position)
                    break
                end
            end
        end)
    end    
})

TeleportTab:AddButton({
    Name = "Teleport to Nearest Brainrot",
    Callback = function()
        local brainrots = GetBrainrots()
        if #brainrots > 0 and brainrots[1]:FindFirstChild("HumanoidRootPart") then
            TeleportTo(brainrots[1].HumanoidRootPart.Position)
        end
    end    
})

TeleportTab:AddButton({
    Name = "Teleport to Nearest Drop",
    Callback = function()
        local drops = GetDrops()
        if #drops > 0 then
            TeleportTo(drops[1].Position)
        end
    end    
})

-- ═══════════════════════════════════════
-- TAB MISC
-- ═══════════════════════════════════════

local MiscSection = MiscTab:Section({
    Name = "⚙️ Miscellaneous"
})

MiscSection:Button({
    Name = "Claim Daily Rewards",
    Callback = function()
        pcall(function()
            if ReplicatedStorage:FindFirstChild("ClaimDaily") then
                ReplicatedStorage.ClaimDaily:FireServer()
            end
            if ReplicatedStorage:FindFirstChild("DailyReward") then
                ReplicatedStorage.DailyReward:FireServer()
            end
        end)
        Window:Notify({
            Title = "Daily Rewards",
            Description = "Claiming daily rewards...",
            Duration = 3
        })
    end
})

MiscSection:Button({
    Name = "Complete All Quests",
    Callback = function()
        pcall(function()
            if ReplicatedStorage:FindFirstChild("CompleteQuest") then
                for i = 1, 50 do
                    ReplicatedStorage.CompleteQuest:FireServer(i)
                end
            end
        end)
        Window:Notify({
            Title = "Quests",
            Description = "Attempting to complete all quests...",
            Duration = 3
        })
    end
})

MiscSection:Button({
    Name = "Unlock All Biomes",
    Callback = function()
        pcall(function()
            local biomes = {"Desert", "Jungle", "Snow", "Cave", "Beach"}
            for _, biome in pairs(biomes) do
                if ReplicatedStorage:FindFirstChild("UnlockBiome") then
                    ReplicatedStorage.UnlockBiome:FireServer(biome)
                end
            end
        end)
        Window:Notify({
            Title = "Biomes",
            Description = "Attempting to unlock all biomes...",
            Duration = 3
        })
    end
})

MiscSection:Button({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

MiscSection:Button({
    Name = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"

        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end

        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[math.random(1, #Servers.data)]
            Next = Servers.nextPageCursor
        until Server

        TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end
})

local CreditsSection = MiscTab:Section({
    Name = "📜 Credits"
})

CreditsSection:Label({
    Text = "MonsHub - Plants vs Brainrots",
    Color = Color3.fromRGB(0, 200, 255)
})

CreditsSection:Label({
    Text = "Game by: Yo Gurt Studios",
    Color = Color3.fromRGB(150, 150, 150)
})

CreditsSection:Label({
    Text = "Script Version: 1.0.0",
    Color = Color3.fromRGB(150, 150, 150)
})

CreditsSection:Label({
    Text = "UI: WindUI by @vsAx",
    Color = Color3.fromRGB(150, 150, 150)
})

MiscTab:AddButton({
    Name = "Copy Discord Invite (If available)",
    Callback = function()
        setclipboard("discord.gg/monshub")
        OrionLib:MakeNotification({
            Name = "Discord",
            Content = "Discord invite copied to clipboard!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

MiscTab:AddLabel("━━━━━━━━━━━━━━━━━━━")
MiscTab:AddLabel("Credits: MonsHub")
MiscTab:AddLabel("Game: Plants vs Brainrots")
MiscTab:AddLabel("By: Yo Gurt Studios")
MiscTab:AddLabel("Script Version: 1.0.0")

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    wait(1)
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
end)

-- Initialize
Window:Notify({
    Title = "🌱 MonsHub Loaded!",
    Description = "Plants vs Brainrots script ready! Enjoy!",
    Duration = 5
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("MonsHub - Plants vs Brainrots")
print("Script Version: 1.0.0")
print("Game by: Yo Gurt Studios")
print("UI: WindUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Features Loaded:")
print("✓ Anti AFK (20 minutes)")
print("✓ Auto Farm Brainrot")
print("✓ Auto Equip Best Brainrot")
print("✓ Auto Move Plant")
print("✓ Auto Use Gear")
print("✓ Card & Halloween Event")
print("✓ Auto Shop (Spin, Crate, Merge)")
print("✓ Discord Webhook")
print("✓ Player Settings & ESP")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")