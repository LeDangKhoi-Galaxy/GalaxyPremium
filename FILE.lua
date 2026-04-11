-- Cấu hình GALAXY Premium v4.4 - TOP HEAD MODULE
local Top_Head_Offset = 0.95 -- Ép tâm vào đỉnh đầu (vị trí cao nhất)
local Lock_Speed = 0.98      -- Tốc độ khóa mục tiêu (gần như tức thì)
local Anti_Over_Lock = true  -- Chống lố qua khỏi đầu

function AimToTopHead(enemy_pos, current_crosshair)
    -- Xác định tọa độ đỉnh đầu
    local target_top_head_y = enemy_pos.y + (enemy_pos.height * Top_Head_Offset)
    
    -- Tính toán khoảng cách Delta
    local delta_y = target_top_head_y - current_crosshair.y
    
    -- Khi người dùng bắt đầu kéo (delta_y âm khi kéo từ dưới lên)
    if math.abs(delta_y) > 0.1 then
        -- Lực kéo siêu mạnh hướng thẳng về đỉnh đầu
        local final_move = current_crosshair.y + (delta_y * Lock_Speed)
        
        -- Cơ chế chặn: Nếu tọa độ mới vượt quá đỉnh đầu, ép trả lại đúng Top_Head
        if Anti_Over_Lock and final_move < target_top_head_y then
            return target_top_head_y
        end
        
        return final_move
    end
    
    return target_top_head_y
end
