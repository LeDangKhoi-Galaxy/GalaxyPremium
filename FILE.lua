-- GALAXY Premium v4.4 - SMART AUTO-RELEASE
local Bone_Target = 0.96      
local Instant_Lock = true     
local Spread_Fix = 0.0        

function OnFireButtonDown(is_touching, enemy_pos, enemy_status)
    -- 1. KIỂM TRA TRẠNG THÁI: Nếu địch gục hoặc không còn chạm nút bắn
    if not is_touching or enemy_status == "DOWN" or enemy_status == "ELIMINATED" then
        -- TRẢ TÂM LẠI BÌNH THƯỜNG: Giải phóng camera để tìm địch mới
        ResetAimLock()
        return nil 
    end

    -- 2. XÁC ĐỊNH MỤC TIÊU (Nếu địch còn sống và đang nhấn bắn)
    if is_touching and enemy_status == "ALIVE" then
        local head_y = enemy_pos.y + (enemy_pos.height * Bone_Target)
        
        -- ÉP TÂM VÀO ĐỈNH ĐẦU
        SetCrosshairPosition(head_y)
        
        -- ĐẠN THẲNG
        FixBulletTrajectory(Spread_Fix)
        
        return head_y
    end
end
