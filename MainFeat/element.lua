-- ╔══════════════════════════════════════════╗
-- ║      TIOO BETA V1 — ELEMENT MODULE       ║
-- ╚══════════════════════════════════════════╝
-- Cara pakai:
-- local Element = loadstring(game:HttpGet("url/element.lua"))()
-- Element.init(scroll, THEME, tween, corner, stroke)

local function init(scroll, THEME, tween, corner, stroke)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- ═══════════════════════════════
    -- DATA
    -- ═══════════════════════════════
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

    local PURPLE = Color3.fromRGB(180, 100, 255)

    -- ═══════════════════════════════
    -- WRAPPER (auto resize)
    -- ═══════════════════════════════
    local isExpanded = false

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 52)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder = 3
    wrapper.ClipsDescendants = false
    wrapper.Parent = scroll

    local wrapLayout = Instance.new("UIListLayout")
    wrapLayout.Padding = UDim.new(0, 4)
    wrapLayout.Parent = wrapper

    wrapLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        wrapper.Size = UDim2.new(1, 0, 0, wrapLayout.AbsoluteContentSize.Y)
    end)

    -- ═══════════════════════════════
    -- HEADER BUTTON
    -- ═══════════════════════════════
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 52)
    headerBtn.BackgroundColor3 = THEME.BG_CARD
    headerBtn.Text = ""
    headerBtn.BorderSizePixel = 0
    headerBtn.LayoutOrder = 1
    headerBtn.Parent = wrapper
    corner(headerBtn, 12)
    stroke(headerBtn, THEME.BORDER, 1, 0.3)

    -- Left accent bar
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0, 28)
    bar.Position = UDim2.new(0, 0, 0.5, -14)
    bar.BackgroundColor3 = PURPLE
    bar.BorderSizePixel = 0
    bar.Parent = headerBtn
    corner(bar, 2)

    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 32, 0, 32)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -16)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = "✨"
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = headerBtn

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -90, 0, 18)
    lbl.Position = UDim2.new(0, 50, 0, 9)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ELEMENTS"
    lbl.TextColor3 = THEME.TEXT_PRIMARY
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = headerBtn

    -- Sublabel
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -90, 0, 14)
    sub.Position = UDim2.new(0, 50, 0, 29)
    sub.BackgroundTransparency = 1
    sub.Text = "9 elements available"
    sub.TextColor3 = THEME.TEXT_MUTED
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = headerBtn

    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = THEME.TEXT_MUTED
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 20
    arrow.Parent = headerBtn

    headerBtn.MouseEnter:Connect(function()
        if not isExpanded then tween(headerBtn, 0.15, {BackgroundColor3 = THEME.BG_HOVER}) end
        tween(arrow, 0.15, {TextColor3 = PURPLE})
    end)
    headerBtn.MouseLeave:Connect(function()
        if not isExpanded then tween(headerBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD}) end
        tween(arrow, 0.15, {TextColor3 = THEME.TEXT_MUTED})
    end)

    -- ═══════════════════════════════
    -- DROPDOWN
    -- ═══════════════════════════════
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.BackgroundColor3 = THEME.BG_PANEL
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.LayoutOrder = 2
    dropdown.Visible = false
    dropdown.Parent = wrapper
    corner(dropdown, 10)
    stroke(dropdown, PURPLE, 1, 0.6)

    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Padding = UDim.new(0, 4)
    dropLayout.Parent = dropdown

    local dropPadding = Instance.new("UIPadding")
    dropPadding.PaddingTop = UDim.new(0, 6)
    dropPadding.PaddingBottom = UDim.new(0, 6)
    dropPadding.PaddingLeft = UDim.new(0, 8)
    dropPadding.PaddingRight = UDim.new(0, 8)
    dropPadding.Parent = dropdown

    -- ═══════════════════════════════
    -- ELEMENT ROWS
    -- ═══════════════════════════════
    local fullHeight = 0

    for _, data in pairs(elements) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = THEME.BG_CARD
        row.Text = ""
        row.BorderSizePixel = 0
        row.Parent = dropdown
        corner(row, 8)

        -- Icon
        local iconR = Instance.new("TextLabel")
        iconR.Size = UDim2.new(0, 28, 1, 0)
        iconR.Position = UDim2.new(0, 8, 0, 0)
        iconR.BackgroundTransparency = 1
        iconR.Text = data.icon
        iconR.TextSize = 16
        iconR.Font = Enum.Font.GothamBold
        iconR.Parent = row

        -- Name
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -80, 1, 0)
        nameLbl.Position = UDim2.new(0, 40, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = data.name
        nameLbl.TextColor3 = THEME.TEXT_PRIMARY
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = row

        -- Status
        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.new(0, 45, 1, 0)
        statusLbl.Position = UDim2.new(1, -50, 0, 0)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "USE"
        statusLbl.TextColor3 = PURPLE
        statusLbl.Font = Enum.Font.GothamBold
        statusLbl.TextSize = 10
        statusLbl.Parent = row

        row.MouseEnter:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = Color3.fromRGB(30, 20, 45)})
        end)
        row.MouseLeave:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = THEME.BG_CARD})
        end)

        row.MouseButton1Click:Connect(function()
            local r = ReplicatedStorage:FindFirstChild("rEvents")
            if r then
                pcall(function()
                    r.elementMasteryEvent:FireServer(data.name)
                end)
                statusLbl.Text = "✓ ON"
                statusLbl.TextColor3 = THEME.GREEN
                task.wait(1.2)
                statusLbl.Text = "USE"
                statusLbl.TextColor3 = PURPLE
            end
        end)

        fullHeight = fullHeight + 36 + 4
    end

    fullHeight = fullHeight + 12 -- padding atas bawah

    -- ═══════════════════════════════
    -- EXPAND / COLLAPSE
    -- ═══════════════════════════════
    headerBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded

        if isExpanded then
            dropdown.Visible = true
            tween(dropdown, 0.2, {Size = UDim2.new(1, 0, 0, fullHeight)})
            tween(headerBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(28, 18, 42)})
            stroke(headerBtn, PURPLE, 1, 0.4)
            arrow.Text = "⌄"
            arrow.TextColor3 = PURPLE
            sub.Text = "Pilih element kamu"
            sub.TextColor3 = PURPLE
        else
            tween(dropdown, 0.15, {Size = UDim2.new(1, 0, 0, 0)})
            tween(headerBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD})
            stroke(headerBtn, THEME.BORDER, 1, 0.3)
            arrow.Text = "›"
            arrow.TextColor3 = THEME.TEXT_MUTED
            sub.Text = "9 elements available"
            sub.TextColor3 = THEME.TEXT_MUTED
            task.delay(0.15, function() dropdown.Visible = false end)
        end
    end)

end

return { init = init }
