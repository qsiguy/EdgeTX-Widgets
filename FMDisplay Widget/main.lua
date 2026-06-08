---------------------------------------------------------------------------
--                                                                       --
--   Title: Flight Mode Display Widget "FMDisplay"                        --
--  Author: Shane Christopherson                                         --
--    Date: 2026-05-12                                                   --
-- Version: 1.3.0                          --
--  Source: https://github.com/qsiguy/EdgeTX-TX16S-Models                --
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
-- Put in /WIDGETS/FMDisplay/                                            --
---------------------------------------------------------------------------

---------------------------------------------------
-- Font Helper
---------------------------------------------------

local fontTable = {
  SMLSIZE,
  MIDSIZE,
  DBLSIZE,
  XXLSIZE
}

local function getFontSize(index)

  if index < 0 then
    index = 0
  end

  if index > 3 then
    index = 3
  end

  return fontTable[index + 1]
end

---------------------------------------------------
-- Rounded Rectangle Helper
---------------------------------------------------

local function drawRoundedFilledRect(x, y, w, h, radius, flags)

  -- center
  lcd.drawFilledRectangle(x + radius, y, w - (radius * 2), h, flags)
  lcd.drawFilledRectangle(x, y + radius, w, h - (radius * 2), flags)

  -- corners
  lcd.drawFilledCircle(x + radius, y + radius, radius, flags)
  lcd.drawFilledCircle(x + w - radius - 1, y + radius, radius, flags)

  lcd.drawFilledCircle(x + radius, y + h - radius - 1, radius, flags)
  lcd.drawFilledCircle(x + w - radius - 1, y + h - radius - 1, radius, flags)
end

---------------------------------------------------
-- Widget Functions
---------------------------------------------------

local function create(zone, options)
  return { zone = zone, options = options }
end

local function update(widget, options)
  widget.options = options
end

local function refresh(widget)

  local x = widget.zone.x
  local y = widget.zone.y
  local w = widget.zone.w
  local h = widget.zone.h

  ---------------------------------------------------
  -- Flight Mode
  ---------------------------------------------------

  local fmNum, fmName = getFlightMode()

  if not fmName or fmName == "" then
    fmName = "FM" .. tostring(fmNum or 0)
  end

  ---------------------------------------------------
  -- Widget Option Colors
  ---------------------------------------------------

  local bgKey = "FM" .. tostring(fmNum) .. " BG"

  local bgColor = widget.options[bgKey] or GREEN

  local txtColor = widget.options["Text"] or BLACK

  ---------------------------------------------------
  -- Font Size
  ---------------------------------------------------

  local textFlags = getFontSize(widget.options["Font"] or 2)

  ---------------------------------------------------
  -- Background
  ---------------------------------------------------

  lcd.setColor(CUSTOM_COLOR, bgColor)

     drawRoundedFilledRect(
      x,
      y,
      w,
      h,
      8,
      CUSTOM_COLOR
    )

 ---------------------------------------------------
  -- Title
  ---------------------------------------------------

  local title = "FLIGHT MODE"
  
  local titleFlags = SMLSIZE
  
  local titleW, titleH = lcd.sizeText(title, titleFlags)
  
  local titleX = x + ((w - titleW) //2)
  
  local titleY = y + 4
  
  lcd.setColor(CUSTOM_COLOR, txtColor)
  
  lcd.drawText(
    titleX,
	titleY,
	title,
	titleFlags + CUSTOM_COLOR
  )

  ---------------------------------------------------
  -- Underline
  ---------------------------------------------------

  local lineY = titleY + titleH + 2
  
  lcd.drawLine(
    x + 8,
	lineY,
	x + w - 8,
	lineY,
	SOLID,
	CUSTOM_COLOR
  )

  ---------------------------------------------------
  -- Measure Text
  ---------------------------------------------------

  local textW, textH = lcd.sizeText(fmName, textFlags)

  ---------------------------------------------------
  -- Center Text
  ---------------------------------------------------

  local textX = x + ((w - textW) // 2)
  local textY = lineY + 6 + ((h - lineY - textH) // 2)

  ---------------------------------------------------
  -- Draw Text
  ---------------------------------------------------

  lcd.setColor(CUSTOM_COLOR, txtColor)

  lcd.drawText(
    textX,
    textY,
    fmName,
    textFlags + CUSTOM_COLOR
  )

end

---------------------------------------------------
-- Widget Options
---------------------------------------------------

local options = {

  { "FM0 BG", COLOR, GREEN },
  { "FM1 BG", COLOR, ORANGE },
  { "FM2 BG", COLOR, BLUE },
  { "FM3 BG", COLOR, WHITE },
  { "FM4 BG", COLOR, YELLOW },
  { "FM5 BG", COLOR, LIGHTGREY },
  { "FM6 BG", COLOR, LIGHTBROWN },
  { "FM7 BG", COLOR, RED },

  { "Text", COLOR, BLACK },

  { "Font", VALUE, 2, 0, 3 },

}

---------------------------------------------------
-- Return Widget
---------------------------------------------------

return {
  name = "FMDisplay",
  options = options,
  create = create,
  update = update,
  refresh = refresh
}