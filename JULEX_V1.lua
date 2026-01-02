-- [[ JULEX V1 | SPECTATE EDITION ]]
-- [ SPECTATE TARGET | ESP FIXED | NO TOUCH SILENT AIM | KEY: BOOK ]

local KEY_AUTH = "BOOK"
local INPUT_KEY = "BOOK"

if INPUT_KEY ~= KEY_AUTH then
    game.Players.LocalPlayer:Kick("JULEX: Access Denied!")
    return
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "JULEX V1 | SPECTATE",
    Footer = "Spectate & God Mode | Key: BOOK",
    NotifySide = "Right",
})

-- [[ ⚙️ GLOBALS ]]
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local targetPlayer = nil
local orbitAngle = 0
local spinAngle = 0
local flying = false

-- [[ 📑 TABS ]]
local Tabs = {
    Combat = Window:AddTab("Combat & Loop", "crosshair"),
    Movement = Window:AddTab("God Physics", "zap"),
    Visuals = Window:AddTab("Visuals & View", "eye"),
}

-- [[ 🥊 1. COMBAT (SILENT AIM เดิม 100%) ]]
local AimBox = Tabs.Combat:AddLeftGroupbox("Silent Aim Setup")
AimBox:AddToggle("SilentAim", { Text = "Enable Silent Aim", Default = true })
AimBox:AddToggle("HitSound", { Text = "Hit Sound (เสียงติ๊ง)", Default = true })

local AssistBox = Tabs.Combat:AddRightGroupbox("Sharp Assist")
AssistBox:AddToggle("AssistEnabled", { Text = "Enable Sharp Lock", Default = true })
AssistBox:AddSlider("Smoothness", { Text = "Smoothness", Default = 5, Min = 1, Max = 50 })
AssistBox:AddToggle("ShowSpinX", { Text = "Show Spinning X (ขาว)", Default = true })

-- [[ 🚀 2. LOOP & ORBIT ]]
local LoopBox = Tabs.Combat:AddLeftGroupbox("Loop & Orbit Control")
LoopBox:AddInput("TargetInput", {
    Text = "ชื่อย่อเป้าหมาย",
    Callback = function(Value)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and (v.Name:lower():find(Value:lower()) or v.DisplayName:lower():find(Value:lower())) then
                targetPlayer = v; Library:Notify("Target Locked: " .. v.DisplayName) break
            end
        end
    end
})
LoopBox:AddToggle("LoopKill", { Text = "Loop Kill (บนหัว)", Default = false })
LoopBox:AddToggle("OrbitKill", { Text = "Orbit Kill (บินรอบ)", Default = false })
LoopBox:AddSlider("OrbitRadius", { Text = "Distance", Default = 8, Min = 2, Max = 40 })
LoopBox:AddSlider("OrbitSpeed", { Text = "Speed", Default = 5, Min = 1, Max = 30 })

-- [[ ⚡ 3. GOD PHYSICS & FLY ]]
local PhysBox = Tabs.Movement:AddLeftGroupbox("Movement Hack")
PhysBox:AddSlider("WalkSpeed", { Text = "Speed (วิ่งเร็ว)", Default = 32, Min = 16, Max = 300 })
PhysBox:AddSlider("JumpPower", { Text = "Jump Power (โดดสูง)", Default = 50, Min = 50, Max = 500 })
PhysBox:AddToggle("FlyMode", { Text = "Fly (บิน)", Default = false, Callback = function(v) flying = v end })

-- [[ 👁️ 4. VISUALS & VIEW ]]
local VisualBox = Tabs.Visuals:AddLeftGroupbox("Visual Settings")
VisualBox:AddToggle("ShowEspName", { Text = "Show Name (มองชื่อ)", Default = true })
VisualBox:AddToggle("ShowEspHealth", { Text = "Show Health (มองเลือด)", Default = true })
VisualBox:AddToggle("ShowLines", { Text = "Snaplines (เส้นลาก)", Default = true })
VisualBox:AddToggle("ShowFOV", { Text = "Show FOV Circle", Default = true })
VisualBox:AddSlider("FOVSize", { Text = "FOV Radius", Default = 150, Min = 10, Max = 800 })

local ViewBox = Tabs.Visuals:AddRightGroupbox("Spectate View")
ViewBox:AddToggle("SpectateTarget", { Text = "View Target (ส่องมุมมอง)", Default = false })

-- [[ 🎨 DRAWINGS ]]
local X1 = Drawing.new("Line"); X1.Thickness = 2; X1.Color = Color3.new(1,1,1)
local X2 = Drawing.new("Line"); X2.Thickness = 2; X2.Color = Color3.new(1,1,1)
local TargetLine = Drawing.new("Line"); TargetLine.Thickness = 1.5; TargetLine.Color = Color3.new(1,1,1)
local FovCircle = Drawing.new("Circle"); FovCircle.Thickness = 1; FovCircle.Color = Color3.new(1,1,1); FovCircle.Filled = false

-- [[ 🔍 SCAN ]]
local function GetTarget()
    local closest, dist = nil, Library.Options.FOVSize.Value
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
            if mag < dist then closest = v; dist = mag end
        end
    end
    return closest
end

-- [[ 🎯 SILENT AIM (ห้ามแก้) ]]
local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__index
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and Library.Toggles.SilentAim.Value and self == mouse and (idx == "Hit" or idx == "Target") then
        local tar = GetTarget()
        if tar then return (idx == "Hit" and tar.Character.Head.CFrame or tar.Character.Head) end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

-- [[ 🔄 MASTER LOOP ]]
runService.RenderStepped:Connect(function()
    spinAngle = spinAngle + math.rad(15)
    orbitAngle = orbitAngle + math.rad(Library.Options.OrbitSpeed.Value)
    local tar = GetTarget()
    
    -- ระบบ FOV
    FovCircle.Visible = Library.Toggles.ShowFOV.Value
    FovCircle.Radius = Library.Options.FOVSize.Value
    FovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    -- ส่องมุมมองคน (Spectate)
    if Library.Toggles.SpectateTarget.Value and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        cam.CameraSubject = targetPlayer.Character.Humanoid
    else
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = lp.Character.Humanoid
        end
    end

    -- Loop Kill & Orbit
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = targetPlayer.Character.HumanoidRootPart
        if Library.Toggles.LoopKill.Value then
            lp.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(0, spinAngle, 0)
        elseif Library.Toggles.OrbitKill.Value then
            local r = Library.Options.OrbitRadius.Value
            local offset = Vector3.new(math.cos(orbitAngle) * r, 5, math.sin(orbitAngle) * r)
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(root.Position + offset, root.Position)
        end
    end

    -- Movement & Physics
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Library.Options.WalkSpeed.Value
        lp.Character.Humanoid.JumpPower = Library.Options.JumpPower.Value
        if flying then lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
    end

    -- Visual Assist
    if tar then
        local p, on = cam:WorldToViewportPoint(tar.Character.Head.Position)
        if on then
            if Library.Toggles.ShowSpinX.Value then
                local s = 10; local cos, sin = math.cos(spinAngle)*s, math.sin(spinAngle)*s
                X1.From = Vector2.new(p.X-cos, p.Y-sin); X1.To = Vector2.new(p.X+cos, p.Y+sin); X1.Visible = true
                X2.From = Vector2.new(p.X+sin, p.Y-cos); X2.To = Vector2.new(p.X-sin, p.Y+cos); X2.Visible = true
            else X1.Visible = false; X2.Visible = false end

            if Library.Toggles.ShowLines.Value then
                TargetLine.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2); TargetLine.To = Vector2.new(p.X, p.Y); TargetLine.Visible = true
            else TargetLine.Visible = false end

            if Library.Toggles.AssistEnabled.Value then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.p, tar.Character.Head.Position), 1/Library.Options.Smoothness.Value)
            end
        end
    else X1.Visible = false; X2.Visible = false; TargetLine.Visible = false end
end)

-- [[ 🧱 ESP SYSTEM ]]
local function ApplyESP(plr)
    local bg = Instance.new("BillboardGui", game.CoreGui)
    bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 200, 0, 50)
    local nameLbl = Instance.new("TextLabel", bg); nameLbl.TextSize = 14; nameLbl.TextColor3 = Color3.new(1,1,1); nameLbl.BackgroundTransparency = 1; nameLbl.Size = UDim2.new(1,0,0.4,0); nameLbl.TextStrokeTransparency = 0; nameLbl.Position = UDim2.new(0,0,-0.5,0); nameLbl.Font = Enum.Font.SourceSansBold
    local hFrame = Instance.new("Frame", bg); hFrame.Size = UDim2.new(0, 60, 0, 5); hFrame.Position = UDim2.new(0.35, 0, 0, 0); hFrame.BackgroundColor3 = Color3.new(0,0,0)
    local hBar = Instance.new("Frame", hFrame); hBar.Size = UDim2.new(1,0,1,0); hBar.BackgroundColor3 = Color3.new(0,1,0); hBar.BorderSizePixel = 0
    runService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            bg.Adornee = plr.Character.Head; nameLbl.Text = plr.DisplayName; nameLbl.Visible = Library.Toggles.ShowEspName.Value
            hFrame.Visible = Library.Toggles.ShowEspHealth.Value; local hp = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth
            hBar.Size = UDim2.new(hp, 0, 1, 0); hBar.BackgroundColor3 = Color3.fromHSV(hp * 0.3, 1, 1); bg.Enabled = true
        else bg.Enabled = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then ApplyESP(v) end end
game.Players.PlayerAdded:Connect(ApplyESP)

Library:Notify("SPECTATE READY: ใส่ชื่อย่อและเปิด View Target เพื่อส่องดูคนนั้นได้เลย!")
