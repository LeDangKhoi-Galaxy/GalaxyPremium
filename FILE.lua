-- GALAXY Premium v4.4 - INSTANT HEADSHOT MODULE
local Bone_Target = 0.96      -- Vị trí đỉnh đầu (Full Red)
local Instant_Lock = true     -- Khóa tức thì khi chạm
local Spread_Fix = 0.0        -- Đạn đi thẳng tắp

function OnFireButtonDown(is_touching, enemy_pos)
    if is_touching then
        -- 1. XÁC ĐỊNH MỤC TIÊU: Ngay khi chạm nút bắn
        local head_y = enemy_pos.y + (enemy_pos.height * Bone_Target)
        
        -- 2. ÉP TÂM (HARD LOCK): Không cần kéo, tâm tự nhảy lên đầu
        SetCrosshairPosition(head_y)
        
        -- 3. ĐẠN THẲNG: Triệt tiêu hoàn toàn độ lệch đạn
        FixBulletTrajectory(Spread_Fix)
        
        -- 4. GIỮ CHẶT: Ghim tâm tại đó cho đến khi thả tay
        return head_y
    else
        -- Trả lại tâm khi buông nút bắn
        return nil
    end
end
