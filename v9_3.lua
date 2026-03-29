--[[ 
   GALAXY PREMIUM v9.3 - FINAL FORCE LOAD
]]
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local function ClearOldUI()
    for _, ui in pairs(LP.PlayerGui:GetChildren()) do
        if ui.Name:find("GalaxyPremium") then ui:Destroy() end
    end
end
ClearOldUI()

local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "GalaxyPremiumV9_3"
G.ResetOnSpawn = false

local NeonRed = Color3.fromRGB(255, 0, 0)
local Dark = Color3.fromRGB(15, 15, 15)

local Main = Instance.new("Frame", G)
Main.Size, Main.Position, Main.Visible = UDim2.new(0, 180, 0, 380), UDim2.new(0.5, -90, 0.5, -190), true
Main.BackgroundColor3, Main.BorderSizePixel = Dark, 0
Main.Active, Main.Draggable = true, true
Instance.new("UIStroke", Main).Color = NeonRed

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 30), "GALAXY v9.3"
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

_G.AutoBlock = false
local isHolding = false
local Blacklist = {"lethal", "counter", "grasp", "pinpoint", "stance", "react", "catch", "absorb", "flow"}

task.spawn(function()
    while true do 
        RS.Heartbeat:Wait()
        if _G.AutoBlock and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local shouldBlock = false
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local tHRP = v.Character.HumanoidRootPart
                        local dist = (LP.Character.HumanoidRootPart.Position - tHRP.Position).Magnitude
                        if dist <= 16 and tHRP.Velocity.Magnitude < 55 then
                            local anim = v.Character.Humanoid:FindFirstChildOfClass("Animator")
                            if anim then
                                for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                                    local n = t.Animation.Name:lower()
                                    local isMove = n:find("run") or n:find("walk") or n:find("idle")
                                    local isAnti = false
                                    for _, word in pairs(Blacklist) do if n:find(word) then isAnti = true break end end
                                    if not isMove and not isAnti and t.IsPlaying and t.TimePosition < 0.45 then
                                        shouldBlock = true; break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if shouldBlock and not isHolding then
                isHolding = true; VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            elseif not shouldBlock and isHolding then
                isHolding = false; VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end
end)

createBtn("FOV AIM", 0, function(on)
    _G.AimEnabled = on
    task.spawn(function()
        while _G.AimEnabled do RS.RenderStepped:Wait()
            pcall(function()
                local target, dist = nil, 250
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character.Humanoid.Health > 0 then
                        local p, o = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                        local mag = (Vector2.new(p.X, p.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if o and mag < dist then dist = mag target = v.Character.HumanoidRootPart end
                    end
                end
                if target then LP.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LP.Character.HumanoidRootPart.Position, Vector3.new(target.Position.X, LP.Character.HumanoidRootPart.Position.Y, target.Position.Z)) end
            end)
        end
    end)
end)

createBtn("PRO ESP", 35, function(on)
    _G.ESP = on
    task.spawn(function()
        while _G.ESP do task.wait(0.5)
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    if not v.Character:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", v.Character)
                        h.FillColor = NeonRed
                    end
                    if not v.Character.Head:FindFirstChild("Tag") then
                        local b = Instance.new("BillboardGui", v.Character.Head)
                        b.Name = "Tag" b.Size, b.AlwaysOnTop = UDim2.new(0,100,0,40), true
                        local l = Instance.new("TextLabel", b)
                        l.Size, l.BackgroundTransparency, l.TextColor3, l.TextSize = UDim2.new(1,0,1,0), 1, NeonRed, 13
                        l.Font = Enum.Font.SourceSansBold
                    end
                    v.Character.Head.Tag.TextLabel.Text = v.Name .. " [" .. math.floor((v.Character.Head.Position - LP.Character.Head.Position).Magnitude) .. "m]"
                end
            end
        end
    end)
end)

createBtn("FLY", 70, function(on)
    _G.Fly = on
    RS.RenderStepped:Connect(function() if _G.Fly and LP.Character then LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) end end)
end)

createBtn("AUTO BLOCK", 105, function(on) _G.AutoBlock = on end)

local I = Instance.new("TextBox", Main)
I.Size, I.Position, I.Text = UDim2.new(1, -40, 0, 30), UDim2.new(0, 20, 0, 185), "16"
I.BackgroundColor3, I.TextColor3 = Color3.fromRGB(40,40,40), NeonRed
_G.S = 16
task.spawn(function() while true do task.wait(0.2) pcall(function() LP.Character.Humanoid.WalkSpeed = _G.S end) end end)
I.FocusLost:Connect(function() _G.S = tonumber(I.Text) or 16 end)

createBtn("CLOSE HUB", 305, function() G:Destroy() end)
