-- ╔══════════════════════════════════════════╗
-- ║        TIOO BETA V1 — MAIN LOADER        ║
-- ║          by Tioo Dev Team                ║
-- ╚══════════════════════════════════════════╝

local BASE_URL = "https://raw.githubusercontent.com/Tiooprime2/Tioo-Prime/refs/heads/main/"

-- ═══════════════════════════════
-- LOAD UI DULU
-- ═══════════════════════════════
local UI = loadstring(game:HttpGet(BASE_URL .. "SemuaUI/ui.lua"))()

-- ═══════════════════════════════
-- LOAD FITUR
-- ═══════════════════════════════
local ESP     = loadstring(game:HttpGet(BASE_URL .. "MainFeat/esp.lua"))()
local Island  = loadstring(game:HttpGet(BASE_URL .. "MainFeat/island.lua"))()
local Element = loadstring(game:HttpGet(BASE_URL .. "MainFeat/element.lua"))()

-- ═══════════════════════════════
-- SAMBUNGKAN KE UI
-- ═══════════════════════════════
Island.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke)
Element.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke)
ESP.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke)
