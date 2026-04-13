-- GALAXY Premium v4.6 - EXTERNAL PATCH
-- Author: Le Dang Khoi
-- Status: OBB Side-by-Side

function OnAimLock()
    -- 1. CHỈ KÍCH HOẠT KHI NHẤN BẮN
    if GetPlayerState(FIRE_BUTTON) == 1 then
        local enemy = GetClosestEnemy()
        
        -- 2. CHẾ ĐỘ GHIM (KHÔNG GHIM ĐỊCH GỤC)
        if enemy and IsAlive(enemy) and GetHealth(enemy) > 0 then
            -- Ép tọa độ vào xương đầu (Bone 0)
            SetLockBone(enemy, 0)
            SetAimSensitivity(100)
            
            -- 3. ĐẠN THẲNG (NO SPREAD)
            SetBulletSpread(0.0)
        else
            -- Địch gục hoặc không có địch -> Trả tâm ngay
            ResetAim()
        end
    else
        ResetAim()
    end
end

-- Vòng lặp quét liên tục để bám mục tiêu di động
while true do
    OnAimLock()
    Sleep(10) -- Tối ưu cho màn hình 120Hz của S26 Ultra
end
