---------------------------------------------------------------------------
--                                                                       --
--   Title: Artificial Horizon/Attitude Indicator Widget "AttInd"        --
--  Author: Shane Christopherson                                         --
--    Date: 2026-05-29                                                   --
-- Version: 1.2.0                                                        --
--  Source: https://github.com/qsiguy/EdgeTX-Widgets                     --
--          https://www.youtube.com/@shanesdiy                           --
--                                                                       --
-- Copyright (C): Shane Christopherson/Shane's DIY                       --
--                                                                       --
-- License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               --
--                                                                       --
-- This program is free software; you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License version 2 as     --
-- published by the Free Software Foundation.                            --
--                                                                       --
-- This program is distributed in the hope that it will be useful        --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          --
-- GNU General Public License for more details.                          --
--                                                                       --
-- Put in /WIDGETS/AttInd/                                               --
--                                                                       --
-- NOTE: Telemetry ratio must be set to high speed. If using 100Hz       --
-- packet rate you must have telem ratio 1:4 (min) or 1:2. If using		 --
-- 333Hz you must use 1:16 (min), 1:8, 1:4, or 1:2. Higher(slower) and	 --
-- the data is too slow for linear response and the widget will lag.	 --
--                                                                       --
-- Pitch telemetry value must be named "Ptch" and roll must be named	 --
-- "Roll". Telemetry value can be renamed in the radio telemetry list	 --
-- or if another name is desired, edit lines 243 & 244 below with your	 --
-- actual pitch and roll telemetry names.								 --
---------------------------------------------------------------------------

local function create(zone, options)
    return { zone = zone }
end

local function update(widget, options)
end

local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

------------------------------------------------------------
-- DRAW ROLL ARC
------------------------------------------------------------
------------------------------------------------------------
-- FIXED ROLL SCALE
------------------------------------------------------------
local function drawRollScale(cx, cy, radius)

    for a = -90, 90, 10 do
        local rad = math.rad(a)

        local x = cx + math.sin(rad) * (radius * 0.95)
        local y = cy - math.cos(rad) * (radius * 0.95)

        lcd.drawLine(x-1, y, x+1, y, SOLID)
        lcd.drawLine(x, y-1, x, y+1, SOLID)
    end
end

------------------------------------------------------------
-- ROLL POINTER
------------------------------------------------------------
local function drawRollPointer(cx, cy, radius, roll)

    local r = math.rad(roll)

    local x = cx + math.sin(r) * (radius * 0.33)
    local y = cy - math.cos(r) * (radius * 0.33)

    -- thick stem
    lcd.drawLine(cx, cy, x, y, SOLID)
    lcd.drawLine(cx + 1, cy, x + 1, y, SOLID)
    lcd.drawLine(cx + 2, cy, x + 2, y, SOLID)	
    lcd.drawLine(cx - 1, cy, x - 1, y, SOLID)
    lcd.drawLine(cx - 2, cy, x - 2, y, SOLID)	

------------------------------------------------------------
-- ROLL TRIANGLE (ANGLE-ALIGNED)
------------------------------------------------------------

local tx = cx + math.sin(r) * (radius * 0.90)
local ty = cy - math.cos(r) * (radius * 0.90)

local size = 5

-- inward direction (toward center of display)
local ix = math.sin(r)
local iy = -math.cos(r)

-- perpendicular direction (along arc)
local px = math.cos(r)
local py = math.sin(r)

-- base center (slightly inward)
local bx = tx + ix * size
local by = ty + iy * size

-- triangle base corners
local lx = bx + px * size
local ly = by + py * size

local rx = bx - px * size
local ry = by - py * size

-- reverse tip/base relationship fixes outward flip
lcd.drawLine(lx, ly, rx, ry, SOLID)  -- base
lcd.drawLine(lx, ly, tx, ty, SOLID)  -- left to tip
lcd.drawLine(rx, ry, tx, ty, SOLID)  -- right to tip

end

------------------------------------------------------------
-- WINGS-LEVEL BAR
------------------------------------------------------------
local function drawWingsBar(cx, cy, roll)

    local r = math.rad(roll)

    local len = 80

    -- rotate bar with roll
    local cs = math.cos(r)
    local sn = math.sin(r)

    local x1 = cx - len * cs
    local y1 = cy - len * sn

    local x2 = cx + len * cs
    local y2 = cy + len * sn

    -- thickened bar (double line)
    lcd.drawLine(x1, y1, x2, y2, SOLID)
    lcd.drawLine(x1, y1 + 1, x2, y2 + 1, SOLID)
    lcd.drawLine(x1, y1 + 2, x2, y2 + 2, SOLID)
    lcd.drawLine(x1, y1 - 1, x2, y2 - 1, SOLID)
    lcd.drawLine(x1, y1 - 2, x2, y2 - 2, SOLID)		
end

------------------------------------------------------------
-- ROLL-COMPENSATED PITCH LADDER
------------------------------------------------------------
local function drawPitchLadder(cx, cy, pitch, roll)

    local pixelsPerDeg = 2.2

    local r = math.rad(roll)
    local cs = math.cos(r)
    local sn = math.sin(r)

    for deg = -30, 30, 10 do

        if deg ~= 0 then

            ------------------------------------------------
            -- Ladder position relative to center
            ------------------------------------------------
            local dy = (pitch - deg) * pixelsPerDeg

            local len = 20

            if math.abs(deg) == 20 then
                len = 30
            elseif math.abs(deg) == 30 then
                len = 40
            end

            ------------------------------------------------
            -- Left segment endpoints (before rotation)
            ------------------------------------------------
            local lx1 = -len
            local ly1 = dy

            local lx2 = -5
            local ly2 = dy

            ------------------------------------------------
            -- Right segment endpoints
            ------------------------------------------------
            local rx1 = 5
            local ry1 = dy

            local rx2 = len
            local ry2 = dy

            ------------------------------------------------
            -- Rotate left segment
            ------------------------------------------------
            local x1 = cx + lx1 * cs - ly1 * sn
            local y1 = cy + lx1 * sn + ly1 * cs

            local x2 = cx + lx2 * cs - ly2 * sn
            local y2 = cy + lx2 * sn + ly2 * cs

            ------------------------------------------------
            -- Rotate right segment
            ------------------------------------------------
            local x3 = cx + rx1 * cs - ry1 * sn
            local y3 = cy + rx1 * sn + ry1 * cs

            local x4 = cx + rx2 * cs - ry2 * sn
            local y4 = cy + rx2 * sn + ry2 * cs

            ------------------------------------------------
            -- Draw ladder lines
            ------------------------------------------------
            lcd.drawLine(x1, y1, x2, y2, SOLID)
            lcd.drawLine(x3, y3, x4, y4, SOLID)

            ------------------------------------------------
            -- Labels (keep horizontal)
            ------------------------------------------------
            lcd.drawText(
                x1 - 12,
                y1 - 4,
                tostring(math.abs(deg)),
                SMLSIZE
            )

            lcd.drawText(
                x4 + 2,
                y4 - 4,
                tostring(math.abs(deg)),
                SMLSIZE
            )
        end
    end
end

------------------------------------------------------------
-- MAIN
------------------------------------------------------------
local function refresh(widget)

    local z = widget.zone
--Edit next 3 lines for actual telemetry name for pitch (Ptch), roll (Roll), and flight mode (FM) if different
    local pitch = getValue("Ptch") or 0
    local roll  = getValue("Roll") or 0
    local fm    = getValue("FM") or ""

    local cx = z.x + z.w / 2
    local cy = z.y + z.h / 2

    --------------------------------------------------------
    -- SKY / GROUND
    --------------------------------------------------------
    local pxPerDeg = 2.2
    local pitchOffset = clamp(pitch, -60, 60) * pxPerDeg

    local horizonY = cy + pitchOffset

    lcd.drawFilledRectangle(
        z.x,
        z.y,
        z.w,
        math.max(0, horizonY - z.y),
        lcd.RGB(80,170,255)
    )

    lcd.drawFilledRectangle(
        z.x,
        horizonY,
        z.w,
        z.h,
        lcd.RGB(140,90,40)
    )
--------------------------------------------------------
-- HORIZON SHADING BAND
--------------------------------------------------------

local band = 6  -- thickness of shading zone

for y = horizonY - band, horizonY + band, 3 do

    if y >= z.y and y <= z.y + z.h then

        local dist = y - horizonY

        -- SKY SIDE (slightly darker blue near horizon)
        if dist < 0 then
            lcd.drawLine(
                z.x,
                y,
                z.x + z.w,
                y,
                SOLID
            )
        else
            -- GROUND SIDE (slightly lighter near horizon)
            lcd.drawLine(
                z.x,
                y,
                z.x + z.w,
                y,
                SOLID
            )
        end
    end
end

--------------------------------------------------------
-- ATMOSPHERIC HORIZON GLOW
--------------------------------------------------------

-- center horizon line
lcd.drawLine(
    z.x,
    horizonY,
    z.x + z.w,
    horizonY,
    SOLID
)

lcd.drawLine(
    z.x,
    horizonY + 1,
    z.x + z.w,
    horizonY + 1,
    SOLID
)

-- outer glow lines
lcd.drawLine(
    z.x,
    horizonY - 3,
    z.x + z.w,
    horizonY - 3,
    SOLID
)

lcd.drawLine(
    z.x,
    horizonY + 4,
    z.x + z.w,
    horizonY + 4,
    SOLID
)
drawPitchLadder(cx, cy, pitch, roll)
    --------------------------------------------------------
    -- AIRCRAFT SYMBOL
    --------------------------------------------------------
    lcd.drawLine(cx - 15, cy, cx + 15, cy, SOLID)
    lcd.drawLine(cx, cy - 6, cx, cy + 6, SOLID)

    --------------------------------------------------------
    -- ROLL ARC
    --------------------------------------------------------
local radius = math.min(z.w, z.h) * 0.45

drawRollScale(cx, cy - 10, radius)
drawRollPointer(cx, cy - 0, radius, roll)
drawWingsBar(cx, cy + 0, roll)

    --------------------------------------------------------
    -- FLIGHT MODE *Intentionally disabled, uncomment 6 lines below this to enable flight mode text
    --------------------------------------------------------
--    lcd.drawText(
--        cx,
--        z.y + 2,
--        fm,
--        CENTER + MIDSIZE
--    )

    --------------------------------------------------------
    -- TELEMETRY
    --------------------------------------------------------
lcd.drawText(
    z.x + 3,
    z.y + 4,
    string.format("P:%4d", pitch),
    SMLSIZE
)

lcd.drawText(
    z.x + 3,
    z.y + 18,
    string.format("R:%4d", roll),
    SMLSIZE
)
end

return {
    name = "AttInd",
    options = {},
    create = create,
    update = update,
    refresh = refresh
}