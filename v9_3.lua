--[[ 
   GALAXY PREMIUM v17.5 - THE RESTORATION
   - FIXED: Loop Speed, Aim, Fly, Auto Block hoạt động trở lại.
   - OPTIMIZED: Hệ thống quét mục tiêu siêu tốc.
   - BRANDING: GALAXY PREMIUM.
]]

-- =========================================
-- SCRIPT INTRO (F9 CONSOLE)
-- =========================================
print([[ 
    ____________________________________________________
   /                                                    \
   |   ⚡ GALAXY PREMIUM v17.5 - REPAIRED SUCCESS! ⚡    |
   |   🌌 DEVELOPER: LeDangKhoi                         |
   |   🔥 STATUS: ALL FUNCTIONS RESTORED                |
   \____________________________________________________/
]])

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")

-- THÔNG BÁO
StarterGui:SetCore("SendNotification", {
    Title = "GALAXY PREMIUM";
    Text = "Version 17.5 - Fixed All!";
    Duration = 5;
})

--// BIẾN ĐIỀU KHIỂN (FIXED)
_G.Speed = 50; _G.TargetName = ""; _G.Fly = false; _G.Aim = false; _G.AutoBlock = false
_G.LoopTP = false; _G.LoopFling = false; _G.Viewing = false; _G.Bring = false

-- DỌN DẸP UI CŨ
for _, v in pairs(LP.PlayerGui:GetChildren()) do
    if v.Name == "GalaxyKhoi" then v:Destroy() end
end

--// HÀM TÌM PLAYER
local function GetPlayer(name)
    if name == "" then return nil end
    name = name:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and (v.Name:lower():find(name) or v.DisplayName:lower():find(name)) then
            return v
        end
    end
    return nil
end

-- =========================================
-- HỆ THỐNG XỬ LÝ CHÍNH (FIXED v17.5)
-- =========================================
RS.RenderStepped:Connect(function()
    pcall(function()
        local Char = LP.Character
        local HRP = Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char:FindFirstChild("Humanoid")
        if not Char or not HRP or not Hum then return end
        
        -- 1. LOOP SPEED & FLY (FIXED)
        Hum.WalkSpeed = _G.Speed
        if _G.Fly then
            HRP.Velocity = Vector3.new(0, 50, 0) -- Giữ bay ổn định
        end

        -- 2. AUTO BLOCK LOGIC (FIXED)
        if _G.AutoBlock then
            -- Giả lập nhấn nút Block nếu có công cụ hoặc skill
            local tool = Char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end

        -- XỬ LÝ THEO MỤC TIÊU (TARGET TOOLS)
        local target = GetPlayer(_G.TargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tHRP = target.Character.HumanoidRootPart
            
            -- 3. SMART AIM (FIXED)
            if _G.Aim then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, tHRP.Position)
            end

            -- 4. VIEW PLAYER
            if _G.Viewing then
                Camera.CameraType = Enum.CameraType.Track
                Camera.CameraSubject = target.Character.Humanoid
            else
                Camera.CameraType = Enum.CameraType.Custom
                if Camera.CameraSubject ~= Hum then Camera.CameraSubject = Hum end
            end
            
            -- 5. BRING / TP / FLING (FIXED)
            if _G.Bring then tHRP.CFrame = HRP.CFrame * CFrame.new(0, 0, -5) end
            if _G.LoopTP then HRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3) end
            
            if _G.LoopFling then
                local oldPos = HRP.CFrame
                for _, part in pairs(Char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
                HRP.CFrame = tHRP.CFrame
                HRP.Velocity = Vector3.new(999999, 999999, 999999)
                HRP.RotVelocity = Vector3.new(0, 999999, 0)
                task.wait(0.2)
                HRP.CFrame = oldPos
                HRP.Velocity = Vector3.new(0,0,0)
                _G.LoopFling = false
                for _, part in pairs(Char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = true end end
            end
        else
            -- Reset Camera nếu không có mục tiêu
            if not _G.Viewing then 
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = Hum 
            end
        end
    end)
end)

-- =========================================
-- GIAO DIỆN UI (PREMIUM STYLE)
-- =========================================
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "GalaxyKhoi"; G.ResetOnSpawn = false
local NeonRed = Color3.fromRGB(255, 0, 0)

local function AddBtn(p, n, y, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -20, 0, 45); b.Position = UDim2.new(0, 10, 0, y); b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.Text = n; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    local s = false; b.MouseButton1Click:Connect(function() 
        s = not s; 
        b.TextColor3 = s and NeonRed or Color3.new(1,1,1); 
        c(s) 
    end)
end

local Main = Instance.new("Frame", G); Main.Size = UDim2.new(0, 220, 0, 480); Main.Position = UDim2.new(0.5, -230, 0.3, 0); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
local PMenu = Instance.new("Frame", G); PMenu.Size = UDim2.new(0, 200, 0, 450); PMenu.Position = UDim2.new(0.5, 10, 0.3, 0); PMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10); PMenu.Active = true; PMenu.Draggable = true; PMenu.Visible = false
Instance.new("UIStroke", Main).Color = NeonRed; Instance.new("UIStroke", PMenu).Color = NeonRed

-- Title
local t1 = Instance.new("TextLabel", Main); t1.Size = UDim2.new(1,0,0,40); t1.BackgroundColor3 = NeonRed; t1.Text = "GALAXY PREMIUM - MAIN"; t1.TextColor3 = Color3.new(1,1,1); t1.Font = Enum.Font.SourceSansBold
local t2 = Instance.new("TextLabel", PMenu); t2.Size = UDim2.new(1,0,0,40); t2.BackgroundColor3 = NeonRed; t2.Text = "PLAYER TOOLS"; t2.TextColor3 = Color3.new(1,1,1); t2.Font = Enum.Font.SourceSansBold

-- Main Buttons (FIXED ACTION)
AddBtn(Main, "SMART AIM", 50, function(v) _G.Aim = v end)
AddBtn(Main, "AUTO BLOCK", 105, function(v) _G.AutoBlock = v end)
AddBtn(Main, "FLY MODE", 160, function(v) _G.Fly = v end)
AddBtn(Main, "PLAYER TOOLS", 215, function(v) PMenu.Visible = v end)

local Inp = Instance.new("TextBox", Main); Inp.Size = UDim2.new(1, -20, 0, 45); Inp.Position = UDim2.new(0, 10, 0, 270); Inp.BackgroundColor3 = Color3.fromRGB(20,20,20); Inp.Text = "50"; Inp.TextColor3 = NeonRed; Inp.Font = Enum.Font.SourceSansBold; Inp.TextSize = 18; Inp.FocusLost:Connect(function() _G.Speed = tonumber(Inp.Text) or 50 end)

AddBtn(Main, "HỦY SCRIPT", 325, function() G:Destroy(); _G.Viewing = false; _G.Fly = false; Camera.CameraType = Enum.CameraType.Custom end)

-- Player Tools (BIG TEXT)
local TInp = Instance.new("TextBox", PMenu); TInp.Size = UDim2.new(1, -20, 0, 50); TInp.Position = UDim2.new(0, 10, 0, 50); TInp.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TInp.Text = "NHẬP TÊN NGƯỜI CHƠI..."; TInp.TextColor3 = Color3.new(1, 1, 1); TInp.Font = Enum.Font.SourceSansBold; TInp.TextSize = 18; TInp.ClearTextOnFocus = true; TInp.FocusLost:Connect(function() _G.TargetName = TInp.Text end)

AddBtn(PMenu, "VIEW PLAYER", 110, function(v) _G.Viewing = v end)
AddBtn(PMenu, "LOOP TELEPORT", 165, function(v) _G.LoopTP = v end)
AddBtn(PMenu, "BRING PLAYER", 220, function(v) _G.Bring = v end)
AddBtn(PMenu, "LOOP FLING", 275, function(v) _G.LoopFling = v end)

-- Toggle GALAXY Button
local TBtn = Instance.new("TextButton", G); TBtn.Size = UDim2.new(0,70,0,35); TBtn.Position = UDim2.new(0,10,0.5,0); TBtn.BackgroundColor3 = Color3.new(0,0,0); TBtn.Text = "GALAXY"; TBtn.TextColor3 = NeonRed; Instance.new("UIStroke", TBtn).Color = NeonRed
TBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
