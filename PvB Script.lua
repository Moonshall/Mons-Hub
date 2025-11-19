--[[
    MonsHub Script for Plants vs Brainrots
    Game: Plants vs Brainrots by Yo Gurt Studios  
    Created: 2025
    Features: Auto Farm Brainrot, Auto Move Plant, Auto Gear, Event Support, and more
    UI: Orion Library (Online Compatible)
]]--

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "🌱 MonsHub | Plants vs Brainrots",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MonsHubPvBR",
    IntroEnabled = true,
    IntroText = "MonsHub Loading..."
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
    
    -- Player Tab
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
    ESPBrainrots = false,
    ESPPlants = false
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
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddLabel("🌱 MonsHub - Plants vs Brainrots")

MainTab:AddToggle({
    Name = "Anti AFK (20 Minutes)",
    Default = false,
    Callback = function(Value)
        Settings.AntiAFK = Value
        OrionLib:MakeNotification({
            Name = "Anti AFK",
            Content = "Anti AFK: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MainTab:AddLabel("Menjaga akun tidak auto-disconnect saat idle")

-- TAB FARM
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddSection({Name = "🔥 Brainrot Section"})

FarmTab:AddToggle({
    Name = "Auto Farm Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarmBrainrot = Value
        OrionLib:MakeNotification({
            Name = "Auto Farm Brainrot",
            Content = "Auto Farm: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

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

FarmTab:AddSection({Name = "🌱 Plant Section"})

FarmTab:AddLabel("Auto Move")

FarmTab:AddDropdown({
    Name = "Select Brainrot Rarity",
    Default = "Common",
    Options = BrainrotRarities,
    Callback = function(Value)
        Settings.SelectedBrainrotRarity = Value
    end
})

FarmTab:AddDropdown({
    Name = "Select Plant",
    Default = "Peashooter",
    Options = PlantList,
    Callback = function(Value)
        Settings.SelectedPlant = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Move Plant",
    Default = false,
    Callback = function(Value)
        Settings.AutoMovePlant = Value
        OrionLib:MakeNotification({
            Name = "Auto Move Plant",
            Content = "Auto Move: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

FarmTab:AddSection({Name = "🛠 Gear Section"})

FarmTab:AddDropdown({
    Name = "Select Gear To Use",
    Default = "Granat",
    Options = GearList,
    Callback = function(Value)
        Settings.SelectedGear = Value
    end
})

FarmTab:AddDropdown({
    Name = "Select Brainrot Rarity",
    Default = "Common",
    Options = BrainrotRarities,
    Callback = function(Value)
        Settings.SelectedGearRarity = Value
    end
})

FarmTab:AddSlider({
    Name = "Auto Gear Delay",
    Min = 1,
    Max = 10,
    Default = 3,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "seconds",
    Callback = function(Value)
        Settings.AutoGearDelay = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Use Gear",
    Default = false,
    Callback = function(Value)
        Settings.AutoUseGear = Value
        OrionLib:MakeNotification({
            Name = "Auto Use Gear",
            Content = "Auto Gear: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- TAB EVENT
local EventTab = Window:MakeTab({
    Name = "Event",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

EventTab:AddSection({Name = "📇 Card Event"})

EventTab:AddToggle({
    Name = "Auto Place Required Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.AutoPlaceRequiredBrainrot = Value
        OrionLib:MakeNotification({
            Name = "Card Event",
            Content = "Auto Place: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

EventTab:AddLabel("Menaruh Brainrot yang diperlukan untuk event Card")

EventTab:AddSection({Name = "🎃 Halloween Event"})

EventTab:AddDropdown({
    Name = "Select Item To Buy",
    Default = "Pumpkin",
    Options = HalloweenItems,
    Callback = function(Value)
        Settings.SelectedHalloweenItem = Value
    end
})

EventTab:AddToggle({
    Name = "Auto Buy Item",
    Default = false,
    Callback = function(Value)
        Settings.AutoBuyHalloweenItem = Value
        OrionLib:MakeNotification({
            Name = "Halloween Event",
            Content = "Auto Buy: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- TAB SHOP
local ShopTab = Window:MakeTab({
    Name = "Shop",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ShopTab:AddSection({Name = "🛒 Shop Features"})

ShopTab:AddToggle({
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
        OrionLib:MakeNotification({
            Name = "Auto Spin",
            Content = "Auto Spin: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

ShopTab:AddDropdown({
    Name = "Select Crate",
    Default = "Basic Crate",
    Options = CrateList,
    Callback = function(Value)
        Settings.SelectedCrate = Value
    end
})

ShopTab:AddToggle({
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
        OrionLib:MakeNotification({
            Name = "Auto Open Crate",
            Content = "Auto Open: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

ShopTab:AddToggle({
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
        OrionLib:MakeNotification({
            Name = "Auto Merge",
            Content = "Auto Merge: " .. (Value and "ON" or "OFF"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- TAB WEBHOOK
local WebhookTab = Window:MakeTab({
    Name = "Webhook",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

WebhookTab:AddSection({Name = "📨 Discord Webhook"})

WebhookTab:AddTextbox({
    Name = "Webhook URL",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        Settings.WebhookURL = Value
        OrionLib:MakeNotification({
            Name = "Webhook",
            Content = "Webhook URL has been set!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

WebhookTab:AddToggle({
    Name = "Enable Webhook",
    Default = false,
    Callback = function(Value)
        Settings.WebhookEnabled = Value
        OrionLib:MakeNotification({
            Name = "Webhook",
            Content = "Webhook: " .. (Value and "Enabled" or "Disabled"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

WebhookTab:AddToggle({
    Name = "Notify Good Drop",
    Default = false,
    Callback = function(Value)
        Settings.NotifyGoodDrop = Value
    end
})

WebhookTab:AddToggle({
    Name = "Notify Rare Brainrot",
    Default = false,
    Callback = function(Value)
        Settings.NotifyRareBrainrot = Value
    end
})

WebhookTab:AddButton({
    Name = "Test Webhook",
    Callback = function()
        SendWebhook(
            "🧪 Test Webhook",
            "MonsHub webhook is working!\\nGame: Plants vs Brainrots",
            3447003
        )
        OrionLib:MakeNotification({
            Name = "Webhook Test",
            Content = "Test message sent to Discord!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

WebhookTab:AddLabel("Kirim notifikasi ke Discord untuk drop bagus & rare Brainrot")

-- TAB PLAYER
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSection({Name = "👤 Player Settings"})

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        Settings.WalkSpeed = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        Settings.JumpPower = Value
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Settings.InfiniteJump = Value
    end
})

PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(Value)
        Settings.NoClip = Value
    end
})

PlayerTab:AddSection({Name = "👁 Visuals"})

PlayerTab:AddToggle({
    Name = "ESP Brainrots",
    Default = false,
    Callback = function(Value)
        Settings.ESPBrainrots = Value
        if not Value then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" then
                    obj:Destroy()
                end
            end
        end
    end
})

PlayerTab:AddToggle({
    Name = "ESP Plants",
    Default = false,
    Callback = function(Value)
        Settings.ESPPlants = Value
    end
})

PlayerTab:AddToggle({
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

-- TAB MISC
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddSection({Name = "⚙️ Miscellaneous"})

MiscTab:AddButton({
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
        OrionLib:MakeNotification({
            Name = "Daily Rewards",
            Content = "Claiming daily rewards...",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MiscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

MiscTab:AddButton({
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

MiscTab:AddSection({Name = "📜 Credits"})

MiscTab:AddLabel("MonsHub - Plants vs Brainrots")
MiscTab:AddLabel("Game by: Yo Gurt Studios")
MiscTab:AddLabel("Script Version: 1.0.0")
MiscTab:AddLabel("UI: Orion Library")

-- Initialize
OrionLib:MakeNotification({
    Name = "🌱 MonsHub Loaded!",
    Content = "Plants vs Brainrots script ready! Enjoy!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("MonsHub - Plants vs Brainrots")
print("Script Version: 1.0.0")
print("Game by: Yo Gurt Studios")
print("UI: Orion Library (Online Compatible)")
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

OrionLib:Init()
