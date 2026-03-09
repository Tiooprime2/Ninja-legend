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
    -- HELPER: row toggle (badge style lama)
    -- ═══════════════════════════════
    local function makeRow(name, desc, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 64)
        btn.BackgroundColor3 = THEME.BG_CARD
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = page
        corner(btn, 10)
        stroke(btn, THEME.BORDER, 1, 0)

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 4, 0.6, 0)
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.BackgroundColor3 = THEME.TEXT_MUTED
        accentBar.BorderSizePixel = 0
        accentBar.Parent = btn
        corner(accentBar, 2)

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -100, 0, 20)
        nameL.Position = UDim2.new(0, 14, 0, 12)
        nameL.BackgroundTransparency = 1
        nameL.Text = name
        nameL.TextColor3 = THEME.TEXT_PRIMARY
        nameL.Font = Enum.Font.GothamBold
        nameL.TextSize = 13
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.Parent = btn

        local descL = Instance.new("TextLabel")
        descL.Size = UDim2.new(1, -100, 0, 16)
        descL.Position = UDim2.new(0, 14, 0, 36)
        descL.BackgroundTransparency = 1
        descL.Text = desc
        descL.TextColor3 = THEME.TEXT_MUTED
        descL.Font = Enum.Font.Gotham
        descL.TextSize = 11
        descL.TextXAlignment = Enum.TextXAlignment.Left
        descL.Parent = btn

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

        local state = false

        local function toggle()
            state = not state
            if state then
                tween(btn, 0.2, {BackgroundColor3 = Color3.fromRGB(15, 40, 20)}):Play()
                tween(accentBar, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
                tween(badge, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
                badgeText.Text = "ON"
                badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke(btn, THEME.GREEN, 1, 0.4)
            else
                tween(btn, 0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
                tween(accentBar, 0.2, {BackgroundColor3 = THEME.TEXT_MUTED}):Play()
                tween(badge, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
                badgeText.Text = "OFF"
                badgeText.TextColor3 = THEME.TEXT_MUTED
                stroke(btn, THEME.BORDER, 1, 0)
            end
            if callback then callback(state, descL) end
        end

        -- Activated: hanya trigger saat benar-benar tap, tidak ikut scroll
        btn.Activated:Connect(toggle)

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
    getgenv().AutoSwing = false

    makeRow("⚔️  Auto Swing", "Equip sword to work", function(on, desc)
        getgenv().AutoSwing = on
        if on then
            desc.Text = "Swinging..."
            desc.TextColor3 = THEME.GREEN
            task.spawn(function()
                while getgenv().AutoSwing do
                    pcall(function()
                        local char = player.Character
                        if char and not char:FindFirstChildOfClass("Tool") then
                            local t = player.Backpack:FindFirstChildOfClass("Tool")
                            if t then t.Parent = char end
                        end
                        player.ninjaEvent:FireServer("swingKatana")
                    end)
                    task.wait(0.1)
                end
            end)
        else
            desc.Text = "Equip sword to work"
            desc.TextColor3 = THEME.TEXT_MUTED
        end
    end)

    -- ═══════════════════════════════
    -- AUTO SELL
    -- ═══════════════════════════════
    makeSection("Farm")
    getgenv().AutoSell = false

    local function findSellPart()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("sell") then return v end
        end
    end

    makeRow("💰  Auto Sell", "Teleport to sell zone", function(on, desc)
        getgenv().AutoSell = on
        if on then
            local sellPart = findSellPart()
            if not sellPart then
                desc.Text = "❌ Sell part not found!"
                desc.TextColor3 = THEME.RED
                return
            end
            desc.Text = "Selling every 4s..."
            desc.TextColor3 = THEME.GREEN
            task.spawn(function()
                while getgenv().AutoSell do
                    task.wait(4)
                    if not getgenv().AutoSell then break end
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

    getgenv().AutoBuy = false
    makeRow("🗡️  Auto Buy Sword", #swords.." swords listed", function(on, desc)
        getgenv().AutoBuy = on
        if on then
            local ev = player:FindFirstChild("ninjaEvent")
            if not ev then
                desc.Text = "❌ ninjaEvent not found!"
                desc.TextColor3 = THEME.RED
                return
            end
            task.spawn(function()
                while getgenv().AutoBuy do
                    for _, sw in ipairs(swords) do
                        if not getgenv().AutoBuy then break end
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
        end
    end)

    -- ═══════════════════════════════
    -- ESP
    -- ═══════════════════════════════
    makeSection("Visual")

    local espCache = {}
    local function rainbow() return Color3.fromHSV((tick() % 5) / 5, 1, 1) end

    local function createESP(p)
        if p == player then return end
        local box    = Drawing.new("Square"); box.Thickness = 2; box.Filled = false; box.Visible = false
        local tracer = Drawing.new("Line");   tracer.Thickness = 2; tracer.Visible = false
        local name   = Drawing.new("Text");   name.Size = 13; name.Center = true; name.Outline = true; name.Visible = false
        local dist   = Drawing.new("Text");   dist.Size = 13; dist.Center = true; dist.Outline = true; dist.Visible = false
        local hbar   = Drawing.new("Line");   hbar.Thickness = 3; hbar.Visible = false
        espCache[p]  = {box=box,tracer=tracer,name=name,distance=dist,healthbar=hbar}
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

    getgenv().ESP_ON = false
    RunService.RenderStepped:Connect(function()
        if not getgenv().ESP_ON then
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
                    local d   = (hrp.Position - Camera.CFrame.Position).Magnitude
                    local sc  = 1 / math.clamp(d, 20, 200) * 100
                    local sz  = Vector2.new(math.clamp(36*sc,20,120), math.clamp(50*sc,28,160))
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
                    local bX = pos.X - sz.X/2 - 6; local bY = pos.Y + 30
                    esp.healthbar.From = Vector2.new(bX, bY)
                    esp.healthbar.To = Vector2.new(bX, bY - 60*hp)
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

    makeRow("👁️  ESP", "Show players through walls", function(on, desc)
        getgenv().ESP_ON = on
        desc.Text = on and "ESP aktif — rainbow box" or "Show players through walls"
        desc.TextColor3 = on and THEME.GREEN or THEME.TEXT_MUTED
    end)

end

return { init = init }
