local Library = loadstring(game:HttpGet("https://pastebin.com/raw/4iG9SKxs"))()
local Window = Library:Window()

local games = {
    [863266079] = "Chdr3y.xyz/ar2",
}
getgenv().ConfigFolder = games[game.GameId] or "Chdr3y.xyz/universal"

local legit = Window:Page({ Name = "Visuals" })
local Test = legit:Section({ Name = "Humans" })
local worldSection = legit:Section({ Name = "world", Side = "Right" })
local SelfChamsSection = legit:Section({ Name = "Local Player", Side = "Right" })
local CorpseSection = legit:Section({ Name = "Corpse Esp", Side = "Left" })
local VehicleSection = legit:Section({ Name = "Vehicle Esp", Side = "Left" })

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local ESPConnections = {}


local function DrawESP(plr)
    repeat wait() until plr.Character and plr.Character:FindFirstChild("Humanoid")
    
    local limbs = {}
    local isR15 = (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)

    local function DrawLine()
        local line = Drawing.new("Line")
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(1, 1)
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Thickness = 1
        line.Transparency = 1
        return line
    end

    if isR15 then
        limbs = {
            Head_UpperTorso = DrawLine(),
            UpperTorso_LowerTorso = DrawLine(),
            UpperTorso_LeftUpperArm = DrawLine(),
            LeftUpperArm_LeftLowerArm = DrawLine(),
            LeftLowerArm_LeftHand = DrawLine(),
            UpperTorso_RightUpperArm = DrawLine(),
            RightUpperArm_RightLowerArm = DrawLine(),
            RightLowerArm_RightHand = DrawLine(),
            LowerTorso_LeftUpperLeg = DrawLine(),
            LeftUpperLeg_LeftLowerLeg = DrawLine(),
            LeftLowerLeg_LeftFoot = DrawLine(),
            LowerTorso_RightUpperLeg = DrawLine(),
            RightUpperLeg_RightLowerLeg = DrawLine(),
            RightLowerLeg_RightFoot = DrawLine(),
        }
    else
        limbs = {
            Head_Spine = DrawLine(),
            Spine = DrawLine(),
            LeftArm = DrawLine(),
            LeftArm_UpperTorso = DrawLine(),
            RightArm = DrawLine(),
            RightArm_UpperTorso = DrawLine(),
            LeftLeg = DrawLine(),
            LeftLeg_LowerTorso = DrawLine(),
            RightLeg = DrawLine(),
            RightLeg_LowerTorso = DrawLine()
        }
    end

    local function SetVisibility(state)
        for _, line in pairs(limbs) do
            line.Visible = state
        end
    end

    local function RemoveLines()
        for _, line in pairs(limbs) do
            line:Remove()
        end
    end

    local connection
    if isR15 then
        connection = RunService.RenderStepped:Connect(function()
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local H = Camera:WorldToViewportPoint(char.Head.Position)
                    local UT = Camera:WorldToViewportPoint(char.UpperTorso.Position)
                    local LT = Camera:WorldToViewportPoint(char.LowerTorso.Position)
                    local LUA = Camera:WorldToViewportPoint(char.LeftUpperArm.Position)
                    local LLA = Camera:WorldToViewportPoint(char.LeftLowerArm.Position)
                    local LH = Camera:WorldToViewportPoint(char.LeftHand.Position)
                    local RUA = Camera:WorldToViewportPoint(char.RightUpperArm.Position)
                    local RLA = Camera:WorldToViewportPoint(char.RightLowerArm.Position)
                    local RH = Camera:WorldToViewportPoint(char.RightHand.Position)
                    local LUL = Camera:WorldToViewportPoint(char.LeftUpperLeg.Position)
                    local LLL = Camera:WorldToViewportPoint(char.LeftLowerLeg.Position)
                    local LF = Camera:WorldToViewportPoint(char.LeftFoot.Position)
                    local RUL = Camera:WorldToViewportPoint(char.RightUpperLeg.Position)
                    local RLL = Camera:WorldToViewportPoint(char.RightLowerLeg.Position)
                    local RF = Camera:WorldToViewportPoint(char.RightFoot.Position)

                    limbs.Head_UpperTorso.From = Vector2.new(H.X, H.Y)
                    limbs.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)

                    limbs.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)

                    limbs.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                    limbs.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)

                    limbs.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                    limbs.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)

                    limbs.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                    limbs.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)

                    limbs.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)

                    limbs.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                    limbs.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)

                    if not limbs.Head_UpperTorso.Visible then
                        SetVisibility(true)
                    end
                else
                    if limbs.Head_UpperTorso.Visible then
                        SetVisibility(false)
                    end
                end
            else
                if limbs.Head_UpperTorso.Visible then
                    SetVisibility(false)
                end
                if not Players:FindFirstChild(plr.Name) then
                    RemoveLines()
                    connection:Disconnect()
                end
            end
        end)
    else
        connection = RunService.RenderStepped:Connect(function()
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local H = Camera:WorldToViewportPoint(char.Head.Position)
                    local torso = char.Torso or char.UpperTorso
                    local T_Height = torso.Size.Y/2 - 0.2
                    local UT = Camera:WorldToViewportPoint((torso.CFrame * CFrame.new(0, T_Height, 0)).p)
                    local LT = Camera:WorldToViewportPoint((torso.CFrame * CFrame.new(0, -T_Height, 0)).p)

                    local LA = char["Left Arm"]
                    local LA_Height = LA.Size.Y/2 - 0.2
                    local LUA = Camera:WorldToViewportPoint((LA.CFrame * CFrame.new(0, LA_Height, 0)).p)
                    local LLA = Camera:WorldToViewportPoint((LA.CFrame * CFrame.new(0, -LA_Height, 0)).p)

                    local RA = char["Right Arm"]
                    local RA_Height = RA.Size.Y/2 - 0.2
                    local RUA = Camera:WorldToViewportPoint((RA.CFrame * CFrame.new(0, RA_Height, 0)).p)
                    local RLA = Camera:WorldToViewportPoint((RA.CFrame * CFrame.new(0, -RA_Height, 0)).p)

                    local LL = char["Left Leg"]
                    local LL_Height = LL.Size.Y/2 - 0.2
                    local LUL = Camera:WorldToViewportPoint((LL.CFrame * CFrame.new(0, LL_Height, 0)).p)
                    local LLL = Camera:WorldToViewportPoint((LL.CFrame * CFrame.new(0, -LL_Height, 0)).p)

                    local RL = char["Right Leg"]
                    local RL_Height = RL.Size.Y/2 - 0.2
                    local RUL = Camera:WorldToViewportPoint((RL.CFrame * CFrame.new(0, RL_Height, 0)).p)
                    local RLL = Camera:WorldToViewportPoint((RL.CFrame * CFrame.new(0, -RL_Height, 0)).p)

                    limbs.Head_Spine.From = Vector2.new(H.X, H.Y)
                    limbs.Head_Spine.To = Vector2.new(UT.X, UT.Y)

                    limbs.Spine.From = Vector2.new(UT.X, UT.Y)
                    limbs.Spine.To = Vector2.new(LT.X, LT.Y)

                    limbs.LeftArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.LeftArm_UpperTorso.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.RightArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.RightArm_UpperTorso.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.LeftLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.LeftLeg_LowerTorso.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.RightLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.RightLeg_LowerTorso.To = Vector2.new(RUL.X, RUL.Y)

                    if not limbs.Head_Spine.Visible then
                        SetVisibility(true)
                    end
                else
                    if limbs.Head_Spine.Visible then
                        SetVisibility(false)
                    end
                end
            else
                if limbs.Head_Spine.Visible then
                    SetVisibility(false)
                end
                if not Players:FindFirstChild(plr.Name) then
                    RemoveLines()
                    connection:Disconnect()
                end
            end
        end)
    end

    
    return function()
        connection:Disconnect()
        RemoveLines()
    end
end

local skeletonColor = Color3.fromRGB(255, 255, 255)

Test:Toggle({
    Name = "Skeleton",
    Flag = "SkeletonToggle",
    Default = false,
    Callback = function(enabled)
        skeletonEnabled = enabled

        if enabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if not ESPConnections[player.Name] then
                        ESPConnections[player.Name] = DrawESP(player, skeletonColor)
                    end
                end
            end

            if not PlayerAddedConn then
                PlayerAddedConn = Players.PlayerAdded:Connect(function(newPlayer)
                    if newPlayer ~= LocalPlayer and skeletonEnabled then
                        if not ESPConnections[newPlayer.Name] then
                            ESPConnections[newPlayer.Name] = DrawESP(newPlayer, skeletonColor)
                        end
                    end
                end)
            end

            if not PlayerRemovingConn then
                PlayerRemovingConn = Players.PlayerRemoving:Connect(function(leavingPlayer)
                    if ESPConnections[leavingPlayer.Name] then
                        ESPConnections[leavingPlayer.Name]()
                        ESPConnections[leavingPlayer.Name] = nil
                    end
                end)
            end
        else
            for playerName, cleanupFunc in pairs(ESPConnections) do
                cleanupFunc()
                ESPConnections[playerName] = nil
            end

            if PlayerAddedConn then
                PlayerAddedConn:Disconnect()
                PlayerAddedConn = nil
            end

            if PlayerRemovingConn then
                PlayerRemovingConn:Disconnect()
                PlayerRemovingConn = nil
            end
        end
    end
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

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local workspaceCharacters = workspace:WaitForChild("Characters")
local localPlayer = Players.LocalPlayer

local isHeldItemESPEnabled = false

local function createOrUpdateESP(character, gunName)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local billboard = rootPart:FindFirstChild("GunESP")

        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "GunESP"
            billboard.Adornee = rootPart
            billboard.Size = UDim2.new(0, 120, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "Label"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextScaled = true
            textLabel.Parent = billboard

            billboard.Parent = rootPart
        end

        local label = billboard:FindFirstChild("Label")
        if label then
            label.Text = "Holding: " .. gunName
        end
    end
end

local function removeESP(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local esp = character.HumanoidRootPart:FindFirstChild("GunESP")
        if esp then
            esp:Destroy()
        end
    end
end

Test:Toggle({
    Name = "Held item",
    Flag = "HeldItemESP_Enabled",
    Callback = function(enabled)
        isHeldItemESPEnabled = enabled
        if not isHeldItemESPEnabled then
            for _, character in pairs(workspaceCharacters:GetChildren()) do
                removeESP(character)
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if not isHeldItemESPEnabled then return end

    for _, character in pairs(workspaceCharacters:GetChildren()) do
        if character.Name ~= localPlayer.Name then
            local equipped = character:FindFirstChild("Equipped")
            local holdingGun = false
            if equipped then
                for _, gun in pairs(equipped:GetChildren()) do
                    if gun:IsA("BasePart") or gun:IsA("Model") then
                        createOrUpdateESP(character, gun.Name)
                        holdingGun = true
                        break
                    end
                end
            end
            if not holdingGun then
                removeESP(character)
            end
        end
    end
end)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local highlights = {}
local HighlightsEnabled = false
local HighlightColor = Color3.fromRGB(255, 255, 0)

local function addHighlightToCharacter(character, player)
	if not HighlightsEnabled then return end
	if player == localPlayer then return end
	if highlights[player] then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerHighlight"
	highlight.FillColor = HighlightColor
	highlight.OutlineColor = HighlightColor
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Adornee = character
	highlight.Parent = character

	highlights[player] = highlight
end

local function removeHighlight(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

local function onCharacterAdded(character, player)
	if player == localPlayer then return end
	if character:IsDescendantOf(game) then
		addHighlightToCharacter(character, player)
	else
		character.AncestryChanged:Wait()
		addHighlightToCharacter(character, player)
	end
end

local function onPlayerAdded(player)
	if player == localPlayer then return end
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(character, player)
	end)
	if player.Character then
		onCharacterAdded(player.Character, player)
	end
end

local function onPlayerRemoving(player)
	removeHighlight(player)
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

Test:Toggle({
	Name = "Chams",
	Flag = "Highlight",
	Default = false,
	Callback = function(val)
		HighlightsEnabled = val
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				if val then
					if player.Character then
						addHighlightToCharacter(player.Character, player)
					end
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
		for _, highlight in pairs(highlights) do
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
local localPlayer = Players.LocalPlayer

local corpseESPEnabled = false
local showNames = false
local showDistance = false

local corpseHighlightColor = Color3.fromRGB(255, 0, 0)
local corpseNameColor = Color3.fromRGB(255, 255, 255)
local corpseDistanceColor = Color3.fromRGB(255, 255, 255)

local function isIgnoredCorpse(model)
    return model.Name:lower():find("infected") ~= nil
end

local function removeESP(model)
    local highlight = model:FindFirstChild("CorpseHighlight")
    if highlight then highlight:Destroy() end
    local espGui = model:FindFirstChild("CorpseESP")
    if espGui then espGui:Destroy() end
end

local function createHighlight(model)
    if isIgnoredCorpse(model) then return end
    if not model:FindFirstChild("CorpseHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "CorpseHighlight"
        highlight.FillColor = corpseHighlightColor
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = model
        highlight.Parent = model
    end
end

local function createBillboard(model)
    if isIgnoredCorpse(model) then return end
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end
    removeESP(model)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CorpseESP"
    billboard.Adornee = primary
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = model

    if showNames then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "CorpseName"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextSize = 16
        nameLabel.TextColor3 = corpseNameColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = model.Name
        nameLabel.Parent = billboard
    end

    if showDistance then
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "CorpseDistance"
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextSize = 16
        distanceLabel.TextColor3 = corpseDistanceColor
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.Text = "..."
        distanceLabel.Parent = billboard

        local RunService = game:GetService("RunService")
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not model or not model.Parent or not primary or not primary.Parent then
                if connection then connection:Disconnect() end
                return
            end
            local distance = (workspace.CurrentCamera.CFrame.Position - primary.Position).Magnitude
            local meters = math.floor(distance * 0.28)
            distanceLabel.Text = tostring(meters) .. "m"
        end)
    end
end

local function updateCorpseESP(enabled)
    for _, corpse in pairs(corpsesFolder:GetChildren()) do
        if corpse:IsA("Model") and not isIgnoredCorpse(corpse) then
            if enabled then
                createHighlight(corpse)
                if showNames or showDistance then
                    createBillboard(corpse)
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
                    createBillboard(newCorpse)
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
        updateCorpseESP(state)
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
        for _, corpse in pairs(corpsesFolder:GetChildren()) do
            local espGui = corpse:FindFirstChild("CorpseESP")
            if espGui then
                local label = espGui:FindFirstChild("CorpseName")
                if label then
                    label.TextColor3 = color
                end
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
        for _, corpse in pairs(corpsesFolder:GetChildren()) do
            local espGui = corpse:FindFirstChild("CorpseESP")
            if espGui then
                local label = espGui:FindFirstChild("CorpseDistance")
                if label then
                    label.TextColor3 = color
                end
            end
        end
    end
})

local vehiclesFolder = workspace:WaitForChild("Vehicles")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local vehicleESPEnabled = false
local vehicleShowNames = false
local vehicleShowDistance = false

local vehicleESPColor = Color3.fromRGB(0, 0, 255)
local vehicleNameColor = Color3.fromRGB(255, 255, 255)
local vehicleDistanceColor = Color3.fromRGB(255, 255, 255)

local espVehicles = {}

local function removeVehicleESP(model)
    local highlight = model:FindFirstChild("VehicleHighlight")
    if highlight then highlight:Destroy() end

    local billboard = model:FindFirstChild("VehicleESPBillboard")
    if billboard then billboard:Destroy() end

    espVehicles[model] = nil
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

    local oldBillboard = model:FindFirstChild("VehicleESPBillboard")
    if oldBillboard then
        oldBillboard:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VehicleESPBillboard"
    billboard.Adornee = primary
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = model

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.TextColor3 = vehicleNameColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = model.Name
    nameLabel.Visible = vehicleShowNames
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextSize = 15
    distanceLabel.TextColor3 = vehicleDistanceColor
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.Text = ""
    distanceLabel.Visible = vehicleShowDistance
    distanceLabel.Parent = billboard

    espVehicles[model] = {
        model = model,
        billboard = billboard,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        primaryPart = primary,
    }
end

local function updateVehicleESP(enabled)
    if not enabled then
        for vehicle, _ in pairs(espVehicles) do
            removeVehicleESP(vehicle)
        end
        espVehicles = {}
        return
    end

    for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
        if vehicle:IsA("Model") then
            createVehicleHighlight(vehicle)
            if vehicleShowNames or vehicleShowDistance then
                createVehicleNameDistance(vehicle)
            else
                removeVehicleESP(vehicle)
            end
        end
    end
end

local renderConnection

local function onRenderStep()
    for _, data in pairs(espVehicles) do
        local model = data.model
        local billboard = data.billboard
        local nameLabel = data.nameLabel
        local distanceLabel = data.distanceLabel
        local primary = data.primaryPart

        if not model or not model.Parent or not primary or not primary.Parent then
            removeVehicleESP(model)
        else
            local distanceStuds = (camera.CFrame.Position - primary.Position).Magnitude
            local distanceMeters = math.floor(distanceStuds * 0.28 + 0.5)

            nameLabel.Visible = vehicleShowNames
            distanceLabel.Visible = vehicleShowDistance

            if vehicleShowNames then
                nameLabel.TextColor3 = vehicleNameColor
            end
            if vehicleShowDistance then
                distanceLabel.Text = tostring(distanceMeters) .. " m"
                distanceLabel.TextColor3 = vehicleDistanceColor
            end
        end
    end
end

local function toggleRenderConnection(state)
    if state then
        if not renderConnection then
            renderConnection = RunService.RenderStepped:Connect(onRenderStep)
        end
    else
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
    end
end

VehicleSection:Toggle({
    Name = "Vehicle Esp",
    Flag = "VehicleESP",
    Callback = function(state)
        vehicleESPEnabled = state
        updateVehicleESP(state)
        toggleRenderConnection(state)
    end
}):Colorpicker({
    Default = vehicleESPColor,
    Flag = "VehicleESPColor",
    Callback = function(color)
        vehicleESPColor = color
        for vehicle, _ in pairs(espVehicles) do
            local highlight = vehicle:FindFirstChild("VehicleHighlight")
            if highlight then
                highlight.FillColor = color
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
        for _, data in pairs(espVehicles) do
            local nameLabel = data.nameLabel
            if nameLabel then
                nameLabel.TextColor3 = color
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
        for _, data in pairs(espVehicles) do
            local distanceLabel = data.distanceLabel
            if distanceLabel then
                distanceLabel.TextColor3 = color
            end
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Firearm = nil
task.spawn(function()
    setthreadidentity(2)
    Firearm = require(ReplicatedStorage.Client.Abstracts.ItemInitializers.Firearm)
end)

repeat task.wait() until Firearm

local Framework = require(ReplicatedFirst:WaitForChild("Framework"))
Framework:WaitForLoaded()

local Animators = Framework.Classes.Animators
local Firearms = Framework.Classes.Firearm

local AnimatedReload = getupvalue(Firearm, 7)

setupvalue(Firearm, 7, function(...)
    if Window.Flags["AR2/InstantReload"] then
        local Args = {...}
        for Index = 0, Args[3].LoopCount do
            Args[4]("Commit", "Load")
        end
        Args[4]("Commit", "End")
        return true
    end

    return AnimatedReload(...)
end)

gunMods:Toggle({
    Name = "Instant Reload",
    Flag = "AR2/InstantReload",
    Callback = function(state)
    end
})

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
    Name = "Infinite Jump (Dont Spam it)",
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
    Name = "WalkSpeed (Risk)",
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
        humanoid:SetAttribute("DefaultWalkSpeed", humanoid.WalkSpeed)
        humanoid:SetAttribute("DefaultJumpPower", humanoid.JumpPower)
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end

    for _, part in ipairs(zombie:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
        end
    end
end

local function unfreezeZombie(zombie)
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

AntiZombie:Toggle({
    Name = "Freeze Zombie",
    Flag = "FreezeZombieHitsound_Enabled",
    Callback = function(enabled)
        isFreezeEnabled = enabled
        for _, zombie in pairs(zombiesFolder:GetChildren()) do
            if zombie:IsA("Model") then
                if isFreezeEnabled then
                    freezeZombie(zombie)
                else
                    unfreezeZombie(zombie)
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


zombiesFolder.ChildAdded:Connect(function(zombie)
    if zombie:IsA("Model") and isFreezeEnabled then
        zombie:WaitForChild("Humanoid")
        freezeZombie(zombie)
    end
end)

local player = game.Players.LocalPlayer
local zombiesFolder = workspace:WaitForChild("Zombies")

local Settings = {
    CircleRadius = 20,
    CircleSpeed = 5
}

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local zombies = {}
local updateConnection

local function updateZombiesList()
    zombies = {}
    for _, zombie in pairs(zombiesFolder:GetChildren()) do
        if zombie:IsA("Model") and zombie.PrimaryPart then
            table.insert(zombies, zombie)
        end
    end
end

local function startZombieCircle()
    updateZombiesList()

    zombiesFolder.ChildAdded:Connect(updateZombiesList)
    zombiesFolder.ChildRemoved:Connect(updateZombiesList)

    local accumulatedTime = 0
    local updateInterval = 0.1
    local nearbyZombies = {}
    local angle = 0

    local tweenInfo = TweenInfo.new(
        updateInterval,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        0,
        false,
        0
    )

    updateConnection = RunService.Heartbeat:Connect(function(dt)
        accumulatedTime = accumulatedTime + dt
        if accumulatedTime < updateInterval then return end
        accumulatedTime = 0

        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        local playerPos = player.Character.HumanoidRootPart.Position

        nearbyZombies = {}
        for _, zombie in pairs(zombies) do
            if zombie.PrimaryPart then
                local dist = (zombie.PrimaryPart.Position - playerPos).Magnitude
                if dist <= 30 then
                    table.insert(nearbyZombies, zombie)
                end
            end
        end

        angle = angle + Settings.CircleSpeed * updateInterval
        local count = #nearbyZombies
        if count == 0 then return end

        for i, zombie in ipairs(nearbyZombies) do
            local theta = angle + (2 * math.pi * (i - 1) / count)
            local x = playerPos.X + Settings.CircleRadius * math.cos(theta)
            local z = playerPos.Z + Settings.CircleRadius * math.sin(theta)
            local y = zombie.PrimaryPart.Position.Y
            local targetCFrame = CFrame.new(Vector3.new(x, y, z), playerPos)
            local goal = {CFrame = targetCFrame}
            TweenService:Create(zombie.PrimaryPart, tweenInfo, goal):Play()
        end
    end)
end

local function stopZombieCircle()
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
end

AntiZombie:Toggle({
    Name = "Zombie Circle(enable it)",
    Flag = "ZombieCircle",
    Default = false,
    Callback = function(val)
        if val then
            startZombieCircle()
        else
            stopZombieCircle()
        end
    end
})

AntiZombie:Slider({
    Name = "Circle Radius",
    Flag = "ZombieCircleRadius",
    Min = 10,
    Max = 100,
    Default = Settings.CircleRadius,
    Rounding = 0,
    Callback = function(value)
        Settings.CircleRadius = value
    end
})

AntiZombie:Slider({
    Name = "Circle Speed",
    Flag = "ZombieCircleSpeed",
    Min = 1,
    Max = 20,
    Default = Settings.CircleSpeed,
    Rounding = 1,
    Callback = function(value)
        Settings.CircleSpeed = value
    end
})

Library:LoadConfigTab(Window)
