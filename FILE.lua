-- GALAXY Premium v4.4 - OBB INJECTOR MODULE
-- Author: Le Dang Khoi
-- Target: Headshot 100% & Auto Release

function Main_AimLock()
    -- 1. ĐỊNH NGHĨA VÙNG KHÓA (Ghim Đỉnh Đầu)
    local AIM_BONE = "BIP01-HEAD"
    local LOCK_INTENSITY = 1.0 -- Khóa tuyệt đối
    
    -- 2. ĐIỀU KIỆN KÍCH HOẠT (Khi nhấn bắn hoặc kéo tâm)
    if Get_FireButton_State() == 1 then
        
        -- Lấy mục tiêu gần nhất
        local target = GetNearestEnemy()
        
        if target then
            -- 3. BỘ LỌC ĐỊCH GỤC (Không ghim khi máu = 0 hoặc trạng thái Down)
            if IsTargetAlive(target) and GetHealth(target) > 0 then
                
                -- Thực hiện ghim chặt vào đầu
                SetAim(target, AIM_BONE, LOCK_INTENSITY)
                
                -- Khử độ nở tâm để đạn thẳng
                SetSpread(0.0)
            else
                -- Tự động nhả tâm khi địch gục
                UnlockAim()
            end
        end
    else
        -- Nhả tâm khi buông nút bắn
        UnlockAim()
    end
end

-- Vòng lặp quét liên tục (60 lần/giây)
while true do
    Main_AimLock()
    Sleep(16) -- Tương thích màn hình 60Hz-120Hz của S26 Ultra
end
