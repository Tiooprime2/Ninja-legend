-- ╔══════════════════════════════════════════╗
-- ║       TIOO BETA V1 — ELEMENT TAB         ║
-- ╚══════════════════════════════════════════╝

local function init(page, THEME, tween, corner, stroke, mainGui)

    local Players = game:GetService("Players")
    local player  = Players.LocalPlayer
    local PURPLE  = Color3.fromRGB(180, 100, 255)

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

    -- Section label
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Text = "  ELEMENT MASTERY"
    sec.TextColor3 = PURPLE
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 10
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = page

    for _, el in ipairs(elements) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 48)
        row.BackgroundColor3 = THEME.BG_CARD
        row.BorderSizePixel = 0
        row.Parent = page
        corner(row, 10)
        stroke(row, THEME.BORDER, 1, 0)

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 4, 0.6, 0)
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.BackgroundColor3 = PURPLE
        accentBar.BorderSizePixel = 0
        accentBar.Parent = row
        corner(accentBar, 2)

        local iconL = Instance.new("TextLabel")
        iconL.Size = UDim2.new(0, 26, 0, 26)
        iconL.Position = UDim2.new(0, 12, 0.5, -13)
        iconL.BackgroundTransparency = 1
        iconL.Text = el.icon
        iconL.TextSize = 18
        iconL.Parent = row

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -110, 0, 18)
        nameL.Position = UDim2.new(0, 44, 0, 7)
        nameL.BackgroundTransparency = 1
        nameL.Text = el.name
        nameL.TextColor3 = THEME.TEXT_PRIMARY
        nameL.Font = Enum.Font.GothamBold
        nameL.TextSize = 12
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.Parent = row

        local statusL = Instance.new("TextLabel")
        statusL.Size = UDim2.new(1, -110, 0, 14)
        statusL.Position = UDim2.new(0, 44, 0, 27)
        statusL.BackgroundTransparency = 1
        statusL.Text = "Tap USE to equip"
        statusL.TextColor3 = THEME.TEXT_MUTED
        statusL.Font = Enum.Font.Gotham
        statusL.TextSize = 11
        statusL.TextXAlignment = Enum.TextXAlignment.Left
        statusL.Parent = row

        -- USE badge button
        local useBtn = Instance.new("TextButton")
        useBtn.Size = UDim2.new(0, 50, 0, 24)
        useBtn.Position = UDim2.new(1, -58, 0.5, -12)
        useBtn.BackgroundColor3 = PURPLE
        useBtn.Text = "USE"
        useBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        useBtn.Font = Enum.Font.GothamBold
        useBtn.TextSize = 10
        useBtn.BorderSizePixel = 0
        useBtn.AutoButtonColor = false
        useBtn.Parent = row
        corner(useBtn, 12)

        useBtn.Activated:Connect(function()
            tween(useBtn, 0.1, {BackgroundColor3 = THEME.GREEN}):Play()
            useBtn.Text = "✓"
            statusL.Text = "Equipping..."
            statusL.TextColor3 = THEME.GREEN

            pcall(function()
                local rEvents = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents")
                if rEvents then
                    rEvents.elementMasteryEvent:FireServer(el.name)
                end
            end)

            task.wait(1.5)
            tween(useBtn, 0.2, {BackgroundColor3 = PURPLE}):Play()
            useBtn.Text = "USE"
            statusL.Text = "✓ " .. el.name
            statusL.TextColor3 = PURPLE
        end)
    end

end

return { init = init }
