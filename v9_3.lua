--[[ 
   GALAXY PREMIUM v9.7 - ULTIMATE FIXED
   - Fix ESP: Hiện Highlight, Tên, Máu và Khoảng cách 100%.
   - Fix Auto Block: Chặn M1, Skill siêu tốc, không kẹt di chuyển.
   - Smart Aim: Quét toàn màn hình, nhắm người gần nhất.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- Xóa UI cũ
for _, ui in pairs(LP.PlayerGui:GetChildren()) do
    if ui.Name:find("Galaxy") then ui:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV9_7"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)
local Dark = Color3.fromRGB(15, 15, 15)

-- MENU UI
local Main = Instance.new("Frame", G)
Main.Size, Main.Position = UDim2.new(0, 180, 0, 380), UDim2.new(0.5, -90, 0.5, -190)
Main.BackgroundColor3, Main.Active, Main.Draggable = Dark, true, true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 30), "GALAXY v9.7"
Title.BackgroundColor3, Title.TextColor3, Title.Font = NeonRed, Color3.new(1,1,1), Enum.Font.SourceSansBold

local OpenBtn = Instance.new("TextButton", G)
OpenBtn.Size, OpenBtn.Position, OpenBtn.Text = UDim2.new(0, 50, 0, 30), UDim2.new(0, 5, 0.5, 0), "MENU"
OpenBtn.BackgroundColor3, OpenBtn.TextColor3 = Dark, NeonRed
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

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
-- [1] AUTO BLOCK FIX v9.7
-- =========================================
_G.AutoBlock = false
local isHoldingF = false
local BL = {"lethal", "counter", "grasp", "pinpoint", "stance", "react", "catch", "absorb", "flow", "water"}

RS.Heartbeat:Connect(function()
    if _G.AutoBlock and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local shouldBlock = false
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 18 then
                        local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                        if anim then
                            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                if t.IsPlaying then
                                    local n = t.Animation.Name:lower()
                                    local move = n:find("run") or n:find("walk") or n:find("idle")
                                    local anti = false
                                    for _, w in pairs(BL) do if n:find(w) then anti = true break end end
                                    
                                    -- Nhận diện đòn đánh (M1 hoặc Skill)
                                    if not move and not anti and (t.TimePosition < 0.3 or t.WeightCurrent > 0.5) then
                                        shouldBlock = true; break
                                    end
                                end
                            end
                        end
                    end
                end
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
-- [2] PRO ESP v9.7 (FIXED)
-- =========================================
createBtn("PRO ESP", 35, function(on)
    _G.ESP = on
    task.spawn(function()
        while _G.ESP do task.wait(0.1)
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    -- Chams (Highlight)
                    if not v.Character:FindFirstChild("Highlight") then
                        local hl = Instance.new("Highlight", v.Character)
                        hl.FillColor = NeonRed
                        hl.OutlineTransparency = 0
                    end
                    -- Name, Health, Distance Tag
                    local head = v.Character.Head
                    if not head:FindFirstChild("GalaxyTag") then
                        local bg = Instance.new("BillboardGui", head)
                        bg.Name = "GalaxyTag"
                        bg.Size = UDim2.new(0, 150, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 3, 0)
                        bg.AlwaysOnTop = true
                        
                        local txt = Instance.new("TextLabel", bg)
                        txt.Name = "Info"
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = NeonRed
                        txt.TextStrokeTransparency = 0
                        txt.Font = Enum.Font.SourceSansBold
                        txt.TextSize = 14
                    end
                    
                    pcall(function()
                        local dist = math.floor((head.Position - LP.Character.Head.Position).Magnitude)
                        local hp = math.floor(v.Character.Humanoid.Health)
                        head.GalaxyTag.Info.Text = v.Name .. "\n[HP: " .. hp .. "] [" .. dist .. "m]"
                    end)
                end
            end
            if not _G.ESP then
                for _, v in pairs(Players:GetPlayers()) do
                    if v.Character then
                        if v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
                        if v.Character.Head:FindFirstChild("GalaxyTag") then v.Character.Head.GalaxyTag:Destroy() end
                    end
                end
            end
        end
    end)
end)

-- =========================================
-- [3] SMART AIM (FULL SCREEN)
-- =========================================
createBtn("SMART AIM", 0, function(on)
    _G.Aim = on
    task.spawn(function()
        while _G.Aim do RS.RenderStepped:Wait()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local target = nil
                local minCDist = math.huge
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character.Humanoid.Health > 0 then
                            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                            if vis then
                                local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if d < minCDist then minCDist = d target = p.Character.HumanoidRootPart end
                            end
                        end
                    end
                    if target then
                        LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.Position.Z))
                    end
                end)
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
_G.S = 16
task.spawn(function() while true do task.wait(0.2) pcall(function() if LP.Character then LP.Character.Humanoid.WalkSpeed = _G.S end end) end end)
I.FocusLost:Connect(function() _G.S = tonumber(I.Text) or 16 end)

createBtn("CLOSE HUB", 305, function() G:Destroy() end)
