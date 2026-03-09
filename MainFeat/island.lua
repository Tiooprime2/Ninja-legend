-- ╔══════════════════════════════════════════╗
-- ║       TIOO BETA V1 — ISLAND TAB          ║
-- ╚══════════════════════════════════════════╝

local function init(page, THEME, tween, corner, stroke, mainGui)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer

    local islands = {
        { name = "Enchanted Island", icon = "🌿", pos = Vector3.new(61,  765, -133) },
        { name = "Astral Island",    icon = "🌌", pos = Vector3.new(241, 2020, 272)  },
        { name = "Mystical Island",  icon = "✨", pos = Vector3.new(165, 4064, 33)   },
    }

    -- Section label
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Text = "  TELEPORT"
    sec.TextColor3 = THEME.ACCENT
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 10
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = page

    for _, island in ipairs(islands) do
        -- Pakai TextButton bukan Frame agar Activated work
        local btn = Instance.new("Frame")
        btn.Size = UDim2.new(1, 0, 0, 48)
        btn.BackgroundColor3 = THEME.BG_CARD
        btn.BorderSizePixel = 0
        btn.Parent = page
        corner(btn, 10)
        stroke(btn, THEME.BORDER, 1, 0)

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 4, 0.6, 0)
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.BackgroundColor3 = THEME.ACCENT
        accentBar.BorderSizePixel = 0
        accentBar.Parent = btn
        corner(accentBar, 2)

        local iconL = Instance.new("TextLabel")
        iconL.Size = UDim2.new(0, 26, 0, 26)
        iconL.Position = UDim2.new(0, 12, 0.5, -13)
        iconL.BackgroundTransparency = 1
        iconL.Text = island.icon
        iconL.TextSize = 18
        iconL.Parent = btn

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -110, 0, 18)
        nameL.Position = UDim2.new(0, 44, 0, 7)
        nameL.BackgroundTransparency = 1
        nameL.Text = island.name
        nameL.TextColor3 = THEME.TEXT_PRIMARY
        nameL.Font = Enum.Font.GothamBold
        nameL.TextSize = 12
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.Parent = btn

        local coordL = Instance.new("TextLabel")
        coordL.Size = UDim2.new(1, -110, 0, 14)
        coordL.Position = UDim2.new(0, 44, 0, 27)
        coordL.BackgroundTransparency = 1
        coordL.Text = string.format("%.0f, %.0f, %.0f", island.pos.X, island.pos.Y, island.pos.Z)
        coordL.TextColor3 = THEME.TEXT_MUTED
        coordL.Font = Enum.Font.Gotham
        coordL.TextSize = 10
        coordL.TextXAlignment = Enum.TextXAlignment.Left
        coordL.Parent = btn

        -- Teleport button
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 80, 0, 28)
        tpBtn.Position = UDim2.new(1, -88, 0.5, -14)
        tpBtn.BackgroundColor3 = THEME.ACCENT
        tpBtn.Text = "TELEPORT"
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 9
        tpBtn.BorderSizePixel = 0
        tpBtn.AutoButtonColor = false
        tpBtn.Parent = btn
        corner(tpBtn, 6)

        tpBtn.Activated:Connect(function()
            tween(tpBtn, 0.1, {BackgroundColor3 = THEME.GREEN}):Play()
            tpBtn.Text = "✓ GO!"
            pcall(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp  = char:WaitForChild("HumanoidRootPart")
                hrp.Anchored = true
                hrp.CFrame = CFrame.new(island.pos + Vector3.new(0, 5, 0))
                task.wait(1.8)
                hrp.Anchored = false
            end)
            task.wait(1)
            tween(tpBtn, 0.2, {BackgroundColor3 = THEME.ACCENT}):Play()
            tpBtn.Text = "TELEPORT"
        end)
    end

end

return { init = init }
