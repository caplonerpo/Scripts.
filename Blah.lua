local player = game.Players.LocalPlayer
if player.Name ~= "CapLonerPo" then return end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local openHolder = Instance.new("Frame")
openHolder.Size = UDim2.new(0, 60, 0, 60)
openHolder.Position = UDim2.new(0, 20, 1, -80)
openHolder.BackgroundColor3 = Color3.fromRGB(20,20,20)
openHolder.BorderSizePixel = 0
openHolder.Parent = gui
openHolder.Active = true

local openCorner = Instance.new("UICorner", openHolder)
openCorner.CornerRadius = UDim.new(0, 12)

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(1,0,1,0)
openButton.BackgroundTransparency = 1
openButton.Text = "🗂"
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.Parent = openHolder

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 420)
main.Position = UDim2.new(0.5, -175, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
main.Active = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Scanner"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -50, 0, 10)
close.BackgroundTransparency = 1
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Parent = main

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -40, 0, 40)
box.Position = UDim2.new(0, 20, 0, 60)
box.BackgroundColor3 = Color3.fromRGB(25,25,25)
box.BorderSizePixel = 0
box.Font = Enum.Font.GothamBold
box.Text = ""
box.PlaceholderText = "Search..."
box.TextColor3 = Color3.new(1,1,1)
box.PlaceholderColor3 = Color3.fromRGB(150,150,150)
box.TextScaled = true
box.Parent = main
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

local scan = Instance.new("TextButton")
scan.Size = UDim2.new(1, -40, 0, 45)
scan.Position = UDim2.new(0, 20, 0, 110)
scan.BackgroundColor3 = Color3.fromRGB(30,30,30)
scan.Font = Enum.Font.GothamBold
scan.TextScaled = true
scan.TextColor3 = Color3.new(1,1,1)
scan.Text = "Scan"
scan.BorderSizePixel = 0
scan.Parent = main
Instance.new("UICorner", scan).CornerRadius = UDim.new(0,10)

local results = Instance.new("ScrollingFrame")
results.Size = UDim2.new(1, -40, 1, -170)
results.Position = UDim2.new(0, 20, 0, 160)
results.CanvasSize = UDim2.new(0,0,0,0)
results.ScrollBarThickness = 6
results.BackgroundColor3 = Color3.fromRGB(20,20,20)
results.BorderSizePixel = 0
results.Parent = main
Instance.new("UICorner", results).CornerRadius = UDim.new(0,10)

local layout = Instance.new("UIListLayout", results)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function scanForWord(word)
    results:ClearAllChildren()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj.Name:lower():find(word:lower()) then
            local item = Instance.new("TextLabel")
            item.Size = UDim2.new(1, -10, 0, 30)
            item.BackgroundColor3 = Color3.fromRGB(30,30,30)
            item.Font = Enum.Font.GothamBold
            item.TextScaled = true
            item.TextColor3 = Color3.new(1,1,1)
            item.Text = obj:GetFullName()
            item.Parent = results
            local c = Instance.new("UICorner", item)
            c.CornerRadius = UDim.new(0,8)
        end
    end
    results.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

local dragging = false
local dragStart, startPos

local function enableDrag(frame)
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

enableDrag(main)
enableDrag(openHolder)

openButton.MouseButton1Click:Connect(function()
    main.Visible = true
    main.Position = UDim2.new(0.5, -175, 0.5, -200)
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

scan.MouseButton1Click:Connect(function()
    if box.Text ~= "" then
        scanForWord(box.Text)
    end
end)

task.spawn(function()
    while task.wait() do
        local cam = workspace.CurrentCamera
        if not cam then continue end
        local vs = cam.ViewportSize

        if main.Visible then
            local s = main.AbsoluteSize
            local p = main.Position
            local x = math.clamp(p.X.Offset, 0, vs.X - s.X)
            local y = math.clamp(p.Y.Offset, 0, vs.Y - s.Y)
            main.Position = UDim2.new(0, x, 0, y)
        end

        local s = openHolder.AbsoluteSize
        local p = openHolder.Position
        local x = math.clamp(p.X.Offset, 0, vs.X - s.X)
        local y = math.clamp(p.Y.Offset, 0, vs.Y - s.Y)
        openHolder.Position = UDim2.new(0, x, 0, y)
    end
end)
