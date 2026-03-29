--[[ 
   GALAXY PREMIUM by LeDangKhoi
   - UI: Chữ siêu to, dễ nhìn trên Mobile.
   - ESP: Chams + Info (Tên, HP, Dist) bản v10.2 nhưng to hơn.
   - Speed: Duy trì tốc độ kể cả khi bị Ragdoll/Stun (Loop cực mạnh).
   - Auto Block: Thông minh v10.4 (Chống mimic/idle).
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- XÓA UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)

-- MENU FRAME
local Main = Instance.new("Frame", G)
Main.Size = UDim2.new(0, 220, 0, 400) -- Tăng kích thước menu để chứa chữ to
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY PREMIUM by LeDangKhoi"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16 -- Tên menu theo yêu cầu của bạn

-- TOGGLE BUTTON
local TBtn = Instance.new("TextButton", G)
TBtn.Size = UDim2.new(0, 70, 0, 35)
TBtn.Position = UDim2.new(0, 10, 0.5, 0)
TBtn.BackgroundColor3 = Color3.new(0,0,0)
TBtn.Text = "GALAXY"
TBtn.TextColor3 = NeonRed
TBtn.Font = Enum.Font.SourceSansBold
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Instance.new("UIStroke", TBtn).Color = NeonRed

-- BIẾN ĐIỀU KHIỂN
_G.Speed = 16
_G.Fly = false
_G.AutoBlock = false
_G.Aim = false
_G.ESP = false

-- =========================================
-- LOGIC HỆ THỐNG (v11.2 Optimized)
-- =========================================
task.spawn(function()
    local Ignore = {"idle", "walk", "run", "jump", "fall", "block", "guard", "hold", "dance", "emote"}
    
    while task.wait() do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                -- 1. Loop Speed Unstoppable
                LP.Character.Humanoid.WalkSpeed = _G.Speed
                
                -- 2. Fly
                if _G.Fly then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
                
                local target = nil
                local minDP = math.huge
                local shouldBlock = false
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        local dist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        
                        -- 3. ESP (Chữ to theo ảnh)
                        if _G.ESP then
                            if not v.Character:FindFirstChild("G_Chams") then
                                local h = Instance.new("Highlight", v.Character)
                                h.Name = "G_Chams"; h.FillColor = NeonRed; h.FillTransparency = 0.5
                            end
                            if not v.Character.Head:FindFirstChild("G_Tag") then
                                local b = Instance.new("BillboardGui", v.Character.Head)
                                b.Name = "G_Tag"; b.Size = UDim2.new(0, 200, 0, 100); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                                local l = Instance.new("TextLabel", b)
                                l.Name = "Info"; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
                                l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 22 -- Chữ siêu to
                                l.TextStrokeTransparency = 0
                            end
                            v.Character.Head.G_Tag.Info.Text = v.Name .. "\nHP: " .. math.floor(v.Character.Humanoid.Health) .. "\nDist: " .. math.floor(dist) .. "m"
                        else
                            if v.Character:FindFirstChild("G_Chams") then v.Character.G_Chams:Destroy() end
                            if v.Character.Head:FindFirstChild("G_Tag") then v.Character.Head.G_Tag:Destroy() end
                        end

                        -- 4. Aim & Block
                        if dist < 22 then
                            if dist < minDP and v.Character.Humanoid.Health > 0 then minDP = dist; target = hrp end
                            if _G.AutoBlock then
                                local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                                if anim then
                                    for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                        local n = t.Animation.Name:lower()
                                        local isIgnore = false
                                        for _, w in pairs(Ignore) do if n:find(w) then isIgnore = true break end end
                                        if not isIgnore and t.WeightCurrent > 0.7 then shouldBlock = true; break end
                                    end
                                end
                                if hrp.Velocity.Magnitude > 55 then shouldBlock = true end
                            end
                        end
                    end
                end
                if _G.Aim and target then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.Position.Z))
                end
                if _G.AutoBlock then VIM:SendKeyEvent(shouldBlock, Enum.KeyCode.F, false, game) end
            end
        end)
    end
end)

-- =========================================
-- UI BUILDER (CHỮ TO)
-- =========================================
local function AddBtn(name, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 45) -- Nút bấm cao hơn
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.Text = name .. ": OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 20 -- Chữ trong nút to hơn
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name .. (state and ": ON" or ": OFF")
        b.TextColor3 = state and NeonRed or Color3.new(1,1,1)
        callback(state)
    end)
end

AddBtn("SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn("AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn("FLY", 160, function(v) _G.Fly = v end)
AddBtn("PRO ESP", 215, function(v) _G.ESP = v end)

local SpeedInp = Instance.new("TextBox", Main)
SpeedInp.Size = UDim2.new(1, -20, 0, 45)
SpeedInp.Position = UDim2.new(0, 10, 0, 270)
SpeedInp.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedInp.Text = "SET SPEED (16)"
SpeedInp.TextColor3 = NeonRed
SpeedInp.Font = Enum.Font.SourceSansBold
SpeedInp.TextSize = 20
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

AddBtn("CLOSE HUB", 345, function() G:Destroy() end)
