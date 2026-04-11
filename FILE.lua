-- GALAXY Premium v4.4 - HARD LOCK MODULE
local Top_Head_Offset = 0.95 -- Tọa độ đỉnh đầu
local Lock_Threshold = 1.0   -- Khoảng cách sai số để kích hoạt khóa (pixel)
local is_locked = false      -- Trạng thái khóa

function OnFireButton(is_pressing, enemy_pos, current_crosshair)
    -- Nếu thả nút bắn: Reset trạng thái khóa ngay lập tức
    if not is_pressing then
        is_locked = false
        return current_crosshair.y
    end

    -- Xác định tọa độ mục tiêu đỉnh đầu
    local target_y = enemy_pos.y + (enemy_pos.height * Top_Head_Offset)
    local delta_y = math.abs(current_crosshair.y - target_y)

    -- Cơ chế khóa chặt:
    if is_locked or delta_y <= Lock_Threshold then
        is_locked = true -- Kích hoạt trạng thái khóa chặt
        return target_y  -- Luôn trả về tọa độ đầu, bất chấp tay bạn đang kéo đi đâu
    else
        -- Nếu chưa chạm đầu: Tiếp tục hỗ trợ kéo lên với lực hút mạnh
        local pull_speed = 0.9 -- Tốc độ kéo lên
        return current_crosshair.y + (target_y - current_crosshair.y) * pull_speed
    end
end
