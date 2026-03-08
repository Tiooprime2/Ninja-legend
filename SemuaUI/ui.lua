-- ╔══════════════════════════════════════════╗
-- ║        TIOO BETA V1 — UI MODULE          ║
-- ║     Theme + Utility + Window + Elements  ║
-- ╚══════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

if pGui:FindFirstChild("TiooBetaV1") then
    pGui.TiooBetaV1:Destroy()
end

-- ═══════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════
local THEME = {
    BG_DARK       = Color3.fromRGB(8, 8, 12),
    BG_PANEL      = Color3.fromRGB(14, 14, 20),
    BG_CARD       = Color3.fromRGB(20, 20, 30),
    BG_HOVER      = Color3.fromRGB(28, 28, 42),
    BG_ACTIVE     = Color3.fromRGB(35, 55, 85),
    ACCENT        = Color3.fromRGB(80, 140, 255),
    ACCENT_GLOW   = Color3.fromRGB(60, 100, 220),
    GREEN         = Color3.fromRGB(50, 210, 120),
    RED           = Color3.fromRGB(255, 70, 70),
    ORANGE        = Color3.fromRGB(255, 160, 50),
    TEXT_PRIMARY  = Color3.fromRGB(235, 235, 245),
    TEXT_MUTED    = Color3.fromRGB(130, 130, 160),
    BORDER        = Color3.fromRGB(40, 40, 60),
    FIXED_COLOR   = Color3.fromRGB(30, 70, 35),
    UNFIXED_COLOR = Color3.fromRGB(22, 22, 32),
}

-- ═══════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function gradient(obj, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rotation or 90
    g.Parent = obj
    return g
end

local function tween(obj, time, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    )
end

-- FIX: pakai :Play() di dalam makeDraggable
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            tween(frame, 0.08, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
end

-- ═══════════════════════════════════════════
-- MAIN GUI
-- ═══════════════════════════════════════════
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "TiooBetaV1"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = pGui

-- ═══════════════════════════════════════════
-- MAIN WINDOW (520x340)
-- FIX: ClipsDescendants = false agar dropdown tidak terpotong
-- ═══════════════════════════════════════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 520, 0, 340)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
mainFrame.BackgroundColor3 = THEME.BG_DARK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = false
mainFrame.Parent = mainGui
corner(mainFrame, 16)
stroke(mainFrame, THEME.BORDER, 1, 0)

-- Top accent line
local topGlow = Instance.new("Frame")
topGlow.Name = "TopGlow"
topGlow.Size = UDim2.new(0.6, 0, 0, 2)
topGlow.Position = UDim2.new(0.2, 0, 0, 0)
topGlow.BackgroundColor3 = THEME.ACCENT
topGlow.BorderSizePixel = 0
topGlow.Parent = mainFrame
corner(topGlow, 2)

-- ═══════════════════════════════════════════
-- HEADER
-- ═══════════════════════════════════════════
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = THEME.BG_PANEL
header.BorderSizePixel = 0
header.Parent = mainFrame
corner(header, 16)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = THEME.BG_PANEL
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Logo
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.new(0, 34, 0, 34)
logoBox.Position = UDim2.new(0, 14, 0.5, -17)
logoBox.BackgroundColor3 = THEME.ACCENT
logoBox.BorderSizePixel = 0
logoBox.Parent = header
corner(logoBox, 10)
gradient(logoBox, THEME.ACCENT, THEME.ACCENT_GLOW, 135)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "T"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 18
logoText.Parent = logoBox

-- Titles
local titleMain = Instance.new("TextLabel")
titleMain.Size = UDim2.new(1, -160, 0, 20)
titleMain.Position = UDim2.new(0, 56, 0, 8)
titleMain.BackgroundTransparency = 1
titleMain.Text = "TIOO BETA V1"
titleMain.TextColor3 = THEME.TEXT_PRIMARY
titleMain.Font = Enum.Font.GothamBold
titleMain.TextSize = 14
titleMain.TextXAlignment = Enum.TextXAlignment.Left
titleMain.Parent = header

local titleSub = Instance.new("TextLabel")
titleSub.Size = UDim2.new(1, -160, 0, 16)
titleSub.Position = UDim2.new(0, 56, 0, 30)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Ninja Legends  •  Pro Edition"
titleSub.TextColor3 = THEME.TEXT_MUTED
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 11
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -44, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = THEME.RED
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header
corner(closeBtn, 8)
stroke(closeBtn, THEME.RED, 1, 0.6)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = THEME.RED, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(45,20,20), TextColor3 = THEME.RED}):Play()
end)

makeDraggable(mainFrame, header)

-- ═══════════════════════════════════════════
-- CONTENT AREA + SCROLL
-- ═══════════════════════════════════════════
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -24, 1, -72)
contentArea.Position = UDim2.new(0, 12, 0, 62)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "MainScroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = THEME.ACCENT
scroll.ScrollBarImageTransparency = 0.3
scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scroll.Parent = contentArea

-- Grid layout 2 kolom
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.5, -8, 0, 64)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.StartCorner = Enum.StartCorner.TopLeft
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = scroll

local function updateCanvasSize()
    scroll.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
end
gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

local gridPadding = Instance.new("UIPadding")
gridPadding.PaddingTop = UDim.new(0, 8)
gridPadding.PaddingBottom = UDim.new(0, 12)
gridPadding.PaddingLeft = UDim.new(0, 4)
gridPadding.PaddingRight = UDim.new(0, 4)
gridPadding.Parent = scroll

-- ═══════════════════════════════════════════
-- VERSION LABEL
-- ═══════════════════════════════════════════
local verLabel = Instance.new("TextLabel")
verLabel.Size = UDim2.new(1, 0, 0, 16)
verLabel.Position = UDim2.new(0, 0, 1, -18)
verLabel.BackgroundTransparency = 1
verLabel.Text = "TIOO HUB  •  Ninja Legends  •  Build 001"
verLabel.TextColor3 = THEME.TEXT_MUTED
verLabel.Font = Enum.Font.Gotham
verLabel.TextSize = 10
verLabel.TextXAlignment = Enum.TextXAlignment.Center
verLabel.Parent = mainFrame

-- ═══════════════════════════════════════════
-- FLOATING OPEN BUTTON
-- ═══════════════════════════════════════════
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 56, 0, 56)
openBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
openBtn.BackgroundColor3 = THEME.BG_DARK
openBtn.Text = "T"
openBtn.TextColor3 = THEME.ACCENT
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 24
openBtn.Visible = false
openBtn.BorderSizePixel = 0
openBtn.Parent = mainGui
corner(openBtn, 16)
stroke(openBtn, THEME.ACCENT, 2, 0.3)
makeDraggable(openBtn)

openBtn.MouseEnter:Connect(function()
    tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD}):Play()
end)
openBtn.MouseLeave:Connect(function()
    tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_DARK}):Play()
end)

-- ═══════════════════════════════════════════
-- OPEN / CLOSE LOGIC
-- ═══════════════════════════════════════════
local isOpen = true

local function closeUI()
    isOpen = false
    tween(mainFrame, 0.2, {Size = UDim2.new(0, 520, 0, 0)}):Play()
    task.delay(0.2, function()
        mainFrame.Visible = false
        openBtn.Visible = true
    end)
end

local function openUI()
    isOpen = true
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 520, 0, 0)
    tween(mainFrame, 0.25, {Size = UDim2.new(0, 520, 0, 340)}):Play()
    openBtn.Visible = false
end

closeBtn.MouseButton1Click:Connect(closeUI)
openBtn.MouseButton1Click:Connect(openUI)

-- Animasi pertama kali
mainFrame.Size = UDim2.new(0, 520, 0, 0)
tween(mainFrame, 0.35, {Size = UDim2.new(0, 520, 0, 340)}):Play()

-- ═══════════════════════════════════════════
-- ELEMENT CREATION API
-- ═══════════════════════════════════════════
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.BG_CARD
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #scroll:GetChildren()
    btn.Parent = scroll
    corner(btn, 10)
    stroke(btn, THEME.BORDER, 1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = THEME.TEXT_PRIMARY
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(1, -18, 0.5, -4)
    dot.BackgroundColor3 = THEME.TEXT_MUTED
    dot.BorderSizePixel = 0
    dot.Parent = btn
    corner(dot, 4)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundColor3 = THEME.BG_CARD}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.05, {Size = UDim2.new(0.98, 0, 0.95, 0)}):Play()
        task.delay(0.05, function()
            tween(btn, 0.1, {Size = UDim2.new(1, 0, 1, 0)}):Play()
        end)
        if callback then callback() end
    end)

    updateCanvasSize()
    return btn
end

local function createToggle(name, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 1, 0)
    toggleFrame.BackgroundColor3 = THEME.BG_CARD
    toggleFrame.BorderSizePixel = 0
    toggleFrame.LayoutOrder = #scroll:GetChildren()
    toggleFrame.Parent = scroll
    corner(toggleFrame, 10)
    stroke(toggleFrame, THEME.BORDER, 1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = THEME.TEXT_PRIMARY
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 24)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBtn.BackgroundColor3 = defaultState and THEME.GREEN or THEME.BG_HOVER
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = toggleFrame
    corner(toggleBtn, 12)

    local state = defaultState

    toggleFrame.MouseEnter:Connect(function()
        tween(toggleFrame, 0.15, {BackgroundColor3 = THEME.BG_HOVER}):Play()
    end)
    toggleFrame.MouseLeave:Connect(function()
        tween(toggleFrame, 0.15, {BackgroundColor3 = THEME.BG_CARD}):Play()
    end)

    local function updateToggle()
        state = not state
        if state then
            tween(toggleBtn, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
            toggleBtn.Text = "ON"
        else
            tween(toggleBtn, 0.2, {BackgroundColor3 = THEME.BG_HOVER}):Play()
            toggleBtn.Text = "OFF"
        end
        if callback then callback(state) end
    end

    toggleBtn.MouseButton1Click:Connect(updateToggle)
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)

    updateCanvasSize()
    return {
        frame    = toggleFrame,
        getState = function() return state end,
        setState = function(newState)
            state = newState
            toggleBtn.BackgroundColor3 = state and THEME.GREEN or THEME.BG_HOVER
            toggleBtn.Text = state and "ON" or "OFF"
            if callback then callback(state) end
        end
    }
end

local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 1, 0)
    sliderFrame.BackgroundColor3 = THEME.BG_CARD
    sliderFrame.BorderSizePixel = 0
    sliderFrame.LayoutOrder = #scroll:GetChildren()
    sliderFrame.Parent = scroll
    corner(sliderFrame, 10)
    stroke(sliderFrame, THEME.BORDER, 1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = THEME.TEXT_PRIMARY
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -52, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = THEME.ACCENT
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 38)
    track.BackgroundColor3 = THEME.BG_HOVER
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    corner(track, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)
    stroke(knob, THEME.ACCENT, 2, 0)

    local dragging = false
    local currentValue = default

    local function updateSlider(input)
        local trackPos   = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        local percent    = math.clamp((input.Position.X - trackPos) / trackWidth, 0, 1)
        local value      = math.floor(min + (percent * (max - min)) + 0.5)
        if value ~= currentValue then
            currentValue = value
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, 0.5, -8)
            if callback then callback(value) end
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    sliderFrame.MouseEnter:Connect(function() tween(sliderFrame, 0.15, {BackgroundColor3 = THEME.BG_HOVER}):Play() end)
    sliderFrame.MouseLeave:Connect(function() tween(sliderFrame, 0.15, {BackgroundColor3 = THEME.BG_CARD}):Play() end)

    updateCanvasSize()
    return {
        frame    = sliderFrame,
        getValue = function() return currentValue end,
        setValue = function(val)
            currentValue = math.clamp(val, min, max)
            local percent = (currentValue - min) / (max - min)
            valueLabel.Text = tostring(currentValue)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -8, 0.5, -8)
            if callback then callback(currentValue) end
        end
    }
end

local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.5, -8, 0, 30)
    section.BackgroundTransparency = 1
    section.LayoutOrder = #scroll:GetChildren()
    section.Parent = scroll

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = THEME.BORDER
    line.BorderSizePixel = 0
    line.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 1, 0)
    label.Position = UDim2.new(0.5, -60, 0, 0)
    label.BackgroundColor3 = THEME.BG_DARK
    label.Text = "  " .. title .. "  "
    label.TextColor3 = THEME.TEXT_MUTED
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = section

    updateCanvasSize()
    return section
end

-- ═══════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════
return {
    THEME         = THEME,
    corner        = corner,
    stroke        = stroke,
    gradient      = gradient,
    tween         = tween,
    makeDraggable = makeDraggable,
    mainGui       = mainGui,
    mainFrame     = mainFrame,
    scroll        = scroll,
    contentArea   = contentArea,
    closeBtn      = closeBtn,
    openBtn       = openBtn,
    isOpen        = function() return isOpen end,
    closeUI       = closeUI,
    openUI        = openUI,
    createButton  = createButton,
    createToggle  = createToggle,
    createSlider  = createSlider,
    createSection = createSection,
    updateLayout  = updateCanvasSize,
}
