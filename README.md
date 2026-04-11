-- Cấu hình khóa mục tiêu nâng cao
local Aim_Height_Offset = 0.85 
local Stickiness = 85 -- Giảm nhẹ từ 100 xuống 85 để tránh bị "giật" do khóa cứng
local Smoothing = 0.15 -- Chỉ số làm mượt (Càng nhỏ càng mượt, ít rung)

function AutoHeadAim(enemy_pos, current_crosshair)
    -- Xác định tọa độ mục tiêu
    local target_head_y = enemy_pos.y + (enemy_pos.height * Aim_Height_Offset)
    
    -- Tính toán khoảng cách cần di chuyển
    local delta_y = target_head_y - current_crosshair.y
    
    -- FIX RUNG: Chỉ xử lý nếu khoảng cách đủ lớn (vượt qua vùng nhiễu)
    if math.abs(delta_y) > 0.5 then 
        -- Thay vì nhảy thẳng, ta di chuyển từng bước nhỏ mượt mà
        local smooth_move = delta_y * Smoothing * (Stickiness / 100)
        return current_crosshair.y + smooth_move
    else
        -- Nếu đã quá gần mục tiêu, giữ nguyên để triệt tiêu rung động nhỏ
        return target_head_y
    end
end
