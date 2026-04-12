-- GALAXY Premium v4.4 - SUPER SENSITIVE & INSTANT LOCK
local Bone_Target = 0.96      
local Instant_Lock = true     
local Spread_Fix = 0.0        
local Sensitivity_Boost = 2.5 -- Tăng tốc độ nhận diện cảm ứng (x2.5 lần)
local Response_Delay = 0      -- Triệt tiêu độ trễ phản hồi

function OnFireButtonDown(is_touching, enemy_pos, enemy_status)
    -- Tăng tốc độ quét lệnh hệ thống
    SetResponseRate(Response_Delay)

    -- 1. KIỂM TRA TRẠNG THÁI: Nếu địch gục hoặc thả tay
    if not is_touching or enemy_status == "DOWN" then
        ResetAimLock()
        return nil 
    end

    -- 2. CƠ CHẾ SIÊU NHẠY: Chỉ cần chạm hoặc nhích nhẹ là khóa
    if is_touching and enemy_status == "ALIVE" then
        local target_y = enemy_pos.y + (enemy_pos.height * Bone_Target)
        
        -- Áp dụng gia tốc nhạy để tâm nhảy lên đỉnh đầu ngay lập tức
        local current_y = GetCrosshairY()
        local instant_move = (target_y - current_y) * Sensitivity_Boost
        
        -- ÉP TÂM HARD LOCK TỨC THÌ
        SetCrosshairPosition(current_y + instant_move)
        
        -- ĐẠN THẲNG TUYỆT ĐỐI
        FixBulletTrajectory(Spread_Fix)
        
        return target_y
    end
end
