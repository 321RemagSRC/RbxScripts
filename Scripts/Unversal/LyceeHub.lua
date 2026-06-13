local GUI = _G.GUI
local LP = _G.LP
local UIS = _G.UIS
local RunService = _G.RunService
local Lighting = game:GetService("Lighting")

local function char() return _G.char() end
local function hum()  return _G.hum() end
local function hrp()  return _G.hrp() end

-- ── Tab: Player / Universal ──────────────────────────────────────────────────
GUI:NavSection("Universal")
local UniversalSec = GUI:CreateTab({ name = "Player", icon = "" })

UniversalSec:Section({ name = "Movement" })

local speedValue  = 16
local speedActive = false

UniversalSec:Toggle({
    name     = "Speed changer",
    default  = false,
    callback = function(v)
        speedActive = v
        local h = hum()
        if h then h.WalkSpeed = v and speedValue or 16 end
    end,
})

UniversalSec:Slider({
    name     = "Walk Speed",
    min      = 16, max = 350, default = 16,
    suffix   = " ws",
    callback = function(v)
        speedValue = v
        if speedActive then
            local h = hum()
            if h then h.WalkSpeed = v end
        end
    end,
})

UniversalSec:Slider({
    name     = "Jump Power",
    min      = 7, max = 300, default = 7,
    suffix   = " jp",
    callback = function(v)
        local h = hum()
        if h then h.JumpPower = v end
    end,
})

local camera = workspace.CurrentCamera
local flyspeedValue = 16
local flyspeedActive = false
local flyConnection = nil
local flyVelocity = nil
local flyGyro = nil

local function root()
    local c = char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function startFlying()
    local hrpPart = root()
    local humanoid = hum()
    if not hrpPart or not humanoid then return end

    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end

    flyGyro = Instance.new("BodyGyro")
    flyGyro.P = 9e4
    flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.cframe = hrpPart.CFrame
    flyGyro.Parent = hrpPart

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.velocity = Vector3.new(0, 0.1, 0)
    flyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVelocity.Parent = hrpPart

    humanoid.PlatformStand = true

    flyConnection = RunService.RenderStepped:Connect(function()
        local currentHrp = root()
        local currentHumanoid = hum()
        
        if not currentHrp or not currentHumanoid or not flyspeedActive then 
            if flyConnection then flyConnection:Disconnect() end
            return 
        end

        local moveDirection = currentHumanoid.MoveDirection
        local cameraCFrame = camera.CFrame
        local flyVec = Vector3.new(0, 0, 0)

        if moveDirection.Magnitude > 0 then
            local lookVector = cameraCFrame.LookVector
            local rightVector = cameraCFrame.RightVector
            local moveX = moveDirection:Dot(cameraCFrame.RightVector)
            local moveZ = moveDirection:Dot(cameraCFrame.LookVector)
            
            flyVec = (lookVector * moveZ) + (rightVector * moveX)
            if flyVec.Magnitude > 0 then flyVec = flyVec.Unit end
        end

        flyVelocity.velocity = flyVec * flyspeedValue
        flyGyro.cframe = cameraCFrame
    end)
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end
    
    local humanoid = hum()
    if humanoid then humanoid.PlatformStand = false end
end

UniversalSec:Toggle({
    name     = "Fly",
    default  = false,
    callback = function(v)
        flyspeedActive = v
        if flyspeedActive then startFlying() else stopFlying() end
    end,
})

UniversalSec:Slider({
    name     = "Fly Speed",
    min      = 16, max = 350, default = 16,
    suffix   = " ws",
    callback = function(v) flyspeedValue = v end,
})

UniversalSec:Section({ name = "Extras" })

local noclipConn
UniversalSec:Toggle({
    name        = "Noclip",
    description = "Walk through walls",
    default     = false,
    callback    = function(v)
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if v then
            noclipConn = RunService.Stepped:Connect(function()
                local c = char(); if not c then return end
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        end
    end,
})

local jumpConn
UniversalSec:Toggle({
    name     = "Infinite Jump",
    default  = false,
    callback = function(v)
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
        if v then
            jumpConn = UIS.JumpRequest:Connect(function()
                local h = hum()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})

UniversalSec:Button({
    name     = "Teleport Up",
    callback = function()
        local r = hrp()
        if r then pcall(function() r.CFrame = r.CFrame + Vector3.new(0, 50, 0) end) end
    end,
})

local mouse = LP:GetMouse()
local clickTPActive = false
local tpConnection

UniversalSec:Toggle({
    name     = "Click TP (Ctrl + Click)",
    default  = false,
    callback = function(v)
        clickTPActive = v
        if tpConnection then tpConnection:Disconnect(); tpConnection = nil end
        if clickTPActive then
            tpConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local r = hrp()
                    if r and mouse.Target then
                        r.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end,
})

UniversalSec:Button({
    name     = "Respawn",
    callback = function()
        local c = char()
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.Health = 0
        end
    end
})

-- ── Tab: World ───────────────────────────────────────────────────────────────
local WorldTab = GUI:CreateTab({ name = "World", icon = "" })

WorldTab:Section({ name = "Lighting" })
WorldTab:Slider({
    name = "Time of Day", min = 0, max = 24, default = 14, suffix = "h",
    callback = function(v) pcall(function() Lighting.ClockTime = v end) end,
})

WorldTab:Toggle({
    name     = "Fullbright",
    default  = false,
    callback = function(v)
        pcall(function()
            Lighting.Ambient        = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
            Lighting.OutdoorAmbient = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,140)
            Lighting.Brightness     = v and 10 or 2
        end)
    end,
})

WorldTab:Slider({
    name = "Gravity", min = 0, max = 400, default = 196, suffix = " g",
    callback = function(v) pcall(function() workspace.Gravity = v end) end,
})

-- ── Tab: Scripts ─────────────────────────────────────────────────────────────
local ScriptSec = GUI:CreateTab({ name = "Scripts", icon = "" })
ScriptSec:Section({ name = "Admin" })

ScriptSec:Button({
    name     = "Infinite Yield",
    callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end,
})

ScriptSec:Button({
    name     = "Nameless Admin",
    callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))() end,
})

ScriptSec:Section({ name = "Remote Spy's" })
ScriptSec:Button({
    name     = "Remote Spy",
    callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))() end,
})

ScriptSec:Button({
    name     = "Cobalt",
    callback = function() loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))() end,
})

ScriptSec:Section({ name = "Explorer" })
ScriptSec:Button({
    name     = "Dex Explorer",
    callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end,
})

ScriptSec:Button({
    name     = "Dex ++",
    callback = function() loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))() end,
})

-- ── Tab: Troll ───────────────────────────────────────────────────────────────
local TrollSec = GUI:CreateTab({ name = "Troll", icon = "" })
TrollSec:Section({ name = "R15 & R6" })
TrollSec:Toggle({
    name        = "Invisible",
    description = "Hide ur skin for others",
    default     = false,
    callback    = function() _G.Invis = not _G.Invis end,
})

TrollSec:Section({ name = "R15" })
TrollSec:Button({
    name     = "Jerk off",
    callback = function() loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))() end,
})

TrollSec:Section({ name = "R6" })
TrollSec:Button({
    name     = "Jerk off",
    callback = function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))() end,
})

-- ── Tab: Misc ────────────────────────────────────────────────────────────────
GUI:NavSection("MISC")
local MiscTab = GUI:CreateTab({ name = "Misc", icon = "" })

MiscTab:Section({ name = "Utilities" })
MiscTab:Button({
    name     = "Copy UserId",
    callback = function()
        pcall(function() setclipboard(tostring(LP.UserId)) end)
        GUI.notify("Copied", "UserId: " .. LP.UserId, 3)
    end,
})

local afkConn
MiscTab:Toggle({
    name        = "Anti-AFK",
    description = "Prevents inactivity kick",
    default     = false,
    callback    = function(v)
        if afkConn then afkConn:Disconnect(); afkConn = nil end
        if v then
            afkConn = LP.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                pcall(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
                task.wait(0.1)
                pcall(function() vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
            end)
        end
    end,
})

MiscTab:Separator()
MiscTab:ButtonGrid({
    columns = 2,
    buttons = {
        { name = "Copy UserId", icon = "", callback = function()
            pcall(function() setclipboard(tostring(LP.UserId)) end)
            GUI.notify("Copied!", "UserId: " .. LP.UserId, 2, "success")
        end },
        { name = "Rejoin",     icon = "", callback = function()
            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
        end },
    }
})

-- ── Invis Handler Setup ───────────────────────────────────────────────────────
_G.Invis = false
if _G.InvData then
    _G.InvData.Active = false
    task.wait()
    for _, v in pairs(_G.InvData.Conns) do v:Disconnect() end
    _G.InvData = nil
end

local u6, u7, u8
local lastState = nil
local u10 = {}

local function setupInvis()
    local character = char()
    u6 = character or LP.CharacterAdded:Wait()
    u7 = u6:WaitForChild('Humanoid')
    u8 = u6:WaitForChild('HumanoidRootPart')
    u10 = {}
    for _, v in pairs(u6:GetDescendants()) do
        if v:IsA('BasePart') and v.Transparency == 0 then table.insert(u10, v) end
    end
    lastState = nil
end

setupInvis()
local conns = {}
conns[1] = RunService.Heartbeat:Connect(function()
    local currentState = _G.Invis
    if currentState ~= lastState then
        lastState = currentState
        if _G.InvData then _G.InvData.Active = currentState end
        for _, v in pairs(u10) do
            if v.Parent then v.Transparency = currentState and 0.5 or 0 end
        end
    end
    if currentState and u8 and u7 then
        local _CFrame = u8.CFrame
        local _CameraOffset = u7.CameraOffset
        local v40 = _CFrame * CFrame.new(0, -200000, 0)
        local _Position = v40:ToObjectSpace(CFrame.new(_CFrame.Position)).Position
        u8.CFrame = v40
        u7.CameraOffset = _Position
        RunService.RenderStepped:Wait()
        if u8 and u7 then
            u8.CFrame = _CFrame
            u7.CameraOffset = _CameraOffset
        end
    end
end)

LP.CharacterAdded:Connect(function() task.wait(0.5); setupInvis() end)
_G.InvData = {Active = _G.Invis, Conns = conns, Gui = nil}