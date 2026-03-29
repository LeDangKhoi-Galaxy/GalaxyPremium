--[[ 
   GALAXY PREMIUM v10.8 - THE ULTIMATE HYBRID
   - Speed: Loop Speed Unstoppable (Di chuyển cả khi bị đánh/Ragdoll).
   - Auto Block: Sử dụng Logic v10.4 (Chống đứng yên, chống mimic block).
   - UI Fix: Loại bỏ lỗi khối đen che khuất chức năng trên Mobile.
   - Smart Aim & ESP: Giữ nguyên bản v10.2 hoàn hảo.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- Dọn dẹp UI cũ
for _, ui in pairs(LP.PlayerGui:GetChildren()) do
    if ui.Name:find("Galaxy") then ui:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV10_8"
G.ResetOnSpawn = false
G.IgnoreGuiInset = true

local NeonRed = Color3.fromRGB(255, 0, 0)
local DarkGray = Color3.fromRGB(30, 30, 30)

-- MENU CHÍNH
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 180, 0, 360)
Main.Position = UDim2.new(0.5, -90, 0.4, 0)
Main.BackgroundColor3 = DarkGray
Main.BackgroundTransparency = 0.15 -- Fix lỗi bị đen màn hình
Main.Active = true
Main.Draggable = true
Main.Visible = true

local StrokeMain = Instance.new("UIStroke", Main)
StrokeMain.Color = NeonRed
StrokeMain.Thickness = 2

-- NÚT BẬT/TẮT MENU (TOGGLE)
local ToggleBtn = Instance.new("TextButton", G)
ToggleBtn.Size = UDim2.new(0, 70, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = NeonRed
ToggleBtn.Text = "GALAXY"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ToggleBtn).Color = NeonRed

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "GALAXY v10.8"
Title.BackgroundColor3 = NeonRed
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- KHU VỰC CHỨC NĂNG (SCROLL)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40)
Scroll.Position = UDim2.new(0, 0, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroll.ScrollBarThickness = 3

local function createBtn(txt, pos, func)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, pos)
    b.Text = txt .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    b.Font = Enum.Font.SourceSansBold
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(80, 80, 80)
    
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = txt .. (act and ": ON" or ": OFF")
        b.TextColor3 = act and NeonRed or Color3.new(0.9, 0.9, 0.9)
        s.Color = act and NeonRed or Color3.fromRGB(80, 80, 80)
        func(act)
    end)
end

-- =========================================
-- [1] UNSTOPPABLE SPEED (TỪ v10.4)
-- =========================================
_G.SpeedValue = 16
RS.Stepped:Connect(function()
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            -- Ép tốc độ liên tục kể cả khi đang Ragdoll/Bị đánh
            LP.Character.Humanoid.WalkSpeed = _G.SpeedValue
        end
    end)
end)

-- =========================================
-- [2] AUTO BLOCK THÔNG MINH (LOGIC v10.4)
-- =========================================
_G.AutoBlock = false
local isHoldingF = false
local IgnoreAnims = {"emoji", "dance", "emote", "rest", "idle", "walk", "run", "fall", "jump", "block", "guard", "hold"}

RS.RenderStepped:Connect(function()
    if _G.AutoBlock and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local shouldBlock = false
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = v.Character.HumanoidRootPart
                    local dist = (LP.Character.HumanoidRootPart.Position - targetHRP.Position).Magnitude
                    if dist <= 18 then
                        -- Check lướt (Dash)
                        local dot = (targetHRP.Position - LP.Character.HumanoidRootPart.Position).Unit:Dot(targetHRP.Velocity.Unit)
                        if targetHRP.Velocity.Magnitude > 50 and dot < -0.75 then
                            shouldBlock = true
                        else
                            -- Check Chiêu thức (Animation)
                            local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                            if anim then
                                for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                    if t.IsPlaying then
                                        local n = t.Animation.Name:lower()
                                        local isIgnore = false
                                        for _, w in pairs(IgnoreAnims) do if n:find(w) then isIgnore = true break end end
                                        if not isIgnore and not n:find("final") then
                                            local thres = (dist < 8) and 0.72 or 0.91
                                            if t.WeightCurrent > thres then shouldBlock = true; break end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if shouldBlock then break end
            end
        end)
        if shouldBlock and not isHoldingF then
            isHoldingF = true
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        elseif not shouldBlock and isHoldingF then
            isHoldingF = false
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
    end
end)

-- =========================================
-- [3] SMART AIM & [4] PRO ESP (v10.2)
-- =========================================
createBtn("SMART AIM", 10, function(on)
    _G.Aim = on
    task.spawn(function()
        while _G.Aim do RS.RenderStepped:Wait()
            if LP.Character then
                local t, minD = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character.Humanoid.Health > 0 then
                        local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if d < minD then minD = d t = p.Character.HumanoidRootPart end
                    end
                end
                if t then LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(t.Position.X, LP.Character.HumanoidRootPart.Position.Y, t.Position.Z)) end
            end
        end
    end)
end)

createBtn("PRO ESP", 50, function(on)
    _G.ESP = on
    task.spawn(function()
        while _G.ESP do task.wait(0.2)
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    if not v.Character:FindFirstChild("Highlight") then Instance.new("Highlight", v.Character).FillColor = NeonRed end
                end
            end
            if not _G.ESP then
                for _, v in pairs(Players:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
                end
            end
        end
    end)
end)

createBtn("AUTO BLOCK", 90, function(on) _G.AutoBlock = on end)

-- SPEED BOX
local Lb = Instance.new("TextLabel", Scroll)
Lb.Size = UDim2.new(1, 0, 0, 20)
Lb.Position = UDim2.new(0, 0, 0, 135)
Lb.Text = "SET SPEED:"
Lb.TextColor3 = NeonRed
Lb.BackgroundTransparency = 1
Lb.Font = Enum.Font.SourceSansBold

local I = Instance.new("TextBox", Scroll)
I.Size = UDim2.new(0, 100, 0, 30)
I.Position = UDim2.new(0.5, -50, 0, 160)
I.Text = "16"
I.BackgroundColor3 = Color3.fromRGB(50,50,50)
I.TextColor3 = NeonRed
I.FocusLost:Connect(function() _G.SpeedValue = tonumber(I.Text) or 16 end)

createBtn("CLOSE HUB", 220, function() G:Destroy() end)
