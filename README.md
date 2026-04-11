-- Cấu hình khóa mục tiêu
local Aim_Height_Offset = 0.85 -- Tỉ lệ chiều cao vùng đầu
local Stickiness = 100 -- Độ bám của tâm (0-100)

function AutoHeadAim(enemy_pos, current_crosshair)
    -- Xác định tọa độ chính xác của đầu dựa trên khung xương đối thủ
    local target_head_y = enemy_pos.y + (enemy_pos.height * Aim_Height_Offset)
    
    if current_crosshair.y > target_head_y then
        -- Nếu tâm đang ở dưới đầu (ngực), thực hiện kéo nhanh
        local pull_force = (current_crosshair.y - target_head_y) * (Stickiness / 100)
        return current_crosshair.y - pull_force
    else
        -- Khi tâm đã chạm đầu, giữ nguyên tọa độ để không bị lố
        return target_head_y
    end
end
