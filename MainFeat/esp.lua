-- ╔══════════════════════════════════════════╗
-- ║        TIOO BETA V1 — ESP MODULE         ║
-- ╚══════════════════════════════════════════╝
-- Cara pakai:
-- local ESP = loadstring(game:HttpGet("url/esp.lua"))()
-- ESP.init(scroll, THEME, tween, corner, stroke)

local function init(scroll, THEME, tween, corner, stroke)

    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Camera      = workspace.CurrentCamera
    local player      = Players.LocalPlayer

    -- ═══════════════════════════════
    -- SETTINGS
    -- ═══════════════════════════════
    local ESP_ENABLED      = false
    local TRACER_ENABLED   = true
    local NAME_ENABLED     = true
    local HEALTH_ENABLED   = true
    local DISTANCE_ENABLED = true

    local espCache = {}

    -- ═══════════════════════════════
    -- RAINBOW COLOR
    -- ═══════════════════════════════
    local function rainbow()
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end

    -- ═══════════════════════════════
    -- CREATE / REMOVE ESP
    -- ═══════════════════════════════
    local function createESP(p)
        if p == player then return end
        local box = Drawing.new("Square")
        box.Thickness = 2; box.Filled = false; box.Visible = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 2; tracer.Visible = false

        local name = Drawing.new("Text")
        name.Size = 13; name.Center = true; name.Outline = true; name.Visible = false

        local distance = Drawing.new("Text")
        distance.Size = 13; distance.Center = true; distance.Outline = true; distance.Visible = false

        local healthbar = Drawing.new("Line")
        healthbar.Thickness = 3; healthbar.Visible = false

        espCache[p] = {
            box       = box,
            tracer    = tracer,
            name      = name,
            distance  = distance,
            healthbar = healthbar
        }
    end

    local function removeESP(p)
        if espCache[p] then
            for _, obj in pairs(espCache[p]) do obj:Remove() end
            espCache[p] = nil
        end
    end

    -- Init semua player yang ada
    for _, p in pairs(Players:GetPlayers()) do createESP(p) end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)

    -- ═══════════════════════════════
    -- RENDER LOOP
    -- ═══════════════════════════════
    RunService.RenderStepped:Connect(function()
        if not ESP_ENABLED then
            for _, esp in pairs(espCache) do
                for _, obj in pairs(esp) do obj.Visible = false end
            end
            return
        end

        for p, esp in pairs(espCache) do
            local character = p.Character
            local hrp       = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid  = character and character:FindFirstChild("Humanoid")

            if hrp and humanoid and humanoid.Health > 0 then
                local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

                if visible then
                    local dist  = (hrp.Position - Camera.CFrame.Position).Magnitude
                    -- Clamp scale: min 20 studs, max 200 studs agar box tidak meledak saat dekat
                    local clampedDist = math.clamp(dist, 20, 200)
                    local scale = 1 / clampedDist * 100
                    local size  = Vector2.new(36, 50) * scale
                    -- Clamp size agar tidak terlalu besar/kecil
                    size = Vector2.new(
                        math.clamp(size.X, 20, 120),
                        math.clamp(size.Y, 28, 160)
                    )
                    local color = rainbow()

                    -- Box
                    esp.box.Size     = size
                    esp.box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                    esp.box.Color    = color
                    esp.box.Visible  = true

                    -- Tracer
                    if TRACER_ENABLED then
                        esp.tracer.From    = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        esp.tracer.To      = Vector2.new(pos.X, pos.Y)
                        esp.tracer.Color   = color
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end

                    -- Name
                    if NAME_ENABLED then
                        esp.name.Text     = p.Name
                        esp.name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 15)
                        esp.name.Color    = color
                        esp.name.Visible  = true
                    else
                        esp.name.Visible = false
                    end

                    -- Distance
                    if DISTANCE_ENABLED then
                        esp.distance.Text     = math.floor(dist).."m"
                        esp.distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
                        esp.distance.Color    = color
                        esp.distance.Visible  = true
                    else
                        esp.distance.Visible = false
                    end

                    -- Health bar (fixed max height 60px, tidak ikut scale)
                    if HEALTH_ENABLED then
                        local hp    = humanoid.Health / humanoid.MaxHealth
                        local maxBarH = 60
                        local barH  = maxBarH * hp
                        local barX  = pos.X - size.X/2 - 6
                        local barY  = pos.Y + maxBarH/2
                        local hpColor = Color3.fromRGB(
                            math.floor((1 - hp) * 255),
                            math.floor(hp * 255),
                            0
                        )
                        esp.healthbar.From    = Vector2.new(barX, barY)
                        esp.healthbar.To      = Vector2.new(barX, barY - barH)
                        esp.healthbar.Color   = hpColor
                        esp.healthbar.Visible = true
                    else
                        esp.healthbar.Visible = false
                    end

                else
                    for _, obj in pairs(esp) do obj.Visible = false end
                end
            else
                for _, obj in pairs(esp) do obj.Visible = false end
            end
        end
    end)

    -- ═══════════════════════════════
    -- ESP TOGGLE BUTTON UI
    -- ═══════════════════════════════
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(1, 0, 0, 52)
    espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    espBtn.Text = ""
    espBtn.BorderSizePixel = 0
    espBtn.LayoutOrder = 5
    espBtn.Parent = scroll
    corner(espBtn, 12)
    stroke(espBtn, THEME.BORDER, 1, 0.3)

    local espBar = Instance.new("Frame")
    espBar.Size = UDim2.new(0, 3, 0, 28)
    espBar.Position = UDim2.new(0, 0, 0.5, -14)
    espBar.BackgroundColor3 = THEME.TEXT_MUTED
    espBar.BorderSizePixel = 0
    espBar.Parent = espBtn
    corner(espBar, 2)

    local espIcon = Instance.new("TextLabel")
    espIcon.Size = UDim2.new(0, 32, 0, 32)
    espIcon.Position = UDim2.new(0, 12, 0.5, -16)
    espIcon.BackgroundTransparency = 1
    espIcon.Text = "👁️"
    espIcon.TextSize = 18
    espIcon.Font = Enum.Font.GothamBold
    espIcon.Parent = espBtn

    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(1, -90, 0, 18)
    espLabel.Position = UDim2.new(0, 50, 0, 9)
    espLabel.BackgroundTransparency = 1
    espLabel.Text = "ESP"
    espLabel.TextColor3 = THEME.TEXT_PRIMARY
    espLabel.Font = Enum.Font.GothamBold
    espLabel.TextSize = 12
    espLabel.TextXAlignment = Enum.TextXAlignment.Left
    espLabel.Parent = espBtn

    local espSub = Instance.new("TextLabel")
    espSub.Size = UDim2.new(1, -90, 0, 14)
    espSub.Position = UDim2.new(0, 50, 0, 29)
    espSub.BackgroundTransparency = 1
    espSub.Text = "Tap to enable"
    espSub.TextColor3 = THEME.TEXT_MUTED
    espSub.Font = Enum.Font.Gotham
    espSub.TextSize = 10
    espSub.TextXAlignment = Enum.TextXAlignment.Left
    espSub.Parent = espBtn

    local espBadge = Instance.new("Frame")
    espBadge.Size = UDim2.new(0, 42, 0, 22)
    espBadge.Position = UDim2.new(1, -52, 0.5, -11)
    espBadge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    espBadge.BorderSizePixel = 0
    espBadge.Parent = espBtn
    corner(espBadge, 11)

    local espBadgeText = Instance.new("TextLabel")
    espBadgeText.Size = UDim2.new(1, 0, 1, 0)
    espBadgeText.BackgroundTransparency = 1
    espBadgeText.Text = "OFF"
    espBadgeText.TextColor3 = THEME.TEXT_MUTED
    espBadgeText.Font = Enum.Font.GothamBold
    espBadgeText.TextSize = 10
    espBadgeText.Parent = espBadge

    espBtn.MouseEnter:Connect(function()
        if not ESP_ENABLED then tween(espBtn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}) end
    end)
    espBtn.MouseLeave:Connect(function()
        if not ESP_ENABLED then tween(espBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 20, 30)}) end
    end)

    espBtn.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            tween(espBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 40, 20)})
            tween(espBar, 0.2, {BackgroundColor3 = THEME.GREEN})
            tween(espBadge, 0.2, {BackgroundColor3 = THEME.GREEN})
            espBadgeText.Text = "ON"
            espBadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
            espSub.Text = "ESP aktif..."
            espSub.TextColor3 = THEME.GREEN
            stroke(espBtn, THEME.GREEN, 1, 0.4)
        else
            tween(espBtn, 0.2, {BackgroundColor3 = Color3.fromRGB(20, 20, 30)})
            tween(espBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED})
            tween(espBadge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)})
            espBadgeText.Text = "OFF"
            espBadgeText.TextColor3 = THEME.TEXT_MUTED
            espSub.Text = "Tap to enable"
            espSub.TextColor3 = THEME.TEXT_MUTED
            stroke(espBtn, THEME.BORDER, 1, 0.3)
        end
    end)

end

return { init = init }
