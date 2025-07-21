local Library = loadstring(game:HttpGet("https://pastebin.com/raw/4iG9SKxs"))()
local Window = Library:Window()

local games = {
    [863266079] = "Chdr3y.xyz/ar2",
}
getgenv().ConfigFolder = games[game.GameId] or "Chdr3y.xyz/universal"

local legit = Window:Page({ Name = "Visuals" })
local Test = legit:Section({ Name = "Visuals" })
local worldSection = legit:Section({ Name = "world", Side = "Right" })
local SelfChamsSection = legit:Section({ Name = "Local Player", Side = "Right" })
local CorpseSection = legit:Section({ Name = "Corpse Esp", Side = "Left" })
local VehicleSection = legit:Section({ Name = "Vehicle Esp", Side = "Left" })
local ZombieSection = legit:Section({ Name = "Zombie Esp", Side = "Right" })

local Settings = {
    BoxEnabled = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    NameEnabled = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameFont = 2,
    NameSize = 13,
    DistanceEnabled = false,
    DistanceColor = Color3.fromRGB(255, 255, 255),
    DistanceFont = 2,
    DistanceSize = 13,
    HealthBarEnabled = false,
    MaxDistance = 1000,
}

Test:Toggle({
    Name = "Box",
    Flag = "Box",
    Default = false,
    Callback = function(val) Settings.BoxEnabled = val end
}):Colorpicker({
    Default = Settings.BoxColor,
    Flag = "BoxColor",
    Callback = function(col)
        Settings.BoxColor = col
    end
})
Test:Toggle({
    Name = "Health",
    Flag = "HealthToggle",
    Default = false,
    Callback = function(val) Settings.HealthBarEnabled = val end
})

Test:Toggle({
    Name = "Name Player",
    Flag = "NameESP",
    Default = false,
    Callback = function(val) Settings.NameEnabled = val end
}):Colorpicker({
    Default = Settings.NameColor,
    Flag = "NameColor",
    Callback = function(col)
        Settings.NameColor = col
    end
})

Test:Toggle({
    Name = "Distance",
    Flag = "DistanceESP",
    Default = false,
    Callback = function(val) Settings.DistanceEnabled = val end
}):Colorpicker({
    Default = Settings.DistanceColor,
    Flag = "DistanceColor",
    Callback = function(col)
        Settings.DistanceColor = col
    end
})

local playerHighlights = {}

local function createHighlight(player)
    if playerHighlights[player] then return end
    local char = player.Character
    if not char then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlightESP"
    highlight.Adornee = char
    highlight.FillColor = HighlightColor
    highlight.OutlineColor = HighlightColor
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = workspace
    playerHighlights[player] = highlight
end

local function removeHighlight(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if HighlightsEnabled then
            createHighlight(player)
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

Test:Toggle({
    Name = "Highlight",
    Flag = "Highlight",
    Default = false,
    Callback = function(val)
        HighlightsEnabled = val
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if val then
                    createHighlight(player)
                else
                    removeHighlight(player)
                end
            end
        end
    end
}):Colorpicker({
    Default = HighlightColor,
    Flag = "HighlightColor",
    Callback = function(color)
        HighlightColor = color
        for _, highlight in pairs(playerHighlights) do
            highlight.FillColor = HighlightColor
            highlight.OutlineColor = HighlightColor
        end
    end
})

Test:Slider({
    Name = "Max Distance",
    Flag = "MaxDistance",
    Min = 1000,
    Max = 10000,
    Default = Settings.MaxDistance,
    Rounding = 0,
    Callback = function(value)
        Settings.MaxDistance = value
    end
})

local boxDrawings = {}
local outlineDrawings = {}

local function createBoxESP(player)
    if boxDrawings[player] or outlineDrawings[player] then return end

    local box = Drawing.new("Square")
    local outline = Drawing.new("Square")

    box.Thickness, box.ZIndex, box.Visible = 1, 2, false
    outline.Thickness, outline.ZIndex, outline.Visible = 1, 1, false

    boxDrawings[player] = box
    outlineDrawings[player] = outline

    game:GetService("RunService").RenderStepped:Connect(function()
        local char = player.Character
        if not char then
            box.Visible = false
            outline.Visible = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hrp and hum then
            local camera = workspace.CurrentCamera
            local charPos = hrp.Position
            local cameraPos = camera.CFrame.Position
            local distance = (cameraPos - charPos).Magnitude
            local pos, onScreen = camera:WorldToViewportPoint(charPos)

            if Settings.BoxEnabled and hum.Health > 0 and onScreen and distance <= Settings.MaxDistance then
                local scale = 1 / (pos.Z * math.tan(math.rad(camera.FieldOfView / 2)) * 2) * 100
                local w, h = 40 * scale, 60 * scale
                local x, y = pos.X - w / 2, pos.Y - h / 2

                box.Size = Vector2.new(w, h)
                box.Position = Vector2.new(x, y)
                box.Color = Settings.BoxColor
                box.Visible = true

                outline.Size = Vector2.new(w + 2, h + 2)
                outline.Position = Vector2.new(x - 1, y - 1)
                outline.Color = Settings.OutlineColor
                outline.Visible = true
            else
                box.Visible = false
                outline.Visible = false
            end
        else
            box.Visible = false
            outline.Visible = false
        end
    end)
end

local function CreateHealthESP(player)
    local segments, bars = 10, {}
    local outline = Drawing.new("Square")
    outline.Thickness = 1
    outline.Color = Color3.new(0, 0, 0)
    outline.Filled = false
    outline.Visible = false

    for i = 1, segments do
        local seg = Drawing.new("Square")
        seg.Filled = true
        seg.Visible = false
        table.insert(bars, seg)
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
            return
        end

        local hum = player.Character:FindFirstChild("Humanoid")
        if not hum or not Settings.HealthBarEnabled then
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
            return
        end

        local camera = workspace.CurrentCamera
        local pos, vis = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
        local distance = (camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude

        if vis and hum.Health > 0 and distance <= Settings.MaxDistance then
            local scale = 1 / (pos.Z * math.tan(math.rad(camera.FieldOfView / 2)) * 2) * 100
            local h = math.floor(60 * scale)
            local x, y = math.floor(pos.X - 20 * scale - 8), math.floor(pos.Y - h / 2)

            outline.Size = Vector2.new(4, h)
            outline.Position = Vector2.new(x - 1, y - 1)
            outline.Visible = true

            local hpPerc = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barFill = math.floor(h * hpPerc)
            local segH = barFill / segments

            for i = 1, segments do
                local seg = bars[i]
                local t = i / segments
                local r = t < 0.5 and 42 + (255 - 42) * (t / 0.5) or 255 + (232 - 255) * ((t - 0.5) / 0.5)
                local g = t < 0.5 and 227 + (218 - 227) * (t / 0.5) or 218 + (27 - 218) * ((t - 0.5) / 0.5)
                seg.Color = Color3.fromRGB(r, g, 5)
                seg.Size = Vector2.new(2, segH)
                seg.Position = Vector2.new(x, y + h - segH * (segments - i + 1))
                seg.Visible = true
            end
        else
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
        end
    end)
end

local function CreateNameESP(player)
    local name = Drawing.new("Text")
    name.Center, name.Outline, name.Visible = true, true, false
    name.Font, name.Size, name.Color = Settings.NameFont, Settings.NameSize, Settings.NameColor

    game:GetService("RunService").RenderStepped:Connect(function()
        if Settings.NameEnabled and player.Character and player.Character:FindFirstChild("Head") then
            local camera = workspace.CurrentCamera
            local pos, visible = camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 2, 0))
            local distance = (camera.CFrame.Position - player.Character.Head.Position).Magnitude
            if visible and distance <= Settings.MaxDistance then
                name.Text = player.Name
                name.Position = Vector2.new(pos.X, pos.Y)
                name.Visible = true
            else
                name.Visible = false
            end
        else
            name.Visible = false
        end
    end)
end

local function CreateDistanceESP(player)
    local dist = Drawing.new("Text")
    dist.Center, dist.Outline, dist.Visible = true, true, false
    dist.Font, dist.Size, dist.Color = Settings.DistanceFont, Settings.DistanceSize, Settings.DistanceColor

    game:GetService("RunService").RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Settings.DistanceEnabled then
            local camera = workspace.CurrentCamera
            local pos, visible = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distanceValue = (camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if visible and distanceValue <= Settings.MaxDistance then
                dist.Text = tostring(math.floor(distanceValue)) .. "m"
                dist.Position = Vector2.new(pos.X, pos.Y + 30)
                dist.Visible = true
            else
                dist.Visible = false
            end
        else
            dist.Visible = false
        end
    end)
end

local function CreateFullESP(player)
    if player == game.Players.LocalPlayer then return end
    createBoxESP(player)
    CreateHealthESP(player)
    CreateNameESP(player)
    CreateDistanceESP(player)
end

for _, player in ipairs(game.Players:GetPlayers()) do
    CreateFullESP(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        CreateFullESP(player)
    end)
end

game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(1)
            CreateFullESP(player)
        end)
        if player.Character then
            wait(1)
            CreateFullESP(player)
        end
    end
end)

local corpsesFolder = workspace:WaitForChild("Corpses")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local corpseESPEnabled = false
local showNames = false
local showDistance = false

local corpseHighlightColor = Color3.fromRGB(255, 0, 0)
local corpseNameColor = Color3.fromRGB(255, 255, 255)
local corpseDistanceColor = Color3.fromRGB(255, 255, 255)

local espConnections = {}
local espDrawings = {}

local function removeESP(model)
    local highlight = model:FindFirstChild("CorpseHighlight")
    if highlight then highlight:Destroy() end

    if espDrawings[model] then
        if espDrawings[model].nameText then
            espDrawings[model].nameText:Remove()
        end
        if espDrawings[model].distanceText then
            espDrawings[model].distanceText:Remove()
        end
        espDrawings[model] = nil
    end

    if espConnections[model] then
        espConnections[model]:Disconnect()
        espConnections[model] = nil
    end

    local billboardGui = model:FindFirstChild("CorpseESP")
    if billboardGui then billboardGui:Destroy() end
end

local function isIgnoredCorpse(model)
    return model.Name:lower():find("infected") ~= nil
end

local function createHighlight(model)
    if isIgnoredCorpse(model) then return end
    local highlight = model:FindFirstChild("CorpseHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "CorpseHighlight"
        highlight.Adornee = model
        highlight.Parent = model
    end
    highlight.FillColor = corpseHighlightColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
end

local function createNameDistance(model)
    if isIgnoredCorpse(model) then return end

    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end

    if espDrawings[model] then
        if espDrawings[model].nameText then espDrawings[model].nameText:Remove() end
        if espDrawings[model].distanceText then espDrawings[model].distanceText:Remove() end
        espDrawings[model] = nil
    end
    if espConnections[model] then
        espConnections[model]:Disconnect()
        espConnections[model] = nil
    end

    local nameText = Drawing.new("Text")
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = false
    nameText.Font = Enum.Font.GothamBold
    nameText.Size = 16
    nameText.Color = corpseNameColor

    local distanceText = Drawing.new("Text")
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Visible = false
    distanceText.Font = Enum.Font.GothamBold
    distanceText.Size = 16
    distanceText.Color = corpseDistanceColor

    espDrawings[model] = {nameText = nameText, distanceText = distanceText}

    local camera = workspace.CurrentCamera

    espConnections[model] = RunService.RenderStepped:Connect(function()
        if not model or not model.Parent or not primary or not primary.Parent then
            nameText.Visible = false
            distanceText.Visible = false
            if espConnections[model] then
                espConnections[model]:Disconnect()
                espConnections[model] = nil
            end
            nameText:Remove()
            distanceText:Remove()
            espDrawings[model] = nil
            return
        end

        local pos, onScreen = camera:WorldToViewportPoint(primary.Position + Vector3.new(0, 3, 0))
        local distanceStuds = (camera.CFrame.Position - primary.Position).Magnitude
        local distanceMeters = math.floor(distanceStuds * 0.28)

        if onScreen then
            nameText.Position = Vector2.new(pos.X, pos.Y)
            distanceText.Position = Vector2.new(pos.X, pos.Y + 18)

            nameText.Visible = showNames
            distanceText.Visible = showDistance

            if showNames then
                nameText.Text = model.Name
                nameText.Color = corpseNameColor
            end
            if showDistance then
                distanceText.Text = tostring(distanceMeters) .. "m"
                distanceText.Color = corpseDistanceColor
            end
        else
            nameText.Visible = false
            distanceText.Visible = false
        end
    end)
end

local function updateCorpseESP(enabled)
    for _, corpse in pairs(corpsesFolder:GetChildren()) do
        if corpse:IsA("Model") and not isIgnoredCorpse(corpse) then
            if enabled then
                createHighlight(corpse)
                if showNames or showDistance then
                    createNameDistance(corpse)
                else
                    removeESP(corpse)
                end
            else
                removeESP(corpse)
            end
        else
            removeESP(corpse)
        end
    end
end

corpsesFolder.ChildAdded:Connect(function(newCorpse)
    if newCorpse:IsA("Model") then
        task.defer(function()
            pcall(function()
                newCorpse:WaitForChild("PrimaryPart", 3)
            end)
            if corpseESPEnabled and not isIgnoredCorpse(newCorpse) then
                createHighlight(newCorpse)
                if showNames or showDistance then
                    createNameDistance(newCorpse)
                end
            end
        end)
    end
end)

CorpseSection:Toggle({
    Name = "Corpse ESP",
    Flag = "CorpseESP",
    Callback = function(state)
        corpseESPEnabled = state
        updateCorpseESP(corpseESPEnabled)
    end
}):Colorpicker({
    Default = corpseHighlightColor,
    Flag = "CorpseESPColor",
    Callback = function(color)
        corpseHighlightColor = color
        for _, corpse in pairs(corpsesFolder:GetChildren()) do
            local hl = corpse:FindFirstChild("CorpseHighlight")
            if hl then
                hl.FillColor = color
            end
        end
    end
})

CorpseSection:Toggle({
    Name = "Names",
    Flag = "CorpseShowNames",
    Callback = function(state)
        showNames = state
        if corpseESPEnabled then
            updateCorpseESP(true)
        end
    end
}):Colorpicker({
    Default = corpseNameColor,
    Flag = "CorpseNameColor",
    Callback = function(color)
        corpseNameColor = color
        for _, v in pairs(espDrawings) do
            if v.nameText then
                v.nameText.Color = color
            end
        end
    end
})

CorpseSection:Toggle({
    Name = "Distance",
    Flag = "CorpseShowDistance",
    Callback = function(state)
        showDistance = state
        if corpseESPEnabled then
            updateCorpseESP(true)
        end
    end
}):Colorpicker({
    Default = corpseDistanceColor,
    Flag = "CorpseDistanceColor",
    Callback = function(color)
        corpseDistanceColor = color
        for _, v in pairs(espDrawings) do
            if v.distanceText then
                v.distanceText.Color = color
            end
        end
    end
})

local vehiclesFolder = workspace:WaitForChild("Vehicles")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local vehicleESPEnabled = false
local vehicleShowNames = false
local vehicleShowDistance = false

local vehicleESPColor = Color3.fromRGB(0, 0, 255)
local vehicleNameColor = Color3.fromRGB(255, 255, 255)
local vehicleDistanceColor = Color3.fromRGB(255, 255, 255)

local espConnectionsVehicles = {}
local espDrawingsVehicles = {}

local function removeVehicleESP(model)
    local highlight = model:FindFirstChild("VehicleHighlight")
    if highlight then highlight:Destroy() end

    if espDrawingsVehicles[model] then
        if espDrawingsVehicles[model].nameText then
            espDrawingsVehicles[model].nameText:Remove()
        end
        if espDrawingsVehicles[model].distanceText then
            espDrawingsVehicles[model].distanceText:Remove()
        end
        espDrawingsVehicles[model] = nil
    end

    if espConnectionsVehicles[model] then
        espConnectionsVehicles[model]:Disconnect()
        espConnectionsVehicles[model] = nil
    end
end

local function createVehicleHighlight(model)
    if not model:FindFirstChild("VehicleHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "VehicleHighlight"
        highlight.Adornee = model
        highlight.FillColor = vehicleESPColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = model
    else
        model.VehicleHighlight.FillColor = vehicleESPColor
    end
end

local function createVehicleNameDistance(model)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end

    if espDrawingsVehicles[model] then
        if espDrawingsVehicles[model].nameText then espDrawingsVehicles[model].nameText:Remove() end
        if espDrawingsVehicles[model].distanceText then espDrawingsVehicles[model].distanceText:Remove() end
        espDrawingsVehicles[model] = nil
    end
    if espConnectionsVehicles[model] then
        espConnectionsVehicles[model]:Disconnect()
        espConnectionsVehicles[model] = nil
    end

    local nameText = Drawing.new("Text")
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = false
    nameText.Font = Enum.Font.GothamBold
    nameText.Size = 16
    nameText.Color = vehicleNameColor

    local distanceText = Drawing.new("Text")
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Visible = false
    distanceText.Font = Enum.Font.GothamBold
    distanceText.Size = 16
    distanceText.Color = vehicleDistanceColor

    espDrawingsVehicles[model] = {nameText = nameText, distanceText = distanceText}

    local camera = workspace.CurrentCamera

    espConnectionsVehicles[model] = RunService.RenderStepped:Connect(function()
        if not model or not model.Parent or not primary or not primary.Parent then
            nameText.Visible = false
            distanceText.Visible = false
            if espConnectionsVehicles[model] then
                espConnectionsVehicles[model]:Disconnect()
                espConnectionsVehicles[model] = nil
            end
            nameText:Remove()
            distanceText:Remove()
            espDrawingsVehicles[model] = nil
            return
        end

        local pos, onScreen = camera:WorldToViewportPoint(primary.Position + Vector3.new(0, 3, 0))
        local distanceStuds = (camera.CFrame.Position - primary.Position).Magnitude
        local distanceMeters = math.floor(distanceStuds * 0.28 + 0.5)

        if onScreen then
            nameText.Position = Vector2.new(pos.X, pos.Y)
            distanceText.Position = Vector2.new(pos.X, pos.Y + 18)

            nameText.Visible = vehicleShowNames
            distanceText.Visible = vehicleShowDistance

            if vehicleShowNames then
                nameText.Text = model.Name
                nameText.Color = vehicleNameColor
            end
            if vehicleShowDistance then
                distanceText.Text = tostring(distanceMeters) .. " m"
                distanceText.Color = vehicleDistanceColor
            end
        else
            nameText.Visible = false
            distanceText.Visible = false
        end
    end)
end

local function updateVehicleESP(enabled)
    for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
        if vehicle:IsA("Model") then
            if enabled then
                createVehicleHighlight(vehicle)
                if vehicleShowNames or vehicleShowDistance then
                    createVehicleNameDistance(vehicle)
                else
                    removeVehicleESP(vehicle)
                end
            else
                removeVehicleESP(vehicle)
            end
        end
    end
end

vehiclesFolder.ChildAdded:Connect(function(newVehicle)
    if newVehicle:IsA("Model") then
        task.defer(function()
            pcall(function()
                newVehicle:WaitForChild("PrimaryPart", 3)
            end)
            if vehicleESPEnabled and newVehicle and newVehicle.Parent then
                createVehicleHighlight(newVehicle)
                if vehicleShowNames or vehicleShowDistance then
                    createVehicleNameDistance(newVehicle)
                end
            end
        end)
    end
end)

VehicleSection:Toggle({
    Name = "Vehicle Esp",
    Flag = "VehicleESP",
    Callback = function(state)
        vehicleESPEnabled = state
        updateVehicleESP(vehicleESPEnabled)
    end
}):Colorpicker({
    Default = vehicleESPColor,
    Flag = "VehicleESPColor",
    Callback = function(color)
        vehicleESPColor = color
        for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
            if vehicle:FindFirstChild("VehicleHighlight") then
                vehicle.VehicleHighlight.FillColor = color
            end
        end
    end
})

VehicleSection:Toggle({
    Name = "Names",
    Flag = "VehicleShowNames",
    Callback = function(state)
        vehicleShowNames = state
        if vehicleESPEnabled then
            updateVehicleESP(true)
        end
    end
}):Colorpicker({
    Default = vehicleNameColor,
    Flag = "VehicleNameColor",
    Callback = function(color)
        vehicleNameColor = color
        for _, v in pairs(espDrawingsVehicles) do
            if v.nameText then
                v.nameText.Color = color
            end
        end
    end
})

VehicleSection:Toggle({
    Name = "Distance",
    Flag = "VehicleShowDistance",
    Callback = function(state)
        vehicleShowDistance = state
        if vehicleESPEnabled then
            updateVehicleESP(true)
        end
    end
}):Colorpicker({
    Default = vehicleDistanceColor,
    Flag = "VehicleDistanceColor",
    Callback = function(color)
        vehicleDistanceColor = color
        for _, v in pairs(espDrawingsVehicles) do
            if v.distanceText then
                v.distanceText.Color = color
            end
        end
    end
})

local zombiesFolder = workspace:WaitForChild("Zombies")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local zombieESPEnabled = false
local showNames = false
local showDistance = false
local espConnections = {}

local function removeESP(model)
    local h = model:FindFirstChild("ZombieHighlight")
    if h then h:Destroy() end
    local b = model:FindFirstChild("ZombieESP")
    if b then b:Destroy() end
    if espConnections[model] then
        espConnections[model]:Disconnect()
        espConnections[model] = nil
    end
end

local function createHighlight(model)
    if not model:FindFirstChild("ZombieHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ZombieHighlight"
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = model
    end
end

local function createNameDistance(model)
    if model:FindFirstChild("ZombieESP") then return end
    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "ZombieESP"
    gui.Adornee = part
    gui.Size = UDim2.new(0, 150, 0, 40)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.Parent = model

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextScaled = false
    label.TextSize = 16
    label.TextWrapped = true
    label.Parent = gui

    espConnections[model] = RunService.Heartbeat:Connect(function()
        if not model or not model.Parent then
            if espConnections[model] then
                espConnections[model]:Disconnect()
                espConnections[model] = nil
            end
            gui:Destroy()
            return
        end
        local char = localPlayer.Character
        if char and char.PrimaryPart and gui.Adornee then
            local dist = (char.PrimaryPart.Position - gui.Adornee.Position).Magnitude * 0.28
            local text = {}
            if showNames then table.insert(text, model.Name) end
            if showDistance then table.insert(text, string.format("%.1f m", dist)) end
            label.Text = #text > 0 and table.concat(text, "\n") or ""
        else
            label.Text = showNames and model.Name or ""
        end
    end)
end

local function updateZombieESP(enabled)
    for _, zombie in ipairs(zombiesFolder:GetChildren()) do
        if zombie:IsA("Model") then
            if enabled then
                createHighlight(zombie)
                if showNames or showDistance then
                    createNameDistance(zombie)
                else
                    removeESP(zombie)
                end
            else
                removeESP(zombie)
            end
        end
    end
end

zombiesFolder.ChildAdded:Connect(function(zombie)
    if zombie:IsA("Model") then
        task.defer(function()
            if not zombie.PrimaryPart then
                zombie:WaitForChild("HumanoidRootPart", 3)
            end
            if zombieESPEnabled then
                createHighlight(zombie)
                if showNames or showDistance then
                    createNameDistance(zombie)
                end
            end
        end)
    end
end)

ZombieSection:Toggle({
    Name = "Zombie ESP",
    Flag = "ZombieESP",
    Callback = function(state)
        zombieESPEnabled = state
        updateZombieESP(state)
    end
})

ZombieSection:Toggle({
    Name = "Names",
    Flag = "ZombieShowNames",
    Callback = function(state)
        showNames = state
        if zombieESPEnabled then
            updateZombieESP(true)
        end
    end
})

ZombieSection:Toggle({
    Name = "Distance",
    Flag = "ZombieShowDistance",
    Callback = function(state)
        showDistance = state
        if zombieESPEnabled then
            updateZombieESP(true)
        end
    end
})

local combat = Window:Page({ Name = "Combat" })
local headExpander = combat:Section({ Name = "Head Expander" })
local silentAim = combat:Section({ Name = "Silent Aim", Side = "Right" })
local spinningCrosshair = combat:Section({ Name = "Spinning CrossHair", Side = "Left" })
local gunMods = combat:Section({ Name = "Gun Mods", Side = "Left" })
local meleeSpeed = combat:Section({ Name = "Melee Speed", Side = "Right" })
local CustomHitSound = combat:Section({ Name = "HitSounds", Side = "Left" })
local AntiZombie = combat:Section({ Name = "Anti Zombie", Side = "Right" })

local ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
local Bullets = require(ReplicatedFirst:WaitForChild("Framework")).Libraries.Bullets

local GetFireImpulse = getupvalue(Bullets.Fire, 6)


local noRecoilEnabled = false
local recoilScale = 0.1


setupvalue(Bullets.Fire, 6, function(...)
    local impulse = {GetFireImpulse(...)}

    if noRecoilEnabled then
        for i = 1, #impulse do
            impulse[i] = impulse[i] * recoilScale
        end
    end

    return unpack(impulse)
end)

gunMods:Toggle({
    Name = "No Recoil",
    Flag = "No Recoil",
    Callback = function(state)
        noRecoilEnabled = state
    end
})

gunMods:Slider({
    Name = "Recoil Control",
    Flag = "Recoil",
    Min = 0,
    Max = 100,
    Default = 100,
    Decimals = 1,
    Callback = function(value)
        recoilScale = value / 100
    end
})

local SilentAimEnabled = false
local MaxDistance = 1000

local function get_closest_player()
    local closest_distance = MaxDistance
    local closest_player = nil

    for _, player in pairs(game.Players:GetPlayers()) do
        local character = player.Character
        if player == game.Players.LocalPlayer or not character or not character:FindFirstChild("Head") then
            continue
        end

        local pos, on_screen = workspace.CurrentCamera:WorldToViewportPoint(character.Head.Position)
        if not on_screen then
            continue
        end

        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        local distance = (center - Vector2.new(pos.X, pos.Y)).Magnitude

        if distance < closest_distance then
            closest_player = character
            closest_distance = distance
        end
    end
    return closest_player
end

local old_fire
local function silent_aim()
    local replicated_first = game:GetService("ReplicatedFirst")
    local framework

    for _, v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "Fire") and typeof(v.Fire) == "function" then
            framework = v
            break
        end
    end

    if not framework then return end

    old_fire = hookfunction(framework.Fire, function(weapon_data, character_data, _, gun_data, origin, direction, ...)
        if SilentAimEnabled then
            local closest_character = get_closest_player()
            if closest_character and closest_character:FindFirstChild("Head") then
                direction = (closest_character.Head.Position - origin).Unit
            end
        end
        return old_fire(weapon_data, character_data, _, gun_data, origin, direction, ...)
    end)
end

silent_aim()

silentAim:Toggle({
    Name = "Silent Aim",
    Flag = "SilentAim",
    Default = false,
    Callback = function(value)
        SilentAimEnabled = value
    end
})

silentAim:Slider({
    Name = "Max Distance",
    Flag = "SilentAimDistance",
    Min = 100,
    Max = 5000,
    Default = MaxDistance,
    Callback = function(value)
        MaxDistance = value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Replicated = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local ViewportSize = Camera.ViewportSize

local aimbotKey = Enum.UserInputType.MouseButton2
local aimbotEnabled = false
local holding = false
local smoothingFactor = 0.5
local radius = 170
local speed = 2200
local selectedHitPart = "Head"

silentAim:Toggle({
    Name = "Aimbot",
    Flag = "AimbotToggle",
    Default = false,
    Tooltip = "Toggle the aimbot on/off.",
    Callback = function(state)
        aimbotEnabled = state
    end
})

silentAim:Slider({
    Name = "Sensivity",
    Flag = "Sensivity",
    Min = 0.5,
    Max = 2,
    Default = smoothingFactor,
    Decimals = 1,
    Callback = function(value)
        smoothingFactor = value
    end
})

local function predict(pos, vel)
    local dist = (pos - Camera.CFrame.Position).Magnitude
    if dist < 1 then return pos end
    local time = dist / speed
    return pos + vel * time + Vector3.new(0, 50 * time^2, 0)
end

local function getTargetPart(character)
    if not character then return nil end
    local part = character:FindFirstChild(selectedHitPart)
    if part and part:IsA("BasePart") then
        return part
    end
    return nil
end

local function getSpeed()
    local char = LP.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local bulletSpeedValue = tool:FindFirstChild("BulletSpeed") or tool:FindFirstChild("Speed")
            if bulletSpeedValue and bulletSpeedValue:IsA("NumberValue") then
                return bulletSpeedValue.Value
            end
        end
    end
    return 2200
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    speed = getSpeed()
    if aimbotEnabled and holding then
        local viewportSize = Camera.ViewportSize
        local closestDist = math.huge
        local targetPlayer = nil

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local targetPart = getTargetPart(player.Character)
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < radius and dist < closestDist then
                            closestDist = dist
                            targetPlayer = player
                        end
                    end
                end
            end
        end

        if targetPlayer and targetPlayer.Character then
            local targetPart = getTargetPart(targetPlayer.Character)
            if targetPart then
                local futurePos = predict(targetPart.Position, targetPart.Velocity or Vector3.new())
                local screenPos, onScreen = Camera:WorldToViewportPoint(futurePos)
                if onScreen and screenPos.Z > 0 then
                    local dx = screenPos.X - (viewportSize.X / 2)
                    local dy = screenPos.Y - (viewportSize.Y / 2)
                    local mouseMoveX = dx * smoothingFactor
                    local mouseMoveY = dy * smoothingFactor
                    if mousemoverel then
                        mousemoverel(mouseMoveX, mouseMoveY)
                    end
                end
            end
        end
    end
end)

meleeSpeed:Toggle({
    Name = "Melee Speed",
    Flag = "MeleeSpeedToggle",
    Default = false,
    Callback = function(state) MeleeSpeedEnabled = state end
})

meleeSpeed:Slider({
    Name = "Melee Speed",
    Flag = "MeleeSpeedSlider",
    Min = 1,
    Max = 5,
    Default = MeleeSpeedValue,
    Callback = function(val) MeleeSpeedValue = val end
})

task.spawn(function()
    local Framework = require(game:GetService("ReplicatedFirst").Framework)
    local Animators = Framework.require("Classes", "Animators")
    local oldAnim; oldAnim = hookfunction(Animators.PlayAnimation, function(self, anim, ...)
        local track = oldAnim(self, anim, ...)
        if MeleeSpeedEnabled and tostring(anim):match("Melees") then
            self:SetAnimationSpeed(anim, MeleeSpeedValue)
        end
        return track
    end)
end)

SelfChamsSection:Button({
    Name = "Noclip",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local noclip = true

        RunService.Stepped:Connect(function()
            if noclip and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local InfiniteJumpEnabled = false
local SlowFallEnabled = false
local JumpPower = 50
local FallModifier = 0.5
local HoldingSpace = false

SelfChamsSection:Toggle({
    Name = "Infinite Jump",
    Flag = "InfiniteJump/Enabled",
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

SelfChamsSection:Slider({
    Name = "Jump Power",
    Flag = "InfiniteJump/Power",
    Min = 10,
    Max = 100,
    Default = 50,
    Decimals = 1,
    Callback = function(value)
        JumpPower = value
    end
})

SelfChamsSection:Toggle({
    Name = "Slow Fall",
    Flag = "SlowFall/Enabled",
    Callback = function(state)
        SlowFallEnabled = state
    end
})

SelfChamsSection:Slider({
    Name = "Fall Speed",
    Flag = "SlowFall/Speed",
    Min = 0.5,
    Max = 2,
    Default = 0.5,
    Decimals = 0.5,
    Callback = function(value)
        FallModifier = value
    end
})

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        HoldingSpace = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        HoldingSpace = false
    end
end)

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart

        if InfiniteJumpEnabled and HoldingSpace then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, JumpPower, hrp.Velocity.Z)
        elseif SlowFallEnabled and hrp.Velocity.Y < 0 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y * FallModifier, hrp.Velocity.Z)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.JumpPower = JumpPower
    end
end)

if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = JumpPower
    end
end

local SelfChamsEnabled = false
local SelfChamsColor = Color3.fromRGB(255, 255, 255)
local RainbowChamsEnabled = false
local originalProperties = {}

local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0

    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end

    return Color3.new(r + m, g + m, b + m)
end

local function applyChams(char)
    task.wait(0)
    originalProperties = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            originalProperties[part] = {
                Color = part.Color,
                Material = part.Material
            }
            part.Material = Enum.Material.ForceField
        end
    end
end

local function removeChams(char)
    if not char then return end
    for part, props in pairs(originalProperties) do
        if part and part.Parent then
            part.Color = props.Color
            part.Material = props.Material
        end
    end
    originalProperties = {}
end

local function updateChams()
    if not SelfChamsEnabled or not LocalPlayer.Character then return end
    for part, _ in pairs(originalProperties) do
        if part and part.Parent then
            if RainbowChamsEnabled then
                local hue = (tick() * 120) % 360
                part.Color = HSVToRGB(hue, 1, 1)
            else
                part.Color = SelfChamsColor
            end
        end
    end
end

SelfChamsSection:Toggle({
    Name = "Self Chams",
    Flag = "SelfChams",
    Default = false,
    Callback = function(state)
        SelfChamsEnabled = state
        if LocalPlayer.Character then
            if SelfChamsEnabled then
                applyChams(LocalPlayer.Character)
            else
                removeChams(LocalPlayer.Character)
            end
        end
    end
})

SelfChamsSection:Toggle({
    Name = "Rainbow Chams",
    Flag = "RainbowChams",
    Default = false,
    Callback = function(state)
        RainbowChamsEnabled = state
        if SelfChamsEnabled and LocalPlayer.Character then
            if not RainbowChamsEnabled then
                for part, _ in pairs(originalProperties) do
                    if part and part.Parent then
                        part.Color = SelfChamsColor
                    end
                end
            end
        end
    end
})

SelfChamsSection:Colorpicker({
    Name = "Chams Color",
    Flag = "ChamsColor",
    Default = SelfChamsColor,
    Callback = function(color)
        SelfChamsColor = color
        if SelfChamsEnabled and not RainbowChamsEnabled and LocalPlayer.Character then
            for part, _ in pairs(originalProperties) do
                if part and part.Parent then
                    part.Color = SelfChamsColor
                end
            end
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(char)
    if SelfChamsEnabled then
        applyChams(char)
    else
        removeChams(char)
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    updateChams()
end)

local strafeEnabled = false

local Vis = SelfChamsSection:Toggle({
    Name = "WalkSpeed",
    Flag = "StrafeRun_Enabled",
    Callback = function(enabled)
        strafeEnabled = enabled
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local movement = { W = false, A = false, S = false, D = false }
local speed = 0.20

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")


player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local key = input.KeyCode.Name
	if movement[key] ~= nil then
		movement[key] = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local key = input.KeyCode.Name
	if movement[key] ~= nil then
		movement[key] = false
	end
end)


RunService.RenderStepped:Connect(function()
	if not strafeEnabled or not hrp then return end

	local moveVector = Vector3.zero
	local forward = hrp.CFrame.LookVector
	local right = hrp.CFrame.RightVector

	if movement.W then moveVector += forward end
	if movement.S then moveVector -= forward end
	if movement.A then moveVector -= right end
	if movement.D then moveVector += right end

	if moveVector.Magnitude > 0 then
		local delta = moveVector.Unit * speed
		local newCFrame = hrp.CFrame + Vector3.new(delta.X, 0, delta.Z)
		character:PivotTo(newCFrame)
	end
end)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local fovCircle = Drawing.new("Circle")
local fovColor = Color3.fromRGB(255, 255, 255)
local fovThickness = 2
local fovRadius = 100
local fovEnabled = true
local fovFilled = false

fovCircle.Color = fovColor
fovCircle.Thickness = fovThickness
fovCircle.Filled = fovFilled
fovCircle.Transparency = 1
fovCircle.Visible = true
fovCircle.Radius = fovRadius

silentAim:Toggle({
    Name = "Show FOV",
    Flag = "ShowFOV",
    Default = true,
    Callback = function(state)
        fovEnabled = state
        fovCircle.Visible = state
    end
})

silentAim:Toggle({
    Name = "Filled",
    Flag = "FOVFilled",
    Default = false,
    Callback = function(state)
        fovFilled = state
        fovCircle.Filled = fovFilled
    end
})

silentAim:Slider({
    Name = "Size",
    Flag = "FOVSize",
    Min = 50,
    Max = 300,
    Default = 120,
    Callback = function(value)
        fovRadius = value
        fovCircle.Radius = fovRadius
    end
})

silentAim:Slider({
    Name = "Thickness",
    Flag = "FOVThickness",
    Min = 1,
    Max = 5,
    Default = fovThickness,
    Callback = function(value)
        fovThickness = value
        fovCircle.Thickness = fovThickness
    end
})

silentAim:Colorpicker({
    Name = "Color",
    Flag = "FOVColor",
    Default = fovColor,
    Callback = function(color)
        fovColor = color
        fovCircle.Color = fovColor
    end
})

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    fovCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    fovCircle.Visible = fovEnabled
end)


local Players = game:GetService("Players")
local headExpanderEnabled = false
local headSizeValue = 1.15
local headTransparencyValue = 0

local function ApplyHeadChanges(player)
    if player == Players.LocalPlayer then return end
    local function apply()
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if head and head:IsA("Part") then
            head.Size = Vector3.new(headSizeValue, headSizeValue, headSizeValue)
            head.Transparency = headTransparencyValue
        end
    end
    apply()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if headExpanderEnabled then
            apply()
        end
    end)
end

headExpander:Toggle({
    Name = "Head Expander",
    Flag = "AR2/HeadExpander",
    Default = false,
    Callback = function(enabled)
        headExpanderEnabled = enabled
        if enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                ApplyHeadChanges(player)
            end
            Players.PlayerAdded:Connect(ApplyHeadChanges)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    local char = player.Character
                    if char then
                        local head = char:FindFirstChild("Head")
                        if head and head:IsA("Part") then
                            head.Size = Vector3.new(2, 1, 1)
                            head.Transparency = 0
                        end
                    end
                end
            end
        end
    end
})

headExpander:Slider({
    Name = "Head Size",
    Flag = "AR2/HeadExpanderSize",
    Min = 1,
    Max = 50,
    Default = headSizeValue,
    Decimals = 1,
    Callback = function(value)
        headSizeValue = value
        if headExpanderEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                ApplyHeadChanges(player)
            end
        end
    end
})

headExpander:Slider({
    Name = "Head Transparency",
    Flag = "AR2/HeadTransparency",
    Min = 0,
    Max = 1,
    Default = headTransparencyValue,
    Decimals = 0.5,
    Callback = function(value)
        headTransparencyValue = value
        if headExpanderEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                ApplyHeadChanges(player)
            end
        end
    end
})

local OldIndex = nil
OldIndex = hookmetamethod(game, "__index", function(Self, Index)
    if Window.Flags["AR2/HeadExpander"] and tostring(Self) == "Head" and Index == "Size" then
        return Vector3.one * 1.15
    end
    return OldIndex(Self, Index)
end)

local CrosshairEnabled = false
local SpinSpeed = 300
local CrosshairRadius = 50
local LineCount = 4
local LineLength = 30
local RainbowEnabled = false

local lines = {}
local currentAngle = 0

local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0

    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end

    return Color3.new(r + m, g + m, b + m)
end

local function CreateCrosshairLines()
    for _, line in ipairs(lines) do
        line:Remove()
    end
    lines = {}
    for i = 1, LineCount do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Transparency = 1
        line.Visible = false
        table.insert(lines, line)
    end
end

CreateCrosshairLines()

RunService.RenderStepped:Connect(function(dt)
    if not CrosshairEnabled then
        for _, line in ipairs(lines) do
            line.Visible = false
        end
        return
    end

    local camera = workspace.CurrentCamera
    local centerX, centerY = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
    local anglePerLine = 360 / LineCount
    currentAngle = (currentAngle + SpinSpeed * dt) % 360

    for i, line in ipairs(lines) do
        local angle = math.rad(currentAngle + anglePerLine * (i - 1))
        local startX = centerX + math.cos(angle) * CrosshairRadius
        local startY = centerY + math.sin(angle) * CrosshairRadius
        local endX = centerX + math.cos(angle) * (CrosshairRadius + LineLength)
        local endY = centerY + math.sin(angle) * (CrosshairRadius + LineLength)
        line.From = Vector2.new(startX, startY)
        line.To = Vector2.new(endX, endY)
        line.Visible = true

        if RainbowEnabled then
            local hue = (tick() * 120 + (360 / LineCount) * (i - 1)) % 360
            line.Color = HSVToRGB(hue, 1, 1)
        else
            line.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end)

spinningCrosshair:Toggle({
    Name = "Spinning Crosshair",
    Flag = "SpinningCrosshair",
    Default = false,
    Callback = function(val)
        CrosshairEnabled = val
    end
})

spinningCrosshair:Slider({
    Name = "Spin Speed",
    Flag = "SpinSpeed",
    Min = 0,
    Max = 1000,
    Default = 300,
    Increment = 1,
    Callback = function(value)
        SpinSpeed = value
    end
})

spinningCrosshair:Slider({
    Name = "Radius",
    Flag = "CrosshairRadius",
    Min = 0,
    Max = 300,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        CrosshairRadius = value
    end
})

spinningCrosshair:Toggle({
    Name = "Rainbow Color",
    Flag = "RainbowColor",
    Default = false,
    Callback = function(val)
        RainbowEnabled = val
    end
})

worldSection:Toggle({
    Name = "Full Bright",
    Flag = "FullBrightToggle",
    Callback = function(enabled)
        local Lighting = game:GetService("Lighting")
        _G.FullBrightEnabled = enabled

        if not _G.FullBrightExecuted then
            _G.FullBrightExecuted = true

            _G.NormalLightingSettings = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                ColorShift_Bottom = Lighting.ColorShift_Bottom,
                ColorShift_Top = Lighting.ColorShift_Top
            }

            local function applyFullBright()
                Lighting.Brightness = 2
                Lighting.ClockTime = 12
                Lighting.FogEnd = 1e6
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting.ColorShift_Top = Color3.new(0, 0, 0)
                Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            end

            local function restoreLighting()
                for prop, value in pairs(_G.NormalLightingSettings) do
                    Lighting[prop] = value
                end
            end

            for _, prop in ipairs({
                "Brightness", "ClockTime", "FogEnd", "GlobalShadows", "Ambient",
                "OutdoorAmbient", "ColorShift_Top", "ColorShift_Bottom"
            }) do
                Lighting:GetPropertyChangedSignal(prop):Connect(function()
                    if _G.FullBrightEnabled then
                        applyFullBright()
                    end
                end)
            end

            task.spawn(function()
                while true do
                    task.wait(1)
                    if _G.FullBrightEnabled then
                        applyFullBright()
                    end
                end
            end)
        end

        if _G.FullBrightEnabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 1e6
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        else
            for prop, value in pairs(_G.NormalLightingSettings) do
                Lighting[prop] = value
            end
        end
    end
})

worldSection:Toggle({
    Name = "No Fog",
    Flag = "NoFog",
    Callback = function(enabled)
        if enabled then    
            atmosphereConnection = game:GetService("Lighting").Atmosphere.Changed:Connect(function(prop)
                if prop == "Density" then
                    game:GetService("Lighting").Atmosphere.Density = 0
                end
            end)
        else
            if atmosphereConnection then
                atmosphereConnection:Disconnect()
            end
        end
    end
})

worldSection:Toggle({
    Name = "No Leaves", 
    Flag = "NoLeavesToggle", 
    Callback = function(enabled)
        if enabled then
            for i, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Leaves" then
                    v:Destroy()
                end
            end
        end
    end
})


local Lighting = game:GetService("Lighting")

local Socolo = {}

function applySkybox(theme)
    
    Socolo.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
    Socolo.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
    Socolo.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
    Socolo.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
    Socolo.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
    Socolo.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
    Socolo.StarCount = nil

    if theme == "Sponge Bob" then
        Socolo.SkyboxBk = "http://www.roblox.com/asset/?id=7633178166"
        Socolo.SkyboxDn = "http://www.roblox.com/asset/?id=7633178166"
        Socolo.SkyboxFt = "http://www.roblox.com/asset/?id=7633178166"
        Socolo.SkyboxLf = "http://www.roblox.com/asset/?id=7633178166"
        Socolo.SkyboxRt = "http://www.roblox.com/asset/?id=7633178166"
        Socolo.SkyboxUp = "http://www.roblox.com/asset/?id=7633178166"

    elseif theme == "Vaporwave" then
        Socolo.SkyboxBk = "rbxassetid://1417494030"
        Socolo.SkyboxDn = "rbxassetid://1417494146"
        Socolo.SkyboxFt = "rbxassetid://1417494253"
        Socolo.SkyboxLf = "rbxassetid://1417494402"
        Socolo.SkyboxRt = "rbxassetid://1417494499"
        Socolo.SkyboxUp = "rbxassetid://1417494643"

    elseif theme == "Clouds" then
        Socolo.SkyboxBk = "rbxassetid://570557514"
        Socolo.SkyboxDn = "rbxassetid://570557775"
        Socolo.SkyboxFt = "rbxassetid://570557559"
        Socolo.SkyboxLf = "rbxassetid://570557620"
        Socolo.SkyboxRt = "rbxassetid://570557672"
        Socolo.SkyboxUp = "rbxassetid://570557727"

    elseif theme == "Twilight" then
        Socolo.SkyboxBk = "rbxassetid://264908339"
        Socolo.SkyboxDn = "rbxassetid://264907909"
        Socolo.SkyboxFt = "rbxassetid://264909420"
        Socolo.SkyboxLf = "rbxassetid://264909758"
        Socolo.SkyboxRt = "rbxassetid://264908886"
        Socolo.SkyboxUp = "rbxassetid://264907379"

    elseif theme == "Chill" then
        Socolo.SkyboxBk = "rbxassetid://5084575798"
        Socolo.SkyboxDn = "rbxassetid://5084575916"
        Socolo.SkyboxFt = "rbxassetid://5103949679"
        Socolo.SkyboxLf = "rbxassetid://5103948542"
        Socolo.SkyboxRt = "rbxassetid://5103948784"
        Socolo.SkyboxUp = "rbxassetid://5084576400"

    elseif theme == "Minecraft" then
        Socolo.SkyboxBk = "rbxassetid://1876545003"
        Socolo.SkyboxDn = "rbxassetid://1876544331"
        Socolo.SkyboxFt = "rbxassetid://1876542941"
        Socolo.SkyboxLf = "rbxassetid://1876543392"
        Socolo.SkyboxRt = "rbxassetid://1876543764"
        Socolo.SkyboxUp = "rbxassetid://1876544642"

    elseif theme == "Among Us" then
        Socolo.SkyboxBk = "rbxassetid://5752463190"
        Socolo.SkyboxDn = "rbxassetid://5872485020"
        Socolo.SkyboxFt = "rbxassetid://5752463190"
        Socolo.SkyboxLf = "rbxassetid://5752463190"
        Socolo.SkyboxRt = "rbxassetid://5752463190"
        Socolo.SkyboxUp = "rbxassetid://5752463190"

    elseif theme == "Redshift" then
        Socolo.SkyboxBk = "rbxassetid://401664839"
        Socolo.SkyboxDn = "rbxassetid://401664862"
        Socolo.SkyboxFt = "rbxassetid://401664960"
        Socolo.SkyboxLf = "rbxassetid://401664881"
        Socolo.SkyboxRt = "rbxassetid://401664901"
        Socolo.SkyboxUp = "rbxassetid://401664936"

    elseif theme == "Aesthetic Night" then
        Socolo.SkyboxBk = "rbxassetid://1045964490"
        Socolo.SkyboxDn = "rbxassetid://1045964368"
        Socolo.SkyboxFt = "rbxassetid://1045964655"
        Socolo.SkyboxLf = "rbxassetid://1045964655"
        Socolo.SkyboxRt = "rbxassetid://1045964655"
        Socolo.SkyboxUp = "rbxassetid://1045962969"

    elseif theme == "Neptune" then
        Socolo.SkyboxBk = "rbxassetid://218955819"
        Socolo.SkyboxDn = "rbxassetid://218953419"
        Socolo.SkyboxFt = "rbxassetid://218954524"
        Socolo.SkyboxLf = "rbxassetid://218958493"
        Socolo.SkyboxRt = "rbxassetid://218957134"
        Socolo.SkyboxUp = "rbxassetid://218950090"
        Socolo.StarCount = 5000

    elseif theme == "Galaxy" then
        Socolo.SkyboxBk = "http://www.roblox.com/asset/?id=159454299"
        Socolo.SkyboxDn = "http://www.roblox.com/asset/?id=159454296"
        Socolo.SkyboxFt = "http://www.roblox.com/asset/?id=159454293"
        Socolo.SkyboxLf = "http://www.roblox.com/asset/?id=159454286"
        Socolo.SkyboxRt = "http://www.roblox.com/asset/?id=159454300"
        Socolo.SkyboxUp = "http://www.roblox.com/asset/?id=159454288"
        Socolo.StarCount = 5000
    end

    
    local oldSky = Lighting:FindFirstChildOfClass("Sky")
    if oldSky then
        oldSky:Destroy()
    end

    
    local sky = Instance.new("Sky")
    sky.Name = "CustomSkybox"
    sky.SkyboxBk = Socolo.SkyboxBk
    sky.SkyboxDn = Socolo.SkyboxDn
    sky.SkyboxFt = Socolo.SkyboxFt
    sky.SkyboxLf = Socolo.SkyboxLf
    sky.SkyboxRt = Socolo.SkyboxRt
    sky.SkyboxUp = Socolo.SkyboxUp
    sky.Parent = Lighting
end


local worldToggle = worldSection:Toggle({
    Name = "Custom Sky",
    Flag = "CustomSkyEnabled",
    Callback = function(enabled)
        if enabled then
            local selectedTheme = Library.Flags["CustomSkyTheme"] or "Default"
            applySkybox(selectedTheme)
        else
            applySkybox("Default")
        end
    end
})

worldSection:Dropdown({
    Name = "Select Sky",
    Flag = "CustomSkyTheme",
    Options = {
        "Default",
        "Sponge Bob",
        "Vaporwave",
        "Clouds",
        "Twilight",
        "Chill",
        "Minecraft",
        "Among Us",
        "Redshift",
        "Aesthetic Night",
        "Neptune",
        "Galaxy",
    },
    Default = "Default",
    Callback = function(value)
        if Library.Flags["CustomSkyEnabled"] then
            applySkybox(value)
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function findImpactFolder()
    local current = ReplicatedStorage
    for _, folderName in ipairs({"Assets", "Sounds", "Impact"}) do
        current = current:FindFirstChild(folderName)
        if not current then return nil end
    end
    return current
end

local impactFolder = findImpactFolder()
if not impactFolder then
    
    return
end

local headshotSound = impactFolder:FindFirstChild("Headshot")
if not headshotSound then
    headshotSound = Instance.new("Sound")
    headshotSound.Name = "Headshot"
    headshotSound.Parent = impactFolder
end

local sounds = {
    ["Default"] = "rbxassetid://2062016772",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["CS:GO"] = "rbxassetid://6937353691",
    ["Among Us"] = "rbxassetid://5700183626",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["TF2 Critical"] = "rbxassetid://296102734",
    ["Mario"] = "rbxassetid://2815207981",
    ["Rust"] = "rbxassetid://1255040462",
    ["Call of Duty"] = "rbxassetid://5952120301",
    ["Steve"] = "rbxassetid://4965083997",
    ["Bamboo"] = "rbxassetid://3769434519",
    ["Minecraft"] = "rbxassetid://4018616850",
    ["TF2"] = "rbxassetid://2868331684"
}

CustomHitSound:Toggle({
    Name = "Head HitSound",
    Flag = "HeadshotHitsound_Enabled",
    Callback = function(enabled)
        if not enabled then
            headshotSound.SoundId = sounds["Default"]
        end
    end
})

CustomHitSound:Dropdown({
    Name = "Select HitSound",
    Flag = "HeadshotHitsound",
    Options = {
        "Default",
        "Gamesense",
        "CS:GO",
        "Among Us",
        "Neverlose",
        "TF2 Critical",
        "Mario",
        "Rust",
        "Call of Duty",
        "Steve",
        "Bamboo",
        "Minecraft",
        "TF2"
    },
    Default = "Default",
    Callback = function(value)
        if Library.Flags["HeadshotHitsound_Enabled"] and sounds[value] then
            headshotSound.SoundId = sounds[value]
            headshotSound.Volume = 3.0
            headshotSound:Play()
        end
    end
})

local function playHeadshotSound()
    if Library.Flags["HeadshotHitsound_Enabled"] then
        headshotSound:Play()
    end
end

local function setupHeadshotDetection()
    local function onCharacterAdded(character)
        local head = character:WaitForChild("Head")
        head.Touched:Connect(function(hitPart)
            playHeadshotSound()
        end)
    end

    local player = Players.LocalPlayer
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

task.spawn(setupHeadshotDetection)

local zombiesFolder = workspace:WaitForChild("Zombies")
_G.anti_zombie = true
local isFreezeEnabled = true

local function freezeZombie(zombie)
    local humanoid = zombie:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end

    for _, part in ipairs(zombie:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
        end
    end
end

AntiZombie:Toggle({
    Name = "Anti Zombie",
    Flag = "AntiZombieHitsound_Enabled",
    Callback = function(enabled)
        _G.anti_zombie = enabled
        if enabled then
            task.spawn(function()
                while _G.anti_zombie do
                    local mobs = workspace:FindFirstChild("Zombies") and workspace.Zombies:FindFirstChild("Mobs")
                    if mobs then
                        for _, obj in pairs(mobs:GetChildren()) do
                            local root = obj:FindFirstChild("HumanoidRootPart")
                            if root and isnetworkowner(root) then
                                root.Anchored = true
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

AntiZombie:Toggle({
    Name = "Freeze Zombie",
    Flag = "FreezeZombieHitsound_Enabled",
    Callback = function(enabled)
        isFreezeEnabled = enabled
        if not isFreezeEnabled then
            for _, zombie in pairs(zombiesFolder:GetChildren()) do
                if zombie:IsA("Model") then
                    local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = humanoid:GetAttribute("DefaultWalkSpeed") or 16
                        humanoid.JumpPower = humanoid:GetAttribute("DefaultJumpPower") or 50
                    end
                    for _, part in ipairs(zombie:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                        end
                    end
                end
            end
        end
    end
})

for _, zombie in pairs(zombiesFolder:GetChildren()) do
    if zombie:IsA("Model") and isFreezeEnabled then
        freezeZombie(zombie)
    end
end

Library:LoadConfigTab(Window)
