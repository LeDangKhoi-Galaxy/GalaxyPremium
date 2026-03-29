--[[ 
   GALAXY PREMIUM v10.6 - FINAL UI FIXED
   - Fix: Nút Toggle Menu hiện 100% (ZIndex High).
   - Speed: Loop Speed Unstoppable (Ragdoll/Stun).
   - Auto Block: Bản v10.3 chuẩn (No Idle/No Mimic).
   - ESP & Aim: Hoàn hảo.
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
G.Name = "GalaxyV10_6"
G.ResetOnSpawn = false
G.IgnoreGuiInset = true -- Để nút có thể nằm sát mép màn hình

local NeonRed = Color3.fromRGB(255, 0, 0)
local Dark = Color3.fromRGB(15, 15, 15)

-- KHUNG MENU CHÍNH
local Main = Instance.new("Frame", G)
Main.Size, Main.Position = UDim2.new(0, 180, 0, 380), UDim2.new(0.5, -90, 0.5, -190)
Main.BackgroundColor3, Main.Active, Main.Draggable = Dark, true, true
Main.Visible = true
Main.ZIndex = 5
local StrokeMain = Instance.new("UIStroke", Main)
StrokeMain.Color = NeonRed
StrokeMain.Thickness = 2

-- [MỚI] NÚT TOGGLE CỰC CHUẨN
local ToggleBtn = Instance.new("TextButton", G)
ToggleBtn.Name = "ToggleGalaxy"
ToggleBtn.Size = UDim2.new(0, 70, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 100) -- Vị trí dưới nút Chat
ToggleBtn.BackgroundColor3 = Dark
ToggleBtn.TextColor3 = NeonRed
ToggleBtn.Text = "GALAXY"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 10 -- Đảm bảo luôn hiện trên cùng

local StrokeBtn = Instance.new("UIStroke", ToggleBtn)
StrokeBtn.Color = NeonRed
StrokeBtn.Thickness = 1.5

local CornerBtn = Instance.new("UICorner", ToggleBtn)
CornerBtn.CornerRadius = UDim.new(0, 6)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 30), "GALAXY v10.6"
Title.BackgroundColor3, Title.TextColor3, Title.Font = NeonRed, Color3.new(1,1,1), Enum.Font.SourceSansBold

local function createBtn(txt, pos, func)
    local b = Instance.new("TextButton", Main)
    b.Size, b.Position, b.Text = UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, pos + 40), txt .. ": OFF"
    b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(0.8, 0.8, 0.8)
    local s = Instance.new("UIStroke", b) s.Color = Color3.fromRGB(60, 60, 60)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = txt .. (act and ": ON" or ": OFF")
        b.TextColor3 = act and NeonRed or Color3.new(0.8, 0.8, 0.8)
        s.Color = act and NeonRed or Color3.fromRGB(60, 60, 60)
        func(act)
    end)
end

-- =========================================
-- LOGIC TÍNH NĂNG (GIỮ NGUYÊN HOÀN HẢO)
-- =========================================

-- SPEED LOOP
_G.SpeedValue = 16
RS.Stepped:Connect(function()
    pcall(function() if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = _G.SpeedValue end end)
end)

-- AUTO BLOCK
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
                        local dot = (targetHRP.Position - LP.Character.HumanoidRootPart.Position).Unit:Dot(targetHRP.Velocity.Unit)
                        if targetHRP.Velocity.Magnitude > 50 and dot < -0.75 then
                            shouldBlock = true
                        else
                            local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                            if anim then
                                for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                    if t.IsPlaying then
                                        local n = t.Animation.Name:lower()
                                        local isIgnore = false
                                        for _, w in pairs(IgnoreAnims) do if n:find(w) then isIgnore = true break end end
                                        local isM1_4 = n:find("final") or n:find("hit4") or n:find("last") or n:find("combo4")
                                        if not isIgnore and not isM1_4 then
                                            local threshold = (dist < 8) and 0.72 or 0.9
                                            if t.WeightCurrent > threshold then shouldBlock = true; break end
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
        if shouldBlock and not isHoldingF then isHoldingF = true VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        elseif not shouldBlock and isHoldingF then isHoldingF = false VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game) end
    end
end)

-- AIM & ESP
createBtn("SMART AIM", 0, function(on)
    _G.Aim = on
    task.spawn(function()
        while _G.Aim do RS.RenderStepped:Wait()
            if LP.Character then
                local t, minD = nil, math.huge
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character.Humanoid.Health > 0 then
                            local _, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                            if vis then
                                local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if d < minD then minD = d t = p.Character.HumanoidRootPart end
                            end
                        end
                    end
                    if t then LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(t.Position.X, LP.Character.HumanoidRootPart.Position.Y, t.Position.Z)) end
                end)
            end
        end
    end)
end)

createBtn("PRO ESP", 35, function(on)
    _G.ESP = on
    task.spawn(function()
        while _G.ESP do task.wait(0.2)
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    if not v.Character:FindFirstChild("Highlight") then Instance.new("Highlight", v.Character).FillColor = NeonRed end
                    if not v.Character.Head:FindFirstChild("GTag") then
                        local b = Instance.new("BillboardGui", v.Character.Head)
                        b.Name = "GTag"; b.Size = UDim2.new(0,120,0,40); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0,3,0)
                        local l = Instance.new("TextLabel", b)
                        l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = NeonRed; l.Font = 8; l.TextSize = 13
                    end
                    pcall(function()
                        local d = math.floor((v.Character.Head.Position - LP.Character.Head.Position).Magnitude)
                        v.Character.Head.GTag.TextLabel.Text = v.Name.."\n[HP: "..math.floor(v.Character.Humanoid.Health).."] ["..d.."m]"
                    end)
                end
            end
            if not _G.ESP then
                for _, v in pairs(Players:GetPlayers()) do
                    if v.Character then
                        if v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
                        if v.Character.Head:FindFirstChild("GTag") then v.Character.Head.GTag:Destroy() end
                    end
                end
            end
        end
    end)
end)

createBtn("FLY", 70, function(on)
    _G.Fly = on
    RS.Heartbeat:Connect(function() if _G.Fly and LP.Character then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end end)
end)

createBtn("AUTO BLOCK", 105, function(on) _G.AutoBlock = on end)

-- SPEED BOX
local I = Instance.new("TextBox", Main)
I.Size, I.Position, I.Text = UDim2.new(1, -40, 0, 30), UDim2.new(0, 20, 0, 185), "16"
I.BackgroundColor3, I.TextColor3 = Color3.fromRGB(40,40,40), NeonRed
I.FocusLost:Connect(function() _G.SpeedValue = tonumber(I.Text) or 16 end)

createBtn("CLOSE HUB", 305, function() G:Destroy() end)
