-- [[ JULEX V3 SUPREME - DA HILLS OFFICIAL ]]
-- Status: Stable for Delta | 24H Key System
-- Key: BOOK

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [ ⚙️ GLOBAL CONFIG ]
_G.Julex = {
    Silent = false,
    Pred = 1.0, 
    FOV = 150,
    ShowFOV = false,
    ShowLine = false,
    Fly = false,
    Spd = 16,
    Jmp = 50,
    ESP = false
}

local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local rs = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- [ 🎯 ADVANCED TARGETING ]
local function GetTarget()
    local target, dist = nil, _G.Julex.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- [ 🛡️ UI SYSTEM ]
local Window = Fluent:CreateWindow({
    Title = "JULEX V3 [ DA HILLS ]",
    SubTitle = "Supreme Edition",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

local KeyTab = Window:AddTab({ Title = "Authentication", Icon = "key" })
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "target" })
local MoveTab = Window:AddTab({ Title = "Movement", Icon = "zap" })

-- [ 🔑 24H KEY SYSTEM LOGIC ]
KeyTab:AddParagraph({
    Title = "Key Status: Unverified",
    Content = "รหัสผ่านมีอายุการใช้งาน 24 ชั่วโมง\nรับรหัสล่าสุดได้ใน Discord เท่านั้น"
})

KeyTab:AddInput("KeyInput", {
    Title = "ใส่รหัสผ่านเพื่อปลดล็อก",
    Placeholder = "Password...",
    Callback = function(Value)
        if Value:upper() == "BOOK" then
            Fluent:Notify({ Title = "Access Granted", Content = "ปลดล็อกฟีเจอร์ 24 ชม. สำเร็จ!", Duration = 5 })
            
            -- ปลดล็อก Combat
            CombatTab:AddToggle("Silent", {Title = "Enable Silent Aim (1s Lead)", Default = false}):OnChanged(function(v) _G.Julex.Silent = v end)
            CombatTab:AddToggle("ShowFOV", {Title = "Show FOV (Center)", Default = false}):OnChanged(function(v) _G.Julex.ShowFOV = v end)
            CombatTab:AddToggle("ShowLine", {Title = "Show Tracer Line", Default = false}):OnChanged(function(v) _G.Julex.ShowLine = v end)
            CombatTab:AddSlider("FOVSize", {Title = "FOV Size", Default = 150, Min = 50, Max = 800, Callback = function(v) _G.Julex.FOV = v end})
            
            -- ปลดล็อก Movement
            MoveTab:AddSlider("Speed", {Title = "WalkSpeed", Default = 16, Min = 16, Max = 350, Callback = function(v) _G.Julex.Spd = v end})
            MoveTab:AddSlider("Jump", {Title = "JumpPower", Default = 50, Min = 50, Max = 500, Callback = function(v) _G.Julex.Jmp = v end})
            MoveTab:AddToggle("Fly", {Title = "ลอยตัว 100 เมตร", Default = false}):OnChanged(function(v) _G.Julex.Fly = v end)
            MoveTab:AddToggle("ESP", {Title = "ESP Highlight", Default = false}):OnChanged(function(v) _G.Julex.ESP = v end)

            Window:SelectTab(2)
        end
    end
})

KeyTab:AddButton({
    Title = "Copy Discord Link",
    Callback = function() setclipboard("https://discord.gg/julex") end
})

-- [ 🛠️ ENGINE CORE ]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5; fovCircle.Color = Color3.fromRGB(255, 0, 150); fovCircle.Transparency = 1; fovCircle.Filled = false
local tracerLine = Drawing.new("Line")
tracerLine.Thickness = 2; tracerLine.Color = Color3.fromRGB(255, 0, 150); tracerLine.Transparency = 1

local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if (_G.Julex.Silent) and getnamecallmethod() == "FireServer" and tostring(self) == "MainEvent" then
        if args[1] == "UpdateMousePos" then
            local t = GetTarget()
            if t then 
                args[2] = t.Character.Head.Position + (t.Character.Head.Velocity * _G.Julex.Pred)
                return old(self, unpack(args)) 
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

rs.Heartbeat:Connect(function()
    fovCircle.Visible = _G.Julex.ShowFOV
    fovCircle.Radius = _G.Julex.FOV
    fovCircle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)

    local t = GetTarget()
    if _G.Julex.ShowLine and t then
        local pos, onScreen = cam:WorldToViewportPoint(t.Character.Head.Position + (t.Character.Head.Velocity * _G.Julex.Pred))
        if onScreen then
            tracerLine.Visible = true
            tracerLine.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
            tracerLine.To = Vector2.new(pos.X, pos.Y)
        else tracerLine.Visible = false end
    else tracerLine.Visible = false end

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if _G.Julex.Fly then lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) lp.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 1.3, 0) end
        lp.Character.Humanoid.WalkSpeed = _G.Julex.Spd
        lp.Character.Humanoid.JumpPower = _G.Julex.Jmp
        lp.Character.Humanoid.UseJumpPower = true
    end
    
    if _G.Julex.ESP then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and not v.Character:FindFirstChild("JulexESP") then
                local h = Instance.new("Highlight", v.Character); h.Name = "JulexESP"; h.FillColor = Color3.fromRGB(255, 0, 150)
            end
        end
    end
end)
