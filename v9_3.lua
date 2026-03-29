--[[ 
   GALAXY PREMIUM v11.2 - THE FINAL PERFECTION
   - ESP: Chams + Tên + Máu + Khoảng cách (v10.2 Style, Chữ To).
   - Speed: Chống Ragdoll/Stun (Loop cực mượt).
   - Auto Block: Thông minh v10.4 (Chống mimic block).
   - Smart Aim & Fly: Hoạt động 100%.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyV11_2" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyV11_2"
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
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = NeonRed
Title.Text = "GALAXY PREMIUM v11.2"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15

-- NÚT MENU (TOGGLE)
local TBtn = Instance.new("TextButton", G)
TBtn.Size = UDim2.new(0, 65, 0, 30)
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
-- HỆ THỐNG VẬN HÀNH TẬP TRUNG
-- =========================================
task.spawn(function()
    local Ignore = {"idle", "walk", "run", "jump", "fall", "block", "guard", "hold", "dance", "emote"}
    
    while task.wait() do
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                -- 1. Unstoppable Speed
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
                        
                        -- 3. Xử lý ESP (Style v10.2 - Nâng cấp chữ to)
                        if _G.ESP then
                            -- Chams (Highlight)
                            if not v.Character:FindFirstChild("G_Chams") then
                                local h = Instance.new("Highlight", v.Character)
                                h.Name = "G_Chams"
                                h.FillColor = NeonRed
                                h.FillTransparency = 0.5
                                h.OutlineColor = Color3.new(1,1,1)
                            end
                            -- Billboard Tag (Tên + Máu + Khoảng cách)
                            if not v.Character.Head:FindFirstChild("G_Tag") then
                                local b = Instance.new("BillboardGui", v.Character.Head)
                                b.Name = "G_Tag"; b.Size = UDim2.new(0, 150, 0, 80); b.AlwaysOnTop = true; b.StudsOffset = Vector3.new(0, 4, 0)
                                local l = Instance.new("TextLabel", b)
                                l.Name = "Info"; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
                                l.TextColor3 = NeonRed; l.Font = Enum.Font.SourceSansBold; l.TextSize = 18 -- Chữ to hơn
                                l.TextStrokeTransparency = 0
                            end
                            local health = math.floor(v.Character.Humanoid.Health)
                            v.Character.Head.G_Tag.Info.Text = v.Name .. "\n[HP: " .. health .. "]\n[" .. math.floor(dist) .. "m]"
                        else
                            if v.Character:FindFirstChild("G_Chams") then v.Character.G_Chams:Destroy() end
                            if v.Character.Head:FindFirstChild("G_Tag") then v.Character.Head.G_Tag:Destroy() end
                        end

                        -- 4. Tìm mục tiêu Aim & Auto Block
                        if dist < 20 then
                            if dist < minDP and v.Character.Humanoid.Health > 0 then
                                minDP = dist; target = hrp
                            end
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
-- UI BUILDER
-- =========================================
local function AddBtn(name, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 35); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.Text = name .. ": OFF"
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold
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
SpeedInp.Size = UDim2.new(1, -20, 0, 35); SpeedInp.Position = UDim2.new(0, 10, 0, 225)
SpeedInp.BackgroundColor3 = Color3.fromRGB(40,40,40); SpeedInp.Text = "SET SPEED (16)"
SpeedInp.TextColor3 = NeonRed; SpeedInp.Font = Enum.Font.SourceSansBold
SpeedInp.FocusLost:Connect(function() _G.Speed = tonumber(SpeedInp.Text) or 16 end)

AddBtn("CLOSE HUB", 330, function() G:Destroy() end)
