-- ╔══════════════════════════════════════════╗
-- ║        TIOO BETA V1 — UI MODULE          ║
-- ║     Theme + Utility + Window + Scroll    ║
-- ╚══════════════════════════════════════════╝

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

-- Hapus GUI lama kalau ada
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

-- Rounded corner
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

-- Border stroke
local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

-- Gradient fill
local function gradient(obj, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rotation or 90
    g.Parent = obj
    return g
end

-- Smooth tween
local function tween(obj, t, props)
    TweenService:Create(
        obj,
        TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- Draggable handler
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
            })
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
-- MAIN WINDOW
-- ═══════════════════════════════════════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 240, 0, 300)
mainFrame.Position = UDim2.new(0.35, 0, 0.28, 0)
mainFrame.BackgroundColor3 = THEME.BG_DARK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = mainGui
corner(mainFrame, 16)
stroke(mainFrame, THEME.BORDER, 1, 0)

-- Top glow line
local topGlow = Instance.new("Frame")
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
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = THEME.BG_PANEL
header.BorderSizePixel = 0
header.Parent = mainFrame
corner(header, 16)

-- Fix bottom corners header
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = THEME.BG_PANEL
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Logo box
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

-- Title
local titleMain = Instance.new("TextLabel")
titleMain.Size = UDim2.new(1, -110, 0, 20)
titleMain.Position = UDim2.new(0, 56, 0, 10)
titleMain.BackgroundTransparency = 1
titleMain.Text = "TIOO BETA V1"
titleMain.TextColor3 = THEME.TEXT_PRIMARY
titleMain.Font = Enum.Font.GothamBold
titleMain.TextSize = 14
titleMain.TextXAlignment = Enum.TextXAlignment.Left
titleMain.Parent = header

-- Subtitle
local titleSub = Instance.new("TextLabel")
titleSub.Size = UDim2.new(1, -110, 0, 16)
titleSub.Position = UDim2.new(0, 56, 0, 30)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Ninja Legends  •  Pro Edition"
titleSub.TextColor3 = THEME.TEXT_MUTED
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 10
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -42, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = THEME.RED
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header
corner(closeBtn, 8)
stroke(closeBtn, THEME.RED, 1, 0.6)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = THEME.RED, TextColor3 = Color3.fromRGB(255, 255, 255)})
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(45, 20, 20), TextColor3 = THEME.RED})
end)

-- Draggable via header
makeDraggable(mainFrame, header)

-- ═══════════════════════════════════════════
-- CONTENT AREA + SCROLL
-- ═══════════════════════════════════════════
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -80)
contentArea.Position = UDim2.new(0, 10, 0, 66)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = THEME.ACCENT
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.Parent = contentArea

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

-- Auto canvas size
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

local listPadding = Instance.new("UIPadding")
listPadding.PaddingBottom = UDim.new(0, 20)
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.Parent = scroll

-- ═══════════════════════════════════════════
-- FLOATING OPEN BUTTON
-- ═══════════════════════════════════════════
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 52, 0, 52)
openBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
openBtn.BackgroundColor3 = THEME.BG_DARK
openBtn.Text = "T"
openBtn.TextColor3 = THEME.ACCENT
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.BorderSizePixel = 0
openBtn.Parent = mainGui
corner(openBtn, 14)
stroke(openBtn, THEME.ACCENT, 1.5, 0.3)
makeDraggable(openBtn)

openBtn.MouseEnter:Connect(function() tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD}) end)
openBtn.MouseLeave:Connect(function() tween(openBtn, 0.15, {BackgroundColor3 = THEME.BG_DARK}) end)

-- Close / Open logic
closeBtn.MouseButton1Click:Connect(function()
    tween(mainFrame, 0.2, {Size = UDim2.new(0, 240, 0, 0)})
    task.delay(0.2, function()
        mainFrame.Visible = false
        openBtn.Visible = true
    end)
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 240, 0, 0)
    tween(mainFrame, 0.25, {Size = UDim2.new(0, 240, 0, 420)})
    openBtn.Visible = false
end)

-- Animasi pertama kali muncul
mainFrame.Size = UDim2.new(0, 240, 0, 0)
tween(mainFrame, 0.3, {Size = UDim2.new(0, 240, 0, 420)})

-- ═══════════════════════════════════════════
-- EXPORTS (untuk dipakai file lain)
-- ═══════════════════════════════════════════
return {
    THEME        = THEME,
    mainGui      = mainGui,
    mainFrame    = mainFrame,
    scroll       = scroll,
    corner       = corner,
    stroke       = stroke,
    gradient     = gradient,
    tween        = tween,
    makeDraggable = makeDraggable,
}
