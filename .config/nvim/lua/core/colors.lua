local M = {}

-- Hybrid カラースキームの基本色
M.palette = {
  base = "#1d1f21",       -- 背景色
  red = "#cc6666",        -- エラー
  yellow = "#f0c674",     -- 警告
  green = "#b5bd68",      -- ヒント
  blue = "#81a2be",       -- 情報
}

---@alias RGB { r: number, g: number, b: number }

---Hex色コードをRGBに変換
---@param hex string '#RRGGBB' 形式の色コード
---@return RGB
function M.hex_to_rgb(hex)
  hex = hex:gsub("^#", "")
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

---RGBをHex色コードに変換
---@param color RGB
---@return string '#RRGGBB' 形式の色コード
function M.rgb_to_hex(color)
  return string.format("#%02x%02x%02x",
    math.floor(color.r + 0.5),
    math.floor(color.g + 0.5),
    math.floor(color.b + 0.5))
end

---アルファブレンド（透明度を適用した色の合成）
---@param foreground string 前景色 '#RRGGBB'
---@param background string 背景色 '#RRGGBB'
---@param alpha number 0〜1のアルファ値
---@return string ブレンドされた色 '#RRGGBB'
function M.alpha_blend(foreground, background, alpha)
  local fg = M.hex_to_rgb(foreground)
  local bg = M.hex_to_rgb(background)
  alpha = math.max(0, math.min(1, alpha))

  return M.rgb_to_hex({
    r = fg.r * alpha + bg.r * (1 - alpha),
    g = fg.g * alpha + bg.g * (1 - alpha),
    b = fg.b * alpha + bg.b * (1 - alpha),
  })
end

return M
