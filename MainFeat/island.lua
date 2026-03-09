-- ╔══════════════════════════════════════════╗
-- ║       TIOO BETA V1 — ISLAND MODULE       ║
-- ╚══════════════════════════════════════════╝

local function init(scroll, THEME, tween, corner, stroke, mainGui, onClose)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer

    local islands = {
        { name = "Enchanted Island", pos = Vector3.new(61,  765,  -133) },
        { name = "Astral Island",    pos = Vector3.new(241, 2020,  272) },
        { name = "Mystical Island",  pos = Vector3.new(165, 4064,   33) },
    }

    local isOpen = false

    -- ═══ CARD BUTTON (di scroll) ═══
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.BG_CARD
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 2
    btn.Parent = scroll
    corner(btn, 10)
    stroke(btn, THEME.BORDER, 1, 0)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.6, 0)
    accentBar.Position = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundColor3 = THEME.ACCENT
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn
    corner(accentBar, 2)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -15)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "🏝️"
    iconLabel.TextSize = 20
    iconLabel.Parent = btn

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -100, 0, 20)
    titleLbl.Position = UDim2.new(0, 48, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "ISLAND TELEPORT"
    titleLbl.TextColor3 = THEME.TEXT_PRIMARY
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = btn

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -100, 0, 16)
    descLbl.Position = UDim2.new(0, 48, 0, 32)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = "3 islands available"
    descLbl.TextColor3 = THEME.TEXT_MUTED
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = btn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 30, 0, 30)
    arrow.Position = UDim2.new(1, -40, 0.5, -15)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = THEME.ACCENT
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = btn

    -- ═══ DROPDOWN (float di mainGui) ═══
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 200, 0, 0)
    dropdown.BackgroundColor3 = THEME.BG_PANEL
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.Visible = false
    dropdown.ZIndex = 99
    dropdown.Parent = mainGui
    corner(dropdown, 8)
    stroke(dropdown, THEME.ACCENT, 1, 0.4)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = dropdown

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = dropdown

    -- Buat option rows
    for _, data in pairs(islands) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = THEME.BG_CARD
        row.Text = ""
        row.BorderSizePixel = 0
        row.ZIndex = 100
        row.Parent = dropdown
        corner(row, 6)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 8, 0.5, -3)
        dot.BackgroundColor3 = THEME.GREEN
        dot.BorderSizePixel = 0
        dot.ZIndex = 100
        dot.Parent = row
        corner(dot, 4)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -70, 1, 0)
        nameLbl.Position = UDim2.new(0, 22, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = data.name
        nameLbl.TextColor3 = THEME.TEXT_PRIMARY
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 100
        nameLbl.Parent = row

        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.new(0, 55, 1, 0)
        statusLbl.Position = UDim2.new(1, -58, 0, 0)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "TELEPORT"
        statusLbl.TextColor3 = THEME.ACCENT
        statusLbl.Font = Enum.Font.GothamBold
        statusLbl.TextSize = 9
        statusLbl.ZIndex = 100
        statusLbl.Parent = row

        row.MouseEnter:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = Color3.fromRGB(25, 50, 30)}):Play()
        end)
        row.MouseLeave:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = THEME.BG_CARD}):Play()
        end)

        row.MouseButton1Click:Connect(function()
            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                statusLbl.Text = "GOING..."
                statusLbl.TextColor3 = THEME.ORANGE
                hrp.CFrame = CFrame.new(data.pos + Vector3.new(0, 50, 0))
                hrp.Anchored = true
                task.wait(1.8)
                hrp.CFrame = CFrame.new(data.pos)
                task.wait(0.3)
                hrp.Anchored = false
                statusLbl.Text = "✓ DONE"
                statusLbl.TextColor3 = THEME.GREEN
                task.wait(1.2)
                statusLbl.Text = "TELEPORT"
                statusLbl.TextColor3 = THEME.ACCENT
            end
        end)
    end

    local dropdownHeight = (#islands * 40) + 20

    -- Update posisi dropdown sesuai posisi btn di layar
    local function updateDropdownPos()
        local absPos  = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
        dropdown.Size = UDim2.new(0, absSize.X, 0, isOpen and dropdownHeight or 0)
    end

    -- Toggle
    local function toggleDropdown()
        isOpen = not isOpen
        updateDropdownPos()

        if isOpen then
            dropdown.Visible = true
            tween(dropdown, 0.25, {Size = UDim2.new(0, btn.AbsoluteSize.X, 0, dropdownHeight)}):Play()
            tween(arrow, 0.25, {Rotation = 180}):Play()
            descLbl.Text = "Tap island untuk teleport"
            descLbl.TextColor3 = THEME.ACCENT
            tween(btn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}):Play()
        else
            tween(dropdown, 0.2, {Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)}):Play()
            tween(arrow, 0.2, {Rotation = 0}):Play()
            descLbl.Text = "3 islands available"
            descLbl.TextColor3 = THEME.TEXT_MUTED
            tween(btn, 0.15, {BackgroundColor3 = THEME.BG_CARD}):Play()
            task.delay(0.2, function() dropdown.Visible = false end)
        end
    end

    btn.MouseButton1Click:Connect(toggleDropdown)

    -- Tutup dropdown saat UI di-close
    if onClose then
        onClose(function()
            if isOpen then
                isOpen = false
                dropdown.Visible = false
                arrow.Rotation = 0
                descLbl.Text = "3 islands available"
                descLbl.TextColor3 = THEME.TEXT_MUTED
            end
        end)
    end

end

return { init = init }
