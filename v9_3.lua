--[[ 
   GALAXY Premium v16.9.4 - INSTANT REACTION
   - UPGRADE: View Player kiểu Infinite Yield (Mượt & Phản ứng nhanh).
   - SPEED: Loại bỏ độ trễ 1-3s, phản ứng tức thì khi nhấn nút.
   - FEATURES: Loop Speed v16.0, TP, Fling, Bring.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--// BIẾN ĐIỀU KHIỂN
_G.Speed = 16; _G.Fly = false; _G.TargetName = ""; 
_G.LoopTP = false; _G.LoopFling = false; _G.Viewing = false

-- DỌN DẸP UI
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

-- =========================================
-- HÀM TÌM PLAYER NHANH
-- =========================================
local function GetPlayer(name)
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and (v.Name:lower():find(name) or v.DisplayName:lower():find(name)) then
            return v
        end
    end
end

-- =========================================
-- HỆ THỐNG XỬ LÝ SIÊU TỐC (NO DELAY)
-- =========================================
RS.RenderStepped:Connect(function()
    pcall(function()
        local Char = LP.Character
        if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
        
        -- Loop Speed v16.0 (Phản ứng ngay lập tức)
        Char.Humanoid.WalkSpeed = _G.Speed
        if _G.Fly then Char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end
        
        -- Xử lý Player Tools
        local target = GetPlayer(_G.TargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tHRP = target.Character.HumanoidRootPart
            
            -- VIEW KIỂU INFINITE YIELD
            if _G.Viewing then
                Camera.CameraSubject = target.Character.Humanoid
            end
            
            -- LOOP TELEPORT (DÍNH CHẶT KHÔNG TRỄ)
            if _G.LoopTP then
                Char.HumanoidRootPart.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
            end
            
            -- LOOP FLING (VẬN TỐC CỰC ĐẠI)
            if _G.LoopFling then
                Char.HumanoidRootPart.CFrame = tHRP.CFrame
                Char.HumanoidRootPart.Velocity = Vector3.new(900000, 900000, 900000)
                Char.HumanoidRootPart.RotVelocity = Vector3.new(0, 900000, 0)
            end
        else
            -- Tự động trả camera về nếu mất mục tiêu hoặc tắt View
            if Camera.CameraSubject ~= Char.Humanoid and not _G.Viewing then
                Camera.CameraSubject = Char.Humanoid
            end
        end
    end)
end)

-- =========================================
-- KHỞI TẠO UI (SAMSUNG A32 OPTIMIZED)
-- =========================================
local Main = Instance.new("Frame", G); Main.Size = UDim2.new(0, 220, 0, 480); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
local PMenu = Instance.new("Frame", G); PMenu.Size = UDim2.new(0, 200, 0, 450); PMenu.Position = UDim2.new(0.5, 10, 0.3, 0); PMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10); PMenu.Active = true; PMenu.Draggable = true; PMenu.Visible = false
Instance.new("UIStroke", Main).Color = NeonRed; Instance.new("UIStroke", PMenu).Color = NeonRed

local function AddTitle(p, txt)
    local t = Instance.new("TextLabel", p); t.Size = UDim2.new(1,0,0,40); t.BackgroundColor3 = NeonRed; t.Text = txt; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 16
end
AddTitle(Main, "GALAXY Premium - LeDangKhoi"); AddTitle(PMenu, "PLAYER TOOLS")

local function AddBtn(p, n, y, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.TextColor3 = s and NeonRed or Color3.new(1,1,1); c(s) end)
end

-- MAIN MENU
AddBtn(Main, "SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn(Main, "AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn(Main, "PLAYER TOOLS", 215, function(v) PMenu.Visible = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "LOOP SPEED (16)"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 16
Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 16 end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(1, -20, 0, 45); Close.Position = UDim2.new(0, 10, 0, 325); Close.BackgroundColor3 = Color3.fromRGB(40, 0, 0); Close.Text = "HỦY SCRIPT"; Close.TextColor3 = Color3.new(1, 1, 1); Close.Font = Enum.Font.SourceSansBold; Close.TextSize = 18
Close.MouseButton1Click:Connect(function() G:Destroy(); _G.Viewing = false; Camera.CameraSubject = LP.Character.Humanoid end)

-- PLAYER MENU
local TInp = Instance.new("TextBox", PMenu); TInp.Size = UDim2.new(1,-20,0,40); TInp.Position = UDim2.new(0,10,0,50); TInp.BackgroundColor3 = Color3.fromRGB(30,30,30); TInp.Text = "TÊN ĐỐI THỦ..."; TInp.TextColor3 = Color3.new(1,1,1)
TInp.FocusLost:Connect(function() _G.TargetName = TInp.Text end)

AddBtn(PMenu, "VIEW PLAYER", 100, function(v) _G.Viewing = v end)
AddBtn(PMenu, "LOOP TELEPORT", 155, function(v) _G.LoopTP = v end)

-- BRING PLAYER (INSTANT)
local BringBtn = Instance.new("TextButton", PMenu); BringBtn.Size = UDim2.new(1,-20,0,45); BringBtn.Position = UDim2.new(0,10,0,210); BringBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); BringBtn.Text = "BRING PLAYER"; BringBtn.TextColor3 = Color3.new(1,1,1); BringBtn.Font = Enum.Font.SourceSansBold; BringBtn.TextSize = 16
BringBtn.MouseButton1Click:Connect(function() 
    local t = GetPlayer(_G.TargetName)
    if t and t.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame end
end)

AddBtn(PMenu, "LOOP FLING", 265, function(v) _G.LoopFling = v end)

-- TOGGLE BUTTON
local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
