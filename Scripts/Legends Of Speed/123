-- Variablen für die Schleifen
local FarmOrbs = false
local FarmGems = false
local FarmXP = false
local FarmJumps = false
local AutoRebirth = false

-- ── DEFINITION DER FUNKTIONEN (Zuerst, damit die Toggles sie kennen) ───

local function Auto_Orb_Farm()
    task.spawn(function()
        while FarmOrbs do
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("rEvents", 5)
            if Event then
                Event.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
            end
            task.wait(0.1) -- Etwas schnelleres Farming
        end
    end)
end

local function Auto_Gem_Farm()
    task.spawn(function()
        while FarmGems do
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("rEvents", 5)
            if Event then
                Event.orbEvent:FireServer("collectOrb", "Gem", "City")
            end
            task.wait(0.1)
        end
    end)
end

local function Auto_XP_Farm()
    task.spawn(function()
        while FarmXP do
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("rEvents", 5)
            if Event then
                Event.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
            end
            task.wait(0.1)
        end
    end)
end

local function Auto_Hoops_Farm()
    task.spawn(function()
        while FarmJumps do
            local hoopsFolder = workspace:FindFirstChild("Hoops")
            local player = game.Players.LocalPlayer
            local character = player.Character
            local head = character and character:FindFirstChild("Head")

            if hoopsFolder and head then
                for _, v in ipairs(hoopsFolder:GetChildren()) do 
                    if not FarmJumps then break end -- Sofort stoppen, wenn Toggle ausgemacht wird
                    
                    if v:IsA("MeshPart") then
                        firetouchinterest(head, v, 0)
                        task.wait()
                        firetouchinterest(head, v, 1)
                    elseif v:IsA("Model") then
                        local targetPart = v:FindFirstChild("Part")
                        if targetPart then
                            firetouchinterest(head, targetPart, 0)
                            task.wait()
                            firetouchinterest(head, targetPart, 1)
                        end
                    end    
                end
            end
            task.wait(0.5)
        end
    end)
end

local function Auto_Rebirth()
    task.spawn(function()
        while AutoRebirth do
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("rEvents", 5)
            if Event then
                Event.rebirthEvent:FireServer("rebirthRequest")
            end
            task.wait(0.5)
        end
    end)
end

-- ── UI ERSTELLUNG ───

-- Hier erstellen wir den Tab
local MainTab = GUI:CreateTab({ name = "Farming", icon = "" })

-- Hier erstellen wir die Sektion (Das ersetzt dein fehlerhaftes GUI:NavSection)
MainTab:Section({ name = "Main Farm" })

-- Toggles hinzufügen
MainTab:Toggle({
    name     = "Farm Orbs",
    default  = false,
    callback = function(v)
        FarmOrbs = v -- FEHLER BEHOBEN: War vorher speedActive
        if v then
            Auto_Orb_Farm()
        end
    end,
})

MainTab:Toggle({
    name     = "Farm Gems",
    default  = false,
    callback = function(v)
        FarmGems = v
        if v then
            Auto_Gem_Farm()
        end
    end,
})

MainTab:Toggle({
    name     = "Farm XP",
    default  = false,
    callback = function(v)
        FarmXP = v
        if v then
            Auto_XP_Farm()
        end
    end,
})

MainTab:Toggle({
    name     = "Farm Jumps",
    default  = false,
    callback = function(v)
        FarmJumps = v
        if v then
            Auto_Hoops_Farm()
        end
    end,
})

MainTab:Toggle({
    name     = "Auto Rebirth",
    default  = false,
    callback = function(v)
        AutoRebirth = v
        if v then
            Auto_Rebirth()
        end
    end,
})
