-- [[ JULEX V3 - SATANIC EDITION ]]
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local cam = workspace.CurrentCamera
local rs = game:GetService("RunService")
local plrs = game:GetService("Players")

_G.JulexPro = {
    Enabled = false,
    ESP = false,
    SatanMode = false, -- ฟีเจอร์ซาตาน
    Speed = false,
    Jump = false,
    ShowFOV = true,
    FOV_Size = 120
}

-- [ 🎨 DRAWING TOOLS ]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1; fov_circle.NumSides = 100; fov_circle.Radius = _G.JulexPro.FOV_Size
fov_circle.Color = Color3.new(1, 1, 1); fov_circle.Transparency = 0.5; fov_circle.Visible = true

-- [ 👁️ TARGET FINDER ]
local function GetClosest()
    local target, dist = nil, _G.JulexPro.FOV_Size
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    for _, v in pairs(plrs:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if mDist < dist then target = v.Character.Head; dist = mDist end
            end
        end
    end
    return target
end

-- [ 🛡️ ENGINE HOOK ]
local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if _G.JulexPro.Enabled and t == mouse and (k == "Hit" or k == "Target") then
        local target = GetClosest()
        if target then return (k == "Hit" and target.CFrame or target) end
    end
    return old(t, k)
end)
setreadonly(mt, true)

-- [ 📱 UI เมนู V3 ]
local sg = Instance.new("ScreenGui", game.CoreGui)
local toggleBtn = Instance.new("TextButton", sg)
toggleBtn.Size = UDim2.new(0, 40, 0, 40); toggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); toggleBtn.Text = "JL"; toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 180, 0, 310); main.Position = UDim2.new(0.5, -90, 0.5, -155)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = true; main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
toggleBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -20, 1, -20); container.Position = UDim2.new(0, 10, 0, 10); container.BackgroundTransparency = 1
Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

local function makeBtn(txt, key)
    local btn = Instance.new("TextButton", container); btn.Size = UDim2.new(1, 0, 0, 32); btn.Text = txt; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G.JulexPro[key] = not _G.JulexPro[key]
        btn.BackgroundColor3 = _G.JulexPro[key] and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(30, 30, 30)
    end)
end

makeBtn("Silent Aim", "Enabled")
makeBtn("Satan Morph", "SatanMode") -- ปุ่มเปิด/ปิดร่างซาตาน
makeBtn("ESP มองทะลุ", "ESP")
makeBtn("Speed Hack", "Speed")
makeBtn("High Jump", "Jump")

-- [ 🔄 MAIN LOOP: เอฟเฟกต์ซาตาน & ระบบ ]
local pentagram = Instance.new("Part")
pentagram.Size = Vector3.new(8, 0.2, 8); pentagram.CanCollide = false; pentagram.Material = Enum.Material.Neon; pentagram.Color = Color3.fromRGB(255, 0, 150); pentagram.Transparency = 1; pentagram.Parent = workspace
local decal = Instance.new("Decal", pentagram); decal.Face = "Top"; decal.Texture = "rbxassetid://121430018"; decal.Transparency = 1

rs.RenderStepped:Connect(function()
    local char = lp.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- ระบบซาตาน
        if _G.JulexPro.SatanMode then
            pentagram.Transparency = 0.5; decal.Transparency = 0
            pentagram.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, tick() * 2, 0)
        else
            pentagram.Transparency = 1; decal.Transparency = 1
        end
        -- ระบบ Movement
        char.Humanoid.WalkSpeed = _G.JulexPro.Speed and 80 or 16
        char.Humanoid.JumpPower = _G.JulexPro.Jump and 120 or 50
    end
    -- FOV Position
    fov_circle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    -- ESP Logic
    for _, v in pairs(plrs:GetPlayers()) do
        if v.Character and v ~= lp then
            local hl = v.Character:FindFirstChild("JulexESP") or Instance.new("Highlight", v.Character)
            hl.Name = "JulexESP"; hl.Enabled = _G.JulexPro.ESP; hl.FillColor = Color3.new(1,1,1)
        end
    end
end)
