--[[ 
   GALAXY PREMIUM v6.4 - UI SYNC ENHANCED
   - UPDATE: Đồng bộ đóng PLAYER TOOL khi tắt Menu chính bằng nút GALAXY.
   - BRANDING: Legacy Intro v5.4.1 + FFlag Dark Potato Style.
   - FEATURES: Anti-Shake, Auto Noclip, Aimbot, Auto Block, ESP.
   - AUTHENTIC BY: LeDangKhoi & Gemini
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- [DỌN DẸP UI CŨ]
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name:find("Galaxy") then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Galaxy_"..math.random(1000,9999); G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- [FFLAG DARK POTATO STYLE]
local function ApplyFFlags()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0.5 
    Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    Lighting.ClockTime = 0 
    Lighting.FogEnd = 9e9
    
    local function Optimize(obj)
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        end
        if obj:IsA("Decal") or obj:IsA("Texture") then obj:Destroy() end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled = false end
    end
    for _, v in pairs(workspace:GetDescendants()) do Optimize(v) end
    workspace.DescendantAdded:Connect(Optimize)
end

-- [BIẾN HỆ THỐNG]
_G.Active = true
_G.TargetName = ""; _G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.LoopTP = false; _G.Bring = false; _G.VoidActive = false
local blockTick = 0
local LastPosBeforeVoid = nil 
local CurrentVoidPlate = nil 

-- [CORE ENGINE: NOCLIP & ANTI-SHAKE]
local function GiveNoclipTool()
    if not _G.Active then return end
    if LP.Backpack:FindFirstChild("Noclip") or (LP.Character and LP.Character:FindFirstChild("Noclip (Galaxy)")) then return end
    local T = Instance.new("Tool"); T.Name = "Noclip"; T.RequiresHandle = false; T.CanBeDropped = false; T.Parent = LP.Backpack
end

RS.Stepped:Connect(function()
    if _G.Active and LP.Character then
        local tool = LP.Character:FindFirstChild("Noclip")
        if tool then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        Camera.FieldOfView = 80
        for _, v in pairs(Camera:GetChildren()) do
            if v.Name:lower():find("shake") or v:IsA("CameraShake") then v:Destroy() end
        end
    end
end)

LP.CharacterAdded:Connect(function() if _G.Active then task.wait(0.5); GiveNoclipTool() end end)

-- [LEGACY INTRO]
local function StartIntro()
    local Overlay = Instance.new("Frame", G); Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.new(0, 0, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 100
    local IntroBox = Instance.new("Frame", Overlay); IntroBox.Size = UDim2.new(0, 400, 0, 100); IntroBox.Position = UDim2.new(0.5, -200, 0.5, -50); IntroBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10); IntroBox.BackgroundTransparency = 1
    local BoxStroke = Instance.new("UIStroke", IntroBox); BoxStroke.Color = NeonRed; BoxStroke.Thickness = 2; BoxStroke.Transparency = 1
    local IntroText = Instance.new("TextLabel", IntroBox); IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "GALAXY Premium By LeDangKhoi"; IntroText.TextColor3 = NeonRed; IntroText.Font = Enum.Font.SourceSansBold; IntroText.TextSize = 25; IntroText.TextTransparency = 1
    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.5)
    TS:Create(IntroBox, TweenInfo.new(0.8), {BackgroundTransparency = 0.2}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TS:Create(IntroText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(2.2); TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play(); TS:Create(IntroBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play(); TS:Create(BoxStroke, TweenInfo.new(0.5), {Transparency = 1}):Play(); TS:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6); Overlay:Destroy()
end

-- [UI: MAIN MENU]
local Main = Instance.new("Frame", G); Main.Visible = false; Main.Size = UDim2.new(0, 180, 0, 450); Main.Position = UDim2.new(0.5, -200, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = NeonRed
local SubMenu = Instance.new("Frame", G); SubMenu.Visible = false; SubMenu.Size = UDim2.new(0, 170, 0, 240); SubMenu.Position = UDim2.new(0.5, 0, 0.3, 0); SubMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15); SubMenu.Active = true; SubMenu.Draggable = true; Instance.new("UIStroke", SubMenu).Color = NeonRed

local function CreateTitle(p, txt)
    local T = Instance.new("TextLabel", p); T.Size = UDim2.new(1, 0, 0, 35); T.BackgroundColor3 = NeonRed; T.Text = txt; T.TextColor3 = Color3.new(1,1,1); T.Font = Enum.Font.SourceSansBold; T.TextSize = 14
end
CreateTitle(Main, "GALAXY Premium - LeDangKhoi")
CreateTitle(SubMenu, "PLAYER TOOL")

local function AddMainBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -16, 0, 38); b.Position = UDim2.new(0, 8, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 14
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddMainBtn("SMART AIM", 45, function(v) _G.Aim = v end)
AddMainBtn("AUTO BLOCK", 88, function(v) _G.AutoBlock = v end)
AddMainBtn("FLY MODE", 131, function(v) _G.Fly = v end)
AddMainBtn("PLAYER ESP", 174, function(v) _G.ESP = v end)
AddMainBtn("PLAYER TOOL", 217, function(v) SubMenu.Visible = v end) -- Logic: Nút OFF sẽ tắt SubMenu
AddMainBtn("TP TO VOID", 260, function(v)
    _G.VoidActive = v
    if v and LP.Character then
        LastPosBeforeVoid = LP.Character.HumanoidRootPart.CFrame
        if not CurrentVoidPlate then
            CurrentVoidPlate = Instance.new("Part", workspace); CurrentVoidPlate.Name = "Galaxy_Void"; CurrentVoidPlate.Size = Vector3.new(2048, 1, 2048); CurrentVoidPlate.Anchored = true; CurrentVoidPlate.Transparency = 0.5; CurrentVoidPlate.Color = NeonRed
        end
        CurrentVoidPlate.Position = Vector3.new(LP.Character.HumanoidRootPart.Position.X, -500, LP.Character.HumanoidRootPart.Position.Z)
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentVoidPlate.Position + Vector3.new(0, 5, 0))
    elseif not v and LP.Character then LP.Character.HumanoidRootPart.CFrame = LastPosBeforeVoid or CFrame.new(0, 50, 0) end
end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -16, 0, 38); Inp.Position = UDim2.new(0, 8, 0, 310); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.Text = "16"; Inp.PlaceholderText = "NHẬP TỐC ĐỘ..."; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Instance.new("UIStroke", Inp).Color = NeonRed
Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-16,0,35); Close.Position = UDim2.new(0,8,0,405); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold; Close.TextSize = 14
Close.MouseButton1Click:Connect(function()
    _G.Active = false
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
    local t1 = LP.Backpack:FindFirstChild("Noclip (Galaxy)"); if t1 then t1:Destroy() end
    local t2 = LP.Character:FindFirstChild("Noclip (Galaxy)"); if t2 then t2:Destroy() end
    G:Destroy()
end)

-- [PLAYER TOOL SUBMENU CONTENT]
local NameBox = Instance.new("TextBox", SubMenu); NameBox.Size = UDim2.new(1, -16, 0, 35); NameBox.Position = UDim2.new(0, 8, 0, 45); NameBox.BackgroundColor3 = Color3.fromRGB(30,30,30); NameBox.PlaceholderText = "NHẬP TÊN..."; NameBox.Text = ""; NameBox.TextColor3 = Color3.new(1,1,1); NameBox.Font = Enum.Font.SourceSansBold; NameBox.TextSize = 14; Instance.new("UIStroke", NameBox).Color = NeonRed
NameBox.FocusLost:Connect(function() _G.TargetName = NameBox.Text end)

local function GetPlayerSmart(name)
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do if v.Name:lower():sub(1, #name) == name or v.DisplayName:lower():sub(1, #name) == name then return v end end
    return nil
end

local function AddSubBtn(n, y, c)
    local b = Instance.new("TextButton", SubMenu); b.Size = UDim2.new(1, -16, 0, 35); b.Position = UDim2.new(0, 8, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 12
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end
AddSubBtn("LOOP TP", 90, function(v) _G.LoopTP = v; task.spawn(function() while _G.LoopTP and _G.Active do task.wait(); local t = GetPlayerSmart(_G.TargetName); if t and t.Character and LP.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end end) end)
AddSubBtn("BRING PLAYER", 135, function(v) _G.Bring = v; task.spawn(function() while _G.Bring and _G.Active do task.wait(); local t = GetPlayerSmart(_G.TargetName); if t and t.Character and LP.Character then t.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) end end end) end)

-- [UI: TOGGLE BUTTON (GALAXY) SYNC LOGIC]
local ToggleBtn = Instance.new("TextButton", G); ToggleBtn.Visible = false; ToggleBtn.Size = UDim2.new(0, 70, 0, 30); ToggleBtn.Position = UDim2.new(0, 5, 0.5, 0); ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.TextColor3 = NeonRed; ToggleBtn.Font = Enum.Font.SourceSansBold; ToggleBtn.TextSize = 14; Instance.new("UIStroke", ToggleBtn).Color = NeonRed

ToggleBtn.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible
    -- TỰ ĐỘNG TẮT SUBMENU KHI ĐÓNG MENU CHÍNH
    if not Main.Visible then 
        SubMenu.Visible = false 
    else
        -- Nếu mở lại Menu chính, kiểm tra xem PLAYER TOOL có đang ON không để hiện SubMenu
        for _, btn in pairs(Main:GetChildren()) do
            if btn:IsA("TextButton") and btn.Text:find("PLAYER TOOL: ON") then
                SubMenu.Visible = true
            end
        end
    end
end)

-- [CORE HEARTBEAT LOOP]
RS.Heartbeat:Connect(function()
    if not _G.Active then return end
    pcall(function()
        local myHRP = LP.Character.HumanoidRootPart; LP.Character.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then myHRP.Velocity = Vector3.new(0, 45, 0) end
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local head = v.Character:FindFirstChild("Head"); local hum = v.Character.Humanoid; local hrp = v.Character.HumanoidRootPart
                if _G.ESP and head then
                    local tag = head:FindFirstChild("G_Tag") or Instance.new("BillboardGui", head)
                    if tag.Name ~= "G_Tag" then
                        tag.Name = "G_Tag"; tag.Size = UDim2.new(0, 150, 0, 70); tag.AlwaysOnTop = true; tag.StudsOffset = Vector3.new(0, 3, 0)
                        local l = Instance.new("TextLabel", tag); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 12
                    end
                    tag.TextLabel.Text = v.Name.."\nHP: "..math.floor(hum.Health)
                elseif not _G.ESP and head and head:FindFirstChild("G_Tag") then head.G_Tag:Destroy() end
                if _G.AutoBlock and (myHRP.Position - hrp.Position).Magnitude < 25 then
                    local anim = hum:FindFirstChildOfClass("Animator")
                    if anim then for _, t in pairs(anim:GetPlayingAnimationTracks()) do if t.IsPlaying and t.Speed > 1.1 then VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game); blockTick = tick() break end end end
                end
            end
        end
        if _G.Aim then 
            local closestDist = 1000; local target = nil
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < closestDist then closestDist = d; target = v.Character.HumanoidRootPart end
                end
            end
            if target then myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(target.Position.X, myHRP.Position.Y, target.Position.Z)) end
        end
        if _G.AutoBlock and tick() - blockTick > 0.4 then VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
    end)
end)

-- [EXECUTION]
task.spawn(function()
    StartIntro()
    ApplyFFlags()
    Main.Visible = true
    ToggleBtn.Visible = true
    GiveNoclipTool()
end)
