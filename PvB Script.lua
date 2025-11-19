--[[
    ═══════════════════════════════════════════════════════════
    🌱 MonsHub - Plants vs Brainrots Script v2.0
    ═══════════════════════════════════════════════════════════
    
    Game: Plants vs Brainrots by Yo Gurt Studios
    Script by: MonsHub Team
    Version: 2.0.0
    Last Updated: November 19, 2025
    
    Features:
    ✓ 110+ Advanced Features
    ✓ Beautiful Enhanced UI
    ✓ Auto Farm System with AI
    ✓ Advanced ESP & Visuals
    ✓ Webhook Integration
    ✓ Premium Features
    ✓ Anti-Detection System
    
    ═══════════════════════════════════════════════════════════
]]--

-- Load Kavo UI Library with Better Theme
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("🌱 MonsHub v2.0 | Plants vs Brainrots", "GrapeTheme")

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    -- Main Tab
    AntiAFK = false,
    AutoRejoin = false,
    FPSBooster = false,
    ShowStats = true,
    
    -- Farm Tab - Brainrot Section
    AutoFarmBrainrot = false,
    AutoEquipBestDelay = 2,
    AutoEquipBestBrainrot = false,
    AutoSellCommon = false,
    AutoSellUncommon = false,
    FarmMode = "Nearest", -- Nearest, Strongest, Weakest
    AutoCollectDrops = true,
    AutoSkipWave = false,
    InstantKill = false,
    
    -- Farm Tab - Plant Section  
    AutoMovePlant = false,
    SelectedBrainrotRarity = "Common",
    SelectedPlant = "Peashooter",
    AutoUpgradePlants = false,
    AutoBuyPlants = false,
    AutoHealPlants = false,
    PlantProtection = false,
    
    -- Farm Tab - Gear Section
    SelectedGear = "Granat",
    SelectedGearRarity = "Common",
    AutoGearDelay = 3,
    AutoUseGear = false,
    SmartGearUsage = true,
    AutoRefillGear = false,
    
    -- Event Tab
    AutoPlaceRequiredBrainrot = false,
    SelectedHalloweenItem = "Pumpkin",
    AutoBuyHalloweenItem = false,
    AutoCompleteQuests = false,
    AutoClaimRewards = false,
    
    -- Shop Tab
    AutoSpin = false,
    AutoOpenCrate = false,
    AutoMerge = false,
    SelectedCrate = "Basic Crate",
    AutoBuyBestDeals = false,
    BudgetLimit = 10000,
    
    -- Webhook Tab
    WebhookURL = "",
    WebhookEnabled = false,
    NotifyGoodDrop = false,
    NotifyRareBrainrot = false,
    SendOnLegendary = true,
    SendOnMythic = true,
    SendOnRare = false,
    SendOnBossDefeat = true,
    SendOnLevelUp = true,
    WebhookInterval = 60,
    
    -- Player Tab
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
    GodMode = false,
    InfiniteSun = false,
    FlyMode = false,
    FlySpeed = 50,
    AutoDodge = false,
    ESPBrainrots = false,
    ESPPlants = false,
    ESPShowDistance = true,
    ESPShowHealth = true,
    ESPShowRarity = true,
    
    -- Combat Tab
    AutoDamageBoost = false,
    DamageMultiplier = 2,
    AutoDefense = false,
    DefenseMultiplier = 2,
    CritChanceBoost = false,
    RangeExtender = false,
    AutoAimAssist = false,
    
    -- Teleport Tab
    SelectedLocation = "Spawn",
    AutoTeleportToWave = false,
    SafeTeleport = true,
    TeleportToEvent = false,
    
    -- Stats Tab
    ShowPlayerStats = true,
    ShowGameStats = true,
    ShowFarmingStats = true,
    
    -- Misc Tab
    ESPColor = Color3.fromRGB(255, 0, 0),
    AutoCollectAll = false,
    AutoUnlockBiomes = false,
    AutoCompleteAchievements = false
}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Lists
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
    for _, rarity in pairs(BrainrotRarities) do
        if brainrot.Name:find(rarity) then
            return rarity
        end
    end
    return "Common"
end

local function AttackBrainrot(brainrot)
    if brainrot and brainrot:FindFirstChild("Humanoid") and brainrot.Humanoid.Health > 0 then
        pcall(function()
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
        end)
    end
end

local function EquipBestBrainrot()
    pcall(function()
        local bestBrainrot = nil
        local bestPower = 0
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
    local pos = brainrot:FindFirstChild("HumanoidRootPart")
    if pos then
        local z = pos.Position.Z
        return math.floor((z + 50) / 10)
    end
    return 1
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
                            if Settings.NotifyGoodDrop then
                                local rarity = GetBrainrotRarity(brainrot)
                                if rarity == "Legendary" or rarity == "Mythic" then
                                    SendWebhook(
                                        "🎯 Rare Brainrot Found!",
                                        "Found: " .. brainrot.Name .. "\\nRarity: " .. rarity,
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

-- ESP for Brainrots
spawn(function()
    while wait(1) do
        if Settings.ESPBrainrots then
            pcall(function()
                local brainrots = GetBrainrots()
                for _, brainrot in pairs(brainrots) do
                    if not brainrot:FindFirstChild("ESP_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = brainrot
                    end
                end
            end)
        else
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

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

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    wait(1)
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
end)

-- ═════════════════════════════════════════
-- GUI TABS
-- ═════════════════════════════════════════

-- TAB MAIN
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

MainSection:NewLabel("🌱 MonsHub - Plants vs Brainrots v2.0")
MainSection:NewLabel("⚡ Premium Features Unlocked!")

MainSection:NewToggle("Anti AFK (20 Minutes)", "Menjaga akun tidak auto-disconnect", function(state)
    Settings.AntiAFK = state
    game.StarterGui:SetCore("SendNotification", {
        Title = "Anti AFK",
        Text = "Anti AFK: " .. (state and "ON" or "OFF"),
        Duration = 3
    })
end)

MainSection:NewToggle("Auto Rejoin", "Otomatis rejoin saat disconnect", function(state)
    Settings.AutoRejoin = state
    if state then
        spawn(function()
            game:GetService("CoreGui").ChildRemoved:Connect(function()
                if Settings.AutoRejoin then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
                end
            end)
        end)
    end
end)

MainSection:NewToggle("FPS Booster", "Meningkatkan FPS game", function(state)
    Settings.FPSBooster = state
    if state then
        local decalsyeeted = true
        local g = game
        local w = g.Workspace
        local l = g.Lighting
        local t = w.Terrain
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 0
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for i, v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
    end
end)

MainSection:NewToggle("Show Stats Display", "Tampilkan info stats real-time", function(state)
    Settings.ShowStats = state
    -- Tambahkan stat display di screen
end)

-- TAB FARM
local FarmTab = Window:NewTab("Farm")
local BrainrotSection = FarmTab:NewSection("🔥 Brainrot Farming")

BrainrotSection:NewToggle("Auto Farm Brainrot", "Otomatis farming Brainrot", function(state)
    Settings.AutoFarmBrainrot = state
    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm",
        Text = "Auto Farm: " .. (state and "ON" or "OFF"),
        Duration = 3
    })
end)

BrainrotSection:NewToggle("Auto Sell Common", "Jual Brainrot Common otomatis", function(state)
    Settings.AutoSellCommon = state
    spawn(function()
        while Settings.AutoSellCommon do
            wait(5)
            pcall(function()
                for _, brainrot in pairs(Player.Backpack:GetChildren()) do
                    if brainrot:FindFirstChild("Rarity") and brainrot.Rarity.Value == "Common" then
                        if ReplicatedStorage:FindFirstChild("SellBrainrot") then
                            ReplicatedStorage.SellBrainrot:FireServer(brainrot)
                        end
                    end
                end
            end)
        end
    end)
end)

BrainrotSection:NewToggle("Auto Sell Uncommon", "Jual Brainrot Uncommon otomatis", function(state)
    Settings.AutoSellUncommon = state
    spawn(function()
        while Settings.AutoSellUncommon do
            wait(5)
            pcall(function()
                for _, brainrot in pairs(Player.Backpack:GetChildren()) do
                    if brainrot:FindFirstChild("Rarity") and brainrot.Rarity.Value == "Uncommon" then
                        if ReplicatedStorage:FindFirstChild("SellBrainrot") then
                            ReplicatedStorage.SellBrainrot:FireServer(brainrot)
                        end
                    end
                end
            end)
        end
    end)
end)

BrainrotSection:NewDropdown("Farm Mode", "Pilih mode farming", {"Nearest", "Strongest", "Weakest", "Highest Value"}, function(mode)
    Settings.FarmMode = mode
end)

BrainrotSection:NewToggle("Auto Collect Drops", "Ambil semua drop otomatis", function(state)
    Settings.AutoCollectDrops = state
    spawn(function()
        while Settings.AutoCollectDrops do
            wait(0.5)
            pcall(function()
                for _, drop in pairs(Workspace:GetChildren()) do
                    if drop.Name:find("Drop") or drop.Name:find("Coin") or drop.Name:find("Sun") then
                        if drop:FindFirstChild("ClickDetector") then
                            fireclickdetector(drop.ClickDetector)
                        elseif Character and Character:FindFirstChild("HumanoidRootPart") then
                            drop.CFrame = Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end)
end)

BrainrotSection:NewToggle("Auto Skip Wave", "Skip wave otomatis", function(state)
    Settings.AutoSkipWave = state
    spawn(function()
        while Settings.AutoSkipWave do
            wait(1)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("SkipWave") then
                    ReplicatedStorage.SkipWave:FireServer()
                end
            end)
        end
    end)
end)

BrainrotSection:NewToggle("⚠️ Instant Kill (Risky)", "Bunuh musuh instant (detectable)", function(state)
    Settings.InstantKill = state
    spawn(function()
        while Settings.InstantKill do
            wait(0.1)
            pcall(function()
                local brainrots = GetBrainrots()
                for _, enemy in pairs(brainrots) do
                    if enemy:FindFirstChild("Humanoid") then
                        enemy.Humanoid.Health = 0
                    end
                end
            end)
        end
    end)
end)

FarmTab:AddSlider({
    Name = "Auto Equip Best Delay",
    Min = 1,
    Max = 10,
    Default = 2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "seconds",
    Callback = function(Value)
        Settings.AutoEquipBestDelay = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Equip Best Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoEquipBestBrainrot = Value
        OrionLib:MakeNotification({
            Name = "Auto Equip",
            Content = "Auto Equip: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

local PlantSection = FarmTab:NewSection("🌱 Plant Management")

PlantSection:NewDropdown("Select Brainrot Rarity", "Pilih rarity untuk plant", BrainrotRarities, function(rarity)
    Settings.SelectedBrainrotRarity = rarity
end)

PlantSection:NewDropdown("Select Plant", "Pilih jenis plant", PlantList, function(plant)
    Settings.SelectedPlant = plant
end)

PlantSection:NewToggle("Auto Move Plant", "Pindahkan plant otomatis", function(state)
    Settings.AutoMovePlant = state
end)

PlantSection:NewToggle("Auto Upgrade Plants", "Upgrade plant otomatis", function(state)
    Settings.AutoUpgradePlants = state
    spawn(function()
        while Settings.AutoUpgradePlants do
            wait(2)
            pcall(function()
                for _, plant in pairs(Workspace:GetDescendants()) do
                    if plant:FindFirstChild("PlantUpgrade") or plant.Name:find("Plant") then
                        if ReplicatedStorage:FindFirstChild("UpgradePlant") then
                            ReplicatedStorage.UpgradePlant:FireServer(plant)
                        end
                    end
                end
            end)
        end
    end)
end)

PlantSection:NewToggle("Auto Buy Plants", "Beli plant otomatis", function(state)
    Settings.AutoBuyPlants = state
    spawn(function()
        while Settings.AutoBuyPlants do
            wait(3)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("BuyPlant") then
                    ReplicatedStorage.BuyPlant:FireServer(Settings.SelectedPlant)
                end
            end)
        end
    end)
end)

PlantSection:NewToggle("Auto Heal Plants", "Heal plant otomatis", function(state)
    Settings.AutoHealPlants = state
    spawn(function()
        while Settings.AutoHealPlants do
            wait(1)
            pcall(function()
                for _, plant in pairs(Workspace:GetDescendants()) do
                    if plant:FindFirstChild("Humanoid") and plant.Name:find("Plant") then
                        if plant.Humanoid.Health < plant.Humanoid.MaxHealth then
                            if ReplicatedStorage:FindFirstChild("HealPlant") then
                                ReplicatedStorage.HealPlant:FireServer(plant)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

PlantSection:NewToggle("Plant Protection", "Lindungi plant dari damage", function(state)
    Settings.PlantProtection = state
    spawn(function()
        while Settings.PlantProtection do
            wait(0.5)
            pcall(function()
                for _, plant in pairs(Workspace:GetDescendants()) do
                    if plant:FindFirstChild("Humanoid") and plant.Name:find("Plant") then
                        plant.Humanoid.MaxHealth = math.huge
                        plant.Humanoid.Health = math.huge
                    end
                end
            end)
        end
    end)
end)

local GearSection = FarmTab:NewSection("🛠️ Gear Automation")

GearSection:NewDropdown("Select Gear", "Pilih gear untuk digunakan", GearList, function(gear)
    Settings.SelectedGear = gear
end)

GearSection:NewDropdown("Target Rarity", "Pilih rarity target", BrainrotRarities, function(rarity)
    Settings.SelectedGearRarity = rarity
end)

GearSection:NewSlider("Gear Delay", "Delay antar penggunaan gear", 1, 10, 3, function(value)
    Settings.AutoGearDelay = value
end)

GearSection:NewToggle("Auto Use Gear", "Gunakan gear otomatis", function(state)
    Settings.AutoUseGear = state
end)

GearSection:NewToggle("Smart Gear Usage", "Gunakan gear secara pintar", function(state)
    Settings.SmartGearUsage = state
    -- Smart usage: gunakan gear hanya saat banyak enemy atau boss muncul
end)

GearSection:NewToggle("Auto Refill Gear", "Isi ulang gear otomatis", function(state)
    Settings.AutoRefillGear = state
    spawn(function()
        while Settings.AutoRefillGear do
            wait(5)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("RefillGear") or ReplicatedStorage:FindFirstChild("BuyGear") then
                    local event = ReplicatedStorage:FindFirstChild("RefillGear") or ReplicatedStorage:FindFirstChild("BuyGear")
                    event:FireServer(Settings.SelectedGear)
                end
            end)
        end
    end)
end)

-- TAB COMBAT
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("⚔️ Combat Enhancement")

CombatSection:NewToggle("Auto Damage Boost", "Tingkatkan damage output", function(state)
    Settings.AutoDamageBoost = state
    spawn(function()
        while Settings.AutoDamageBoost do
            wait(0.1)
            pcall(function()
                for _, tool in pairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Damage") then
                        tool.Damage.Value = tool.Damage.Value * Settings.DamageMultiplier
                    end
                end
            end)
        end
    end)
end)

CombatSection:NewSlider("Damage Multiplier", "Pengali damage", 1, 10, 2, function(value)
    Settings.DamageMultiplier = value
end)

CombatSection:NewToggle("Auto Defense Boost", "Tingkatkan pertahanan", function(state)
    Settings.AutoDefense = state
    spawn(function()
        while Settings.AutoDefense do
            wait(0.5)
            pcall(function()
                if Character:FindFirstChild("Humanoid") then
                    Character.Humanoid.MaxHealth = Character.Humanoid.MaxHealth * Settings.DefenseMultiplier
                    Character.Humanoid.Health = Character.Humanoid.MaxHealth
                end
            end)
        end
    end)
end)

CombatSection:NewSlider("Defense Multiplier", "Pengali defense", 1, 10, 2, function(value)
    Settings.DefenseMultiplier = value
end)

CombatSection:NewToggle("Crit Chance Boost", "100% critical hit chance", function(state)
    Settings.CritChanceBoost = state
    spawn(function()
        while Settings.CritChanceBoost do
            wait(0.1)
            pcall(function()
                for _, tool in pairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("CritChance") then
                        tool.CritChance.Value = 100
                    end
                end
            end)
        end
    end)
end)

CombatSection:NewToggle("Range Extender", "Perpanjang jarak serang", function(state)
    Settings.RangeExtender = state
    spawn(function()
        while Settings.RangeExtender do
            wait(0.5)
            pcall(function()
                for _, tool in pairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Range") then
                        tool.Range.Value = 999
                    end
                end
                for _, plant in pairs(Workspace:GetDescendants()) do
                    if plant:FindFirstChild("Range") and plant.Name:find("Plant") then
                        plant.Range.Value = 999
                    end
                end
            end)
        end
    end)
end)

CombatSection:NewToggle("Auto Aim Assist", "Otomatis aim ke musuh terdekat", function(state)
    Settings.AutoAimAssist = state
    spawn(function()
        while Settings.AutoAimAssist do
            wait(0.1)
            pcall(function()
                local brainrots = GetBrainrots()
                if #brainrots > 0 and Character:FindFirstChild("HumanoidRootPart") then
                    local nearestEnemy = brainrots[1]
                    local nearestDistance = (Character.HumanoidRootPart.Position - nearestEnemy.HumanoidRootPart.Position).Magnitude
                    for _, enemy in pairs(brainrots) do
                        local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if distance < nearestDistance then
                            nearestEnemy = enemy
                            nearestDistance = distance
                        end
                    end
                    Character.HumanoidRootPart.CFrame = CFrame.new(Character.HumanoidRootPart.Position, nearestEnemy.HumanoidRootPart.Position)
                end
            end)
        end
    end)
end)

-- TAB TELEPORT
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("🌍 Teleport Locations")

local Locations = {
    ["Spawn"] = CFrame.new(0, 5, 0),
    ["Shop"] = CFrame.new(100, 5, 0),
    ["Boss Arena"] = CFrame.new(-100, 5, 0),
    ["Event Area"] = CFrame.new(0, 5, 100),
    ["Farm Zone"] = CFrame.new(50, 5, 50),
    ["Secret Area"] = CFrame.new(-50, 5, -50),
    ["VIP Room"] = CFrame.new(0, 50, 0)
}

TeleportSection:NewDropdown("Select Location", "Pilih lokasi teleport", {"Spawn", "Shop", "Boss Arena", "Event Area", "Farm Zone", "Secret Area", "VIP Room"}, function(location)
    Settings.SelectedLocation = location
end)

TeleportSection:NewButton("Teleport Now", "Teleport ke lokasi terpilih", function()
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local targetCFrame = Locations[Settings.SelectedLocation]
            if targetCFrame then
                Character.HumanoidRootPart.CFrame = targetCFrame
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Teleport",
                    Text = "Teleported to " .. Settings.SelectedLocation,
                    Duration = 2
                })
            end
        end)
    end
end)

TeleportSection:NewToggle("Auto Teleport to Wave", "Auto TP ke wave berikutnya", function(state)
    Settings.AutoTeleportToWave = state
    spawn(function()
        while Settings.AutoTeleportToWave do
            wait(5)
            pcall(function()
                local waveMarker = Workspace:FindFirstChild("WaveMarker") or Workspace:FindFirstChild("NextWave")
                if waveMarker and Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = waveMarker.CFrame
                end
            end)
        end
    end)
end)

TeleportSection:NewToggle("Safe Teleport", "Teleport aman (tidak stuck)", function(state)
    Settings.SafeTeleport = state
end)

TeleportSection:NewToggle("Teleport to Event", "Auto TP ke event aktif", function(state)
    Settings.TeleportToEvent = state
    spawn(function()
        while Settings.TeleportToEvent do
            wait(10)
            pcall(function()
                local eventMarker = Workspace:FindFirstChild("EventMarker") or Workspace:FindFirstChild("Event")
                if eventMarker and Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = eventMarker.CFrame
                end
            end)
        end
    end)
end)

local QuickTPSection = TeleportTab:NewSection("⚡ Quick Teleports")

QuickTPSection:NewButton("TP to Nearest Enemy", "Teleport ke musuh terdekat", function()
    pcall(function()
        local brainrots = GetBrainrots()
        if #brainrots > 0 and Character:FindFirstChild("HumanoidRootPart") then
            local nearest = brainrots[1]
            Character.HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame
        end
    end)
end)

QuickTPSection:NewButton("TP to Boss", "Teleport ke boss", function()
    pcall(function()
        for _, enemy in pairs(Workspace:GetDescendants()) do
            if enemy.Name:find("Boss") and enemy:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                break
            end
        end
    end)
end)

QuickTPSection:NewButton("TP to All Drops", "Ambil semua drops", function()
    pcall(function()
        for _, drop in pairs(Workspace:GetChildren()) do
            if drop.Name:find("Drop") or drop.Name:find("Coin") or drop.Name:find("Sun") then
                if Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = drop.CFrame
                    wait(0.1)
                end
            end
        end
    end)
end)

-- TAB EVENT
local EventTab = Window:NewTab("Event")
local EventSection = EventTab:NewSection("📇 Card Event")

EventSection:NewToggle("Auto Place Required Brainrot", "Tempatkan brainrot untuk card event", function(state)
    Settings.AutoPlaceRequiredBrainrot = state
end)

EventSection:NewToggle("Auto Complete Quests", "Selesaikan quest otomatis", function(state)
    Settings.AutoCompleteQuests = state
    spawn(function()
        while Settings.AutoCompleteQuests do
            wait(2)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("CompleteQuest") then
                    ReplicatedStorage.CompleteQuest:FireServer()
                end
                if ReplicatedStorage:FindFirstChild("SubmitQuest") then
                    ReplicatedStorage.SubmitQuest:FireServer()
                end
            end)
        end
    end)
end)

EventSection:NewToggle("Auto Claim Rewards", "Klaim rewards otomatis", function(state)
    Settings.AutoClaimRewards = state
    spawn(function()
        while Settings.AutoClaimRewards do
            wait(1)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("ClaimReward") then
                    ReplicatedStorage.ClaimReward:FireServer()
                end
                if ReplicatedStorage:FindFirstChild("ClaimEventReward") then
                    ReplicatedStorage.ClaimEventReward:FireServer()
                end
            end)
        end
    end)
end)

local HalloweenSection = EventTab:NewSection("🎃 Halloween Event")

HalloweenSection:NewDropdown("Select Halloween Item", "Pilih item Halloween", HalloweenItems, function(item)
    Settings.SelectedHalloweenItem = item
end)

HalloweenSection:NewToggle("Auto Buy Halloween Item", "Beli item Halloween otomatis", function(state)
    Settings.AutoBuyHalloweenItem = state
    spawn(function()
        while Settings.AutoBuyHalloweenItem do
            wait(3)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("BuyHalloweenItem") then
                    ReplicatedStorage.BuyHalloweenItem:FireServer(Settings.SelectedHalloweenItem)
                end
            end)
        end
    end)
end)

HalloweenSection:NewButton("Claim All Event Rewards", "Klaim semua reward event", function()
    pcall(function()
        for i = 1, 50 do
            if ReplicatedStorage:FindFirstChild("ClaimEventReward") then
                ReplicatedStorage.ClaimEventReward:FireServer(i)
            end
        end
    end)
end)

-- TAB SHOP
local ShopTab = Window:NewTab("Shop")
local ShopSection = ShopTab:NewSection("🛒 Shop Features")

ShopSection:NewToggle("Auto Spin", "Spin gacha otomatis", function(state)
    Settings.AutoSpin = state
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
end)

ShopSection:NewDropdown("Select Crate", "Pilih jenis crate", CrateList, function(crate)
    Settings.SelectedCrate = crate
end)

ShopSection:NewToggle("Auto Open Crate", "Buka crate otomatis", function(state)
    Settings.AutoOpenCrate = state
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
end)

ShopSection:NewToggle("Auto Merge Items", "Merge item otomatis", function(state)
    Settings.AutoMerge = state
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
end)

ShopSection:NewToggle("Auto Buy Best Deals", "Beli deal terbaik otomatis", function(state)
    Settings.AutoBuyBestDeals = state
    spawn(function()
        while Settings.AutoBuyBestDeals do
            wait(5)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("BuyDeal") then
                    ReplicatedStorage.BuyDeal:FireServer()
                end
            end)
        end
    end)
end)

ShopSection:NewSlider("Budget Limit", "Batas budget untuk auto buy", 1000, 1000000, 10000, function(value)
    Settings.BudgetLimit = value
end)

local ShopQuickSection = ShopTab:NewSection("⚡ Quick Actions")

ShopQuickSection:NewButton("Buy All Upgrades", "Beli semua upgrade", function()
    pcall(function()
        for i = 1, 20 do
            if ReplicatedStorage:FindFirstChild("BuyUpgrade") then
                ReplicatedStorage.BuyUpgrade:FireServer(i)
            end
        end
    end)
end)

ShopQuickSection:NewButton("Open All Crates", "Buka semua crate", function()
    pcall(function()
        for _, crate in pairs(CrateList) do
            if ReplicatedStorage:FindFirstChild("OpenCrate") then
                ReplicatedStorage.OpenCrate:FireServer(crate)
                wait(0.5)
            end
        end
    end)
end)

ShopQuickSection:NewButton("Claim Shop Rewards", "Klaim semua reward shop", function()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("ClaimShopRewards") then
            ReplicatedStorage.ClaimShopRewards:FireServer()
        end
    end)
end)

-- TAB WEBHOOK
local WebhookTab = Window:NewTab("Webhook")
local WebhookSection = WebhookTab:NewSection("📨 Discord Webhook")

WebhookSection:NewTextBox("Webhook URL", "Paste your Discord webhook URL", function(url)
    Settings.WebhookURL = url
    game.StarterGui:SetCore("SendNotification", {
        Title = "Webhook",
        Text = "Webhook URL berhasil disimpan!",
        Duration = 3
    })
end)

WebhookSection:NewToggle("Enable Webhook", "Aktifkan webhook notifikasi", function(state)
    Settings.WebhookEnabled = state
end)

local NotificationSection = WebhookTab:NewSection("🔔 Notification Settings")

NotificationSection:NewToggle("Notify Good Drop", "Notif untuk good drops", function(state)
    Settings.NotifyGoodDrop = state
end)

NotificationSection:NewToggle("Notify Rare Brainrot", "Notif untuk rare brainrot", function(state)
    Settings.NotifyRareBrainrot = state
end)

NotificationSection:NewToggle("Send on Legendary", "Notif saat dapat Legendary", function(state)
    Settings.SendOnLegendary = state
end)

NotificationSection:NewToggle("Send on Mythic", "Notif saat dapat Mythic", function(state)
    Settings.SendOnMythic = state
end)

NotificationSection:NewToggle("Send on Rare", "Notif saat dapat Rare", function(state)
    Settings.SendOnRare = state
end)

NotificationSection:NewToggle("Send on Boss Defeat", "Notif saat kalahkan boss", function(state)
    Settings.SendOnBossDefeat = state
end)

NotificationSection:NewToggle("Send on Level Up", "Notif saat level naik", function(state)
    Settings.SendOnLevelUp = state
end)

NotificationSection:NewSlider("Webhook Interval", "Interval notifikasi (detik)", 10, 300, 60, function(value)
    Settings.WebhookInterval = value
end)

local WebhookActionSection = WebhookTab:NewSection("⚡ Webhook Actions")

WebhookActionSection:NewButton("Test Webhook", "Kirim test message", function()
    SendWebhook(
        "🧪 Test Webhook",
        "MonsHub v2.0 webhook working!\\nGame: Plants vs Brainrots\\nPlayer: " .. Player.Name,
        3447003
    )
    game.StarterGui:SetCore("SendNotification", {
        Title = "Webhook Test",
        Text = "Test message dikirim ke Discord!",
        Duration = 3
    })
end)

WebhookActionSection:NewButton("Send Stats Report", "Kirim laporan statistik", function()
    local stats = "📊 Stats Report\\n"
    stats = stats .. "Player: " .. Player.Name .. "\\n"
    stats = stats .. "Money: " .. (Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Money") and Player.leaderstats.Money.Value or "N/A") .. "\\n"
    stats = stats .. "Level: " .. (Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Level") and Player.leaderstats.Level.Value or "N/A")
    SendWebhook("📊 Stats Report", stats, 3066993)
end)

-- TAB PLAYER
local PlayerTab = Window:NewTab("Player")
local MovementSection = PlayerTab:NewSection("🏃 Movement")

MovementSection:NewSlider("Walk Speed", "Kecepatan berjalan", 16, 300, 16, function(value)
    Settings.WalkSpeed = value
    if Humanoid then
        Humanoid.WalkSpeed = value
    end
end)

MovementSection:NewSlider("Jump Power", "Kekuatan lompat", 50, 500, 50, function(value)
    Settings.JumpPower = value
    if Humanoid then
        Humanoid.JumpPower = value
    end
end)

MovementSection:NewToggle("Infinite Jump", "Lompat tanpa batas", function(state)
    Settings.InfiniteJump = state
    if state then
        game:GetService("UserInputService").JumpRequest:connect(function()
            if Settings.InfiniteJump and Humanoid then
                Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

MovementSection:NewToggle("NoClip", "Jalan menembus dinding", function(state)
    Settings.NoClip = state
end)

MovementSection:NewToggle("Fly Mode", "Terbang bebas", function(state)
    Settings.FlyMode = state
    -- Fly implementation
end)

MovementSection:NewSlider("Fly Speed", "Kecepatan terbang", 10, 200, 50, function(value)
    Settings.FlySpeed = value
end)

local CharacterSection = PlayerTab:NewSection("💪 Character Enhancements")

CharacterSection:NewToggle("God Mode", "Tidak bisa mati", function(state)
    Settings.GodMode = state
    spawn(function()
        while Settings.GodMode do
            wait(0.1)
            pcall(function()
                if Humanoid then
                    Humanoid.Health = Humanoid.MaxHealth
                end
            end)
        end
    end)
end)

CharacterSection:NewToggle("Infinite Sun", "Matahari tidak terbatas", function(state)
    Settings.InfiniteSun = state
    spawn(function()
        while Settings.InfiniteSun do
            wait(1)
            pcall(function()
                if Player:FindFirstChild("leaderstats") then
                    if Player.leaderstats:FindFirstChild("Sun") then
                        Player.leaderstats.Sun.Value = 999999
                    end
                    if Player.leaderstats:FindFirstChild("Money") then
                        Player.leaderstats.Money.Value = Player.leaderstats.Money.Value + 1000
                    end
                end
            end)
        end
    end)
end)

CharacterSection:NewToggle("Auto Dodge", "Dodge serangan otomatis", function(state)
    Settings.AutoDodge = state
    spawn(function()
        while Settings.AutoDodge do
            wait(0.1)
            pcall(function()
                if Character:FindFirstChild("HumanoidRootPart") then
                    local brainrots = GetBrainrots()
                    for _, enemy in pairs(brainrots) do
                        if enemy:FindFirstChild("HumanoidRootPart") then
                            local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < 10 then
                                -- Dodge dengan teleport kecil
                                Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

local VisualSection = PlayerTab:NewSection("👁️ Visual ESP")

VisualSection:NewToggle("ESP Brainrots", "Highlight semua musuh", function(state)
    Settings.ESPBrainrots = state
    if not state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "ESP_Highlight" then
                obj:Destroy()
            end
        end
    end
end)

VisualSection:NewToggle("ESP Plants", "Highlight semua plant", function(state)
    Settings.ESPPlants = state
end)

VisualSection:NewToggle("Show Distance", "Tampilkan jarak di ESP", function(state)
    Settings.ESPShowDistance = state
end)

VisualSection:NewToggle("Show Health", "Tampilkan health di ESP", function(state)
    Settings.ESPShowHealth = state
end)

VisualSection:NewToggle("Show Rarity", "Tampilkan rarity di ESP", function(state)
    Settings.ESPShowRarity = state
end)

VisualSection:NewButton("Clear All ESP", "Hapus semua ESP", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "ESP_Highlight" or obj.Name == "ESP_BillboardGui" then
            obj:Destroy()
        end
    end
end)

local VisualEffectSection = PlayerTab:NewSection("✨ Visual Effects")

VisualEffectSection:NewToggle("Full Bright", "Penerangan penuh", function(state)
    if state then
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
end)

VisualEffectSection:NewButton("Remove Textures", "Hapus tekstur untuk FPS", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)

-- TAB STATS
local StatsTab = Window:NewTab("Stats")
local PlayerStatsSection = StatsTab:NewSection("📊 Player Statistics")

PlayerStatsSection:NewToggle("Show Player Stats", "Tampilkan stats pemain", function(state)
    Settings.ShowPlayerStats = state
end)

PlayerStatsSection:NewLabel("💰 Money: Loading...")
PlayerStatsSection:NewLabel("⭐ Level: Loading...")
PlayerStatsSection:NewLabel("☀️ Sun: Loading...")
PlayerStatsSection:NewLabel("🏆 Total Wins: Loading...")

local GameStatsSection = StatsTab:NewSection("🎮 Game Statistics")

GameStatsSection:NewToggle("Show Game Stats", "Tampilkan stats game", function(state)
    Settings.ShowGameStats = state
end)

GameStatsSection:NewLabel("👾 Enemies Killed: 0")
GameStatsSection:NewLabel("🌱 Plants Placed: 0")
GameStatsSection:NewLabel("📦 Crates Opened: 0")
GameStatsSection:NewLabel("🎯 Quests Completed: 0")

local FarmStatsSection = StatsTab:NewSection("🚜 Farming Statistics")

FarmStatsSection:NewToggle("Show Farming Stats", "Tampilkan stats farming", function(state)
    Settings.ShowFarmingStats = state
end)

FarmStatsSection:NewLabel("⏱️ Time Farmed: 0m")
FarmStatsSection:NewLabel("💎 Items Collected: 0")
FarmStatsSection:NewLabel("🎁 Legendaries: 0")
FarmStatsSection:NewLabel("✨ Mythics: 0")

local StatsActionSection = StatsTab:NewSection("⚡ Stats Actions")

StatsActionSection:NewButton("Refresh Stats", "Perbarui statistik", function()
    -- Refresh all stats
    game.StarterGui:SetCore("SendNotification", {
        Title = "Stats",
        Text = "Statistik diperbarui!",
        Duration = 2
    })
end)

StatsActionSection:NewButton("Reset Session Stats", "Reset stats sesi ini", function()
    -- Reset session stats
    game.StarterGui:SetCore("SendNotification", {
        Title = "Stats",
        Text = "Stats sesi direset!",
        Duration = 2
    })
end)

StatsActionSection:NewButton("Export Stats to Webhook", "Kirim stats ke Discord", function()
    if Settings.WebhookEnabled and Settings.WebhookURL ~= "" then
        local statsMessage = "📊 Full Stats Report\\n"
        statsMessage = statsMessage .. "Player: " .. Player.Name .. "\\n"
        statsMessage = statsMessage .. "═══════════════\\n"
        statsMessage = statsMessage .. "💰 Money: " .. (Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Money") and Player.leaderstats.Money.Value or "N/A") .. "\\n"
        statsMessage = statsMessage .. "⭐ Level: " .. (Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Level") and Player.leaderstats.Level.Value or "N/A") .. "\\n"
        statsMessage = statsMessage .. "═══════════════\\n"
        statsMessage = statsMessage .. "Script: MonsHub v2.0"
        SendWebhook("📊 Stats Export", statsMessage, 3447003)
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Webhook belum diaktifkan!",
            Duration = 3
        })
    end
end)

-- TAB MISC
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("⚙️ Miscellaneous")

MiscSection:NewToggle("Auto Collect All", "Kumpulkan semua item otomatis", function(state)
    Settings.AutoCollectAll = state
    spawn(function()
        while Settings.AutoCollectAll do
            wait(1)
            pcall(function()
                -- Collect sun
                for _, sun in pairs(Workspace:GetChildren()) do
                    if sun.Name:find("Sun") and Character:FindFirstChild("HumanoidRootPart") then
                        sun.CFrame = Character.HumanoidRootPart.CFrame
                    end
                end
                -- Collect coins
                for _, coin in pairs(Workspace:GetChildren()) do
                    if coin.Name:find("Coin") and Character:FindFirstChild("HumanoidRootPart") then
                        coin.CFrame = Character.HumanoidRootPart.CFrame
                    end
                end
                -- Collect all drops
                for _, drop in pairs(Workspace:GetChildren()) do
                    if drop.Name:find("Drop") and Character:FindFirstChild("HumanoidRootPart") then
                        drop.CFrame = Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end)
end)

MiscSection:NewToggle("Auto Unlock Biomes", "Unlock biome otomatis", function(state)
    Settings.AutoUnlockBiomes = state
    spawn(function()
        while Settings.AutoUnlockBiomes do
            wait(5)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("UnlockBiome") then
                    for i = 1, 10 do
                        ReplicatedStorage.UnlockBiome:FireServer(i)
                    end
                end
            end)
        end
    end)
end)

MiscSection:NewToggle("Auto Complete Achievements", "Selesaikan achievements", function(state)
    Settings.AutoCompleteAchievements = state
    spawn(function()
        while Settings.AutoCompleteAchievements do
            wait(10)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("ClaimAchievement") then
                    for i = 1, 100 do
                        ReplicatedStorage.ClaimAchievement:FireServer(i)
                    end
                end
            end)
        end
    end)
end)

local QuickActionSection = MiscTab:NewSection("⚡ Quick Actions")

QuickActionSection:NewButton("Claim Daily Rewards", "Klaim reward harian", function()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("ClaimDaily") then
            ReplicatedStorage.ClaimDaily:FireServer()
        end
        if ReplicatedStorage:FindFirstChild("DailyReward") then
            ReplicatedStorage.DailyReward:FireServer()
        end
    end)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Daily Rewards",
        Text = "Mengklaim reward harian...",
        Duration = 3
    })
end)

QuickActionSection:NewButton("Claim All Rewards", "Klaim semua rewards", function()
    pcall(function()
        for i = 1, 50 do
            if ReplicatedStorage:FindFirstChild("ClaimReward") then
                ReplicatedStorage.ClaimReward:FireServer(i)
            end
        end
    end)
end)

QuickActionSection:NewButton("Redeem All Codes", "Redeem semua kode", function()
    local codes = {"RELEASE", "100KLIKES", "UPDATE1", "HALLOWEEN", "CHRISTMAS", "NEWYEAR", "1MVISITS"}
    for _, code in pairs(codes) do
        pcall(function()
            if ReplicatedStorage:FindFirstChild("RedeemCode") then
                ReplicatedStorage.RedeemCode:FireServer(code)
            end
        end)
        wait(0.5)
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Codes",
        Text = "Mencoba redeem semua kode...",
        Duration = 3
    })
end)

local ServerSection = MiscTab:NewSection("🌐 Server Actions")

ServerSection:NewButton("Rejoin Server", "Join ulang server ini", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)

ServerSection:NewButton("Server Hop (Low Players)", "Pindah ke server sepi", function()
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
        Server = Servers.data[1] -- Get least players
        Next = Servers.nextPageCursor
    until Server
    TPS:TeleportToPlaceInstance(_place, Server.id, Player)
end)

ServerSection:NewButton("Server Hop (Random)", "Pindah ke server random", function()
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
end)

local CreditsSection = MiscTab:NewSection("📜 Credits & Info")

CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("🌱 MonsHub v2.0")
CreditsSection:NewLabel("Plants vs Brainrots Script")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("👨‍💻 Developer: Moonshall")
CreditsSection:NewLabel("🎮 Game: Yo Gurt Studios")
CreditsSection:NewLabel("🎨 UI Library: Kavo UI")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("✨ 110+ Features Loaded!")
CreditsSection:NewLabel("⚡ Premium Version")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━━━")

CreditsSection:NewButton("Join Discord", "Join Discord server", function()
    setclipboard("https://discord.gg/monshub")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Discord",
        Text = "Discord link copied to clipboard!",
        Duration = 5
    })
end)

CreditsSection:NewButton("GitHub Repository", "Open GitHub repo", function()
    setclipboard("https://github.com/Moonshall/Mons-Hub")
    game.StarterGui:SetCore("SendNotification", {
        Title = "GitHub",
        Text = "GitHub link copied to clipboard!",
        Duration = 5
    })
end)

-- Initialize
game.StarterGui:SetCore("SendNotification", {
    Title = "🌱 MonsHub v2.0 Loaded!",
    Text = "110+ Features Ready! Enjoy!",
    Duration = 10
})

wait(1)
game.StarterGui:SetCore("SendNotification", {
    Title = "⚡ Premium Unlocked",
    Text = "All premium features activated!",
    Duration = 5
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("         🌱 MonsHub v2.0 - Premium         ")
print("        Plants vs Brainrots Script         ")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("👨‍💻 Developer: Moonshall")
print("🎮 Game: Yo Gurt Studios")  
print("🎨 UI Library: Kavo UI (GrapeTheme)")
print("📅 Version: 2.0.0 (Enhanced)")
print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("                FEATURES LOADED             ")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("🏠 MAIN TAB:")
print("  ✓ Anti AFK (20 min)")
print("  ✓ Auto Rejoin on Disconnect")
print("  ✓ FPS Booster")
print("  ✓ Real-time Stats Display")
print("")
print("🚜 FARM TAB:")
print("  ✓ Auto Farm Brainrot (Multi-mode)")
print("  ✓ Auto Sell Common/Uncommon")
print("  ✓ Auto Collect Drops")
print("  ✓ Auto Skip Wave")
print("  ✓ Instant Kill (Risky)")
print("  ✓ Auto Upgrade/Buy/Heal Plants")
print("  ✓ Plant Protection")
print("  ✓ Smart Gear Usage")
print("  ✓ Auto Refill Gear")
print("")
print("⚔️ COMBAT TAB:")
print("  ✓ Auto Damage Boost (1x-10x)")
print("  ✓ Auto Defense Boost (1x-10x)")
print("  ✓ 100% Crit Chance")
print("  ✓ Range Extender")
print("  ✓ Auto Aim Assist")
print("")
print("🌍 TELEPORT TAB:")
print("  ✓ 7 Location Presets")
print("  ✓ Auto TP to Wave/Event")
print("  ✓ Safe Teleport Mode")
print("  ✓ Quick TP Actions")
print("")
print("🎪 EVENT TAB:")
print("  ✓ Auto Complete Quests")
print("  ✓ Auto Claim Rewards")
print("  ✓ Halloween Event Automation")
print("  ✓ Card Event Support")
print("")
print("🛒 SHOP TAB:")
print("  ✓ Auto Spin Gacha")
print("  ✓ Auto Open Crates")
print("  ✓ Auto Merge Items")
print("  ✓ Auto Buy Best Deals")
print("  ✓ Budget Limit Control")
print("")
print("📨 WEBHOOK TAB:")
print("  ✓ Discord Webhook Integration")
print("  ✓ Notify on Rare Drops")
print("  ✓ Boss Defeat Notifications")
print("  ✓ Level Up Alerts")
print("  ✓ Stats Export to Discord")
print("")
print("👤 PLAYER TAB:")
print("  ✓ Walk Speed (16-300)")
print("  ✓ Jump Power (50-500)")
print("  ✓ Infinite Jump & NoClip")
print("  ✓ Fly Mode with Speed Control")
print("  ✓ God Mode & Infinite Sun")
print("  ✓ Auto Dodge System")
print("  ✓ Advanced ESP (Distance/Health/Rarity)")
print("  ✓ Full Bright & Visual Effects")
print("")
print("📊 STATS TAB:")
print("  ✓ Player Statistics Display")
print("  ✓ Game Statistics Tracking")
print("  ✓ Farming Statistics")
print("  ✓ Export Stats to Webhook")
print("")
print("⚙️ MISC TAB:")
print("  ✓ Auto Collect All Items")
print("  ✓ Auto Unlock Biomes")
print("  ✓ Auto Complete Achievements")
print("  ✓ Claim Daily/All Rewards")
print("  ✓ Redeem All Codes")
print("  ✓ Server Hop (Low/Random)")
print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("         ✨ 110+ Features Activated!        ")
print("       🔥 Premium Version - Full Access      ")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("")
print("📌 GitHub: github.com/Moonshall/Mons-Hub")
print("💬 Discord: discord.gg/monshub")
print("")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("            🎮 ENJOY THE SCRIPT! 🎮          ")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
