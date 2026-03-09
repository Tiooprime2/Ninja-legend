-- ╔══════════════════════════════════════════╗
-- ║   TIOO BETA V1 — AUTO BUY SWORD MODULE  ║
-- ╚══════════════════════════════════════════╝

local function init(scroll, THEME, tween, corner, stroke)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer
    local event   = player:WaitForChild("ninjaEvent")

    local isActive = false
    local buyLoop  = nil

    local swords = {
        -- ═══ Ground / Valley ═══
        "Bamboo", "Electral Bamboo", "Ultra Bamboo",
        "Crimson Bamboo", "Corrupted Bamboo", "Shadow Bamboo",
        "Katana", "Peace Katana", "Enraged Katana",
        "Golden Katana", "Royal Katana", "Enchanted Katana", "Shadowblade",
        "Wooden Staff", "Electral Staff", "Infernal Staff",
        "Ultra Staff", "Shadow Staff", "Light Staff",
        "Odachi", "Electro Odachi", "Overdrive Odachi",
        "Charged Odachi", "Dark Odachi", "Crimson Odachi",
        "Naginata", "Inferno Naginata", "Electral Naginata",
        "Guardian Naginata", "Mystical Naginata", "Shadow Naginata",
        -- ═══ Astral Island ═══
        "Dual Katana", "Dual Electro Katana", "Dual Inferno Katana",
        "Dual Corrupt Katana", "Dual Ultra Katana", "Dual Balance Katana",
        "Scythe", "Electro Scythe", "Inferno Scythe",
        "Peace Scythe", "Corrupted Scythe", "Shadow Scythe",
        "Dual Odachi", "Dual Corrupt Odachi", "Dual Ultra Odachi",
        "Dual Power Odachi", "Dual Shadow Odachi", "Dual Inferno Odachi",
    }

    -- ═══════════════════════════════
    -- CARD BUTTON
    -- ═══════════════════════════════
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.BG_CARD
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 6
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
    iconLbl.Text = "🗡️"
    iconLbl.TextSize = 20
    iconLbl.Parent = btn

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -100, 0, 20)
    titleLbl.Position = UDim2.new(0, 48, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "AUTO BUY SWORD"
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
    -- BUY LOOP
    -- ═══════════════════════════════
    local function startBuy()
        buyLoop = task.spawn(function()
            while isActive do
                for _, swordName in ipairs(swords) do
                    if not isActive then break end
                    pcall(function()
                        event:FireServer("buySword", swordName)
                    end)
                    descLbl.Text = "Buying: " .. swordName
                    task.wait(0.5)
                end
                task.wait(2)
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
            descLbl.Text = "Starting..."
            descLbl.TextColor3 = THEME.GREEN
            stroke(btn, THEME.GREEN, 1, 0.4)
            startBuy()
        else
            tween(btn, 0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
            tween(accentBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
            tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            badgeText.Text = "OFF"
            badgeText.TextColor3 = THEME.TEXT_MUTED
            descLbl.Text = "Tap to enable"
            descLbl.TextColor3 = THEME.TEXT_MUTED
            stroke(btn, THEME.BORDER, 1, 0)
            if buyLoop then
                task.cancel(buyLoop)
                buyLoop = nil
            end
        end
    end)

end

return { init = init }
