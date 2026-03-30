--[[ 
   GALAXY PREMIUM v1.2
   - UPDATE: Full Intro Black Overlay & Notification System
   - AUTHENTIC BY: LeDangKhoi
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- =========================================
-- HỆ THỐNG INTRO & NOTIFICATION
-- =========================================
local function StartScript()
    -- 1. Tạo Overlay đen mờ toàn màn hình
    local Overlay = Instance.new("Frame", G)
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.ZIndex = 100

    -- 2. Khung chứa chữ Intro
    local IntroBox = Instance.new("Frame", Overlay)
    IntroBox.Size = UDim2.new(0, 400, 0, 100)
    IntroBox.Position = UDim2.new(0.5, -200, 0.5, -50)
    IntroBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    IntroBox.BackgroundTransparency = 1
    local BoxStroke = Instance.new("UIStroke", IntroBox)
    BoxStroke.Color = NeonRed; BoxStroke.Thickness = 2; BoxStroke.Transparency = 1

    local IntroText = Instance.new("TextLabel", IntroBox)
    IntroText.Size = UDim2.new(1, 0, 1, 0)
    IntroText.BackgroundTransparency = 1
    IntroText.Text = "GALAXY Premium By LeDangKhoi"
    IntroText.TextColor3 = NeonRed
    IntroText.Font = Enum.Font.SourceSansBold
    IntroText.TextSize = 25
    IntroText.TextTransparency = 1

    -- Hiệu ứng chạy Intro
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.5)
    TweenService:Create(IntroBox, TweenInfo.new(0.8), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(BoxStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    
    task.wait(2.5) -- Thời gian hiển thị

    -- Tắt Intro
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(IntroBox, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BoxStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    Overlay:Destroy()

    -- 3. Tạo Notification (Phía trên bên trái)
    local Notif = Instance.new("Frame", G)
    Notif.Size = UDim2.new(0, 180, 0, 35)
    Notif.Position = UDim2.new(0, -200, 0, 20) -- Bắt đầu từ ngoài màn hình
    Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    local NStroke = Instance.new("UIStroke", Notif)
    NStroke.Color = NeonRed; NStroke.Thickness = 1.5
    
    local NText = Instance.new("TextLabel", Notif)
    NText.Size = UDim2.new(1, 0, 1, 0)
    NText.BackgroundTransparency = 1
    NText.Text = "Script Load Hoàn Thành"
    NText.TextColor3 = Color3.new(1, 1, 1)
    NText.Font = Enum.Font.SourceSansBold
    NText.TextSize = 14

    -- Hiệu ứng trượt Notification vào
    Notif:TweenPosition(UDim2.new(0, 20, 0, 20), "Out", "Back", 0.5, true)
    task.wait(3)
    -- Trượt ra và xóa
    Notif:TweenPosition(UDim2.new(0, -200, 0, 20), "In", "Linear", 0.5, true)
    task.delay(0.5, function() Notif:Destroy() end)
end

-- =========================================
-- MENU CHÍNH
-- =========================================
local Main = Instance.new("Frame", G)
Main.Visible = false
Main.Size = UDim2.new(0, 220, 0, 420); Main.Position = UDim2.new(0.5, -110, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true 
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = NeonRed; Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY Premium - LeDangKhoi"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 16

local ToggleBtn = Instance.new("TextButton", G)
ToggleBtn.Visible = false
ToggleBtn.Size = UDim2.new(0, 85, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.new(0,0,0); ToggleBtn.Text = "ON/OFF"; ToggleBtn.TextColor3 = NeonRed
ToggleBtn.Font = Enum.Font.SourceSansBold; ToggleBtn.TextSize = 12
local TStroke = Instance.new("UIStroke", ToggleBtn); TStroke.Color = NeonRed
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Khởi chạy hệ thống
task.spawn(function()
    StartScript()
    Main.Visible = true
    ToggleBtn.Visible = true
end)

-- =========================================
-- LOGIC TÍNH NĂNG (GIỮ NGUYÊN)
-- =========================================
_G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
local blockTick = 0

RS.Heartbeat:Connect(function()
    pcall(function()
        if not LP.Character or not LP.Character:FindFirstChild("Humanoid") then return end
        LP.Character.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        
        local myHRP = LP.Character.HumanoidRootPart
        local shouldBlock = false
        local targetHRP = nil
        local minFOV = math.huge
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local dist = (myHRP.Position - hrp.Position).Magnitude
                local hum = v.Character.Humanoid
                
                if _G.Aim and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local fov = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if fov < minFOV then minFOV = fov; targetHRP = hrp end
                    end
                end
                
                if _G.ESP then
                    if not v.Character.Head:FindFirstChild("G_Tag") then
                        local b = Instance.new("BillboardGui", v.Character.Head); b.Name = "G_Tag"; b.Size = UDim2.new(0, 200, 0, 100); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 22
                    end
                    v.Character.Head.G_Tag.TextLabel.Text = v.Name.."\nHP: "..math.floor(hum.Health).."\n"..math.floor(dist).."m"
                end

                if _G.AutoBlock and dist < 25 and dist > 6.5 then
                    local anim = hum:FindFirstChildOfClass("Animator")
                    if anim then
                        for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                            if t.IsPlaying and t.Speed > 1.1 and t.WeightCurrent > 0.55 then
                                shouldBlock = true; break
                            end
                        end
                    end
                    if hrp.Velocity.Magnitude > 55 then shouldBlock = true end
                end
            end
        end
        
        if _G.Aim and targetHRP then
            LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z))
        end
        
        if _G.AutoBlock then
            if shouldBlock then
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                blockTick = tick()
            elseif tick() - blockTick > 0.4 then
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end)
end)

local function AddBtn(n, y, c)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.Text = n..": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.Text = n..(s and ": ON" or ": OFF"); b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

AddBtn("AIMBOT", 50, function(v) _G.Aim = v end)
AddBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn("FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn("PLAYER ESP", 215, function(v) _G.ESP = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(30,30,30); Inp.Text = "TỐC ĐỘ (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,330); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold; Close.MouseButton1Click:Connect(function() G:Destroy() end)
