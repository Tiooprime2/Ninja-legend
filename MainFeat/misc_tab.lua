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

    -- ═══════════════════════════════
    -- FLY (XNEO TranslateBy)
    -- ═══════════════════════════════
    makeSection("Flight")

    local RunService = game:GetService("RunService")
    local Fly = {}
    Fly.enabled = false
    Fly.speed   = 50

    local flyHoverConn, flyMoveConn, flyBG, flyBV

    local function flyEnable()
        if flyHoverConn then flyHoverConn:Disconnect() end
        if flyMoveConn  then flyMoveConn:Disconnect()  end
        if flyBG then flyBG:Destroy() end
        if flyBV then flyBV:Destroy() end

        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local states = {
            Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
            Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
            Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
            Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
            Enum.HumanoidStateType.Swimming,
        }
        for _, s in ipairs(states) do hum:SetStateEnabled(s, false) end
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
        char.Animate.Disabled = true
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:AdjustSpeed(0) end
        hum.PlatformStand = true

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then return end

        flyBG = Instance.new("BodyGyro", torso)
        flyBG.P = 9e4; flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
        flyBG.CFrame = torso.CFrame

        flyBV = Instance.new("BodyVelocity", torso)
        flyBV.Velocity = Vector3.zero; flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)

        flyHoverConn = RunService.RenderStepped:Connect(function()
            if not Fly.enabled then return end
            if flyBG then flyBG.CFrame = workspace.CurrentCamera.CoordinateFrame end
        end)

        flyMoveConn = RunService.Heartbeat:Connect(function()
            if not Fly.enabled then return end
            local c2 = player.Character; if not c2 then return end
            local h2 = c2:FindFirstChildOfClass("Humanoid"); if not h2 then return end
            if h2.MoveDirection.Magnitude > 0 then
                c2:TranslateBy(h2.MoveDirection * (Fly.speed / 50))
            end
        end)
    end

    local function flyDisable()
        Fly.enabled = false
        if flyHoverConn then flyHoverConn:Disconnect(); flyHoverConn = nil end
        if flyMoveConn  then flyMoveConn:Disconnect();  flyMoveConn  = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        local char = player.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum.PlatformStand = false
        char.Animate.Disabled = false
        local states = {
            Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Flying,   Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
            Enum.HumanoidStateType.Landed,   Enum.HumanoidStateType.Physics,
            Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.Running,  Enum.HumanoidStateType.RunningNoPhysics,
            Enum.HumanoidStateType.Seated,   Enum.HumanoidStateType.StrafingNoPhysics,
            Enum.HumanoidStateType.Swimming,
        }
        for _, s in ipairs(states) do hum:SetStateEnabled(s, true) end
        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    end

    -- Fly card
    local flyCard = Instance.new("Frame")
    flyCard.Size             = UDim2.new(1, 0, 0, 90)
    flyCard.BackgroundColor3 = THEME.BG_CARD
    flyCard.BorderSizePixel  = 0
    flyCard.Parent           = page
    corner(flyCard, 10)
    stroke(flyCard, THEME.BORDER, 1, 0)

    local flyAccBar = Instance.new("Frame")
    flyAccBar.Size             = UDim2.new(0, 4, 0.85, 0)
    flyAccBar.Position         = UDim2.new(0, 0, 0.075, 0)
    flyAccBar.BackgroundColor3 = THEME.TEXT_MUTED
    flyAccBar.BorderSizePixel  = 0
    flyAccBar.Parent           = flyCard
    corner(flyAccBar, 2)

    local flyIcon = Instance.new("TextLabel")
    flyIcon.Size                  = UDim2.new(0, 26, 0, 26)
    flyIcon.Position              = UDim2.new(0, 12, 0, 10)
    flyIcon.BackgroundTransparency = 1
    flyIcon.Text                  = "🪂"
    flyIcon.TextSize              = 18
    flyIcon.Parent                = flyCard

    local flyNameL = Instance.new("TextLabel")
    flyNameL.Size                  = UDim2.new(1, -110, 0, 18)
    flyNameL.Position              = UDim2.new(0, 44, 0, 10)
    flyNameL.BackgroundTransparency = 1
    flyNameL.Text                  = "Fly"
    flyNameL.TextColor3            = THEME.TEXT_PRIMARY
    flyNameL.Font                  = Enum.Font.GothamBold
    flyNameL.TextSize              = 12
    flyNameL.TextXAlignment        = Enum.TextXAlignment.Left
    flyNameL.Parent                = flyCard

    local flyBadge = Instance.new("Frame")
    flyBadge.Size             = UDim2.new(0, 44, 0, 22)
    flyBadge.Position         = UDim2.new(1, -54, 0, 10)
    flyBadge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    flyBadge.BorderSizePixel  = 0
    flyBadge.Parent           = flyCard
    corner(flyBadge, 11)

    local flyBadgeTxt = Instance.new("TextLabel")
    flyBadgeTxt.Size                  = UDim2.new(1, 0, 1, 0)
    flyBadgeTxt.BackgroundTransparency = 1
    flyBadgeTxt.Text                  = "OFF"
    flyBadgeTxt.TextColor3            = THEME.TEXT_MUTED
    flyBadgeTxt.Font                  = Enum.Font.GothamBold
    flyBadgeTxt.TextSize              = 10
    flyBadgeTxt.Parent                = flyBadge

    -- Speed value label
    local flySpeedVal = Instance.new("TextLabel")
    flySpeedVal.Size                  = UDim2.new(0, 40, 0, 16)
    flySpeedVal.Position              = UDim2.new(1, -54, 0, 36)
    flySpeedVal.BackgroundTransparency = 1
    flySpeedVal.Text                  = tostring(Fly.speed)
    flySpeedVal.TextColor3            = THEME.ACCENT
    flySpeedVal.Font                  = Enum.Font.GothamBold
    flySpeedVal.TextSize              = 11
    flySpeedVal.TextXAlignment        = Enum.TextXAlignment.Center
    flySpeedVal.Parent                = flyCard

    -- Slider
    local flyTrack = Instance.new("Frame")
    flyTrack.Size             = UDim2.new(1, -24, 0, 5)
    flyTrack.Position         = UDim2.new(0, 12, 0, 58)
    flyTrack.BackgroundColor3 = THEME.BG_HOVER
    flyTrack.BorderSizePixel  = 0
    flyTrack.Parent           = flyCard
    corner(flyTrack, 3)

    local flyFill = Instance.new("Frame")
    flyFill.Size             = UDim2.new(Fly.speed / 500, 0, 1, 0)
    flyFill.BackgroundColor3 = THEME.ACCENT
    flyFill.BorderSizePixel  = 0
    flyFill.Parent           = flyTrack
    corner(flyFill, 3)

    local flyKnob = Instance.new("TextButton")
    flyKnob.Size             = UDim2.new(0, 18, 0, 18)
    flyKnob.Position         = UDim2.new(Fly.speed / 500, -9, 0.5, -9)
    flyKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flyKnob.Text             = ""
    flyKnob.BorderSizePixel  = 0
    flyKnob.AutoButtonColor  = false
    flyKnob.Parent           = flyTrack
    corner(flyKnob, 9)
    stroke(flyKnob, THEME.ACCENT, 2, 0)

    local flyMinL = Instance.new("TextLabel")
    flyMinL.Size                  = UDim2.new(0, 20, 0, 14)
    flyMinL.Position              = UDim2.new(0, 12, 0, 70)
    flyMinL.BackgroundTransparency = 1
    flyMinL.Text                  = "0"
    flyMinL.TextColor3            = THEME.TEXT_MUTED
    flyMinL.Font                  = Enum.Font.Gotham
    flyMinL.TextSize              = 9
    flyMinL.TextXAlignment        = Enum.TextXAlignment.Left
    flyMinL.Parent                = flyCard

    local flyMaxL = Instance.new("TextLabel")
    flyMaxL.Size                  = UDim2.new(0, 30, 0, 14)
    flyMaxL.Position              = UDim2.new(1, -42, 0, 70)
    flyMaxL.BackgroundTransparency = 1
    flyMaxL.Text                  = "500"
    flyMaxL.TextColor3            = THEME.TEXT_MUTED
    flyMaxL.Font                  = Enum.Font.Gotham
    flyMaxL.TextSize              = 9
    flyMaxL.TextXAlignment        = Enum.TextXAlignment.Right
    flyMaxL.Parent                = flyCard

    -- Slider logic
    local flyDragging = false

    local function applyFlySpeed(val)
        Fly.speed = val
        flySpeedVal.Text = tostring(val)
        local pct = val / 500
        flyFill.Size    = UDim2.new(pct, 0, 1, 0)
        flyKnob.Position = UDim2.new(pct, -9, 0.5, -9)
    end

    local function flySliderUpdate(input)
        local pct = math.clamp(
            (input.Position.X - flyTrack.AbsolutePosition.X) / flyTrack.AbsoluteSize.X,
            0, 1
        )
        applyFlySpeed(math.floor(pct * 500))
    end

    flyKnob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            flyDragging = true
        end
    end)
    flyTrack.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            flyDragging = true
            flySliderUpdate(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if flyDragging and (
            i.UserInputType == Enum.UserInputType.MouseMovement or
            i.UserInputType == Enum.UserInputType.Touch
        ) then flySliderUpdate(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            flyDragging = false
        end
    end)

    -- Badge toggle
    local flyOn = false
    flyBadge.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            flyOn = not flyOn
            Fly.enabled = flyOn
            if flyOn then
                flyEnable()
                tween(flyCard,    0.2, {BackgroundColor3 = Color3.fromRGB(15,40,20)}):Play()
                tween(flyAccBar,  0.2, {BackgroundColor3 = THEME.ACCENT}):Play()
                tween(flyBadge,   0.2, {BackgroundColor3 = THEME.GREEN}):Play()
                flyBadgeTxt.Text      = "ON"
                flyBadgeTxt.TextColor3 = Color3.fromRGB(255,255,255)
                stroke(flyCard, THEME.GREEN, 1, 0.4)
            else
                flyDisable()
                tween(flyCard,   0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
                tween(flyAccBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
                tween(flyBadge,  0.2, {BackgroundColor3 = Color3.fromRGB(40,40,55)}):Play()
                flyBadgeTxt.Text       = "OFF"
                flyBadgeTxt.TextColor3 = THEME.TEXT_MUTED
                stroke(flyCard, THEME.BORDER, 1, 0)
            end
        end
    end)

    -- Auto disable saat respawn
    player.CharacterAdded:Connect(function()
        flyOn = false
        Fly.enabled = false
        flyDisable()
        tween(flyCard,   0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
        tween(flyAccBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
        tween(flyBadge,  0.2, {BackgroundColor3 = Color3.fromRGB(40,40,55)}):Play()
        flyBadgeTxt.Text       = "OFF"
        flyBadgeTxt.TextColor3 = THEME.TEXT_MUTED
    end)

end

return { init = init }

-- placeholder marker for fly section
