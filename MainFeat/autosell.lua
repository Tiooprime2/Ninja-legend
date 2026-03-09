-- ╔══════════════════════════════════════════╗
-- ║     TIOO BETA V1 — AUTO SELL MODULE      ║
-- ╚══════════════════════════════════════════╝

local function init(scroll, THEME, tween, corner, stroke)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer

    local isActive = false
    local sellLoop = nil

    -- Cari sell part
    local function findSellPart()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("sell") then
                return v
            end
        end
    end

    -- ═══════════════════════════════
    -- CARD BUTTON
    -- ═══════════════════════════════
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.BG_CARD
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 5
    btn.Parent = scroll
    corner(btn, 10)
    stroke(btn, THEME.BORDER, 1, 0)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.6, 0)
    accentBar.Position = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundColor3 = THEME.TEXT_MUTED
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn
    corner(accentBar, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 30, 0, 30)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -15)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = "💰"
    iconLbl.TextSize = 20
    iconLbl.Parent = btn

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -100, 0, 20)
    titleLbl.Position = UDim2.new(0, 48, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "AUTO SELL"
    titleLbl.TextColor3 = THEME.TEXT_PRIMARY
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = btn

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -100, 0, 16)
    descLbl.Position = UDim2.new(0, 48, 0, 32)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = "Tap to enable"
    descLbl.TextColor3 = THEME.TEXT_MUTED
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = btn

    -- Badge ON/OFF
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 44, 0, 24)
    badge.Position = UDim2.new(1, -54, 0.5, -12)
    badge.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    badge.BorderSizePixel = 0
    badge.Parent = btn
    corner(badge, 12)

    local badgeText = Instance.new("TextLabel")
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = "OFF"
    badgeText.TextColor3 = THEME.TEXT_MUTED
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 10
    badgeText.Parent = badge

    -- ═══════════════════════════════
    -- SELL LOOP
    -- ═══════════════════════════════
    local function startSell()
        sellLoop = task.spawn(function()
            local sellPart = findSellPart()

            -- Update desc kalau sell part tidak ketemu
            if not sellPart then
                descLbl.Text = "Sell part not found!"
                descLbl.TextColor3 = THEME.RED
                return
            end

            descLbl.Text = "Selling every 4s..."
            descLbl.TextColor3 = THEME.GREEN

            while isActive do
                task.wait(4)
                pcall(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp  = char:WaitForChild("HumanoidRootPart")
                    local old  = hrp.CFrame
                    hrp.CFrame = sellPart.CFrame + Vector3.new(0, 1, 0)
                    task.wait(0.25)
                    hrp.CFrame = old
                end)
            end
        end)
    end

    -- ═══════════════════════════════
    -- TOGGLE
    -- ═══════════════════════════════
    btn.MouseButton1Click:Connect(function()
        isActive = not isActive

        if isActive then
            tween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 40, 20)}):Play()
            tween(accentBar, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
            tween(badge, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
            badgeText.Text = "ON"
            badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
            descLbl.Text = "Looking for sell..."
            descLbl.TextColor3 = THEME.GREEN
            stroke(btn, THEME.GREEN, 1, 0.4)
            startSell()
        else
            tween(btn, 0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
            tween(accentBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
            tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            badgeText.Text = "OFF"
            badgeText.TextColor3 = THEME.TEXT_MUTED
            descLbl.Text = "Tap to enable"
            descLbl.TextColor3 = THEME.TEXT_MUTED
            stroke(btn, THEME.BORDER, 1, 0)
            if sellLoop then
                task.cancel(sellLoop)
                sellLoop = nil
            end
        end
    end)

end

return { init = init }
