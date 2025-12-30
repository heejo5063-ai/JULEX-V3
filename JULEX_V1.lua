-- [[ JULEX V1 | SATANIC FINAL EDITION ]]
-- [ KEY: "BOOK" | TRUE WALLBANG | ULTRA THIN LINE ]

local lp = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local runService = game:GetService("RunService")

-- [[ 🔑 ACCESS SYSTEM ]]
local KeyGui = Instance.new("ScreenGui", game.CoreGui)
local KeyFrame = Instance.new("Frame", KeyGui); KeyFrame.Size = UDim2.new(0, 280, 0, 160); KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -80); KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", KeyFrame)
local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.Size = UDim2.new(0, 220, 0, 35); KeyInput.Position = UDim2.new(0.5, -110, 0.35, 0); KeyInput.PlaceholderText = "ใส่คีย์: BOOK"; Instance.new("UICorner", KeyInput)
local KeySubmit = Instance.new("TextButton", KeyFrame); KeySubmit.Size = UDim2.new(0, 120, 0, 30); KeySubmit.Position = UDim2.new(0.5, -60, 0.75, 0); KeySubmit.Text = "UNLOCK"; KeySubmit.BackgroundColor3 = Color3.fromRGB(255, 46, 126); Instance.new("UICorner", KeySubmit)

-- [[ 🚀 SATAN ENGINE ]]
local function StartJulex()
    local MainGui = Instance.new("ScreenGui", game.CoreGui)
    
    -- [[ ⚙️ CONFIG ]]
    _G.SilentAim = false; _G.Wallbang = false; _G.ShowFOV = true; _G.ShowSnapline = true
    _G.Prediction = 0.165; _G.FOV = 150; _G.Speed = 16; _G.Jump = 50

    -- [[ 🎯 UI ELEMENTS ]]
    local fovC = Instance.new("Frame", MainGui); fovC.BackgroundTransparency = 1; fovC.AnchorPoint = Vector2.new(0.5, 0.5); fovC.Position = UDim2.new(0.5, 0, 0.5, 0)
    local fovS = Instance.new("UIStroke", fovC); fovS.Color = Color3.fromRGB(255, 46, 126); Instance.new("UICorner", fovC).CornerRadius = UDim.new(1, 0)
    local snap = Instance.new("Frame", MainGui); snap.BackgroundColor3 = Color3.fromRGB(255, 46, 126); snap.BorderSizePixel = 0; snap.AnchorPoint = Vector2.new(0.5, 0.5); snap.Visible = false; snap.Size = UDim2.new(0, 0, 0, 1) 

    -- [[ 📱 MAIN MENU ]]
    local MainFrame = Instance.new("Frame", MainGui); MainFrame.Size = UDim2.new(0, 350, 0, 400); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200); MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); MainFrame.Visible = false; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 46, 126)
    local Content = Instance.new("ScrollingFrame", MainFrame); Content.Size = UDim2.new(1, -20, 1, -60); Content.Position = UDim2.new(0, 10, 0, 50); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0; Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

    -- [[ 🎯 LOGIC ]]
    local function GetTarget()
        local target, dist = nil, _G.FOV
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = cam:WorldToViewportPoint(v.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    if _G.Wallbang or vis then target = v.Character; dist = mag end
                end
            end
        end
        return target
    end

    -- [[ 🚀 ULTIMATE HOOK (FOR WALLBANG) ]]
    local mt = getrawmetatable(game); setreadonly(mt, false); local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod(); local args = {...}
        if _G.SilentAim and not checkcaller() and (method == "Raycast" or method == "FindPartOnRayWithIgnoreList" or method == "FireServer") then
            local tar = GetTarget()
            if tar then
                local pPos = tar.Head.Position + (tar.HumanoidRootPart.Velocity * _G.Prediction)
                if method == "FireServer" and tostring(self) == "MainEvent" then 
                    if args[1] == "UpdateMousePos" then args[2] = pPos; return oldNamecall(self, unpack(args)) end
                elseif method == "Raycast" then args[2] = (pPos - args[1]).Unit * 1000
                elseif method == "FindPartOnRayWithIgnoreList" then args[1] = Ray.new(cam.CFrame.Position, (pPos - cam.CFrame.Position).Unit * 1000) end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)

    -- [[ 🔄 LOOP ]]
    runService.RenderStepped:Connect(function()
        fovC.Visible = _G.ShowFOV; fovC.Size = UDim2.new(0, _G.FOV * 2, 0, _G.FOV * 2)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = _G.Speed; lp.Character.Humanoid.JumpPower = _G.Jump
        end
        local tar = GetTarget()
        if tar and _G.ShowSnapline and _G.SilentAim then
            local pPos = tar.Head.Position + (tar.HumanoidRootPart.Velocity * _G.Prediction)
            local sPos, on = cam:WorldToViewportPoint(pPos)
            if on then
                local start = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
                local endP = Vector2.new(sPos.X, sPos.Y); local mag = (endP - start).Magnitude
                snap.Visible = true; snap.Size = UDim2.new(0, mag, 0, 1); snap.Position = UDim2.new(0, (start.X + endP.X)/2, 0, (start.Y + endP.Y)/2); snap.Rotation = math.deg(math.atan2(endP.Y - start.Y, endP.X - start.X))
            else snap.Visible = false end
        else snap.Visible = false end
    end)

    -- [[ 🔘 COMPONENTS ]]
    local function AddToggle(txt, var)
        local b = Instance.new("TextButton", Content); b.Size = UDim2.new(1, 0, 0, 35); b.Text = "  " .. txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.fromRGB(200, 200, 200); b.TextXAlignment = 0; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            _G[var] = not _G[var]; b.Text = "  " .. txt .. ": " .. (_G[var] and "ON" or "OFF"); b.TextColor3 = _G[var] and Color3.fromRGB(255, 46, 126) or Color3.fromRGB(200, 200, 200)
        end)
    end
    
    AddToggle("SILENT AIM", "SilentAim")
    AddToggle("WALLBANG (ยิงทะลุ)", "Wallbang")
    AddToggle("แสดงวง FOV", "ShowFOV")
    AddToggle("เส้น SNAPLINE (บาง)", "ShowSnapline")

    local OpenBtn = Instance.new("TextButton", MainGui); OpenBtn.Size = UDim2.new(0, 60, 0, 30); OpenBtn.Position = UDim2.new(0, 10, 0, 10); OpenBtn.Text = "JULEX"; OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 46, 126); Instance.new("UICorner", OpenBtn)
    OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
end

KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text == "BOOK" then KeyGui:Destroy(); StartJulex() end
end)
