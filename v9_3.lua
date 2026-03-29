--[[ 
   GALAXY PREMIUM v11.1 - SUPER OPTIMIZED
   - Fix: Hoạt động 100% trên Delta/Executor Mobile.
   - Speed: Chống Ragdoll/Stun (v10.2).
   - Auto Block: Thông minh (v10.4).
   - Features: Fly, Smart Aim, ESP (Full).
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- XÓA UI CŨ TRÁNH XUNG ĐỘT
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyV11_1" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV11_1"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)

-- MENU FRAME
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 190, 0, 380)
Main.Position = UDim2.new(0.5, -95, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Visible = true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY PREMIUM v11.1"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15

-- NÚT MENU (TOGGLE)
local TBtn = Instance.new("TextButton", G)
TBtn.Size = UDim2.new(0, 60, 0, 30)
TBtn.Position = UDim2.new(0, 10, 0.5, 0)
TBtn.BackgroundColor3 = Color3.new(0,0,0)
TBtn.Text = "MENU"
TBtn.TextColor3 = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Instance.new("UIStroke", TBtn).Color = NeonRed

-- BIẾN ĐIỀU KHIỂN
_G.Speed = 16
_G.Fly = false
_G.AutoBlock = false
_G.Aim = false
_G.ESP = false

-- =========================================
-- HỆ THỐNG QUẢN LÝ TẬP TRUNG (ONE-LOOP SYSTEM)
-- =========================================
task.spawn(function()
    local Ignore = {"idle", "walk", "run", "jump", "fall", "block", "guard", "hold", "dance", "emote"}
    
    while task.wait() do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                -- 1. Loop Speed (Chống Ragdoll)
                LP.Character.Humanoid.WalkSpeed = _G.Speed
                
                -- 2. Fly
                if _G.Fly then
                    LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
                end
                
                -- 3. Auto Block & Smart Aim Logic
                local target = nil
                local minDP = math.huge
                local shouldBlock = false
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        
                        if dist < 20 then
                            -- Tìm mục tiêu cho Aim
                            if dist < minDP and v.Character.Humanoid.Health > 0 then
                                minDP = dist
                                target = v.Character.HumanoidRootPart
                            end
                            
                            -- Xử lý Auto Block
                            if _G.AutoBlock then
                                local animator = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                                if animator then
                                    for _, t in pairs(animator:GetPlayingAnimationTracks()) do
                                        if t.IsPlaying then
                                            local n = t.Animation.Name:lower()
                                            local isIgnore = false
                                            for _, word in pairs(Ignore) do if n:find(word) then isIgnore = true break end end
                                            if not isIgnore and t.WeightCurrent > 0.7 then shouldBlock = true break end
                                        end
                                    end
                                end
                                if v.Character.HumanoidRootPart.Velocity.Magnitude > 55 then shouldBlock = true end
                            end
                        end
                        
                        -- 4. ESP (Highlight)
                        if _G.ESP then
                            if not v.Character:FindFirstChild("Highlight") then
                                local h = Instance.new("Highlight", v.Character)
                                h.FillColor = NeonRed
                                h.OutlineColor = Color3.new(1,1,1)
                            end
                        else
                            if v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
                        end
                    end
                end
                
                -- Thực thi Aim
                if _G.Aim and target then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.Position.Z))
                end
                
                -- Thực thi Block
                if _G.AutoBlock then
                    VIM:SendKeyEvent(shouldBlock, Enum.KeyCode.F, false, game)
                end
            end
        end)
    end
end)

-- =========================================
-- UI BUILDER
-- =========================================
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
AddBtn("PRO ESP", 180, function(v) _G.ESP = v end)

local SpeedInp = Instance.new("TextBox", Main)
SpeedInp.Size = UDim2.new(1, -20, 0, 35)
SpeedInp.Position = UDim2.new(0, 10, 0, 225)
SpeedInp.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedInp.Text = "SET SPEED (16)"
SpeedInp.TextColor3 = NeonRed
SpeedInp.Font = Enum.Font.SourceSansBold
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

AddBtn("CLOSE HUB", 330, function() G:Destroy() end)
