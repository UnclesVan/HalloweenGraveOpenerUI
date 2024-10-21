local Fsys = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

-- DEHASH REMOTES
local function rename(remotename, hashedremote)
    hashedremote.Name = remotename
end
table.foreach(getupvalue(Fsys("RouterClient").init, 4), rename)

-- Create GUI Elements
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
local titleLabel = Instance.new("TextLabel", frame)
local toggleCheckbox = Instance.new("TextButton", frame)
local startButton = Instance.new("TextButton", frame)
local closeButton = Instance.new("TextButton", frame)
local collectedLabel = Instance.new("TextLabel", frame)

-- GUI Properties
frame.Size = UDim2.new(0.4, 0, 0.4, 0)
frame.Position = UDim2.new(0.5, -200, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.5
frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Title Label Properties
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Text = "Gravestone Pusher"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 36

-- Toggle Checkbox Properties
toggleCheckbox.Size = UDim2.new(0.3, 0, 0.1, 0)
toggleCheckbox.Position = UDim2.new(0.5, -75, 0.3, 0)
toggleCheckbox.Text = "Push Gravestones: Off"
toggleCheckbox.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleCheckbox.TextColor3 = Color3.new(1, 1, 1)
toggleCheckbox.BorderSizePixel = 0
local isActive = false

-- Collected Label Properties
collectedLabel.Size = UDim2.new(1, 0, 0.1, 0)
collectedLabel.Position = UDim2.new(0, 0, 0.4, 0)
collectedLabel.Text = "Gravestones Collected: 0"
collectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
collectedLabel.BackgroundTransparency = 1
collectedLabel.Font = Enum.Font.SourceSansBold
collectedLabel.TextSize = 24

-- Start Button Properties
startButton.Size = UDim2.new(0.3, 0, 0.1, 0)
startButton.Position = UDim2.new(0.5, -75, 0.5, 0)
startButton.Text = "Start Pushing"
startButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BorderSizePixel = 0

-- Close Button Properties
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 10)
closeButton.Text = "✖"
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BorderSizePixel = 0
closeButton.AnchorPoint = Vector2.new(0.5, 0)

-- Toggle Checkbox Functionality
toggleCheckbox.MouseButton1Click:Connect(function()
    isActive = not isActive
    toggleCheckbox.Text = isActive and "Push Gravestones: On" or "Push Gravestones: Off"
    toggleCheckbox.BackgroundColor3 = isActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Start Button Functionality
startButton.MouseButton1Click:Connect(function()
    if isActive then
        local collectedCount = 0  -- Initialize count
        collectedLabel.Text = "Gravestones Collected: " .. collectedCount  -- Update label initially

        while isActive do  -- Keep running as long as isActive is true
            for i = 1, 18 do
                local args = { [1] = i }
                local success, result = pcall(function()
                    return game:GetService("ReplicatedStorage").API:FindFirstChild("HalloweenAPI/PushGravestone"):InvokeServer(unpack(args))
                end)

                if success then
                    if result then
                        collectedCount = collectedCount + 1
                        collectedLabel.Text = "Gravestones Collected: " .. collectedCount
                    else
                        print("Push gravestone returned false for args: " .. tostring(args))
                    end
                else
                    print("Error invoking gravestone push: " .. tostring(result))
                    break  -- Exit the loop on persistent errors
                end
                
                wait(2) -- Increase wait time to reduce the likelihood of errors
            end
            
            -- Reset the count after pushing 18 gravestones
            collectedCount = 0
            collectedLabel.Text = "Gravestones Collected: " .. collectedCount
        end
    end
end)

-- Connect close button to remove the GUI
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Ensure the GUI is visible when the script runs
gui.Enabled = true
