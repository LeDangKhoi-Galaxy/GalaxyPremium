--[[ 
   GALAXY PREMIUM v4.0 - INFINITE VOID EDITION
   - UPGRADE: Tấm kính Void kích thước siêu lớn (2048x2048) và tự động căn giữa theo Player.
   - RESTORED: Full Intro + Notification "Script Load Hoàn Thành".
   - FIXED: Absolute Void Y = -500.
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name:find("Galaxy") then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Galaxy_"..math.random(1000,9999); G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- BIẾN HỆ THỐNG
_G.Active = true
_G.TargetName = ""; _G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.LoopTP = false; _G.Bring = false
_G.VoidActive = false
local OriginalCFrames = {}
local blockTick = 0
local LastPosBeforeVoid = nil 
local CurrentVoidPlate = nil 

-- =========================================
-- [INTRO & NOTIFICATION]
-- =========================================
local function StartIntro()
    local Overlay = Instance.new("Frame", G)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.new(0, 0, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 100
    local IntroBox = Instance.new("Frame", Overlay)
    IntroBox.Size = UDim2.new(0, 400, 0, 100); IntroBox.Position = UDim2.new(0.5, -200, 0.5, -50); IntroBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10); IntroBox.BackgroundTransparency = 1
    local BoxStroke = Instance.new("UIStroke", IntroBox); BoxStroke.Color = NeonRed; BoxStroke.Thickness = 2; BoxStroke.Transparency = 1
    local IntroText = Instance.new("TextLabel", IntroBox)
    IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "GALAXY Premium By LeDangKhoi"; IntroText.TextColor3 = NeonRed; IntroText.Font = Enum.Font.SourceSansBold; IntroText.TextSize = 25; IntroText.TextTransparency = 1

    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.5)
    TS:Create(IntroBox, TweenInfo.new(0.8), {BackgroundTransparency = 0.2}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TS:Create(IntroText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(2.2)
    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(IntroBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TS:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6); Overlay:Destroy()

    local Notif = Instance.new("Frame", G)
    Notif.Size = UDim2.new(0, 200, 0, 35); Notif.Position = UDim2.new(0, -220, 0, 20); Notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UIStroke", Notif).Color = NeonRed
    local NText = Instance.new("TextLabel", Notif); NText.Size = UDim2.new(1, 0, 1, 0); NText.BackgroundTransparency = 1; NText.Text = "Script Loading"; NText.TextColor3 = Color3.new(1, 1, 1); NText.Font = Enum.Font.SourceSansBold; NText.TextSize = 14
    Notif:TweenPosition(UDim2.new(0, 20, 0, 20), "Out", "Back", 0.5, true)
    task.wait(3); Notif:TweenPosition(UDim2.new(0, -220, 0, 20), "In", "Linear", 0.5, true)
    task.delay(0.5, function() Notif:Destroy() end)
end

-- =========================================
-- [MENU]
-- =========================================
local Main = Instance.new("Frame", G); Main.Visible = false; Main.Size = UDim2.new(0, 220, 0, 520); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = NeonRed
local SubMenu = Instance.new("Frame", G); SubMenu.Visible = false; SubMenu.Size = UDim2.new(0, 200, 0, 250); SubMenu.Position = UDim2.new(0.5, 10, 0.3, 0); SubMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15); SubMenu.Active = true; SubMenu.Draggable = true; Instance.new("UIStroke", SubMenu).Color = NeonRed

local function CreateTitle(p, txt)
    local T = Instance.new("TextLabel", p); T.Size = UDim2.new(1, 0, 0, 40); T.BackgroundColor3 = NeonRed; T.Text = txt; T.TextColor3 = Color3.new(1,1,1); T.Font = Enum.Font.SourceSansBold; T.TextSize = 16
end
CreateTitle(Main, "GALAXY Premium - LeDangKhoi")
CreateTitle(SubMenu, "PLAYER TOOL")

local ToggleBtn = Instance.new("TextButton", G); ToggleBtn.Visible = false; ToggleBtn.Size = UDim2.new(0, 85, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0); ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.TextColor3 = NeonRed; ToggleBtn.Font = Enum.Font.SourceSansBold; ToggleBtn.TextSize = 12; Instance.new("UIStroke", ToggleBtn).Color = NeonRed
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [CHỨC NĂNG PHỤ]
local function GetPlayerSmart(name)
    if name == "" then return nil end
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do if v.Name:lower():sub(1, #name) == name or v.DisplayName:lower():sub(1, #name) == name then return v end end
    return nil
end

local function AddMainBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddMainBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddMainBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddMainBtn("FLY MODE", 160, function(v) _G.Fly = v end)
AddMainBtn("PLAYER ESP", 215, function(v) _G.ESP = v end)
AddMainBtn("PLAYER TOOL", 270, function(v) SubMenu.Visible = v end)

-- [INFINITE VOID SYSTEM]
AddMainBtn("TP TO VOID", 325, function(v)
    _G.VoidActive = v
    if v and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LastPosBeforeVoid = LP.Character.HumanoidRootPart.CFrame
        if not CurrentVoidPlate then
            CurrentVoidPlate = Instance.new("Part", workspace)
            CurrentVoidPlate.Name = "Galaxy_InfiniteVoid"
            CurrentVoidPlate.Size = Vector3.new(2048, 1, 2048) -- Size tối đa
            CurrentVoidPlate.Position = Vector3.new(LastPosBeforeVoid.Position.X, -500, LastPosBeforeVoid.Position.Z)
            CurrentVoidPlate.Anchored = true; CurrentVoidPlate.Transparency = 0.5; CurrentVoidPlate.Color = NeonRed; CurrentVoidPlate.Material = Enum.Material.ForceField
        end
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentVoidPlate.Position + Vector3.new(0, 5, 0))
        
        -- Vòng lặp cập nhật vị trí tấm kính để tạo cảm giác vô tận
        task.spawn(function()
            while _G.VoidActive and _G.Active do
                if CurrentVoidPlate and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local pPos = LP.Character.HumanoidRootPart.Position
                    -- Luôn giữ tấm kính ở dưới chân người chơi dù họ di chuyển xa cỡ nào
                    CurrentVoidPlate.Position = Vector3.new(pPos.X, -500, pPos.Z)
                end
                task.wait()
            end
        end)
    elseif not v and LP.Character then
        LP.Character.HumanoidRootPart.CFrame = LastPosBeforeVoid or CFrame.new(0, 50, 0)
    end
end)

-- [PLAYER TOOL & SPEED]
local NameBox = Instance.new("TextBox", SubMenu); NameBox.Size = UDim2.new(1, -20, 0, 40); NameBox.Position = UDim2.new(0, 10, 0, 50); NameBox.BackgroundColor3 = Color3.fromRGB(30,30,30); NameBox.PlaceholderText = "Tên người chơi..."; NameBox.TextColor3 = Color3.new(1,1,1); NameBox.Font = Enum.Font.SourceSansBold; NameBox.TextSize = 12; Instance.new("UIStroke", NameBox).Color = NeonRed
NameBox.FocusLost:Connect(function() _G.TargetName = NameBox.Text end)

local function AddSubBtn(n, y, c)
    local b = Instance.new("TextButton", SubMenu); b.Size = UDim2.new(1, -20, 0, 40); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 14
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddSubBtn("LOOP TELEPORT", 100, function(v) _G.LoopTP = v; task.spawn(function() while _G.LoopTP and _G.Active do task.wait(); local t = GetPlayerSmart(_G.TargetName); if t and t.Character and LP.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end end) end)
AddSubBtn("BRING PLAYER", 150, function(v) _G.Bring = v; local t = GetPlayerSmart(_G.TargetName); if v and t then OriginalCFrames[t.UserId] = t.Character.HumanoidRootPart.CFrame; task.spawn(function() while _G.Bring and _G.Active do task.wait(); if LP.Character and t.Character then t.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) end end end) elseif not v and t and OriginalCFrames[t.UserId] then t.Character.HumanoidRootPart.CFrame = OriginalCFrames[t.UserId] end end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 380); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.Text = "TỐC ĐỘ (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,435); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold
Close.MouseButton1Click:Connect(function() 
    _G.Active = false; if CurrentVoidPlate then CurrentVoidPlate:Destroy() end; G:Destroy() 
end)

-- [HEARTBEAT CORE]
RS.Heartbeat:Connect(function()
    if not _G.Active then return end
    pcall(function()
        LP.Character.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        local myHRP = LP.Character.HumanoidRootPart; local targetHRP = nil; local minFOV = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart"); local hum = v.Character:FindFirstChild("Humanoid"); local head = v.Character:FindFirstChild("Head")
                if hrp and hum and head then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if _G.ESP then
                        if not head:FindFirstChild("G_Tag") then
                            local b = Instance.new("BillboardGui", head); b.Name = "G_Tag"; b.Size = UDim2.new(0, 200, 0, 100); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                            local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 22
                        end
                        head.G_Tag.TextLabel.Text = v.Name.."\nHP: "..math.floor(hum.Health).."\n"..math.floor(dist).."m"
                    end
                    if _G.Aim and hum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local fov = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if fov < minFOV then minFOV = fov; targetHRP = hrp end
                        end
                    end
                    if _G.AutoBlock and dist < 25 and dist > 6.5 then
                        local anim = hum:FindFirstChildOfClass("Animator")
                        if anim then for _, t in pairs(anim:GetPlayingAnimationTracks()) do if t.IsPlaying and t.Speed > 1.1 and t.WeightCurrent > 0.55 then VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game); blockTick = tick() break end end end
                    end
                end
            end
        end
        if _G.Aim and targetHRP then LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z)) end
        if _G.AutoBlock and tick() - blockTick > 0.4 then VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
    end)
end)

task.spawn(function() StartIntro(); Main.Visible = true; ToggleBtn.Visible = true end)
