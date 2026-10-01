--// PS99 Championship Hub
--// Luau / Roblox

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local Config = {
    AutoFarm = false,
    AutoCollect = false,
    AntiAFK = true,

    SpeedEnabled = false,
    Speed = 50,

    JumpEnabled = false,
    JumpPower = 100
}

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "PS99ChampionshipHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.5, -210, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "🐾 PS99 CHAMPIONSHIP HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = main

--==================================================
-- BOTÃO PADRÃO
--==================================================

local function Button(text, y)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(0,180,0,40)
    button.Position = UDim2.new(0,15,0,y)

    button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    button.TextColor3 = Color3.new(1,1,1)

    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Text = text

    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = button

    return button
end

--==================================================
-- BOTÕES
--==================================================

local farmButton = Button("Auto Farm: OFF",60)
local collectButton = Button("Auto Collect: OFF",110)
local speedButton = Button("Speed: OFF",160)
local jumpButton = Button("JumpPower: OFF",210)

--==================================================
-- TELEPORT
--==================================================

local teleportButton = Instance.new("TextButton")

teleportButton.Size = UDim2.new(0,180,0,40)
teleportButton.Position = UDim2.new(0,215,0,60)

teleportButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
teleportButton.TextColor3 = Color3.new(1,1,1)

teleportButton.TextSize = 14
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Text = "Teleport Spawn"

teleportButton.Parent = main

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0,8)
tc.Parent = teleportButton

--==================================================
-- REJOIN
--==================================================

local rejoinButton = Instance.new("TextButton")

rejoinButton.Size = UDim2.new(0,180,0,40)
rejoinButton.Position = UDim2.new(0,215,0,110)

rejoinButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
rejoinButton.TextColor3 = Color3.new(1,1,1)

rejoinButton.TextSize = 14
rejoinButton.Font = Enum.Font.GothamBold
rejoinButton.Text = "Rejoin Server"

rejoinButton.Parent = main

local rc = Instance.new("UICorner")
rc.CornerRadius = UDim.new(0,8)
rc.Parent = rejoinButton

--==================================================
-- MINIMIZAR
--==================================================

local minimizeButton = Instance.new("TextButton")

minimizeButton.Size = UDim2.new(0,180,0,40)
minimizeButton.Position = UDim2.new(0,215,0,160)

minimizeButton.BackgroundColor3 = Color3.fromRGB(55,55,55)
minimizeButton.TextColor3 = Color3.new(1,1,1)

minimizeButton.TextSize = 14
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "Minimizar"

minimizeButton.Parent = main

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0,8)
mc.Parent = minimizeButton

--==================================================
-- FECHAR
--==================================================

local closeButton = Instance.new("TextButton")

closeButton.Size = UDim2.new(0,180,0,40)
closeButton.Position = UDim2.new(0,215,0,210)

closeButton.BackgroundColor3 = Color3.fromRGB(130,40,40)
closeButton.TextColor3 = Color3.new(1,1,1)

closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "Fechar Hub"

closeButton.Parent = main

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0,8)
cc.Parent = closeButton

--==================================================
-- RESTAURAR
--==================================================

local restoreButton = Instance.new("TextButton")

restoreButton.Size = UDim2.new(0,55,0,55)
restoreButton.Position = UDim2.new(0,15,0.5,-27)

restoreButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
restoreButton.TextColor3 = Color3.new(1,1,1)

restoreButton.TextSize = 25
restoreButton.Font = Enum.Font.GothamBold
restoreButton.Text = "🐾"

restoreButton.Visible = false
restoreButton.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(1,0)
restoreCorner.Parent = restoreButton

--==================================================
-- CHARACTER
--==================================================

local function getCharacter()

    return player.Character or player.CharacterAdded:Wait()

end

local function getHumanoid()

    local char = getCharacter()

    return char:FindFirstChildOfClass("Humanoid")

end

local function getRoot()

    local char = getCharacter()

    return char:FindFirstChild("HumanoidRootPart")

end

--==================================================
-- FARM
--==================================================

local farmCenter = nil

local FARM_RADIUS = 180

-- Guarda a posição onde o Farm foi ativado.
-- O Farm trabalha somente nessa área.

local function setFarmArea()

    local root = getRoot()

    if root then
        farmCenter = root.Position
    end

end

--==================================================
-- ENCONTRAR ALVOS DA ÁREA
--==================================================

local function getTargets()

    if not Config.AutoFarm then
        return {}
    end

    local root = getRoot()

    if not root or not farmCenter then
        return {}
    end

    local targets = {}

    for _, obj in ipairs(workspace:GetDescendants()) do

        if not Config.AutoFarm then
            return {}
        end

        if obj:IsA("BasePart") then

            local name = obj.Name:lower()

            local validName =
                name:find("break")
                or name:find("coin")
                or name:find("chest")
                or name:find("present")

            if validName then

                local areaDistance =
                    (obj.Position - farmCenter).Magnitude

                if areaDistance <= FARM_RADIUS then

                    local playerDistance =
                        (obj.Position - root.Position).Magnitude

                    table.insert(targets, {

                        Object = obj,

                        Distance = playerDistance

                    })

                end

            end

        end

    end

    table.sort(targets, function(a,b)

        return a.Distance < b.Distance

    end)

    return targets

end

--==================================================
-- FARM
--==================================================

local function farm()

    if not Config.AutoFarm then
        return
    end

    if not farmCenter then
        setFarmArea()
    end

    local targets = getTargets()

    for _, data in ipairs(targets) do

        if not Config.AutoFarm then
            return
        end

        local target = data.Object

        if target and target.Parent then

            local root = getRoot()

            if root then

                root.CFrame =
                    target.CFrame *
                    CFrame.new(0,0,5)

                task.wait(0.08)

            end

        end

    end

end

--==================================================
-- AUTO FARM BUTTON
--==================================================

farmButton.MouseButton1Click:Connect(function()

    Config.AutoFarm = not Config.AutoFarm

    if Config.AutoFarm then

        -- Define a área atual como a área do Farm
        setFarmArea()

        farmButton.Text = "Auto Farm: ON"

    else

        -- Libera a área salva
        farmCenter = nil

        farmButton.Text = "Auto Farm: OFF"

    end

end)

--==================================================
-- AUTO COLLECT
--==================================================

collectButton.MouseButton1Click:Connect(function()

    Config.AutoCollect = not Config.AutoCollect

    collectButton.Text =
        Config.AutoCollect
        and "Auto Collect: ON"
        or "Auto Collect: OFF"

end)

--==================================================
-- SPEED
--==================================================

speedButton.MouseButton1Click:Connect(function()

    Config.SpeedEnabled =
        not Config.SpeedEnabled

    local humanoid = getHumanoid()

    if humanoid then

        if Config.SpeedEnabled then

            humanoid.WalkSpeed =
                Config.Speed

            speedButton.Text =
                "Speed: ON"

        else

            humanoid.WalkSpeed =
                16

            speedButton.Text =
                "Speed: OFF"

        end

    end

end)

--==================================================
-- JUMP POWER
--==================================================

jumpButton.MouseButton1Click:Connect(function()

    Config.JumpEnabled =
        not Config.JumpEnabled

    local humanoid = getHumanoid()

    if humanoid then

        if Config.JumpEnabled then

            humanoid.JumpPower =
                Config.JumpPower

            jumpButton.Text =
                "JumpPower: ON"

        else

            humanoid.JumpPower =
                50

            jumpButton.Text =
                "JumpPower: OFF"

        end

    end

end)

--==================================================
-- TELEPORT SPAWN
--==================================================

teleportButton.MouseButton1Click:Connect(function()

    local root = getRoot()

    local spawn =
        workspace:FindFirstChild("SpawnLocation")

    if root and spawn then

        root.CFrame =
            spawn.CFrame *
            CFrame.new(0,5,0)

    end

end)

--==================================================
-- REJOIN
--==================================================

rejoinButton.MouseButton1Click:Connect(function()

    TeleportService:Teleport(
        game.PlaceId,
        player
    )

end)

--==================================================
-- MINIMIZAR
--==================================================

minimizeButton.MouseButton1Click:Connect(function()

    main.Visible = false

    restoreButton.Visible = true

end)

restoreButton.MouseButton1Click:Connect(function()

    main.Visible = true

    restoreButton.Visible = false

end)

--==================================================
-- FECHAR
--==================================================

closeButton.MouseButton1Click:Connect(function()

    Config.AutoFarm = false
    Config.AutoCollect = false

    farmCenter = nil

    gui:Destroy()

end)

--==================================================
-- FARM LOOP
--==================================================

task.spawn(function()

    while gui.Parent do

        if Config.AutoFarm then

            pcall(function()
                farm()
            end)

        end

        task.wait(0.15)

    end

end)

--==================================================
-- ANTI AFK
--==================================================

player.Idled:Connect(function()

    if Config.AntiAFK then

        VirtualUser:CaptureController()

        VirtualUser:ClickButton2(
            Vector2.new()
        )

    end

end)

--==================================================
-- RESPAWN
--==================================================

player.CharacterAdded:Connect(function(character)

    local humanoid =
        character:WaitForChild("Humanoid")

    task.wait(0.5)

    if Config.SpeedEnabled then

        humanoid.WalkSpeed =
            Config.Speed

    end

    if Config.JumpEnabled then

        humanoid.JumpPower =
            Config.JumpPower

    end

end)

print("PS99 Championship Hub carregado!")
