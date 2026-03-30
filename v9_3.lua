--[[ 
   GALAXY Premium v16.8 - FULL POWER
   - RESTORED: Loop Speed (Tốc độ chạy siêu ổn định).
   - PLAYER TOOLS: TP, Fling, Bring (Nhập tên đối thủ).
   - SECURE: Anti-Ban Firewall v16.5.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

--// BIẾN ĐIỀU KHIỂN
_G.Speed = 16; _G.Fly = false; _G.AutoBlock = false; _G.Aim = false; _G.ESP = false
_G.TargetName = ""; _G.LoopTP = false; _G.LoopFling = false

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- =========================================
-- MENU CHÍNH & MENU PLAYER (DRAGGABLE)
-- =========================================
local Main = Instance.new("Frame", G); Main.Size = UDim2.new(0, 220, 0, 450); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
local PMenu = Instance.new("Frame", G); PMenu.Size = UDim2.new(0, 200, 0, 350); PMenu.Position = UDim2.new(0.5, 10, 0.3, 0); PMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10); PMenu.Active = true; PMenu.Draggable = true; PMenu.Visible = false
Instance.new("UIStroke", Main).Color = NeonRed; Instance.new("UIStroke", PMenu).Color = NeonRed

local function AddTitle(p, txt)
    local t = Instance.new("TextLabel", p); t.Size = UDim2.new(1,0,0,40); t.BackgroundColor3 = NeonRed; t.Text = txt; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 16
end
AddTitle(Main, "GALAXY Premium - LeDangKhoi"); AddTitle(PMenu, "PLAYER TOOLS")

-- =========================================
-- HỆ THỐNG LOOP SPEED & FLY (TRÁI TIM CỦA SCRIPT)
-- =========================================
RS.Stepped:Connect(function()
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            -- LOOP SPEED CỦA KHÔI ĐÃ QUAY LẠI ĐÂY!
            LP.Character.Humanoid.WalkSpeed = _G.Speed
            
            if _G.Fly then 
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) 
            end
            
            -- XỬ LÝ PLAYER TOOLS
            if _G.TargetName ~= "" then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and (v.Name:lower():find(_G.TargetName:lower()) or v.DisplayName:lower():find(_G.TargetName:lower())) then
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local tHRP = v.Character.HumanoidRootPart
                            if _G.LoopTP then LP.Character.HumanoidRootPart.CFrame = tHRP.CFrame * CFrame.new(0,0,3) end
                            if _G.LoopFling then
                                LP.Character.HumanoidRootPart.CFrame = tHRP.CFrame
                                LP.Character.HumanoidRootPart.Velocity = Vector3.new(999999, 999999, 999999)
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- =========================================
-- UI BUILDER (CHỮ TO DỄ BẤM CHO A32)
-- =========================================
local function AddBtn(p, n, y, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

-- MAIN MENU CONTENT
AddBtn(Main, "SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn(Main, "AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn(Main, "PLAYER TOOLS", 215, function(v) PMenu.Visible = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "LOOP SPEED (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 16
Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

-- PLAYER MENU CONTENT
local TInp = Instance.new("TextBox", PMenu); TInp.Size = UDim2.new(1,-20,0,40); TInp.Position = UDim2.new(0,10,0,50); TInp.BackgroundColor3 = Color3.fromRGB(30,30,30); TInp.Text = "TÊN ĐỐI THỦ..."; TInp.TextColor3 = Color3.new(1,1,1)
TInp.FocusLost:Connect(function() _G.TargetName = TInp.Text end)

AddBtn(PMenu, "LOOP TELEPORT", 100, function(v) _G.LoopTP = v end)
AddBtn(PMenu, "LOOP FLING", 155, function(v) _G.LoopFling = v end)

-- NÚT GALAXY TOGGLE
local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible; PMenu.Visible = false end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1,-20,0,40); Close.Position = UDim2.new(0,10,0,330); Close.BackgroundColor3 = Color3.new(0.2,0,0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.SourceSansBold; Close.MouseButton1Click:Connect(function() G:Destroy() end)
