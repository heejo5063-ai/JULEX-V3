-- [[ JULEX: FRIEND EDITION ]]
-- [ PC UI STYLE | PERMANENT ORBIT | KEY: BOOK ]

local AUTH_KEY = "BOOK"
local INPUT_KEY = "BOOK" -- เพื่อนใส่ BOOK เพื่อเข้าใช้งาน

if INPUT_KEY ~= AUTH_KEY then
    game.Players.LocalPlayer:Kick("JULEX: Key Incorrect!")
    return
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "JULEX | FRIEND EDITION",
    Footer = "PC Style UI | Key: BOOK",
    NotifySide = "Right",
})

-- [[ ⚙️ GLOBALS ]]
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local orbitTarget = nil
local orbitAngle = 0

-- [[ 📑 TABS ]]
local Tabs = {
    Combat = Window:AddTab("Combat (PC Style)", "crosshair"),
    Orbit = Window:AddTab("Orbit Control", "refresh-cw"),
    Visuals = Window:AddTab("Visuals & ESP", "eye"),
    Settings = Window:AddTab("Movement & Misc", "settings"),
}

-- [[ 🥊 1. COMBAT (Silent Aim + FOV + Lines) ]]
local AimBox = Tabs.Combat:AddLeftGroupbox("Silent Aim System")
AimBox:AddToggle("SilentAim", { Text = "Enable Silent Aim", Default = true })
AimBox:AddToggle("ShowFOV", { Text = "Show FOV Circle", Default = true })
AimBox:AddSlider("FOVSize", { Text = "FOV Radius", Default = 150, Min = 10, Max = 800 })
AimBox:AddToggle("ShowLines", { Text = "Show Snaplines", Default = true })

local AssistBox = Tabs.Combat:AddRightGroupbox("Crosshair Settings")
AssistBox:AddToggle("ShowSpinX", { Text = "Spinning X (White)", Default = true })
AssistBox:AddSlider("SpinSpeed", { Text = "Spin Speed", Default = 10, Min = 1, Max = 50 })

-- [[ 🔄 2. ORBIT CONTROL (บินจนกว่าจะสั่งหยุด) ]]
local OrbitBox = Tabs.Orbit:AddLeftGroupbox("Advanced Orbit")
OrbitBox:AddInput("OrbitInput", {
    Text = "ชื่อย่อเป้าหมาย",
    Callback = function(Value)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and (v.Name:lower():find(Value:lower()) or v.DisplayName:lower():find(Value:lower())) then
                orbitTarget = v; Library:Notify("Target Locked: " .. v.DisplayName) break
            end
        end
    end
})
OrbitBox:AddToggle("EnableOrbit", { Text = "Start Orbiting (บินวนรอบตัว)", Default = false })
OrbitBox:AddSlider("OrbitRadius", { Text = "Distance", Default = 10, Min = 5, Max = 30 })
OrbitBox:AddSlider("OrbitSpeed", { Text = "Speed", Default = 8, Min = 1, Max = 30 })

-- [[ 👁️ 3. VISUALS (ESP) ]]
local VisualBox = Tabs.Visuals:AddLeftGroupbox("ESP Settings")
VisualBox:AddToggle("EspName", { Text = "Show Names (มองชื่อ)", Default = true })
VisualBox:AddToggle("EspHealth", { Text = "Show Health (มองเลือด)", Default = true })

-- [[ ⚙️ 4. MOVEMENT & MISC ]]
local MiscBox = Tabs.Settings:AddLeftGroupbox("Movement Upgrades")
MiscBox:AddSlider("WalkSpeed", { Text = "Speed (วิ่งเร็ว)", Default = 32, Min = 16, Max = 300 })
MiscBox:AddSlider("JumpPower", { Text = "Jump (กระโดดสูง)", Default = 50, Min = 50, Max = 500 })

-- [[ 🎨 DRAWINGS ]]
local FovCircle = Drawing.new("Circle"); FovCircle.Filled = false; FovCircle.Color = Color3.new(1,1,1); FovCircle.Thickness = 1
local TargetLine = Drawing.new("Line"); TargetLine.Thickness = 1; TargetLine.Color = Color3.new(1,1,1)
local X1 = Drawing.new("Line"); X1.Thickness = 1.5; X1.Color = Color3.new(1,1,1)
local X2 = Drawing.new("Line"); X2.Thickness = 1.5; X2.Color = Color3.new(1,1,1)

-- [[ 🔍 SCAN TARGET ]]
local function GetClosest()
    local target, dist = nil, Library.Options.FOVSize.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if m < dist then target = v; dist = m end
            end
        end
    end
    return target
end

-- [[ 🎯 SILENT AIM ]]
local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__index
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and Library.Toggles.SilentAim.Value and self == mouse and (idx == "Hit" or idx == "Target") then
        local t = GetClosest()
        if t then return (idx == "Hit" and t.Character.Head.CFrame or t.Character.Head) end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

-- [[ 🔄 MASTER LOOP ]]
runService.RenderStepped:Connect(function()
    local tar = GetClosest()
    local sAng = os.clock() * Library.Options.SpinSpeed.Value
    
    -- Movement
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Library.Options.WalkSpeed.Value
        lp.Character.Humanoid.JumpPower = Library.Options.JumpPower.Value
    end

    -- Orbit (บินจนกว่าจะปิดหรือเปลี่ยนคน)
    if Library.Toggles.EnableOrbit.Value and orbitTarget and orbitTarget.Character and orbitTarget.Character:FindFirstChild("HumanoidRootPart") then
        orbitAngle = orbitAngle + math.rad(Library.Options.OrbitSpeed.Value)
        local offset = Vector3.new(math.cos(orbitAngle) * Library.Options.OrbitRadius.Value, 0, math.sin(orbitAngle) * Library.Options.OrbitRadius.Value)
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(orbitTarget.Character.HumanoidRootPart.Position + offset, orbitTarget.Character.HumanoidRootPart.Position)
        lp.Character.HumanoidRootPart.Velocity = Vector3.zero
    end

    -- Visuals
    FovCircle.Visible = Library.Toggles.ShowFOV.Value
    FovCircle.Radius = Library.Options.FOVSize.Value
    FovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    if tar then
        local p, on = cam:WorldToViewportPoint(tar.Character.Head.Position)
        if on then
            if Library.Toggles.ShowSpinX.Value then
                local s = 10; local c, s2 = math.cos(sAng)*s, math.sin(sAng)*s
                X1.From = Vector2.new(p.X-c, p.Y-s2); X1.To = Vector2.new(p.X+c, p.Y+s2); X1.Visible = true
                X2.From = Vector2.new(p.X+s2, p.Y-c); X2.To = Vector2.new(p.X-s2, p.Y+c); X2.Visible = true
            else X1.Visible = false; X2.Visible = false end
            
            if Library.Toggles.ShowLines.Value then
                TargetLine.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2); TargetLine.To = Vector2.new(p.X, p.Y); TargetLine.Visible = true
            else TargetLine.Visible = false end
        end
    else X1.Visible = false; X2.Visible = false; TargetLine.Visible = false end
end)

-- [[ 🧱 FULL ESP (NAME & HEALTH) ]]
function CreateESP(plr)
    local bg = Instance.new("BillboardGui", game.CoreGui)
    bg.Size = UDim2.new(0, 100, 0, 50); bg.AlwaysOnTop = true
    local n = Instance.new("TextLabel", bg); n.Size = UDim2.new(1,0,0,20); n.BackgroundTransparency = 1; n.TextColor3 = Color3.new(1,1,1); n.TextStrokeTransparency = 0; n.TextSize = 14
    local f = Instance.new("Frame", bg); f.Size = UDim2.new(0,40,0,4); f.Position = UDim2.new(0.5,-20,0,25); f.BackgroundColor3 = Color3.new(0,0,0)
    local b = Instance.new("Frame", f); b.Size = UDim2.new(1,0,1,0); b.BackgroundColor3 = Color3.new(0,1,0); b.BorderSizePixel = 0
    runService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") and (Library.Toggles.EspName.Value or Library.Toggles.EspHealth.Value) then
            bg.Adornee = plr.Character:FindFirstChild("Head")
            n.Text = plr.DisplayName; n.Visible = Library.Toggles.EspName.Value
            local hp = math.clamp(plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth, 0, 1)
            b.Size = UDim2.new(hp,0,1,0); f.Visible = Library.Toggles.EspHealth.Value; bg.Enabled = true
        else bg.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
game.Players.PlayerAdded:Connect(CreateESP)

Library:Notify("JULEX FRIEND EDITION LOADED | KEY: BOOK")
