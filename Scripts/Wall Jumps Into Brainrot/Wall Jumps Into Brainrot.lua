local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

local Window = MacLib:Window({
    Title = "LyceeBrain",
    Subtitle = "Free | V0.0.1",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    Keybind = Enum.KeyCode.RightControl,
})

local Players = game:GetService("Players")
local TARGET_GAME_ID = 133954025408703
local player = Players.LocalPlayer

local function checkGameID()
	local currentPlaceId = game.PlaceId
	
	if not currentPlaceId == TARGET_GAME_ID then
		Window:Notify({
			Title = "LyceeBrain",
			Description = "This script only works for: 133954025408703",
			Lifetime = 5
		})
		Unload()
	end
end

checkGameID()

local TabGroup = Window:TabGroup()

-- --- MAIN TAB ---
local MainTab = TabGroup:Tab({ Name = "Main" })
-- Erzwinge Side = "Left" für jede Sektion
local MainSec = MainTab:Section({ Name = "Hauptmenü", Side = "Left" })
MainSec:Label({ Text = "Welcome to LyceeBrain\n-- Made by 321Remag -- \n\nThis script is free so pls join my Discord server (.gg/QvYFKsjv9k) \nThis is btw my first script so i hope its good :)" })
-- MainSec:Label({ Text = " -- Made by 321Remag --" })

-- --- FARMING TAB ---
_G.ActiveFarms = {}

-- --- FARMING TAB ---
local FarmingTab = TabGroup:Tab({ Name = "Farming" })
local FarmingSec = FarmingTab:Section({ Name = "Auto Farm", Side = "Left" })

-- Funktion zum Erstellen der Toggle-Logik (ohne stopAllFarms)
local function createFarmToggle(name, position, waitTime)
    FarmingSec:Toggle({
        Name = name,
        Default = false,
        Callback = function(State)
            _G.ActiveFarms[name] = State -- Setzt den Status direkt auf den State des Toggles
            
            if State then
                -- Nur wenn der Toggle AN ist, starte den Loop
                task.spawn(function()
                    while _G.ActiveFarms[name] do
                        local player = game.Players.LocalPlayer
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            hrp.CFrame = CFrame.new(position)
                        end
                        task.wait(waitTime)
                    end
                end)
            end
        end
    })
end

-- Toggles hinzufügen
createFarmToggle("Auto Farm Wallhop", Vector3.new(-19.8, 10.8, 3250.1), 9)
createFarmToggle("Auto Farm Easy Obby", Vector3.new(-19.9, 27.3, -331.9), 1)
createFarmToggle("Auto Farm Medium Obby", Vector3.new(-297.2, 41.5, -120.8), 1)
createFarmToggle("Auto Farm Hard Obby", Vector3.new(253.4, 13.9, -114.2), 1)

local UpgradeSec = FarmingTab:Section({ Name = "Auto Upgrades", Side = "Right" })

local function createUpgradeToggle(name)
    _G.ActiveUpgrades = _G.ActiveUpgrades or {}
    
    UpgradeSec:Toggle({
        Name = "Upgrade: " .. name,
        Default = false,
        Callback = function(State)
            _G.ActiveUpgrades[name] = State
            
            if State then
                task.spawn(function()
                    while _G.ActiveUpgrades[name] do
                        local Event = game:GetService("ReplicatedStorage").Remotes.Functions.BuyUpgrade
                        
                        Event:InvokeServer(name) 
                        
                        task.wait(0.001) 
                    end
                end)
            end
        end
    })
end

createUpgradeToggle("Speed")
createUpgradeToggle("Jump")
createUpgradeToggle("Cash")

local BuyTab = TabGroup:Tab({ Name = "Buy" })
local BuySec = BuyTab:Section({ Name = "Buying", Side = "Left" })
local Event = game:GetService("ReplicatedStorage").Remotes.Functions.BuyGear

BuySec:Button({
	Name = "Trash Fusion Coil - $4,000",
	Callback = function()
		Event:InvokeServer("Trash Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Weak Fusion Coil - $7,500",
	Callback = function()
		Event:InvokeServer("Weak Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Decent Fusion Coil - $18,000",
	Callback = function()
		Event:InvokeServer("Decent Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Great Fusion Coil - $32,000",
	Callback = function()
		Event:InvokeServer("Great Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Amazing Fusion Coil - $64,000",
	Callback = function()
		Event:InvokeServer("Amazing Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Huge Gold Slap - $999,999,999",
	Callback = function()
		Event:InvokeServer("Amazing Fusion Coil")
	end,
})

BuySec:Button({
	Name = "Flying Carpet - $99,999,999,999",
	Callback = function()
		Event:InvokeServer("Flying Carpet")
	end,
})

MainTab:Select()
