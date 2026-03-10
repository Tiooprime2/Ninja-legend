-- ╔══════════════════════════════════════════╗
-- ║     TIOO BETA V1 — MISC TAB              ║
-- ║           Walkspeed, dll                 ║
-- ╚══════════════════════════════════════════╝

local function init(page, THEME, tween, corner, stroke, mainGui)

    local Players          = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player           = Players.LocalPlayer

    -- ═══════════════════════════════
    -- HELPER: section label
    -- ═══════════════════════════════
    local function makeSection(title)
        local sec = Instance.new("TextLabel")
        sec.Size = UDim2.new(1, 0, 0, 22)
        sec.BackgroundTransparency = 1
        sec.Text = "  " .. title:upper()
        sec.TextColor3 = THEME.ACCENT
        sec.Font = Enum.Font.GothamBold
        sec.TextSize = 10
        sec.TextXAlignment = Enum.TextXAlignment.Left
        sec.Parent = page
    end

    -- ═══════════════════════════════
    -- WALKSPEED
    -- ═══════════════════════════════
    makeSection("Movement")

    local DEFAULT_SPEED = 16
    local currentSpeed  = 16
    local wsActive      = false

    -- Card utama
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 90)
    card.BackgroundColor3 = THEME.BG_CARD
    card.BorderSizePixel = 0
    card.Parent = page
    corner(card, 10)
    stroke(card, THEME.BORDER, 1, 0)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.85, 0)
    accentBar.Position = UDim2.new(0, 0, 0.075, 0)
    accentBar.BackgroundColor3 = THEME.TEXT_MUTED
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    corner(accentBar, 2)

    -- Icon + Title
    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, 26, 0, 26)
    iconL.Position = UDim2.new(0, 12, 0, 10)
    iconL.BackgroundTransparency = 1
    iconL.Text = "🏃"
    iconL.TextSize = 18
    iconL.Parent = card

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -110, 0, 18)
    nameL.Position = UDim2.new(0, 44, 0, 10)
    nameL.BackgroundTransparency = 1
    nameL.Text = "Walk Speed"
    nameL.TextColor3 = THEME.TEXT_PRIMARY
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 12
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = card

    -- Badge ON/OFF
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 44, 0, 22)
    badge.Position = UDim2.new(1, -54, 0, 10)
    badge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    badge.BorderSizePixel = 0
    badge.Parent = card
    corner(badge, 11)

    local badgeText = Instance.new("TextLabel")
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = "OFF"
    badgeText.TextColor3 = THEME.TEXT_MUTED
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 10
    badgeText.Parent = badge

    -- Value label
    local valueL = Instance.new("TextLabel")
    valueL.Size = UDim2.new(0, 40, 0, 16)
    valueL.Position = UDim2.new(1, -54, 0, 36)
    valueL.BackgroundTransparency = 1
    valueL.Text = tostring(DEFAULT_SPEED)
    valueL.TextColor3 = THEME.ACCENT
    valueL.Font = Enum.Font.GothamBold
    valueL.TextSize = 11
    valueL.TextXAlignment = Enum.TextXAlignment.Center
    valueL.Parent = card

    -- Slider track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 5)
    track.Position = UDim2.new(0, 12, 0, 58)
    track.BackgroundColor3 = THEME.BG_HOVER
    track.BorderSizePixel = 0
    track.Parent = card
    corner(track, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(DEFAULT_SPEED / 500, 0, 1, 0)
    fill.BackgroundColor3 = THEME.ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(DEFAULT_SPEED / 500, -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.AutoButtonColor = false
    knob.Parent = track
    corner(knob, 9)
    stroke(knob, THEME.ACCENT, 2, 0)

    -- Slider min/max label
    local minL = Instance.new("TextLabel")
    minL.Size = UDim2.new(0, 20, 0, 14)
    minL.Position = UDim2.new(0, 12, 0, 70)
    minL.BackgroundTransparency = 1
    minL.Text = "0"
    minL.TextColor3 = THEME.TEXT_MUTED
    minL.Font = Enum.Font.Gotham
    minL.TextSize = 9
    minL.TextXAlignment = Enum.TextXAlignment.Left
    minL.Parent = card

    local maxL = Instance.new("TextLabel")
    maxL.Size = UDim2.new(0, 30, 0, 14)
    maxL.Position = UDim2.new(1, -42, 0, 70)
    maxL.BackgroundTransparency = 1
    maxL.Text = "500"
    maxL.TextColor3 = THEME.TEXT_MUTED
    maxL.Font = Enum.Font.Gotham
    maxL.TextSize = 9
    maxL.TextXAlignment = Enum.TextXAlignment.Right
    maxL.Parent = card

    -- ═══════════════════════════════
    -- SLIDER LOGIC
    -- ═══════════════════════════════
    local dragging = false

    local function applySpeed(val)
        currentSpeed = val
        valueL.Text = tostring(val)
        local pct = val / 500
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -9, 0.5, -9)
        if wsActive then
            pcall(function()
                local char = player.Character
                if char then
                    char:WaitForChild("Humanoid").WalkSpeed = val
                end
            end)
        end
    end

    local function updateFromInput(input)
        local trackPos   = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        local pct        = math.clamp((input.Position.X - trackPos) / trackWidth, 0, 1)
        local val        = math.floor(pct * 500)
        applySpeed(val)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ═══════════════════════════════
    -- BADGE TOGGLE (ON/OFF)
    -- ═══════════════════════════════
    badge.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            wsActive = not wsActive

            if wsActive then
                tween(card, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 40, 20)}):Play()
                tween(accentBar, 0.2, {BackgroundColor3 = THEME.ACCENT}):Play()
                tween(badge, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
                tween(knob, 0.15, {BackgroundColor3 = THEME.ACCENT}):Play()
                badgeText.Text = "ON"
                badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke(card, THEME.GREEN, 1, 0.4)
                -- Apply speed sekarang
                pcall(function()
                    player.Character:WaitForChild("Humanoid").WalkSpeed = currentSpeed
                end)
            else
                tween(card, 0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
                tween(accentBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
                tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
                tween(knob, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                badgeText.Text = "OFF"
                badgeText.TextColor3 = THEME.TEXT_MUTED
                stroke(card, THEME.BORDER, 1, 0)
                -- Reset speed ke default
                pcall(function()
                    player.Character:WaitForChild("Humanoid").WalkSpeed = DEFAULT_SPEED
                end)
            end
        end
    end)

    -- Reset speed saat karakter respawn
    player.CharacterAdded:Connect(function(char)
        if wsActive then
            local hum = char:WaitForChild("Humanoid")
            hum.WalkSpeed = currentSpeed
        end
    end)

end

return { init = init }
