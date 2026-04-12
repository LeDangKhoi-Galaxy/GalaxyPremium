-- GALAXY Premium v4.4 - DRAG-TO-LOCK MODULE
local Bone_Head = 0.95        -- Ghim đúng đỉnh đầu
local Drag_Sensitivity = 5    -- Độ nhạy nhận diện kéo (pixel)
local Is_Locked = false

function OnTouchUpdate(touch_start_y, touch_current_y, enemy_pos, current_aim)
    -- Tính toán quãng đường tay bạn đã kéo trên màn hình
    local drag_distance = touch_start_y - touch_current_y 
    
    -- 1. Phát hiện hành động kéo tâm (vuốt lên trên)
    if drag_distance > Drag_Sensitivity then
        
        -- Xác định vị trí đỉnh đầu đối thủ
        local target_y = enemy_pos.y + (enemy_pos.height * Bone_Head)
        
        -- 2. Cơ chế Ghim chặt: Ngay khi phát hiện kéo, ép tâm vào đầu
        Is_Locked = true
        return target_y -- Trả về tọa độ đầu ngay lập tức
        
    else
        -- 3. Nếu không kéo hoặc thả tay: Trả lại trạng thái bình thường
        Is_Locked = false
        return current_aim.y
    end
end
