--[[ 
   GALAXY PREMIUM v11.0 - THE FINAL MASTERPIECE
   - Fly: Đã thêm lại (Return).
   - Speed: Chạy bất chấp Ragdoll/Bị đánh (v10.2 Hybrid).
   - Auto Block: Thông minh v10.4 (Chống đứng yên, chống mimic).
   - UI: Khắc phục triệt để lỗi hiển thị trên Mobile.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyV11" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV11"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)

-- MENU FRAME
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 190, 0, 350)
Main.Position = UDim2.new(0.5, -95, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY PREMIUM v11.0"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15

-- TOGGLE BUTTON
local TBtn = Instance.new("TextButton", G)
TBtn.Size = UDim2.new(0, 60, 0, 30)
TBtn.Position = UDim2.new(0, 10, 0.5, 0)
TBtn.BackgroundColor3 = Color3.new(0,0,0)
TBtn.Text = "MENU"
TBtn.TextColor3 = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Instance.new("UIStroke", TBtn).Color = NeonRed

-- [1] FLY (ĐÃ THÊM LẠI)
_G.Fly = false
task.spawn(function()
    while true do
        task.wait()
        if _G.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        end
    end
end)

-- [2] LOOP SPEED (CHỐNG RAGDOLL - v10.2)
_G.Speed = 16
task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = _G.Speed
            end
        end)
    end
end)

-- [3] AUTO BLOCK (LOGIC v10.4 CHUẨN)
_G.AutoBlock = false
local Ignore = {"idle", "walk", "run", "jump", "fall", "block", "guard", "hold", "dance", "emote"}

task.spawn(function()
    while true do
        task.wait()
        if _G.AutoBlock and LP.Character then
            local should = false
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 18 then
                            local animator = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, t in pairs(animator:GetPlayingAnimationTracks()) do
                                    if t.IsPlaying then
                                        local n = t.Animation.Name:lower()
                                        local isIgnore = false
                                        for _, word in pairs(Ignore) do if n:find(word) then isIgnore = true break end end
                                        
                                        if not isIgnore and t.WeightCurrent > 0.75 then
                                            should = true; break
                                        end
                                    end
                                end
                            end
                            if v.Character.HumanoidRootPart.Velocity.Magnitude > 55 then should = true end
                        end
                    end
                end
            end)
            
            if should then
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            else
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end
end)

-- [4] SMART AIM (v10.2)
_G.Aim = false
task.spawn(function()
    while true do
        task.wait()
        if _G.Aim and LP.Character then
            pcall(function()
                local target = nil
                local dist = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                        local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = p.Character.HumanoidRootPart end
                    end
                end
                if target then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.Position.Z))
                end
            end)
        end
    end)
end)

-- UI BUILDER
local function AddBtn(name, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.Text = name .. ": OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name .. (state and ": ON" or ": OFF")
        b.TextColor3 = state and NeonRed or Color3.new(1,1,1)
        callback(state)
    end)
end

AddBtn("SMART AIM", 45, function(v) _G.Aim = v end)
AddBtn("AUTO BLOCK", 90, function(v) _G.AutoBlock = v end)
AddBtn("FLY", 135, function(v) _G.Fly = v end)

local SpeedInp = Instance.new("TextBox", Main)
SpeedInp.Size = UDim2.new(1, -20, 0, 35)
SpeedInp.Position = UDim2.new(0, 10, 0, 180)
SpeedInp.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedInp.Text = "SET SPEED (16)"
SpeedInp.TextColor3 = NeonRed
SpeedInp.Font = Enum.Font.SourceSansBold
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

AddBtn("CLOSE HUB", 300, function() G:Destroy() end)
