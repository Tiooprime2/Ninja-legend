-- ╔══════════════════════════════════════════╗
-- ║       TIOO BETA V1 — ISLAND MODULE       ║
-- ╚══════════════════════════════════════════╝
-- Cara pakai:
-- local Island = loadstring(game:HttpGet("url/island.lua"))()
-- Island.init(scroll, THEME, tween, corner, stroke)

local function init(scroll, THEME, tween, corner, stroke)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer

    -- ═══════════════════════════════
    -- DATA (hanya 3 yang work)
    -- ═══════════════════════════════
    local islands = {
        { name = "Enchanted Island", pos = Vector3.new(61,  765,  -133) },
        { name = "Astral Island",    pos = Vector3.new(241, 2020,  272) },
        { name = "Mystical Island",  pos = Vector3.new(165, 4064,   33) },
    }

    -- ═══════════════════════════════
    -- HEADER CARD (klik = expand)
    -- ═══════════════════════════════
    local isExpanded = false

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 52)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder = 2
    wrapper.ClipsDescendants = false
    wrapper.Parent = scroll

    local wrapLayout = Instance.new("UIListLayout")
    wrapLayout.Padding = UDim.new(0, 4)
    wrapLayout.Parent = wrapper

    wrapLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        wrapper.Size = UDim2.new(1, 0, 0, wrapLayout.AbsoluteContentSize.Y)
    end)

    -- Header button
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
    bar.BackgroundColor3 = THEME.ACCENT
    bar.BorderSizePixel = 0
    bar.Parent = headerBtn
    corner(bar, 2)

    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 32, 0, 32)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -16)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = "🏝️"
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = headerBtn

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -90, 0, 18)
    lbl.Position = UDim2.new(0, 50, 0, 9)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ISLAND TELEPORT"
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
    sub.Text = "3 islands available"
    sub.TextColor3 = THEME.TEXT_MUTED
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = headerBtn

    -- Arrow indicator
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
        tween(arrow, 0.15, {TextColor3 = THEME.ACCENT})
    end)
    headerBtn.MouseLeave:Connect(function()
        if not isExpanded then tween(headerBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD}) end
        tween(arrow, 0.15, {TextColor3 = THEME.TEXT_MUTED})
    end)

    -- ═══════════════════════════════
    -- DROPDOWN CONTAINER
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
    stroke(dropdown, THEME.BORDER, 1, 0.4)

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
    -- ISI ISLAND ROWS
    -- ═══════════════════════════════
    local fullHeight = 0

    for _, data in pairs(islands) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = THEME.BG_CARD
        row.Text = ""
        row.BorderSizePixel = 0
        row.Parent = dropdown
        corner(row, 8)

        -- Dot hijau
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 10, 0.5, -3)
        dot.BackgroundColor3 = THEME.GREEN
        dot.BorderSizePixel = 0
        dot.Parent = row
        corner(dot, 4)

        -- Nama island
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -80, 1, 0)
        nameLbl.Position = UDim2.new(0, 24, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = data.name
        nameLbl.TextColor3 = THEME.TEXT_PRIMARY
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = row

        -- Status label
        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.new(0, 55, 1, 0)
        statusLbl.Position = UDim2.new(1, -60, 0, 0)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "TELEPORT"
        statusLbl.TextColor3 = THEME.ACCENT
        statusLbl.Font = Enum.Font.GothamBold
        statusLbl.TextSize = 9
        statusLbl.Parent = row

        row.MouseEnter:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = Color3.fromRGB(25, 50, 30)})
        end)
        row.MouseLeave:Connect(function()
            tween(row, 0.12, {BackgroundColor3 = THEME.BG_CARD})
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

        fullHeight = fullHeight + 36 + 4
    end

    fullHeight = fullHeight + 12 -- padding atas bawah

    -- ═══════════════════════════════
    -- EXPAND / COLLAPSE LOGIC
    -- ═══════════════════════════════
    headerBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded

        if isExpanded then
            dropdown.Visible = true
            tween(dropdown, 0.2, {Size = UDim2.new(1, 0, 0, fullHeight)})
            tween(headerBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(20, 35, 55)})
            stroke(headerBtn, THEME.ACCENT, 1, 0.4)
            arrow.Text = "⌄"
            arrow.TextColor3 = THEME.ACCENT
            sub.Text = "Tap island untuk teleport"
            sub.TextColor3 = THEME.ACCENT
        else
            tween(dropdown, 0.15, {Size = UDim2.new(1, 0, 0, 0)})
            tween(headerBtn, 0.15, {BackgroundColor3 = THEME.BG_CARD})
            stroke(headerBtn, THEME.BORDER, 1, 0.3)
            arrow.Text = "›"
            arrow.TextColor3 = THEME.TEXT_MUTED
            sub.Text = "3 islands available"
            sub.TextColor3 = THEME.TEXT_MUTED
            task.delay(0.15, function() dropdown.Visible = false end)
        end
    end)

end

return { init = init }
