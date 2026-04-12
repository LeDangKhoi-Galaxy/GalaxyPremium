-- GALAXY Premium v4.4 - NO SPREAD & BULLET STRAIGHT
local Max_Accuracy = 1.0       -- Đẩy độ chính xác lên mức 100%
local Spread_Reduction = 0.0   -- Ép độ nở tâm về 0
local Recoil_Control = 0.95    -- Giảm độ giật súng 95%

function BulletControl(is_firing)
    if is_firing then
        -- 1. Triệt tiêu độ nở tâm khi sấy lâu
        SetWeaponSpread(Spread_Reduction)
        
        -- 2. Giữ đường đạn đi thẳng theo trục tọa độ đã ghim ở đầu
        SetBulletTrajectory("Straight")
        
        -- 3. Tăng độ ổn định cho khung hình để không bị rung khi đạn ra
        SetCameraStability(100)
    end
end

-- Kết hợp với logic Ghim Đầu trước đó
function OnDragToLock(enemy_pos)
    local target_y = enemy_pos.y + (enemy_pos.height * 0.95) -- Ghim đỉnh đầu
    BulletControl(true) -- Kích hoạt đạn thẳng
    return target_y
end
