-- GALAXY Premium v4.4 - TOTAL LOCK (FIX ĐỨNG IM)
local Bone_Target = 0.96      
local Instant_Lock = true     
local Spread_Fix = 0.0        
local Prediction_Scale = 1.5 

function OnFireButtonDown(is_touching, enemy_pos, enemy_velocity, enemy_status)
    -- 1. THOÁT LỆNH: Nếu thả tay hoặc địch gục
    if not is_touching or enemy_status == "DOWN" then
        ResetAimLock()
        return nil 
    end

    -- 2. LOGIC KHÓA MỤC TIÊU TỔNG LỰC
    if is_touching and enemy_status == "ALIVE" then
        -- Tọa độ đỉnh đầu gốc
        local head_x = enemy_pos.x
        local head_y = enemy_pos.y + (enemy_pos.height * Bone_Target)
        
        -- KIỂM TRA CHUYỂN ĐỘNG:
        if math.abs(enemy_velocity.x) < 0.1 and math.abs(enemy_velocity.y) < 0.1 then
            -- TRƯỜNG HỢP ĐỊCH ĐỨNG IM: Ghim chết tại tọa độ gốc
            SetCrosshairPosition(head_x, head_y)
        else
            -- TRƯỜNG HỢP ĐỊCH DI CHUYỂN: Kích hoạt dự đoán đón đầu
            local predict_x = head_x + (enemy_velocity.x * Prediction_Scale)
            local predict_y = head_y + (enemy_velocity.y * Prediction_Scale)
            SetCrosshairPosition(predict_x, predict_y)
        end
        
        -- Luôn giữ đạn thẳng
        FixBulletTrajectory(Spread_Fix)
    end
end
