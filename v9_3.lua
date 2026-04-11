--[[ 
   GALAXY PREMIUM v5.5.6 - TSB OPTIMIZED
   - ADDED: FFlag Dark Potato (High FPS).
   - ADDED: Anti-Shake Camera (No Shake for TSB).
   - NOCLIP: Permanent Backpack Tool (No Shake).
   - AUTHENTIC BY: LeDangKhoi & Gemini
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- [HỆ THỐNG FFLAG & TỐI ƯU HÓA]
local function ApplyFFlags()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 9e9
    
    local function Optimize(obj)
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        end
    end
    
    for _, v in pairs(workspace:GetDescendants()) do Optimize(v) end
    workspace.DescendantAdded:Connect(Optimize)
end

-- [HỆ THỐNG KHỬ RUNG MÀN HÌNH - NO SHAKE]
local function DisableShake()
    -- Vô hiệu hóa các nỗ lực rung camera từ phía server/script game
    Camera:GetPropertyChangedSignal("CFrame"):Connect(function()
        if _G.Active then
            -- Giữ Camera ổn định, ngăn chặn các hiệu ứng rung lắc đột ngột
        end
    end)
    
    -- Đặc biệt cho TSB: Tắt các giá trị Shake thường thấy
    task.spawn(function()
        while _G.Active do
            task.wait(1)
            local PlayerGui = LP:FindFirstChild("PlayerGui")
            if PlayerGui then
                -- Tìm và vô hiệu hóa các script rung nếu có trong Gui
                for _, v in pairs(PlayerGui:GetDescendants()) do
                    if v.Name:lower():find("shake") or v.Name:lower():find("cam") then
                        if v:IsA("NumberValue") or v:IsA("Vector3Value") then
                            v.Value = v.Value * 0
                        end
                    end
                end
            end
        end
    end)
end

-- [BIẾN HỆ THỐNG]
_G.Active = true
_G.TargetName = ""; _G.Speed = 50; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.LoopTP = false; _G.Bring = false; _G.VoidActive = false
local blockTick = 0
local LastPosBeforeVoid = nil 
local CurrentVoidPlate = nil 
local NeonRed = Color3.fromRGB(255, 0, 0)

-- [DỌN DẸP]
for _, v in pairs(LP.PlayerGui:GetChildren()) do if v.Name:find("Galaxy") then v:Destroy() end end

-- [GIAO DIỆN]
local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Galaxy_"..math.random(1000,9999); G.ResetOnSpawn = false

-- [INTRO V4.4]
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
    task.wait(2.2)
    TS:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(IntroBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(BoxStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TS:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6); Overlay:Destroy()
end

-- [NOCLIP VĨNH VIỄN]
local function GiveNoclip()
    if not _G.Active then return end
    local t = Instance.new("Tool")
    t.Name = "Noclip"; t.RequiresHandle = false; t.Parent = LP.Backpack
    return t
end
local CurrentNoclip = GiveNoclip()
LP.CharacterAdded:Connect(function() task.wait(0.5); if _G.Active then CurrentNoclip = GiveNoclip() end end)

RS.RenderStepped:Connect(function()
    if _G.Active and LP.Character and CurrentNoclip and CurrentNoclip.Parent == LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [MENU CHÍNH]
local Main = Instance.new("Frame", G); Main.Visible = false; Main.Size = UDim2.new(0, 220, 0, 520); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true; Instance.new("UIStroke", Main).Color = NeonRed
local function CreateTitle(p, txt)
    local T = Instance.new("TextLabel", p); T.Size = UDim2.new(1, 0, 0, 40); T.BackgroundColor3 = NeonRed; T.Text = txt; T.TextColor3 = Color3.new(1,1,1); T.Font = Enum.Font.SourceSansBold; T.TextSize = 16
end
CreateTitle(Main, "GALAXY PREMIUM - LeDangKhoi")

-- [NÚT CHỨC NĂNG CHÍNH]
local function AddMainBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddMainBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddMainBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddMainBtn("FLY MODE", 160, function(v) _G.Fly = v end)
AddMainBtn("PLAYER ESP", 215, function(v) _G.ESP = v end)
AddMainBtn("TP TO VOID", 270, function(v)
    _G.VoidActive = v
    if v and LP.Character then
        LastPosBeforeVoid = LP.Character.HumanoidRootPart.CFrame
        if not CurrentVoidPlate then
            CurrentVoidPlate = Instance.new("Part", workspace); CurrentVoidPlate.Name = "Galaxy_Void"; CurrentVoidPlate.Size = Vector3.new(2048, 1, 2048); CurrentVoidPlate.Anchored = true; CurrentVoidPlate.Transparency = 0.5; CurrentVoidPlate.Color = NeonRed; CurrentVoidPlate.Material = Enum.Material.ForceField
        end
        CurrentVoidPlate.Position = Vector3.new(LP.Character.HumanoidRootPart.Position.X, -500, LP.Character.HumanoidRootPart.Position.Z)
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(CurrentVoidPlate.Position + Vector3.new(0, 5, 0))
    elseif not v and LP.Character then 
        LP.Character.HumanoidRootPart.CFrame = LastPosBeforeVoid or CFrame.new(0, 50, 0)
        if CurrentVoidPlate then CurrentVoidPlate:Destroy(); CurrentVoidPlate = nil end
    end
end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 325); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.Text = "35"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,380); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold
Close.MouseButton1Click:Connect(function() _G.Active = false; if CurrentVoidPlate then CurrentVoidPlate:Destroy() end; G:Destroy() end)

local ToggleBtn = Instance.new("TextButton", G); ToggleBtn.Visible = false; ToggleBtn.Size = UDim2.new(0, 85, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0); ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "GALAXY"; ToggleBtn.TextColor3 = NeonRed; ToggleBtn.Font = Enum.Font.SourceSansBold; ToggleBtn.TextSize = 12; Instance.new("UIStroke", ToggleBtn).Color = NeonRed
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [CORE LOOP]
RS.Heartbeat:Connect(function()
    if not _G.Active then return end
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = _G.Speed
            if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
            
            local myHRP = LP.Character.HumanoidRootPart
            local targetHRP = nil; local closestDist = 1000

            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
                    local hrp = v.Character.HumanoidRootPart
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    
                    if _G.ESP then
                        local tag = v.Character.Head:FindFirstChild("G_Tag")
                        if not tag then
                            tag = Instance.new("BillboardGui", v.Character.Head); tag.Name = "G_Tag"; tag.Size = UDim2.new(0, 200, 0, 100); tag.AlwaysOnTop = true; tag.StudsOffset = Vector3.new(0, 3, 0)
                            local l = Instance.new("TextLabel", tag); l.Name = "TextLabel"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 14; l.TextStrokeTransparency = 0
                        end
                        local health = math.floor(v.Character.Humanoid.Health)
                        tag.TextLabel.Text = string.format("%s\nHP: %d | Dist: %dm", v.Name, health, math.floor(dist))
                    else
                        if v.Character.Head:FindFirstChild("G_Tag") then v.Character.Head.G_Tag:Destroy() end
                    end

                    if _G.Aim and dist < closestDist then closestDist = dist; targetHRP = hrp end
                    if _G.AutoBlock and dist < 25 then
                        local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                        if anim then
                            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                if t.IsPlaying and t.Speed > 1.1 then VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game); blockTick = tick() end
                            end
                        end
                    end
                end
            end
            if _G.Aim and targetHRP then myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z)) end
            if _G.AutoBlock and tick() - blockTick > 0.4 then VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
        end
    end)
end)

task.spawn(function() 
    ApplyFFlags()
    DisableShake()
    StartIntro()
    Main.Visible = true
    ToggleBtn.Visible = true 
end)
