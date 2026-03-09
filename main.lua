-- ╔══════════════════════════════════════════╗
-- ║        TIOO BETA V1 — MAIN LOADER        ║
-- ╚══════════════════════════════════════════╝

local BASE_URL = "https://raw.githubusercontent.com/Tiooprime2/Ninja-legend/refs/heads/main/"

local UI      = loadstring(game:HttpGet(BASE_URL .. "SemuaUI/ui.lua"))()
local ESP     = loadstring(game:HttpGet(BASE_URL .. "MainFeat/esp.lua"))()
local Island  = loadstring(game:HttpGet(BASE_URL .. "MainFeat/island.lua"))()
local Element = loadstring(game:HttpGet(BASE_URL .. "MainFeat/element.lua"))()

-- Sambungkan ke UI (mainGui sekarang dikirim juga)
Island.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke, UI.mainGui, UI.onClose)
Element.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke, UI.mainGui, UI.onClose)
ESP.init(UI.scroll, UI.THEME, UI.tween, UI.corner, UI.stroke)
