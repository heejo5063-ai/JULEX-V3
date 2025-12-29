-- [[ JULEX V3 | MACLIB EDITION ]]
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

local Window = MacLib:Window({
    Title = "JULEX V3",
    Subtitle = "Satanic Ultimate Edition",
    ConfigName = "JulexConfig",
    ToggleKey = Enum.KeyCode.LeftControl,
    BackgroundColor = Color3.fromRGB(20, 20, 20)
})

local MainTab = Window:Tab({ Title = "Combat", Icon = "rbxassetid://10734950309" })
local VisualTab = Window:Tab({ Title = "Visuals", Icon = "rbxassetid://10734950309" })
local SatanTab = Window:Tab({ Title = "Satan & Misc", Icon = "rbxassetid://10734950309" })

-- [[ SYSTEM VARIABLES ]]
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local cam = workspace.CurrentCamera
local TargetPlayer = ""
local SilentAimEnabled = false
local FOVSize = 150
local AutoKillEnabled = false
local SatanEnabled = false
local ESPEnabled = false

-- [ 🎨 FOV SETUP ]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1.5; fov_circle.NumSides = 100; fov_circle.Filled = false; fov_circle.Color = Color3.new(1,1,1); fov_circle.Visible = false

-- [ 😈 SATAN ASSETS ]
local pentagram = Instance.new("Part")
pentagram.Size = Vector3.new(8, 0.2, 8); pentagram.CanCollide = false; pentagram.Anchored = true; pentagram.Material = "Neon"; pentagram.Color = Color3.fromRGB(255, 0, 150); pentagram.Transparency = 1; pentagram.Parent = workspace
local decal = Instance.new("Decal", pentagram); decal.Face = "Top"; decal.Texture = "rbxassetid://121430018"; decal.Transparency = 1
local aura = Instance.new("ParticleEmitter")
aura.Color = ColorSequence.new(Color3.fromRGB(255, 0, 150)); aura.LightEmission = 1; aura.Size = NumberSequence.new(0.6, 0); aura.Texture = "rbxassetid://243660364"; aura.Transparency = NumberSequence.new(0.2, 1); aura.Lifetime = NumberRange.new(0.8); aura.Rate = 50; aura.Enabled = false

-- [[ FUNCTIONS ]]
local function KillEffect(pos)
    local orb = Instance.new("Part", workspace)
    orb.Size = Vector3.new(1,1,1); orb.Shape = "Ball"; orb.Color = Color3.fromRGB(255, 0, 150); orb.Material = "Neon"; orb.Anchored = true; orb.CanCollide = false; orb.Position = pos
    ts:Create(orb, TweenInfo.new(0.5), {Size = Vector3.new(12,12,12), Transparency = 1}):Play()
    task.delay(0.6, function() orb:Destroy() end)
end

local function GetClosest()
    local target, dist = nil, FOVSize
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if mDist < dist then target = v.Character; dist = mDist end
            end
        end
    end
    return target
end

-- [[ SILENT AIM V2 ENGINE ]]
local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}; local method = getnamecallmethod()
    if SilentAimEnabled and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = GetClosest()
        if target and target:FindFirstChild("Head") then return target.Head, target.Head.Position, Vector3.new(0,1,0), target.Head.Material end
    end
    return oldNamecall(self, ...)
end)

-- [[ UI SETUP: COMBAT ]]
MainTab:Toggle({ Title = "Silent Aim V2", Default = false, Callback = function(v) SilentAimEnabled = v end })
MainTab:Slider({ Title = "FOV Size", Min = 0, Max = 800, Default = 150, Callback = function(v) FOVSize = v end })

MainTab:Dropdown({
    Title = "เลือกเป้าหมาย",
    Multi = false,
    Items = (function()
        local p = {}
        for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(p, v.Name) end end
        return p
    end)(),
    Callback = function(v) TargetPlayer = v end
})

MainTab:Toggle({ Title = "Auto Kill (วาป+ยิง)", Default = false, Callback = function(v) AutoKillEnabled = v end })

-- [[ UI SETUP: VISUALS ]]
VisualTab:Toggle({ Title = "White ESP", Default = false, Callback = function(v) ESPEnabled = v end })

-- [[ UI SETUP: SATAN ]]
SatanTab:Toggle({ Title = "Satan Morph (ตัวดำ+ชมพู)", Default = false, Callback = function(v) SatanEnabled = v end })
SatanTab:Slider({ Title = "Walk Speed", Min = 16, Max = 250, Default = 16, Callback = function(v) if lp.Character then lp.Character.Humanoid.WalkSpeed = v end end })

-- [[ MAIN LOOP ]]
rs.RenderStepped:Connect(function()
    fov_circle.Visible = SilentAimEnabled; fov_circle.Radius = FOVSize; fov_circle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    
    local char = lp.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if SatanEnabled then
            pentagram.Transparency = 0.5; decal.Transparency = 0; pentagram.CFrame = hrp.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, tick()*3, 0)
            if aura.Parent ~= hrp then aura.Parent = hrp end; aura.Enabled = true
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Color = Color3.new(0,0,0); v.Material = "Neon" 
                elseif v:IsA("Clothing") then v:Destroy() end
            end
        else
            pentagram.Transparency = 1; decal.Transparency = 1; aura.Enabled = false
        end

        if AutoKillEnabled and TargetPlayer ~= "" then
            local p = game.Players:FindFirstChild(TargetPlayer)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                hrp.CFrame = CFrame.new(hrp.Position, p.Character.HumanoidRootPart.Position)
                local tool = lp.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool then lp.Character.Humanoid:EquipTool(tool); tool:Activate() end
            end
        end
    end

    if ESPEnabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v ~= lp then
                local hl = v.Character:FindFirstChild("JulexESP") or Instance.new("Highlight", v.Character)
                hl.Name = "JulexESP"; hl.Enabled = true; hl.FillColor = Color3.new(1,1,1)
            end
        end
    end
end)

-- [[ KILL EFFECT SENSOR ]]
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        c:WaitForChild("Humanoid").Died:Connect(function() KillEffect(c.HumanoidRootPart.Position) end)
    end)
end)

MacLib:Notify({ Title = "JULEX V3", Content = "MacLib Edition Loaded!", Time = 5 })
