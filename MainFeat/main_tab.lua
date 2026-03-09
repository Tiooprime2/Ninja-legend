-- ╔══════════════════════════════════════════╗
-- ║     TIOO BETA V1 — MAIN TAB              ║
-- ║  Auto Swing, Auto Sell, Auto Buy, ESP    ║
-- ╚══════════════════════════════════════════╝

local function init(page, THEME, tween, corner, stroke, mainGui, onClose)

    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera     = workspace.CurrentCamera
    local player     = Players.LocalPlayer

    -- ═══════════════════════════════
    -- HELPER: buat row toggle
    -- ═══════════════════════════════
    local function makeRow(name, desc, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52)
        row.BackgroundColor3 = THEME.BG_CARD
        row.BorderSizePixel = 0
        row.Parent = page
        corner(row, 8)
        stroke(row, THEME.BORDER, 1, 0.5)

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -70, 0, 20)
        nameL.Position = UDim2.new(0, 12, 0, 8)
        nameL.BackgroundTransparency = 1
        nameL.Text = name
        nameL.TextColor3 = THEME.TEXT_PRIMARY
        nameL.Font = Enum.Font.GothamSemibold
        nameL.TextSize = 12
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.Parent = row

        local descL = Instance.new("TextLabel")
        descL.Size = UDim2.new(1, -70, 0, 16)
        descL.Position = UDim2.new(0, 12, 0, 30)
        descL.BackgroundTransparency = 1
        descL.Text = desc
        descL.TextColor3 = THEME.TEXT_MUTED
        descL.Font = Enum.Font.Gotham
        descL.TextSize = 10
        descL.TextXAlignment = Enum.TextXAlignment.Left
        descL.Parent = row

        local switch = Instance.new("Frame")
        switch.Size = UDim2.new(0, 44, 0, 24)
        switch.Position = UDim2.new(1, -56, 0.5, -12)
        switch.BackgroundColor3 = THEME.BG_HOVER
        switch.BorderSizePixel = 0
        switch.Parent = row
        corner(switch, 12)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.Parent = switch
        corner(knob, 9)

        local state = false

        local function toggle()
            state = not state
            if state then
                tween(switch, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
                tween(knob, 0.2, {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                tween(row, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 35, 20)}):Play()
            else
                tween(switch, 0.2, {BackgroundColor3 = THEME.BG_HOVER}):Play()
                tween(knob, 0.2, {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                tween(row, 0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
            end
            if callback then callback(state, descL) end
        end

        row.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                toggle()
            end
        end)

        return descL, function() return state end
    end

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
    -- AUTO SWING
    -- ═══════════════════════════════
    makeSection("Combat")
    local swingLoop
    local swingDesc, swingState = makeRow("Auto Swing", "Equip sword to work", function(on, desc)
        if on then
            desc.Text = "Swinging..."
            desc.TextColor3 = THEME.GREEN
            swingLoop = task.spawn(function()
                while swingState() do
                    local char = player.Character
                    local bp = player.Backpack
                    if char and not char:FindFirstChildOfClass("Tool") then
                        local t = bp and bp:FindFirstChildOfClass("Tool")
                        if t then t.Parent = char end
                    end
                    pcall(function() player.ninjaEvent:FireServer("swingKatana") end)
                    task.wait(0.1)
                end
            end)
        else
            desc.Text = "Equip sword to work"
            desc.TextColor3 = THEME.TEXT_MUTED
            if swingLoop then task.cancel(swingLoop); swingLoop = nil end
        end
    end)

    -- ═══════════════════════════════
    -- AUTO SELL
    -- ═══════════════════════════════
    makeSection("Farm")
    local sellLoop
    local function findSellPart()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("sell") then return v end
        end
    end

    local sellDesc, sellState = makeRow("Auto Sell", "Teleport to sell zone", function(on, desc)
        if on then
            local sellPart = findSellPart()
            if not sellPart then
                desc.Text = "Sell part not found!"
                desc.TextColor3 = THEME.RED
                return
            end
            desc.Text = "Selling every 4s..."
            desc.TextColor3 = THEME.GREEN
            sellLoop = task.spawn(function()
                while sellState() do
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
        else
            desc.Text = "Teleport to sell zone"
            desc.TextColor3 = THEME.TEXT_MUTED
            if sellLoop then task.cancel(sellLoop); sellLoop = nil end
        end
    end)

    -- ═══════════════════════════════
    -- AUTO BUY SWORD
    -- ═══════════════════════════════
    local swords = {
        "Bamboo","Electral Bamboo","Ultra Bamboo","Crimson Bamboo","Corrupted Bamboo","Shadow Bamboo",
        "Katana","Peace Katana","Enraged Katana","Golden Katana","Royal Katana","Enchanted Katana","Shadowblade",
        "Wooden Staff","Electral Staff","Infernal Staff","Ultra Staff","Shadow Staff","Light Staff",
        "Odachi","Electro Odachi","Overdrive Odachi","Charged Odachi","Dark Odachi","Crimson Odachi",
        "Naginata","Inferno Naginata","Electral Naginata","Guardian Naginata","Mystical Naginata","Shadow Naginata",
        "Dual Katana","Dual Electro Katana","Dual Inferno Katana","Dual Corrupt Katana","Dual Ultra Katana","Dual Balance Katana",
        "Scythe","Electro Scythe","Inferno Scythe","Peace Scythe","Corrupted Scythe","Shadow Scythe",
        "Dual Odachi","Dual Corrupt Odachi","Dual Ultra Odachi","Dual Power Odachi","Dual Shadow Odachi","Dual Inferno Odachi",
    }

    local buyLoop
    local buyDesc, buyState = makeRow("Auto Buy Sword", #swords.." swords listed", function(on, desc)
        if on then
            local ev = player:FindFirstChild("ninjaEvent")
            if not ev then
                desc.Text = "ninjaEvent not found!"
                desc.TextColor3 = THEME.RED
                return
            end
            buyLoop = task.spawn(function()
                while buyState() do
                    for _, sw in ipairs(swords) do
                        if not buyState() then break end
                        desc.Text = "Buying: " .. sw
                        pcall(function() ev:FireServer("buySword", sw) end)
                        task.wait(0.5)
                    end
                    task.wait(2)
                end
            end)
        else
            desc.Text = #swords.." swords listed"
            desc.TextColor3 = THEME.TEXT_MUTED
            if buyLoop then task.cancel(buyLoop); buyLoop = nil end
        end
    end)

    -- ═══════════════════════════════
    -- ESP
    -- ═══════════════════════════════
    makeSection("Visual")
    local espCache = {}

    local function rainbow()
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end

    local function createESP(p)
        if p == player then return end
        local box = Drawing.new("Square")
        box.Thickness = 2; box.Filled = false; box.Visible = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 2; tracer.Visible = false

        local name = Drawing.new("Text")
        name.Size = 13; name.Center = true; name.Outline = true; name.Visible = false

        local dist = Drawing.new("Text")
        dist.Size = 13; dist.Center = true; dist.Outline = true; dist.Visible = false

        local hbar = Drawing.new("Line")
        hbar.Thickness = 3; hbar.Visible = false

        espCache[p] = {box=box, tracer=tracer, name=name, distance=dist, healthbar=hbar}
    end

    local function removeESP(p)
        if espCache[p] then
            for _, obj in pairs(espCache[p]) do obj:Remove() end
            espCache[p] = nil
        end
    end

    for _, p in pairs(Players:GetPlayers()) do createESP(p) end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)

    local ESP_ON = false

    RunService.RenderStepped:Connect(function()
        if not ESP_ON then
            for _, esp in pairs(espCache) do
                for _, obj in pairs(esp) do obj.Visible = false end
            end
            return
        end
        for p, esp in pairs(espCache) do
            local char = p.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                if vis then
                    local d = (hrp.Position - Camera.CFrame.Position).Magnitude
                    local cd = math.clamp(d, 20, 200)
                    local sc = 1 / cd * 100
                    local sz = Vector2.new(
                        math.clamp(36 * sc, 20, 120),
                        math.clamp(50 * sc, 28, 160)
                    )
                    local col = rainbow()
                    esp.box.Size = sz
                    esp.box.Position = Vector2.new(pos.X - sz.X/2, pos.Y - sz.Y/2)
                    esp.box.Color = col; esp.box.Visible = true
                    esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.tracer.To = Vector2.new(pos.X, pos.Y)
                    esp.tracer.Color = col; esp.tracer.Visible = true
                    esp.name.Text = p.Name
                    esp.name.Position = Vector2.new(pos.X, pos.Y - sz.Y/2 - 15)
                    esp.name.Color = col; esp.name.Visible = true
                    esp.distance.Text = math.floor(d).."m"
                    esp.distance.Position = Vector2.new(pos.X, pos.Y + sz.Y/2 + 2)
                    esp.distance.Color = col; esp.distance.Visible = true
                    local hp = hum.Health / hum.MaxHealth
                    local bH = 60 * hp
                    local bX = pos.X - sz.X/2 - 6
                    local bY = pos.Y + 30
                    esp.healthbar.From = Vector2.new(bX, bY)
                    esp.healthbar.To   = Vector2.new(bX, bY - bH)
                    esp.healthbar.Color = Color3.fromRGB(math.floor((1-hp)*255), math.floor(hp*255), 0)
                    esp.healthbar.Visible = true
                else
                    for _, obj in pairs(esp) do obj.Visible = false end
                end
            else
                for _, obj in pairs(esp) do obj.Visible = false end
            end
        end
    end)

    local espDesc, espState = makeRow("ESP", "Show players through walls", function(on, desc)
        ESP_ON = on
        if on then
            desc.Text = "ESP aktif — rainbow box"
            desc.TextColor3 = THEME.GREEN
        else
            desc.Text = "Show players through walls"
            desc.TextColor3 = THEME.TEXT_MUTED
        end
    end)

end

return { init = init }
