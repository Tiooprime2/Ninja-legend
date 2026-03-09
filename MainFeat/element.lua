-- ╔══════════════════════════════════════════╗
-- ║      TIOO BETA V1 — ELEMENT MODULE       ║
-- ╚══════════════════════════════════════════╝

local function init(scroll, THEME, tween, corner, stroke, mainGui, onClose)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local PURPLE = Color3.fromRGB(180, 100, 255)

    local elements = {
        { name = "Shadow Charge",   icon = "🌑" },
        { name = "Electral Chaos",  icon = "⚡" },
        { name = "Blazing Entity",  icon = "🔥" },
        { name = "Shadowfire",      icon = "🌑" },
        { name = "Lightning",       icon = "⚡" },
        { name = "Masterful Wrath", icon = "💥" },
        { name = "Inferno",         icon = "🔥" },
        { name = "Eternity Storm",  icon = "🌪️" },
        { name = "Frost",           icon = "❄️" },
    }

    local isOpen = false

    -- ═══ CARD BUTTON (di scroll) ═══
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.BG_CARD
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 3
    btn.Parent = scroll
    corner(btn, 10)
    stroke(btn, THEME.BORDER, 1, 0)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.6, 0)
    accentBar.Position = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundColor3 = PURPLE
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn
    corner(accentBar, 2)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 12, 0.5, -15)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "✨"
    iconLabel.TextSize = 20
    iconLabel.Parent = btn

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -100, 0, 20)
    titleLbl.Position = UDim2.new(0, 48, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "ELEMENTS"
    titleLbl.TextColor3 = THEME.TEXT_PRIMARY
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = btn

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -100, 0, 16)
    descLbl.Position = UDim2.new(0, 48, 0, 32)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = "9 elements available"
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
    arrow.TextColor3 = PURPLE
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = btn

    -- ═══ DROPDOWN dengan ScrollingFrame (float di mainGui) ═══
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 200, 0, 0)
    dropdown.BackgroundColor3 = THEME.BG_PANEL
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.Visible = false
    dropdown.ZIndex = 99
    dropdown.Parent = mainGui
    corner(dropdown, 8)
    stroke(dropdown, PURPLE, 1, 0.4)

    -- ScrollingFrame di dalam dropdown
    local dropScroll = Instance.new("ScrollingFrame")
    dropScroll.Size = UDim2.new(1, 0, 1, 0)
    dropScroll.BackgroundTransparency = 1
    dropScroll.BorderSizePixel = 0
    dropScroll.ScrollBarThickness = 3
    dropScroll.ScrollBarImageColor3 = PURPLE
    dropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropScroll.ZIndex = 99
    dropScroll.Parent = dropdown

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = dropScroll

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
    end)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = dropScroll

    for _, data in pairs(elements) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = THEME.BG_CARD
        row.Text = ""
        row.BorderSizePixel = 0
        row.ZIndex = 100
        row.Parent = dropScroll
        corner(row, 6)

        local iconR = Instance.new("TextLabel")
        iconR.Size = UDim2.new(0, 28, 1, 0)
        iconR.Position = UDim2.new(0, 6, 0, 0)
        iconR.BackgroundTransparency = 1
        iconR.Text = data.icon
        iconR.TextSize = 16
        iconR.Font = Enum.Font.GothamBold
        iconR.ZIndex = 100
        iconR.Parent = row

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -80, 1, 0)
        nameLbl.Position = UDim2.new(0, 36, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = data.name
        nameLbl.TextColor3 = THEME.TEXT_PRIMARY
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 100
        nameLbl.Parent = row

        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.new(0, 40, 1, 0)
        statusLbl.Position = UDim2.new(1, -44, 0, 0)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "USE"
        statusLbl.TextColor3 = PURPLE
        statusLbl.Font = Enum.Font.GothamBold
        statusLbl.TextSize = 9
        statusLbl.ZIndex = 100
        statusLbl.Parent = row

        row.MouseEnter:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = Color3.fromRGB(30, 20, 45)}):Play()
        end)
        row.MouseLeave:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = THEME.BG_CARD}):Play()
        end)

        row.MouseButton1Click:Connect(function()
            local r = ReplicatedStorage:FindFirstChild("rEvents")
            if r then
                pcall(function() r.elementMasteryEvent:FireServer(data.name) end)
                statusLbl.Text = "✓ ON"
                statusLbl.TextColor3 = THEME.GREEN
                task.wait(1.2)
                statusLbl.Text = "USE"
                statusLbl.TextColor3 = PURPLE
            end
        end)
    end

    -- Tinggi max dropdown 200px, isi bisa di-scroll
    local maxDropHeight = 200

    local function updateDropdownPos()
        local absPos  = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
    end

    local function toggleDropdown()
        isOpen = not isOpen
        updateDropdownPos()

        if isOpen then
            dropdown.Visible = true
            tween(dropdown, 0.25, {Size = UDim2.new(0, btn.AbsoluteSize.X, 0, maxDropHeight)}):Play()
            tween(arrow, 0.25, {Rotation = 180}):Play()
            descLbl.Text = "Pilih element kamu"
            descLbl.TextColor3 = PURPLE
            tween(btn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}):Play()
        else
            tween(dropdown, 0.2, {Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 0)}):Play()
            tween(arrow, 0.2, {Rotation = 0}):Play()
            descLbl.Text = "9 elements available"
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
                descLbl.Text = "9 elements available"
                descLbl.TextColor3 = THEME.TEXT_MUTED
            end
        end)
    end

end

return { init = init }
