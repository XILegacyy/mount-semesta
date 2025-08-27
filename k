local summitLocation = CFrame.new(4523, 3419, 668)
local resetSummitLocation = CFrame.new(2748, 1850, 1671)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local isLooping = false 
local terminateScript = false 
local isSpeedBoosted = false
local originalWalkSpeed = 16 

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoSummitGUI"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.BorderSizePixel = 2
mainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
mainFrame.Size = UDim2.new(0, 200, 0, 150) 
mainFrame.Active = true
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Auto Summit"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = mainFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
toggleButton.BorderColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.Position = UDim2.new(0.1, 0, 0.2, 0) 
toggleButton.Size = UDim2.new(0.8, 0, 0, 25)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Start Loop"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16

local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = mainFrame
speedButton.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
speedButton.BorderColor3 = Color3.fromRGB(20, 20, 20)
speedButton.Position = UDim2.new(0.1, 0, 0.4, 0) 
speedButton.Size = UDim2.new(0.8, 0, 0, 25)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.Text = "Speed Boost"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 16

local terminateButton = Instance.new("TextButton")
terminateButton.Name = "TerminateButton"
terminateButton.Parent = mainFrame
terminateButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
terminateButton.BorderColor3 = Color3.fromRGB(20, 20, 20)
terminateButton.Position = UDim2.new(0.1, 0, 0.6, 0) 
terminateButton.Size = UDim2.new(0.8, 0, 0, 25)
terminateButton.Font = Enum.Font.SourceSansBold
terminateButton.Text = "Terminate Script"
terminateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
terminateButton.TextSize = 16

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Name = "Watermark"
watermarkLabel.Parent = mainFrame
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Position = UDim2.new(0, 0, 0.85, 0)
watermarkLabel.Size = UDim2.new(1, 0, 0, 20)
watermarkLabel.Font = Enum.Font.SourceSans
watermarkLabel.Text = "Made by XILegacyy"
watermarkLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
watermarkLabel.TextSize = 12

local function toggleSpeedBoost()
    isSpeedBoosted = not isSpeedBoosted
    local character = localPlayer.Character
    if not (character and character:FindFirstChild("Humanoid")) then return end

    if isSpeedBoosted then
        originalWalkSpeed = character.Humanoid.WalkSpeed
        character.Humanoid.WalkSpeed = 30
        speedButton.Text = "Speed Off"
        speedButton.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
    else
        character.Humanoid.WalkSpeed = originalWalkSpeed
        speedButton.Text = "Speed Boost"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
    end
end

local function teleportTo(location)
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = location
    else
        warn("Character or HumanoidRootPart not found. Cannot teleport.")
    end
end

local function continuousWalkLoop()
    while isLooping and not terminateScript do
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:Move(character.HumanoidRootPart.CFrame.LookVector, false)
        end
        wait()
    end
end

local function spamJumpLoop()
    while isLooping and not terminateScript do
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Jump = true
        end
        wait(0.1)
    end
end

local function startSummitLoop()
    print("Auto Summit: Teleport loop started.")
    while isLooping and not terminateScript do
        teleportTo(summitLocation)
        wait(0.6)

        if not (isLooping and not terminateScript) then break end

        teleportTo(resetSummitLocation)
        wait(0.6)
    end
    print("Auto Summit: Teleport loop stopped.")
end

function toggleLoop()
    isLooping = not isLooping
    if isLooping then
        toggleButton.Text = "Stop Loop"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
        
        coroutine.wrap(startSummitLoop)()
        coroutine.wrap(continuousWalkLoop)()
        coroutine.wrap(spamJumpLoop)()
    else
        toggleButton.Text = "Start Loop"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:Move(Vector3.new(0, 0, 0), false)
        end
        
        teleportTo(resetSummitLocation)
    end
end

function terminate()
    print("Terminating Auto Summit script...")
    isLooping = false
    terminateScript = true

    if isSpeedBoosted then 
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = originalWalkSpeed
        end
    end

    local character = localPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid:Move(Vector3.new(0, 0, 0), false)
    end
    
    teleportTo(resetSummitLocation) 
    
    screenGui:Destroy()
end

toggleButton.MouseButton1Click:Connect(toggleLoop)
speedButton.MouseButton1Click:Connect(toggleSpeedBoost)
terminateButton.MouseButton1Click:Connect(terminate)

print("MADE BY XILEGACYY")
