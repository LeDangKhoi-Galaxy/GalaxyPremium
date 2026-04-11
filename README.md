-- Cấu hình độ nhạy tổng quát cho mọi dòng súng
local Sensi_Config = {
    ["SMG"] = {force = 1.2, smooth = 0.4},  -- Súng sấy: Kéo nhanh, mượt
    ["Shotgun"] = {force = 2.5, smooth = 0.2}, -- Shotgun: Lực kéo mạnh để vẩy
    ["Rifle"] = {force = 1.0, smooth = 0.5}   -- Súng trường: Ổn định tầm xa
}

function ApplyAimAssist(gun_type)
    local setting = Sensi_Config[gun_type] or Sensi_Config["Rifle"]
    
    -- Giả lập lệnh hệ thống điều chỉnh độ nhạy cảm ứng
    SetSystemSensitivity(setting.force)
    SetTouchSmoothing(setting.smooth)
end

-- Kích hoạt khi nhấn nút bắn
function OnFire(is_pressing)
    if is_pressing then
        -- Tự động tính toán để tâm không văng quá đầu
        LockVerticalAxis(Head_Coordinate) 
    end
end
