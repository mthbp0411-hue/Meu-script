--// PS99 Championship Hub
--// Luau / Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
    Speed = 16,
    JumpPower = 50
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

local farmButton = Button("Auto Farm: OFF",60)
local collectButton = Button("Auto Collect: OFF",110)
local speedButton = Button("Speed: OFF",160)
local jumpButton = Button("JumpPower: OFF",210)

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

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,180,0,40)
closeButton.Position = UDim2.new(0,215,0,160)
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
-- CHARACTER
--==================================================

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

--==================================================
-- AUTO FARM BASE
--==================================================

local function findNearestObject()
    local char = getCharacter()
    local root = char:FindFirstChild("HumanoidRootPart")

    if not root then
        return nil
    end

    local nearest
    local distance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()

            if name:find("break")
            or name:find("coin")
            or name:find("chest")
            or name:find("present") then

                local d = (obj.Position - root.Position).Magnitude

                if d < distance then
                    distance = d
                    nearest = obj
                end
            end
        end
    end

    return nearest
end

local function farm()
    local target = findNearestObject()

    if target then
        local char = getCharacter()
        local root = char:FindFirstChild("HumanoidRootPart")

        if root then
            root.CFrame =
                target.CFrame *
                CFrame.new(0,0,5)
        end
    end
end

--==================================================
-- BUTTONS
--==================================================

farmButton.MouseButton1Click:Connect(function()
    Config.AutoFarm = not Config.AutoFarm

    farmButton.Text =
        Config.AutoFarm
        and "Auto Farm: ON"
        or "Auto Farm: OFF"
end)

collectButton.MouseButton1Click:Connect(function()
    Config.AutoCollect = not Config.AutoCollect

    collectButton.Text =
        Config.AutoCollect
        and "Auto Collect: ON"
        or "Auto Collect: OFF"
end)

speedButton.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()

    if humanoid then
        if humanoid.WalkSpeed == 16 then
            humanoid.WalkSpeed = 50
            speedButton.Text = "Speed: ON"
        else
            humanoid.WalkSpeed = 16
            speedButton.Text = "Speed: OFF"
        end
    end
end)

jumpButton.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()

    if humanoid then
        if humanoid.JumpPower == 50 then
            humanoid.JumpPower = 100
            jumpButton.Text = "JumpPower: ON"
        else
            humanoid.JumpPower = 50
            jumpButton.Text = "JumpPower: OFF"
        end
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    local char = getCharacter()
    local root = char:FindFirstChild("HumanoidRootPart")

    if root and workspace:FindFirstChild("SpawnLocation") then
        root.CFrame =
            workspace.SpawnLocation.CFrame *
            CFrame.new(0,5,0)
    end
end)

rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--==================================================
-- AUTO FARM LOOP
--==================================================

task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoFarm then
            pcall(farm)
        end
    end
end)

--==================================================
-- ANTI AFK
--==================================================

player.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

print("PS99 Championship Hub carregado!")
