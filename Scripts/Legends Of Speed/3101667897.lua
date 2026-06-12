GUI:NavSection("Main")
local MainSec = GUI:CreateTab({ name = "Farming", icon = "" })
MainSec:Section({ name = "Main Farm" })

local FarmOrbs = false
MainSec:Toggle({
    name     = "Farm Orbs",
    default  = false,
    callback = function(v)
        speedActive = v
		if v then
        	Auto_Orb_Farm()
		end
    end,
})

local FarmGems = false
MainSec:Toggle({
    name     = "Farm Gems",
    default  = false,
    callback = function(v)
        FarmGems = v
		if v then
        	Auto_Gem_Farm()
		end
    end,
})

local FarmXP = false
MainSec:Toggle({
    name     = "Farm XP",
    default  = false,
    callback = function(v)
        FarmXP = v
		if v then
        	Auto_XP_Farm()
		end
    end,
})

local FarmJumps = false
MainSec:Toggle({
    name     = "Farm Jumps",
    default  = false,
    callback = function(v)
        FarmJumps = v
		if v then
			Auto_Hoops_Farm()
		end
    end,
})

local AutoRebirth = false
MainSec:Toggle({
    name     = "Auto Rebirth",
    default  = false,
    callback = function(v)
        AutoRebirth = v
		if v then
        	Auto_Rebirth()
		end
    end,
})

-- ── Tab 1: Main ─────────────────────────────────────────────────────────────
function Auto_Orb_Farm()
	task.spawn(function()
    while FarmOrbs do
			local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
			Event:FireServer("collectOrb", "Orange Orb", "City")
			task.wait(0.5)
		end
	end)
end

function Auto_Gem_Farm()
	task.spawn(function()
	while FarmGems do
			local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
			Event:FireServer("collectOrb", "Gem", "City")
			task.wait(0.5)
		end
	end)
end

function Auto_XP_Farm()
	task.spawn(function()
	while FarmXP do
			local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
			Event:FireServer("collectOrb", "Yellow Orb", "City")
			task.wait(0.5)
		end
	end)
end

function Auto_Hoops_Farm()
	task.spawn(function()
	while FarmJumps do
			local hoopsFolder = workspace.Hoops
			local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local head = character:WaitForChild("Head")

			for i, v in pairs(hoopsFolder:GetChildren()) do 
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
			task.wait(0.5)
		end
	end)
end

function Auto_Rebirth()
	task.spawn(function()
	while AutoRebirth do
			local Event = game:GetService("ReplicatedStorage").rEvents.rebirthEvent
			Event:FireServer("rebirthRequest")
			task.wait(0.5)
		end
	end)
end
