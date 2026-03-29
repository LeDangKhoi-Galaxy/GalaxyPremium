--[[ 
   GALAXY PREMIUM v9.6 - SMART CLOSEST AIM
   - Aim: Quét toàn màn hình (Full Screen Scan).
   - Target: Tự động khóa mục tiêu đứng gần nhân vật nhất.
   - Reflex: Giữ nguyên Auto Block phản xạ cực nhanh của v9.5.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local Camera = workspace.CurrentCamera

-- Xóa UI cũ
for _, ui in pairs(LP.PlayerGui:GetChildren()) do
    if ui.Name:find("Galaxy") then ui:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV9_6"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)
local Dark = Color3.fromRGB(15, 15, 15)

-- MENU UI
local Main = Instance.new("Frame", G)
Main.Size, Main.Position = UDim2.new(0, 180, 0, 380), UDim2.new(0.5, -90, 0.5, -190)
Main.BackgroundColor3, Main.Active, Main.Draggable = Dark, true, true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 30), "GALAXY v9.6"
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
-- [1] ULTRA REFLEX AUTO BLOCK
-- =========================================
_G.AutoBlock = false
local isBlocking = false
local BL = {"lethal", "counter", "grasp", "pinpoint", "stance", "react", "catch", "absorb", "flow", "water"}

local function ToggleBlock(state)
    CAS:CallFunction("Block", state and Enum.UserInputState.Begin or Enum.UserInputState.End, nil)
end

RS.RenderStepped:Connect(function()
    if _G.AutoBlock and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local shouldBlock = false
        local myHRP = LP.Character.HumanoidRootPart
        pcall(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 18 then
                        local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                        if anim then
                            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                if t.IsPlaying then
                                    local n = t.Animation.Name:lower()
                                    local isMove = n:find("run") or n:find("walk") or n:find("idle") or n:find("fall")
                                    local isAnti = false
                                    for _, w in pairs(BL) do if n:find(w) then isAnti = true break end end
                                    if not isMove and not isAnti and (t.TimePosition < 0.25 or t.WeightCurrent > 0.6) then
                                        shouldBlock = true; break
                                    end
                                end
                            end
                        end
                    end
                end
                if shouldBlock then break end
            end
        end)
        if shouldBlock and not isBlocking then isBlocking = true; ToggleBlock(true)
        elseif not shouldBlock and isBlocking then isBlocking = false; ToggleBlock(false) end
    end
end)

-- =========================================
-- [2] NEW: SMART CLOSEST AIM (FULL SCREEN)
-- =========================================
createBtn("SMART AIM", 0, function(on)
    _G.Aim = on
    task.spawn(function()
        while _G.Aim do 
            RS.RenderStepped:Wait()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local closestPlayer = nil
                    local shortestDistance = math.huge -- Tìm khoảng cách nhỏ nhất
                    
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                            -- Kiểm tra xem đối thủ có trong màn hình không
                            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                            
                            if onScreen then
                                -- Tính khoảng cách 3D thực tế giữa bạn và đối thủ
                                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                
                                if dist < shortestDistance then
                                    shortestDistance = dist
                                    closestPlayer = p.Character.HumanoidRootPart
                                end
                            end
                        end
                    end
                    
                    -- Khóa mục tiêu vào người gần nhất
                    if closestPlayer then
                        LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
                            LP.Character.HumanoidRootPart.Position, 
                            Vector3.new(closestPlayer.Position.X, LP.Character.HumanoidRootPart.Position.Y, closestPlayer.Position.Z)
                        )
                    end
                end)
            end
        end
    end)
end)

-- [3] CÁC TÍNH NĂNG PHỤ
createBtn("PRO ESP", 35, function(on)
    _G.ESP = on
    task.spawn(function()
        while _G.ESP do task.wait(0.5)
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") == nil then
                    Instance.new("Highlight", v.Character).FillColor = NeonRed
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

createBtn("FLY", 70, function(on)
    _G.Fly = on
    RS.Heartbeat:Connect(function() if _G.Fly and LP.Character then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end end)
end)

createBtn("AUTO BLOCK", 105, function(on) _G.AutoBlock = on end)

local I = Instance.new("TextBox", Main)
I.Size, I.Position, I.Text = UDim2.new(1, -40, 0, 30), UDim2.new(0, 20, 0, 185), "16"
I.BackgroundColor3, I.TextColor3 = Color3.fromRGB(40,40,40), NeonRed
_G.S = 16
task.spawn(function() while true do task.wait(0.2) pcall(function() if LP.Character then LP.Character.Humanoid.WalkSpeed = _G.S end end) end end)
I.FocusLost:Connect(function() _G.S = tonumber(I.Text) or 16 end)

createBtn("CLOSE HUB", 305, function() G:Destroy() end)
