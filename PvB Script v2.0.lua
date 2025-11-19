--[[
    ═══════════════════════════════════════════════════════════════
                        🌱 MonsHub Script 🌱
                    Plants vs Brainrots
                    by Yo Gurt Studios
    ═══════════════════════════════════════════════════════════════
    
    Features:
    ✓ Anti AFK System
    ✓ Auto Farm Brainrot + Auto Equip Best
    ✓ Auto Move Plant + Auto Use Gear  
    ✓ Event Support (Card & Halloween)
    ✓ Shop Automation (Spin, Crate, Merge)
    ✓ Discord Webhook Integration
    ✓ Player Enhancements + ESP
    ✓ Teleport System
    ✓ Auto Collect Drops
    ✓ God Mode & Instant Kill
    ✓ Biome Unlocking
    
    Version: 2.0.0
    UI: Kavo UI Library
    
    ═══════════════════════════════════════════════════════════════
]]--

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌱 MonsHub | Plants vs Brainrots v2.0", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    -- Main
    AntiAFK = false,
    AutoCollectDrops = false,
    AutoRejoin = false,
    GodMode = false,
    
    -- Farm - Brainrot
    AutoFarmBrainrot = false,
    AutoEquipBestDelay = 2,
    AutoEquipBestBrainrot = false,
    InstantKill = false,
    AutoFarmBoss = false,
    FarmDistance = 10,
    
    -- Farm - Plant
    AutoMovePlant = false,
    SelectedBrainrotRarity = "Common",
    SelectedPlant = "Peashooter",
    AutoUpgradePlants = false,
    AutoBuyPlants = false,
    AutoPlacePlants = false,
    
    -- Farm - Gear
    SelectedGear = "Granat",
    SelectedGearRarity = "Common",
    AutoGearDelay = 3,
    AutoUseGear = false,
    
    -- Event
    AutoPlaceRequiredBrainrot = false,
    SelectedHalloweenItem = "Pumpkin",
    AutoBuyHalloweenItem = false,
    AutoCompleteQuests = false,
    
    -- Shop
    AutoSpin = false,
    AutoOpenCrate = false,
    AutoMerge = false,
    SelectedCrate = "Basic Crate",
    AutoBuyCoins = false,
    
    -- Webhook
    WebhookURL = "",
    WebhookEnabled = false,
    NotifyGoodDrop = false,
    NotifyRareBrainrot = false,
    NotifyLevelUp = false,
    
    -- Player
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
    FlyEnabled = false,
    FlySpeed = 50,
    
    -- Visuals
    ESPBrainrots = false,
    ESPPlants = false,
    ESPDrops = false,
    ESPPlayers = false,
    FullBright = false,
    RemoveFog = false,
    
    -- Teleport
    SelectedBiome = "Grassland",
    AutoTeleportToWave = false
}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Lists
local BrainrotRarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"}
local PlantList = {"Peashooter", "Sunflower", "CherryBomb", "WallNut", "PotatoMine", "SnowPea", "Chomper", "Repeater", "PuffShroom", "SunShroom", "FumeShroom", "Threepeater"}
local GearList = {"Granat", "Shovel", "Fertilizer", "PlantFood", "IceBlock", "Cherry", "Garlic", "Rake", "Lawnmower"}
local HalloweenItems = {"Pumpkin", "Candy", "Ghost", "Witch Hat", "Spider Web", "Haunted Seed"}
local CrateList = {"Basic Crate", "Silver Crate", "Gold Crate", "Diamond Crate", "Mythic Crate", "Event Crate"}
local BiomeList = {"Grassland", "Desert", "Jungle", "Snow", "Cave", "Beach", "Volcano"}
local ThemeList = {"DarkTheme", "GrapeTheme", "BloodTheme", "Ocean", "Midnight", "Sentinel", "Synapse", "Serpent"}

-- Notification Function
local function Notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

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

-- Auto Rejoin on Disconnect
game:GetService("CoreGui").DescendantRemoving:Connect(function(descendant)
    if Settings.AutoRejoin and descendant.Name == "ErrorPrompt" then
        wait(0.1)
        TeleportService:Teleport(game.PlaceId, Player)
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

local function GetBosses()
    local bosses = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and (obj.Name:find("Boss") or obj.Name:find("King") or obj.Name:find("Giant")) then
            if obj.Humanoid.Health > 0 then
                table.insert(bosses, obj)
            end
        end
    end
    return bosses
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

local function GetDrops()
    local drops = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Coin") or obj.Name:find("Money") or obj.Name:find("Drop") or obj.Name:find("Reward") or obj.Name:find("Sun") then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(drops, obj)
            end
        end
    end
    return drops
end

local function TeleportTo(position)
    if HumanoidRootPart and typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function AttackBrainrot(brainrot)
    if brainrot and brainrot:FindFirstChild("Humanoid") and brainrot.Humanoid.Health > 0 then
        pcall(function()
            if Settings.InstantKill then
                brainrot.Humanoid.Health = 0
            end
            
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
        if ReplicatedStorage:FindFirstChild("PlacePlant") then
            ReplicatedStorage.PlacePlant:FireServer(plantName, row)
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

local function BuyItem(itemName)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("BuyItem") then
            ReplicatedStorage.BuyItem:FireServer(itemName)
        end
        if ReplicatedStorage:FindFirstChild("BuyEventItem") then
            ReplicatedStorage.BuyEventItem:FireServer(itemName)
        end
        if ReplicatedStorage:FindFirstChild("PurchaseHalloween") then
            ReplicatedStorage.PurchaseHalloween:FireServer(itemName)
        end
        if ReplicatedStorage:FindFirstChild("Shop") then
            ReplicatedStorage.Shop:FireServer("Buy", itemName)
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

local function CreateESP(obj, name, color)
    if not obj:FindFirstChild("ESP_Highlight") then
        pcall(function()
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = color or Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = obj
            
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESP_Billboard"
            billboardGui.Size = UDim2.new(0, 100, 0, 40)
            billboardGui.StudsOffset = Vector3.new(0, 2, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = obj
            
            if obj:FindFirstChild("HumanoidRootPart") then
                billboardGui.Adornee = obj.HumanoidRootPart
            elseif obj:IsA("BasePart") then
                billboardGui.Adornee = obj
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
        end)
    end
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
                            local distance = (brainrot.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                            if distance <= Settings.FarmDistance then
                                AttackBrainrot(brainrot)
                                
                                if Settings.NotifyRareBrainrot then
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
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait(1) do
        if Settings.AutoFarmBoss then
            pcall(function()
                local bosses = GetBosses()
                if #bosses > 0 then
                    for _, boss in pairs(bosses) do
                        AttackBrainrot(boss)
                        wait(0.1)
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

-- Auto Collect Drops
spawn(function()
    while wait(0.2) do
        if Settings.AutoCollectDrops then
            pcall(function()
                local drops = GetDrops()
                for _, drop in pairs(drops) do
                    if drop and drop:IsA("BasePart") then
                        TeleportTo(drop.Position)
                        wait(0.05)
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

-- Auto Buy Halloween Item
spawn(function()
    while wait(2) do
        if Settings.AutoBuyHalloweenItem and Settings.SelectedHalloweenItem then
            pcall(function()
                BuyItem(Settings.SelectedHalloweenItem)
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

-- God Mode
spawn(function()
    while wait(0.1) do
        if Settings.GodMode and Humanoid then
            pcall(function()
                Humanoid.Health = Humanoid.MaxHealth
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

-- Fly System
local flying = false
local flySpeed = 50
local flyCtrl = {f = 0, b = 0, l = 0, r = 0}
local flyLastCtrl = {f = 0, b = 0, l = 0, r = 0}

local function Fly()
    flying = true
    local bg = Instance.new("BodyGyro", HumanoidRootPart)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = HumanoidRootPart.CFrame
    local bv = Instance.new("BodyVelocity", HumanoidRootPart)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    spawn(function()
        while flying and Settings.FlyEnabled do
            wait()
            flyCtrl = {f = 0, b = 0, l = 0, r = 0}
            local speed = Settings.FlySpeed or 50
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyCtrl.f = speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyCtrl.b = -speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyCtrl.l = -speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyCtrl.r = speed end
            
            if flyCtrl.f ~= 0 or flyCtrl.b ~= 0 or flyCtrl.l ~= 0 or flyCtrl.r ~= 0 then
                bv.velocity = ((workspace.Camera.CoordinateFrame.lookVector * (flyCtrl.f + flyCtrl.b)) + 
                              ((workspace.Camera.CoordinateFrame * CFrame.new(flyCtrl.l + flyCtrl.r, (flyCtrl.f + flyCtrl.b) * 0.2, 0).p) - workspace.Camera.CoordinateFrame.p))
                flyLastCtrl = {f = flyCtrl.f, b = flyCtrl.b, l = flyCtrl.l, r = flyCtrl.r}
            elseif flyCtrl.f == 0 and flyCtrl.b == 0 and flyCtrl.l == 0 and flyCtrl.r == 0 and flyLastCtrl.f == 0 and flyLastCtrl.b == 0 and flyLastCtrl.l == 0 and flyLastCtrl.r == 0 then
                bv.velocity = Vector3.new(0, 0, 0)
            end
            
            bg.cframe = workspace.Camera.CoordinateFrame
        end
        
        flyCtrl = {f = 0, b = 0, l = 0, r = 0}
        flyLastCtrl = {f = 0, b = 0, l = 0, r = 0}
        bg:Destroy()
        bv:Destroy()
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
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                    obj:Destroy()
                end
            end
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

-- ═══════════════════════════════════════
-- GUI TABS
-- ═══════════════════════════════════════

-- TAB: HOME
local HomeTab = Window:NewTab("🏠 Home")
local HomeSection = HomeTab:NewSection("Welcome to MonsHub!")

HomeSection:NewLabel("🌱 Plants vs Brainrots Script v2.0")
HomeSection:NewLabel("Created by: MonsHub Team")
HomeSection:NewLabel("Game by: Yo Gurt Studios")
HomeSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")

HomeSection:NewButton("Discord Server", "Join our Discord", function()
    setclipboard("discord.gg/monshub")
    Notify("Discord", "Discord link copied to clipboard!", 3)
end)

HomeSection:NewButton("Check for Updates", "Check latest version", function()
    Notify("Version Check", "You are running version 2.0.0", 3)
end)

HomeSection:NewDropdown("Change Theme", "Select UI theme", ThemeList, function(theme)
    Library:ChangeTheme(theme)
    Notify("Theme", "Theme changed to: " .. theme, 3)
end)

-- TAB: MAIN
local MainTab = Window:NewTab("⚙️ Main")
local MainSection = MainTab:NewSection("Main Features")

MainSection:NewToggle("Anti AFK (20 Minutes)", "Prevents auto-disconnect", function(state)
    Settings.AntiAFK = state
    Notify("Anti AFK", "Anti AFK: " .. (state and "ON" or "OFF"), 3)
end)

MainSection:NewToggle("Auto Collect Drops", "Automatically collect money/coins", function(state)
    Settings.AutoCollectDrops = state
    Notify("Auto Collect", "Auto Collect: " .. (state and "ON" or "OFF"), 3)
end)

MainSection:NewToggle("Auto Rejoin on Disconnect", "Rejoin automatically", function(state)
    Settings.AutoRejoin = state
    Notify("Auto Rejoin", "Auto Rejoin: " .. (state and "ON" or "OFF"), 3)
end)

MainSection:NewToggle("God Mode", "Infinite health", function(state)
    Settings.GodMode = state
    Notify("God Mode", "God Mode: " .. (state and "ON" or "OFF"), 3)
end)

MainSection:NewButton("Claim Daily Rewards", "Claim all dailies", function()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("ClaimDaily") then
            ReplicatedStorage.ClaimDaily:FireServer()
        end
        if ReplicatedStorage:FindFirstChild("DailyReward") then
            ReplicatedStorage.DailyReward:FireServer()
        end
    end)
    Notify("Daily Rewards", "Claiming daily rewards...", 3)
end)

MainSection:NewButton("Redeem All Codes", "Redeem codes", function()
    local codes = {"RELEASE", "1KLIKES", "5KLIKES", "10KLIKES", "FREEGEMS"}
    for _, code in pairs(codes) do
        pcall(function()
            if ReplicatedStorage:FindFirstChild("RedeemCode") then
                ReplicatedStorage.RedeemCode:FireServer(code)
            end
        end)
        wait(0.5)
    end
    Notify("Codes", "Redeemed all codes!", 3)
end)

-- TAB: FARM
local FarmTab = Window:NewTab("⚡ Farm")
local BrainrotSection = FarmTab:NewSection("🔥 Brainrot Farming")

BrainrotSection:NewToggle("Auto Farm Brainrot", "Farm all Brainrots", function(state)
    Settings.AutoFarmBrainrot = state
    Notify("Auto Farm", "Auto Farm: " .. (state and "ON" or "OFF"), 3)
end)

BrainrotSection:NewToggle("Auto Farm Boss", "Farm bosses only", function(state)
    Settings.AutoFarmBoss = state
    Notify("Auto Boss", "Auto Boss: " .. (state and "ON" or "OFF"), 3)
end)

BrainrotSection:NewToggle("Instant Kill", "One-hit Brainrots", function(state)
    Settings.InstantKill = state
    Notify("Instant Kill", "Instant Kill: " .. (state and "ON" or "OFF"), 3)
end)

BrainrotSection:NewSlider("Farm Distance", "Max distance to farm", 100, 10, function(value)
    Settings.FarmDistance = value
end)

BrainrotSection:NewSlider("Auto Equip Delay", "Delay in seconds", 10, 1, function(value)
    Settings.AutoEquipBestDelay = value
end)

BrainrotSection:NewToggle("Auto Equip Best Brainrot", "Equip highest power", function(state)
    Settings.AutoEquipBestBrainrot = state
    Notify("Auto Equip", "Auto Equip: " .. (state and "ON" or "OFF"), 3)
end)

BrainrotSection:NewButton("Kill All Brainrots", "One-time kill all", function()
    local brainrots = GetBrainrots()
    for _, brainrot in pairs(brainrots) do
        AttackBrainrot(brainrot)
        if Settings.InstantKill then
            pcall(function()
                brainrot.Humanoid.Health = 0
            end)
        end
    end
    Notify("Kill All", "Killed " .. #brainrots .. " Brainrots!", 3)
end)

local PlantSection = FarmTab:NewSection("🌱 Plant Management")

PlantSection:NewDropdown("Select Brainrot Rarity", "Target rarity", BrainrotRarities, function(rarity)
    Settings.SelectedBrainrotRarity = rarity
end)

PlantSection:NewDropdown("Select Plant", "Choose plant", PlantList, function(plant)
    Settings.SelectedPlant = plant
end)

PlantSection:NewToggle("Auto Move Plant", "Move to Brainrot row", function(state)
    Settings.AutoMovePlant = state
    Notify("Auto Move", "Auto Move: " .. (state and "ON" or "OFF"), 3)
end)

PlantSection:NewToggle("Auto Buy Plants", "Buy plants automatically", function(state)
    Settings.AutoBuyPlants = state
    spawn(function()
        while Settings.AutoBuyPlants do
            wait(5)
            pcall(function()
                if Settings.SelectedPlant and ReplicatedStorage:FindFirstChild("BuyPlant") then
                    ReplicatedStorage.BuyPlant:FireServer(Settings.SelectedPlant)
                end
            end)
        end
    end)
end)

PlantSection:NewToggle("Auto Upgrade Plants", "Upgrade all plants", function(state)
    Settings.AutoUpgradePlants = state
    spawn(function()
        while Settings.AutoUpgradePlants do
            wait(3)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("UpgradePlant") then
                    ReplicatedStorage.UpgradePlant:FireServer()
                end
                if ReplicatedStorage:FindFirstChild("UpgradeAll") then
                    ReplicatedStorage.UpgradeAll:FireServer()
                end
            end)
        end
    end)
end)

local GearSection = FarmTab:NewSection("🛠 Gear System")

GearSection:NewDropdown("Select Gear", "Choose gear", GearList, function(gear)
    Settings.SelectedGear = gear
end)

GearSection:NewDropdown("Gear Target Rarity", "Target rarity", BrainrotRarities, function(rarity)
    Settings.SelectedGearRarity = rarity
end)

GearSection:NewSlider("Auto Gear Delay", "Delay in seconds", 10, 1, function(value)
    Settings.AutoGearDelay = value
end)

GearSection:NewToggle("Auto Use Gear", "Use gear automatically", function(state)
    Settings.AutoUseGear = state
    Notify("Auto Gear", "Auto Gear: " .. (state and "ON" or "OFF"), 3)
end)

-- TAB: EVENT
local EventTab = Window:NewTab("🎉 Event")
local CardSection = EventTab:NewSection("📇 Card Event")

CardSection:NewToggle("Auto Place Required Brainrot", "Auto for card event", function(state)
    Settings.AutoPlaceRequiredBrainrot = state
    Notify("Card Event", "Card Event: " .. (state and "ON" or "OFF"), 3)
end)

CardSection:NewLabel("Automatically places required Brainrot")

local HalloweenSection = EventTab:NewSection("🎃 Halloween Event")

HalloweenSection:NewDropdown("Select Item", "Choose item", HalloweenItems, function(item)
    Settings.SelectedHalloweenItem = item
end)

HalloweenSection:NewToggle("Auto Buy Item", "Buy event items", function(state)
    Settings.AutoBuyHalloweenItem = state
    Notify("Halloween", "Auto Buy: " .. (state and "ON" or "OFF"), 3)
end)

local QuestSection = EventTab:NewSection("📋 Quests")

QuestSection:NewToggle("Auto Complete Quests", "Complete all quests", function(state)
    Settings.AutoCompleteQuests = state
    spawn(function()
        while Settings.AutoCompleteQuests do
            wait(5)
            pcall(function()
                if ReplicatedStorage:FindFirstChild("CompleteQuest") then
                    for i = 1, 50 do
                        ReplicatedStorage.CompleteQuest:FireServer(i)
                    end
                end
            end)
        end
    end)
end)

QuestSection:NewButton("Claim All Quests", "Claim rewards", function()
    pcall(function()
        if ReplicatedStorage:FindFirstChild("ClaimQuest") then
            for i = 1, 50 do
                ReplicatedStorage.ClaimQuest:FireServer(i)
            end
        end
    end)
    Notify("Quests", "Claimed all quest rewards!", 3)
end)

-- TAB: SHOP
local ShopTab = Window:NewTab("🛒 Shop")
local ShopSection = ShopTab:NewSection("Shop Features")

ShopSection:NewToggle("Auto Spin", "Spin wheel automatically", function(state)
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
    Notify("Auto Spin", "Auto Spin: " .. (state and "ON" or "OFF"), 3)
end)

ShopSection:NewDropdown("Select Crate", "Choose crate", CrateList, function(crate)
    Settings.SelectedCrate = crate
end)

ShopSection:NewToggle("Auto Open Crate", "Open crates", function(state)
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
    Notify("Auto Crate", "Auto Crate: " .. (state and "ON" or "OFF"), 3)
end)

ShopSection:NewToggle("Auto Merge Items", "Merge duplicates", function(state)
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
    Notify("Auto Merge", "Auto Merge: " .. (state and "ON" or "OFF"), 3)
end)

ShopSection:NewButton("Buy All Available Items", "Mass purchase", function()
    pcall(function()
        for _, item in pairs(PlantList) do
            BuyItem(item)
            wait(0.3)
        end
    end)
    Notify("Shop", "Buying all available items...", 3)
end)

-- TAB: WEBHOOK
local WebhookTab = Window:NewTab("📨 Webhook")
local WebhookSection = WebhookTab:NewSection("Discord Webhook")

WebhookSection:NewTextBox("Webhook URL", "Paste Discord webhook", function(url)
    Settings.WebhookURL = url
    Notify("Webhook", "Webhook URL set!", 3)
end)

WebhookSection:NewToggle("Enable Webhook", "Turn on notifications", function(state)
    Settings.WebhookEnabled = state
    Notify("Webhook", "Webhook: " .. (state and "Enabled" or "Disabled"), 3)
end)

WebhookSection:NewToggle("Notify Good Drop", "Alert on good drops", function(state)
    Settings.NotifyGoodDrop = state
end)

WebhookSection:NewToggle("Notify Rare Brainrot", "Alert on rare enemies", function(state)
    Settings.NotifyRareBrainrot = state
end)

WebhookSection:NewToggle("Notify Level Up", "Alert on level up", function(state)
    Settings.NotifyLevelUp = state
end)

WebhookSection:NewButton("Test Webhook", "Send test message", function()
    SendWebhook(
        "🧪 Test Webhook",
        "MonsHub webhook is working!\\nGame: Plants vs Brainrots\\nPlayer: " .. Player.Name,
        3447003
    )
    Notify("Webhook", "Test message sent!", 3)
end)

WebhookSection:NewLabel("Sends notifications to your Discord")

-- TAB: PLAYER
local PlayerTab = Window:NewTab("👤 Player")
local MovementSection = PlayerTab:NewSection("Movement")

MovementSection:NewSlider("Walk Speed", "Speed multiplier", 200, 16, function(value)
    Settings.WalkSpeed = value
    if Humanoid then
        Humanoid.WalkSpeed = value
    end
end)

MovementSection:NewSlider("Jump Power", "Jump height", 300, 50, function(value)
    Settings.JumpPower = value
    if Humanoid then
        Humanoid.JumpPower = value
    end
end)

MovementSection:NewToggle("Infinite Jump", "Jump infinitely", function(state)
    Settings.InfiniteJump = state
end)

MovementSection:NewToggle("NoClip", "Walk through walls", function(state)
    Settings.NoClip = state
end)

MovementSection:NewSlider("Fly Speed", "Flight speed", 200, 50, function(value)
    Settings.FlySpeed = value
    flySpeed = value
end)

MovementSection:NewToggle("Fly (WASD to move)", "Enable flying", function(state)
    Settings.FlyEnabled = state
    if state then
        Fly()
    else
        flying = false
    end
end)

local VisualsSection = PlayerTab:NewSection("👁 Visuals")

VisualsSection:NewToggle("ESP Brainrots", "Highlight enemies", function(state)
    Settings.ESPBrainrots = state
    if not state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
                obj:Destroy()
            end
        end
    end
end)

VisualsSection:NewToggle("ESP Drops", "Highlight money/coins", function(state)
    Settings.ESPDrops = state
end)

VisualsSection:NewToggle("Full Bright", "Remove darkness", function(state)
    Settings.FullBright = state
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

VisualsSection:NewToggle("Remove Fog", "Clear fog", function(state)
    Settings.RemoveFog = state
    if state then
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.FogEnd = 500
    end
end)

VisualsSection:NewButton("Remove All ESP", "Clear highlights", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "ESP_Highlight" or obj.Name == "ESP_Billboard" then
            obj:Destroy()
        end
    end
    Notify("ESP", "All ESP removed!", 3)
end)

-- TAB: TELEPORT
local TeleportTab = Window:NewTab("🌐 Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Locations")

TeleportSection:NewButton("Teleport to Spawn", "Go to spawn", function()
    pcall(function()
        if Workspace:FindFirstChild("SpawnLocation") then
            TeleportTo(Workspace.SpawnLocation.Position)
        end
    end)
    Notify("Teleport", "Teleporting to spawn...", 2)
end)

TeleportSection:NewButton("Teleport to Shop", "Go to shop", function()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("shop") and obj:IsA("BasePart") then
                TeleportTo(obj.Position)
                break
            end
        end
    end)
    Notify("Teleport", "Teleporting to shop...", 2)
end)

TeleportSection:NewButton("Teleport to Garden", "Go to garden", function()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj.Name:lower():find("garden") or obj.Name:lower():find("plot")) and obj:IsA("BasePart") then
                TeleportTo(obj.Position)
                break
            end
        end
    end)
    Notify("Teleport", "Teleporting to garden...", 2)
end)

TeleportSection:NewDropdown("Select Biome", "Choose biome", BiomeList, function(biome)
    Settings.SelectedBiome = biome
end)

TeleportSection:NewButton("Teleport to Biome", "Go to selected biome", function()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find(Settings.SelectedBiome:lower()) and obj:IsA("BasePart") then
                TeleportTo(obj.Position)
                break
            end
        end
    end)
    Notify("Teleport", "Teleporting to " .. Settings.SelectedBiome .. "...", 2)
end)

TeleportSection:NewButton("Teleport to Nearest Brainrot", "Go to enemy", function()
    local brainrots = GetBrainrots()
    if #brainrots > 0 and brainrots[1]:FindFirstChild("HumanoidRootPart") then
        TeleportTo(brainrots[1].HumanoidRootPart.Position)
        Notify("Teleport", "Teleporting to Brainrot...", 2)
    end
end)

TeleportSection:NewButton("Teleport to Nearest Drop", "Go to money", function()
    local drops = GetDrops()
    if #drops > 0 then
        TeleportTo(drops[1].Position)
        Notify("Teleport", "Teleporting to drop...", 2)
    end
end)

local BiomeSection = TeleportTab:NewSection("🌍 Biome Unlocking")

BiomeSection:NewButton("Unlock All Biomes", "Unlock all areas", function()
    pcall(function()
        for _, biome in pairs(BiomeList) do
            if ReplicatedStorage:FindFirstChild("UnlockBiome") then
                ReplicatedStorage.UnlockBiome:FireServer(biome)
            end
            wait(0.2)
        end
    end)
    Notify("Biomes", "Attempting to unlock all biomes...", 3)
end)

-- TAB: MISC
local MiscTab = Window:NewTab("🔧 Misc")
local MiscSection = MiscTab:NewSection("Miscellaneous")

MiscSection:NewButton("Rejoin Server", "Rejoin current server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)

MiscSection:NewButton("Server Hop", "Find new server", function()
    local Http = HttpService
    local TPS = TeleportService
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

MiscSection:NewButton("Copy Game Link", "Copy to clipboard", function()
    setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
    Notify("Game Link", "Link copied to clipboard!", 3)
end)

MiscSection:NewButton("FPS Boost", "Optimize performance", function()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
            if obj:IsA("Explosion") then
                obj.BlastPressure = 1
                obj.BlastRadius = 1
            end
        end
    end)
    Notify("FPS Boost", "Performance optimized!", 3)
end)

local InfoSection = MiscTab:NewSection("ℹ️ Information")

InfoSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")
InfoSection:NewLabel("🌱 MonsHub v2.0.0")
InfoSection:NewLabel("Game: Plants vs Brainrots")
InfoSection:NewLabel("by Yo Gurt Studios")
InfoSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")
InfoSection:NewLabel("Script by: MonsHub Team")
InfoSection:NewLabel("UI: Kavo UI Library")
InfoSection:NewLabel("Last Updated: " .. os.date("%m/%d/%Y"))
InfoSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")

InfoSection:NewButton("Join Discord", "Get support", function()
    setclipboard("discord.gg/monshub")
    Notify("Discord", "Discord link copied!", 3)
end)

-- Initialize
Notify("🌱 MonsHub Loaded!", "Plants vs Brainrots v2.0 - Ready to use!", 5)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🌱 MonsHub - Plants vs Brainrots")
print("Version: 2.0.0")
print("Game by: Yo Gurt Studios")
print("UI: Kavo UI Library")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("All features loaded successfully!")
print("Total Tabs: 9")
print("Total Features: 70+")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
