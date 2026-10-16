"local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local pg = LP:WaitForChild("PlayerGui")

local function parentGui(gui)
	local function tryParent(target)
		pcall(function() gui.Parent = target end)
		return gui.Parent ~= nil
	end
	if tryParent(pg) then return true end
	pcall(function()
		if typeof(gethui) == "function" then
			local h = gethui()
			if h and tryParent(h) then return true end
		end
	end)
	if tryParent(game:GetService("CoreGui")) then return true end
	return false
end

local store = {}

store["KrixHubGUI"] = Instance.new("ScreenGui")
store.KrixHubGUI.Name = "KrixHubGUI"
store.KrixHubGUI.ResetOnSpawn = false
store.KrixHubGUI.DisplayOrder = 1000000
store.KrixHubGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
store.KrixHubGUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

store["Outer"] = Instance.new("Frame")
store.Outer.Name = "Outer"
store.Outer.Active = true
store.Outer.Position = UDim2.new(0,7,0,-53)
store.Outer.Size = UDim2.new(0,330,0,470)
store.Outer.BackgroundTransparency = 1
store.Outer.BorderSizePixel = 0
store.Outer.Parent = store.KrixHubGUI

store["Inner"] = Instance.new("Frame")
store.Inner.Name = "Inner"
store.Inner.ClipsDescendants = true
store.Inner.AnchorPoint = Vector2.new(0.5,0.5)
store.Inner.Position = UDim2.new(0.5,0,0.5,0)
store.Inner.Size = UDim2.new(1,0,1,0)
store.Inner.BackgroundColor3 = Color3.fromRGB(8,8,8)
store.Inner.BackgroundTransparency = 1
store.Inner.BorderSizePixel = 0
store.Inner.Parent = store.Outer

store["UICorner"] = Instance.new("UICorner")
store.UICorner.Name = "UICorner"
store.UICorner.CornerRadius = UDim.new(0,24)
store.UICorner.Parent = store.Inner

store["PanelPop"] = Instance.new("UIScale")
store.PanelPop.Name = "PanelPop"
store.PanelPop.Parent = store.Inner

store["BgGradient"] = Instance.new("Frame")
store.BgGradient.Name = "BgGradient"
store.BgGradient.ZIndex = 0
store.BgGradient.Size = UDim2.new(1,0,1,0)
store.BgGradient.BackgroundColor3 = Color3.fromRGB(15,10,18)
store.BgGradient.BorderSizePixel = 0
store.BgGradient.Parent = store.Inner

store["UICorner2"] = Instance.new("UICorner")
store.UICorner2.Name = "UICorner"
store.UICorner2.CornerRadius = UDim.new(0,24)
store.UICorner2.Parent = store.BgGradient

store["UIGradient"] = Instance.new("UIGradient")
store.UIGradient.Name = "UIGradient"
store.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(26,26,26)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(12,12,12)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,22,22))})
store.UIGradient.Rotation = 135
store.UIGradient.Parent = store.BgGradient

store["BackgroundImage"] = Instance.new("ImageLabel")
store.BackgroundImage.Name = "BackgroundImage"
store.BackgroundImage.Visible = true
store.BackgroundImage.ZIndex = 2
store.BackgroundImage.Size = UDim2.new(1,0,1,0)
store.BackgroundImage.BackgroundColor3 = Color3.fromRGB(15,10,18)
store.BackgroundImage.BackgroundTransparency = 1
store.BackgroundImage.Image = "rbxassetid://123325812442364"
store.BackgroundImage.ScaleType = Enum.ScaleType.Fit
store.BackgroundImage.Parent = store.Inner

store["UICorner3"] = Instance.new("UICorner")
store.UICorner3.Name = "UICorner"
store.UICorner3.CornerRadius = UDim.new(0,24)
store.UICorner3.Parent = store.BackgroundImage

store["Frame"] = Instance.new("Frame")
store.Frame.Name = "Frame"
store.Frame.ZIndex = 5
store.Frame.Size = UDim2.new(1,0,0,64)
store.Frame.BackgroundTransparency = 1
store.Frame.BorderSizePixel = 0
store.Frame.Parent = store.Inner

store["TextButton"] = Instance.new("TextButton")
store.TextButton.Name = "TextButton"
store.TextButton.ZIndex = 6
store.TextButton.Position = UDim2.new(1,-40,0,7)
store.TextButton.Size = UDim2.new(0,30,0,22)
store.TextButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
store.TextButton.BackgroundTransparency = 0.5
store.TextButton.BorderSizePixel = 0
store.TextButton.Text = "-"
store.TextButton.TextColor3 = Color3.fromRGB(255,255,255)
store.TextButton.TextSize = 14
store.TextButton.Font = Enum.Font.GothamBold
store.TextButton.Parent = store.Frame

store["UICorner4"] = Instance.new("UICorner")
store.UICorner4.Name = "UICorner"
store.UICorner4.Parent = store.TextButton

store["Frame2"] = Instance.new("Frame")
store.Frame2.Name = "Frame"
store.Frame2.ZIndex = 6
store.Frame2.BackgroundTransparency = 1
store.Frame2.BorderSizePixel = 0
store.Frame2.Parent = store.Frame

store["HeaderSeparator"] = Instance.new("Frame")
store.HeaderSeparator.Name = "HeaderSeparator"
store.HeaderSeparator.ZIndex = 4
store.HeaderSeparator.Position = UDim2.new(0,14,0,64)
store.HeaderSeparator.Size = UDim2.new(1,-28,0,1)
store.HeaderSeparator.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.HeaderSeparator.BackgroundTransparency = 0.7
store.HeaderSeparator.BorderSizePixel = 0
store.HeaderSeparator.Parent = store.Inner

store["UIGradient2"] = Instance.new("UIGradient")
store.UIGradient2.Name = "UIGradient"
store.UIGradient2.Color = ColorSequence.new(Color3.fromRGB(254,254,254),Color3.fromRGB(254,254,254))
store.UIGradient2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.15,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(0.85,0.3,0),NumberSequenceKeypoint.new(1,1,0)})
store.UIGradient2.Parent = store.HeaderSeparator

store["BottomTabBar"] = Instance.new("ScrollingFrame")
store.BottomTabBar.Name = "BottomTabBar"
store.BottomTabBar.Visible = false
store.BottomTabBar.ZIndex = 4
store.BottomTabBar.Position = UDim2.new(0,8,1,2)
store.BottomTabBar.Size = UDim2.new(1,-16,0,-10)
store.BottomTabBar.BackgroundTransparency = 1
store.BottomTabBar.BorderSizePixel = 0
store.BottomTabBar.ScrollBarThickness = 0
store.BottomTabBar.ScrollingDirection = Enum.ScrollingDirection.X
store.BottomTabBar.CanvasSize = UDim2.new(0,0,0,0)
store.BottomTabBar.ElasticBehavior = Enum.ElasticBehavior.Never
store.BottomTabBar.Parent = store.Inner

store["UIListLayout"] = Instance.new("UIListLayout")
store.UIListLayout.Name = "UIListLayout"
store.UIListLayout.Padding = UDim.new(0,4)
store.UIListLayout.FillDirection = Enum.FillDirection.Horizontal
store.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
store.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout.Parent = store.BottomTabBar

store["UIPadding"] = Instance.new("UIPadding")
store.UIPadding.Name = "UIPadding"
store.UIPadding.PaddingTop = UDim.new(0,4)
store.UIPadding.PaddingBottom = UDim.new(0,4)
store.UIPadding.PaddingLeft = UDim.new(0,6)
store.UIPadding.PaddingRight = UDim.new(0,6)
store.UIPadding.Parent = store.BottomTabBar

-- Speed Tab
store["TextButton2"] = Instance.new("TextButton")
store.TextButton2.Name = "TextButton"
store.TextButton2.ZIndex = 6
store.TextButton2.LayoutOrder = 1
store.TextButton2.Size = UDim2.new(0,82,1,0)
store.TextButton2.BackgroundTransparency = 1
store.TextButton2.BorderSizePixel = 0
store.TextButton2.Text = ""
store.TextButton2.AutoButtonColor = false
store.TextButton2.Parent = store.BottomTabBar

store["Label"] = Instance.new("TextLabel")
store.Label.Name = "Label"
store.Label.ZIndex = 7
store.Label.Size = UDim2.new(1,0,1,0)
store.Label.BackgroundTransparency = 1
store.Label.Text = "Speed"
store.Label.TextColor3 = Color3.fromRGB(130,135,145)
store.Label.TextSize = 13
store.Label.Font = Enum.Font.GothamBold
store.Label.Parent = store.TextButton2

store["Underline"] = Instance.new("Frame")
store.Underline.Name = "Underline"
store.Underline.ZIndex = 8
store.Underline.Position = UDim2.new(0.5,-18,1,-2)
store.Underline.Size = UDim2.new(0,36,0,2)
store.Underline.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline.BackgroundTransparency = 1
store.Underline.BorderSizePixel = 0
store.Underline.Parent = store.TextButton2

-- Steal Tab
store["TextButton4"] = Instance.new("TextButton")
store.TextButton4.Name = "TextButton"
store.TextButton4.ZIndex = 6
store.TextButton4.LayoutOrder = 2
store.TextButton4.Size = UDim2.new(0,82,1,0)
store.TextButton4.BackgroundTransparency = 1
store.TextButton4.BorderSizePixel = 0
store.TextButton4.Text = ""
store.TextButton4.AutoButtonColor = false
store.TextButton4.Parent = store.BottomTabBar

store["Label2"] = Instance.new("TextLabel")
store.Label2.Name = "Label"
store.Label2.ZIndex = 7
store.Label2.Size = UDim2.new(1,0,1,0)
store.Label2.BackgroundTransparency = 1
store.Label2.Text = "Steal"
store.Label2.TextColor3 = Color3.fromRGB(130,135,145)
store.Label2.TextSize = 13
store.Label2.Font = Enum.Font.GothamBold
store.Label2.Parent = store.TextButton4

store["Underline2"] = Instance.new("Frame")
store.Underline2.Name = "Underline"
store.Underline2.ZIndex = 8
store.Underline2.Position = UDim2.new(0.5,-18,1,-2)
store.Underline2.Size = UDim2.new(0,36,0,2)
store.Underline2.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline2.BackgroundTransparency = 1
store.Underline2.BorderSizePixel = 0
store.Underline2.Parent = store.TextButton4

-- Movement Tab
store["TextButton5"] = Instance.new("TextButton")
store.TextButton5.Name = "TextButton"
store.TextButton5.ZIndex = 6
store.TextButton5.LayoutOrder = 3
store.TextButton5.Size = UDim2.new(0,82,1,0)
store.TextButton5.BackgroundTransparency = 1
store.TextButton5.BorderSizePixel = 0
store.TextButton5.Text = ""
store.TextButton5.AutoButtonColor = false
store.TextButton5.Parent = store.BottomTabBar

store["Label3"] = Instance.new("TextLabel")
store.Label3.Name = "Label"
store.Label3.ZIndex = 7
store.Label3.Size = UDim2.new(1,0,1,0)
store.Label3.BackgroundTransparency = 1
store.Label3.Text = "Movement"
store.Label3.TextColor3 = Color3.fromRGB(130,135,145)
store.Label3.TextSize = 13
store.Label3.Font = Enum.Font.GothamBold
store.Label3.Parent = store.TextButton5

store["Underline3"] = Instance.new("Frame")
store.Underline3.Name = "Underline"
store.Underline3.ZIndex = 8
store.Underline3.Position = UDim2.new(0.5,-18,1,-2)
store.Underline3.Size = UDim2.new(0,36,0,2)
store.Underline3.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline3.BackgroundTransparency = 1
store.Underline3.BorderSizePixel = 0
store.Underline3.Parent = store.TextButton5

-- Visual Tab
store["TextButton6"] = Instance.new("TextButton")
store.TextButton6.Name = "TextButton"
store.TextButton6.ZIndex = 6
store.TextButton6.LayoutOrder = 4
store.TextButton6.Size = UDim2.new(0,82,1,0)
store.TextButton6.BackgroundTransparency = 1
store.TextButton6.BorderSizePixel = 0
store.TextButton6.Text = ""
store.TextButton6.AutoButtonColor = false
store.TextButton6.Parent = store.BottomTabBar

store["Label4"] = Instance.new("TextLabel")
store.Label4.Name = "Label"
store.Label4.ZIndex = 7
store.Label4.Size = UDim2.new(1,0,1,0)
store.Label4.BackgroundTransparency = 1
store.Label4.Text = "Visual"
store.Label4.TextColor3 = Color3.fromRGB(130,135,145)
store.Label4.TextSize = 13
store.Label4.Font = Enum.Font.GothamBold
store.Label4.Parent = store.TextButton6

store["Underline4"] = Instance.new("Frame")
store.Underline4.Name = "Underline"
store.Underline4.ZIndex = 8
store.Underline4.Position = UDim2.new(0.5,-18,1,-2)
store.Underline4.Size = UDim2.new(0,36,0,2)
store.Underline4.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline4.BackgroundTransparency = 1
store.Underline4.BorderSizePixel = 0
store.Underline4.Parent = store.TextButton6

-- Auto Tab
store["TextButton7"] = Instance.new("TextButton")
store.TextButton7.Name = "TextButton"
store.TextButton7.ZIndex = 6
store.TextButton7.LayoutOrder = 5
store.TextButton7.Size = UDim2.new(0,82,1,0)
store.TextButton7.BackgroundTransparency = 1
store.TextButton7.BorderSizePixel = 0
store.TextButton7.Text = ""
store.TextButton7.AutoButtonColor = false
store.TextButton7.Parent = store.BottomTabBar

store["Label5"] = Instance.new("TextLabel")
store.Label5.Name = "Label"
store.Label5.ZIndex = 7
store.Label5.Size = UDim2.new(1,0,1,0)
store.Label5.BackgroundTransparency = 1
store.Label5.Text = "Auto"
store.Label5.TextColor3 = Color3.fromRGB(130,135,145)
store.Label5.TextSize = 13
store.Label5.Font = Enum.Font.GothamBold
store.Label5.Parent = store.TextButton7

store["Underline5"] = Instance.new("Frame")
store.Underline5.Name = "Underline"
store.Underline5.ZIndex = 8
store.Underline5.Position = UDim2.new(0.5,-18,1,-2)
store.Underline5.Size = UDim2.new(0,36,0,2)
store.Underline5.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline5.BackgroundTransparency = 1
store.Underline5.BorderSizePixel = 0
store.Underline5.Parent = store.TextButton7

-- Settings Tab
store["TextButton9"] = Instance.new("TextButton")
store.TextButton9.Name = "TextButton"
store.TextButton9.ZIndex = 6
store.TextButton9.LayoutOrder = 6
store.TextButton9.Size = UDim2.new(0,82,1,0)
store.TextButton9.BackgroundTransparency = 1
store.TextButton9.BorderSizePixel = 0
store.TextButton9.Text = ""
store.TextButton9.AutoButtonColor = false
store.TextButton9.Parent = store.BottomTabBar

store["Label6"] = Instance.new("TextLabel")
store.Label6.Name = "Label"
store.Label6.ZIndex = 7
store.Label6.Size = UDim2.new(1,0,1,0)
store.Label6.BackgroundTransparency = 1
store.Label6.Text = "Settings"
store.Label6.TextColor3 = Color3.fromRGB(130,135,145)
store.Label6.TextSize = 13
store.Label6.Font = Enum.Font.GothamBold
store.Label6.Parent = store.TextButton9

store["Underline6"] = Instance.new("Frame")
store.Underline6.Name = "Underline"
store.Underline6.ZIndex = 8
store.Underline6.Position = UDim2.new(0.5,-18,1,-2)
store.Underline6.Size = UDim2.new(0,36,0,2)
store.Underline6.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Underline6.BackgroundTransparency = 1
store.Underline6.BorderSizePixel = 0
store.Underline6.Parent = store.TextButton9

store["Frame3"] = Instance.new("Frame")
store.Frame3.Name = "Frame"
store.Frame3.Visible = false
store.Frame3.ZIndex = 3
store.Frame3.Position = UDim2.new(0,8,1,2)
store.Frame3.Size = UDim2.new(1,-16,0,2)
store.Frame3.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame3.BackgroundTransparency = 0.65
store.Frame3.BorderSizePixel = 0
store.Frame3.Parent = store.Inner

store["UIGradient3"] = Instance.new("UIGradient")
store.UIGradient3.Name = "UIGradient"
store.UIGradient3.Color = ColorSequence.new(Color3.fromRGB(254,254,254),Color3.fromRGB(254,254,254))
store.UIGradient3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.15,0.2,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(0.85,0.2,0),NumberSequenceKeypoint.new(1,1,0)})
store.UIGradient3.Parent = store.Frame3

store["Frame4"] = Instance.new("Frame")
store.Frame4.Name = "Frame"
store.Frame4.Visible = false
store.Frame4.BackgroundTransparency = 1
store.Frame4.Parent = store.Inner

store["ScrollingFrame"] = Instance.new("ScrollingFrame")
store.ScrollingFrame.Name = "ScrollingFrame"
store.ScrollingFrame.ZIndex = 3
store.ScrollingFrame.Position = UDim2.new(0,0,0,64)
store.ScrollingFrame.Size = UDim2.new(1,0,1,-74)
store.ScrollingFrame.BackgroundTransparency = 1
store.ScrollingFrame.BorderSizePixel = 0
store.ScrollingFrame.ScrollBarThickness = 3
store.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(254,254,254)
store.ScrollingFrame.ScrollBarImageTransparency = 0.4
store.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
store.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
store.ScrollingFrame.Parent = store.Inner

store["UIListLayout2"] = Instance.new("UIListLayout")
store.UIListLayout2.Name = "UIListLayout"
store.UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
store.UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout2.Parent = store.ScrollingFrame

store["UIPadding2"] = Instance.new("UIPadding")
store.UIPadding2.Name = "UIPadding"
store.UIPadding2.PaddingTop = UDim.new(0,2)
store.UIPadding2.PaddingBottom = UDim.new(0,8)
store.UIPadding2.PaddingLeft = UDim.new(0,4)
store.UIPadding2.PaddingRight = UDim.new(0,4)
store.UIPadding2.Parent = store.ScrollingFrame

-- Pages
store["Page_Speed"] = Instance.new("Frame")
store.Page_Speed.Name = "Page_Speed"
store.Page_Speed.ZIndex = 3
store.Page_Speed.LayoutOrder = 1001
store.Page_Speed.Size = UDim2.new(1,0,0,0)
store.Page_Speed.BackgroundTransparency = 1
store.Page_Speed.BorderSizePixel = 0
store.Page_Speed.Parent = store.ScrollingFrame

store["UIListLayout3"] = Instance.new("UIListLayout")
store.UIListLayout3.Name = "UIListLayout"
store.UIListLayout3.Padding = UDim.new(0,10)
store.UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout3.Parent = store.Page_Speed

store["UIPadding3"] = Instance.new("UIPadding")
store.UIPadding3.Name = "UIPadding"
store.UIPadding3.PaddingTop = UDim.new(0,10)
store.UIPadding3.PaddingLeft = UDim.new(0,12)
store.UIPadding3.PaddingRight = UDim.new(0,12)
store.UIPadding3.Parent = store.Page_Speed

-- Speed Page Content
store["Frame5"] = Instance.new("Frame")
store.Frame5.Name = "Frame"
store.Frame5.LayoutOrder = 8
store.Frame5.Size = UDim2.new(1,0,0,24)
store.Frame5.BackgroundTransparency = 1
store.Frame5.BorderSizePixel = 0
store.Frame5.Parent = store.Page_Speed

store["TextLabel"] = Instance.new("TextLabel")
store.TextLabel.Name = "TextLabel"
store.TextLabel.ZIndex = 4
store.TextLabel.Position = UDim2.new(0,0,0,2)
store.TextLabel.Size = UDim2.new(1,0,0,16)
store.TextLabel.BackgroundTransparency = 1
store.TextLabel.Text = "SPEED CONFIGURATION"
store.TextLabel.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel.TextSize = 12
store.TextLabel.Font = Enum.Font.GothamBlack
store.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel.Parent = store.Frame5

store["Frame6"] = Instance.new("Frame")
store.Frame6.Name = "Frame"
store.Frame6.ZIndex = 3
store.Frame6.Position = UDim2.new(0,0,0,20)
store.Frame6.Size = UDim2.new(1,0,0,1)
store.Frame6.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame6.BackgroundTransparency = 0.85
store.Frame6.BorderSizePixel = 0
store.Frame6.Parent = store.Frame5

-- Speed Frame 7
store["Frame7"] = Instance.new("Frame")
store.Frame7.Name = "Frame"
store.Frame7.ZIndex = 4
store.Frame7.LayoutOrder = 12
store.Frame7.Size = UDim2.new(1,0,0,44)
store.Frame7.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame7.BackgroundTransparency = 0.5
store.Frame7.BorderSizePixel = 0
store.Frame7.Parent = store.Page_Speed

store["UICorner5"] = Instance.new("UICorner")
store.UICorner5.Name = "UICorner"
store.UICorner5.CornerRadius = UDim.new(0,12)
store.UICorner5.Parent = store.Frame7

store["UIStroke"] = Instance.new("UIStroke")
store.UIStroke.Name = "UIStroke"
store.UIStroke.Color = Color3.fromRGB(38,38,38)
store.UIStroke.Transparency = 0.5
store.UIStroke.Parent = store.Frame7

store["TextLabel2"] = Instance.new("TextLabel")
store.TextLabel2.Name = "TextLabel"
store.TextLabel2.ZIndex = 5
store.TextLabel2.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel2.Size = UDim2.new(0,110,0,18)
store.TextLabel2.BackgroundTransparency = 1
store.TextLabel2.Text = "Lagger Speed"
store.TextLabel2.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel2.TextSize = 12
store.TextLabel2.Font = Enum.Font.GothamBold
store.TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel2.Parent = store.Frame7

store["Frame8"] = Instance.new("Frame")
store.Frame8.Name = "Frame"
store.Frame8.Visible = false
store.Frame8.ZIndex = 5
store.Frame8.Position = UDim2.new(0,12,0.5,9)
store.Frame8.Size = UDim2.new(0,73,0,1)
store.Frame8.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame8.BackgroundTransparency = 0.5
store.Frame8.BorderSizePixel = 0
store.Frame8.Parent = store.Frame7

store["Frame9"] = Instance.new("Frame")
store.Frame9.Name = "Frame"
store.Frame9.ZIndex = 6
store.Frame9.Position = UDim2.new(1,-56,0.5,-13)
store.Frame9.Size = UDim2.new(0,44,0,26)
store.Frame9.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame9.BackgroundTransparency = 0.5
store.Frame9.BorderSizePixel = 0
store.Frame9.Parent = store.Frame7

store["UICorner6"] = Instance.new("UICorner")
store.UICorner6.Name = "UICorner"
store.UICorner6.Parent = store.Frame9

store["UIStroke2"] = Instance.new("UIStroke")
store.UIStroke2.Name = "UIStroke"
store.UIStroke2.Color = Color3.fromRGB(254,254,254)
store.UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke2.Transparency = 0.45
store.UIStroke2.Parent = store.Frame9

store["UIGradient4"] = Instance.new("UIGradient")
store.UIGradient4.Name = "UIGradient"
store.UIGradient4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient4.Parent = store.UIStroke2

store["TextBox"] = Instance.new("TextBox")
store.TextBox.Name = "TextBox"
store.TextBox.ZIndex = 7
store.TextBox.Size = UDim2.new(1,0,1,0)
store.TextBox.BackgroundTransparency = 1
store.TextBox.Text = "25"
store.TextBox.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox.TextSize = 10
store.TextBox.Font = Enum.Font.GothamBold
store.TextBox.ClearTextOnFocus = false
store.TextBox.Parent = store.Frame9

store["Frame10"] = Instance.new("Frame")
store.Frame10.Name = "Frame"
store.Frame10.ZIndex = 6
store.Frame10.Position = UDim2.new(1,-112,0.5,-13)
store.Frame10.Size = UDim2.new(0,44,0,26)
store.Frame10.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame10.BackgroundTransparency = 0.5
store.Frame10.BorderSizePixel = 0
store.Frame10.Parent = store.Frame7

store["UICorner7"] = Instance.new("UICorner")
store.UICorner7.Name = "UICorner"
store.UICorner7.Parent = store.Frame10

store["UIStroke3"] = Instance.new("UIStroke")
store.UIStroke3.Name = "UIStroke"
store.UIStroke3.Color = Color3.fromRGB(254,254,254)
store.UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke3.Transparency = 0.45
store.UIStroke3.Parent = store.Frame10

store["UIGradient5"] = Instance.new("UIGradient")
store.UIGradient5.Name = "UIGradient"
store.UIGradient5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient5.Parent = store.UIStroke3

store["TextBox2"] = Instance.new("TextBox")
store.TextBox2.Name = "TextBox"
store.TextBox2.ZIndex = 7
store.TextBox2.Size = UDim2.new(1,0,1,0)
store.TextBox2.BackgroundTransparency = 1
store.TextBox2.Text = "50"
store.TextBox2.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox2.TextSize = 10
store.TextBox2.Font = Enum.Font.GothamBold
store.TextBox2.ClearTextOnFocus = false
store.TextBox2.Parent = store.Frame10

store["TextButton10"] = Instance.new("TextButton")
store.TextButton10.Name = "TextButton"
store.TextButton10.ZIndex = 4
store.TextButton10.Size = UDim2.new(1,0,1,0)
store.TextButton10.BackgroundTransparency = 1
store.TextButton10.Text = ""
store.TextButton10.AutoButtonColor = false
store.TextButton10.Parent = store.Frame7

store["Frame11"] = Instance.new("Frame")
store.Frame11.Name = "Frame"
store.Frame11.ZIndex = 8
store.Frame11.ClipsDescendants = true
store.Frame11.Position = UDim2.new(0,128,0.5,-11)
store.Frame11.Size = UDim2.new(0,46,0,22)
store.Frame11.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame11.BackgroundTransparency = 0.6
store.Frame11.BorderSizePixel = 0
store.Frame11.Parent = store.Frame7

store["UICorner8"] = Instance.new("UICorner")
store.UICorner8.Name = "UICorner"
store.UICorner8.Parent = store.Frame11

store["TextLabel3"] = Instance.new("TextLabel")
store.TextLabel3.Name = "TextLabel"
store.TextLabel3.ZIndex = 9
store.TextLabel3.Size = UDim2.new(1,0,1,0)
store.TextLabel3.BackgroundTransparency = 1
store.TextLabel3.Text = "None"
store.TextLabel3.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel3.TextSize = 12
store.TextLabel3.TextScaled = true
store.TextLabel3.Font = Enum.Font.GothamBold
store.TextLabel3.TextWrapped = true
store.TextLabel3.Parent = store.Frame11

store["UITextSizeConstraint"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint.Name = "UITextSizeConstraint"
store.UITextSizeConstraint.MinTextSize = 6
store.UITextSizeConstraint.MaxTextSize = 12
store.UITextSizeConstraint.Parent = store.TextLabel3

store["TextButton11"] = Instance.new("TextButton")
store.TextButton11.Name = "TextButton"
store.TextButton11.ZIndex = 10
store.TextButton11.Position = UDim2.new(0,-2,0,-2)
store.TextButton11.Size = UDim2.new(1,4,1,4)
store.TextButton11.BackgroundTransparency = 1
store.TextButton11.Text = ""
store.TextButton11.AutoButtonColor = false
store.TextButton11.Parent = store.Frame11

-- Frame12
store["Frame12"] = Instance.new("Frame")
store.Frame12.Name = "Frame"
store.Frame12.ZIndex = 4
store.Frame12.LayoutOrder = 14
store.Frame12.Size = UDim2.new(1,0,0,44)
store.Frame12.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame12.BackgroundTransparency = 0.5
store.Frame12.BorderSizePixel = 0
store.Frame12.Parent = store.Page_Speed

store["UICorner9"] = Instance.new("UICorner")
store.UICorner9.Name = "UICorner"
store.UICorner9.CornerRadius = UDim.new(0,12)
store.UICorner9.Parent = store.Frame12

store["UIStroke4"] = Instance.new("UIStroke")
store.UIStroke4.Name = "UIStroke"
store.UIStroke4.Color = Color3.fromRGB(38,38,38)
store.UIStroke4.Transparency = 0.5
store.UIStroke4.Parent = store.Frame12

store["TextLabel4"] = Instance.new("TextLabel")
store.TextLabel4.Name = "TextLabel"
store.TextLabel4.ZIndex = 5
store.TextLabel4.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel4.Size = UDim2.new(0,110,0,18)
store.TextLabel4.BackgroundTransparency = 1
store.TextLabel4.Text = "Custom Speed"
store.TextLabel4.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel4.TextSize = 12
store.TextLabel4.Font = Enum.Font.GothamBold
store.TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel4.Parent = store.Frame12

store["Frame13"] = Instance.new("Frame")
store.Frame13.Name = "Frame"
store.Frame13.Visible = false
store.Frame13.ZIndex = 5
store.Frame13.Position = UDim2.new(0,12,0.5,9)
store.Frame13.Size = UDim2.new(0,78,0,1)
store.Frame13.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame13.BackgroundTransparency = 0.5
store.Frame13.BorderSizePixel = 0
store.Frame13.Parent = store.Frame12

store["Frame14"] = Instance.new("Frame")
store.Frame14.Name = "Frame"
store.Frame14.ZIndex = 6
store.Frame14.Position = UDim2.new(1,-56,0.5,-13)
store.Frame14.Size = UDim2.new(0,44,0,26)
store.Frame14.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame14.BackgroundTransparency = 0.5
store.Frame14.BorderSizePixel = 0
store.Frame14.Parent = store.Frame12

store["UICorner10"] = Instance.new("UICorner")
store.UICorner10.Name = "UICorner"
store.UICorner10.Parent = store.Frame14

store["UIStroke5"] = Instance.new("UIStroke")
store.UIStroke5.Name = "UIStroke"
store.UIStroke5.Color = Color3.fromRGB(254,254,254)
store.UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke5.Transparency = 0.45
store.UIStroke5.Parent = store.Frame14

store["UIGradient6"] = Instance.new("UIGradient")
store.UIGradient6.Name = "UIGradient"
store.UIGradient6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient6.Parent = store.UIStroke5

store["TextBox3"] = Instance.new("TextBox")
store.TextBox3.Name = "TextBox"
store.TextBox3.ZIndex = 7
store.TextBox3.Size = UDim2.new(1,0,1,0)
store.TextBox3.BackgroundTransparency = 1
store.TextBox3.Text = "33"
store.TextBox3.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox3.TextSize = 10
store.TextBox3.Font = Enum.Font.GothamBold
store.TextBox3.ClearTextOnFocus = false
store.TextBox3.Parent = store.Frame14

store["Frame15"] = Instance.new("Frame")
store.Frame15.Name = "Frame"
store.Frame15.ZIndex = 6
store.Frame15.Position = UDim2.new(1,-112,0.5,-13)
store.Frame15.Size = UDim2.new(0,44,0,26)
store.Frame15.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame15.BackgroundTransparency = 0.5
store.Frame15.BorderSizePixel = 0
store.Frame15.Parent = store.Frame12

store["UICorner11"] = Instance.new("UICorner")
store.UICorner11.Name = "UICorner"
store.UICorner11.Parent = store.Frame15

store["UIStroke6"] = Instance.new("UIStroke")
store.UIStroke6.Name = "UIStroke"
store.UIStroke6.Color = Color3.fromRGB(254,254,254)
store.UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke6.Transparency = 0.45
store.UIStroke6.Parent = store.Frame15

store["UIGradient7"] = Instance.new("UIGradient")
store.UIGradient7.Name = "UIGradient"
store.UIGradient7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient7.Parent = store.UIStroke6

store["TextBox4"] = Instance.new("TextBox")
store.TextBox4.Name = "TextBox"
store.TextBox4.ZIndex = 7
store.TextBox4.Size = UDim2.new(1,0,1,0)
store.TextBox4.BackgroundTransparency = 1
store.TextBox4.Text = "65"
store.TextBox4.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox4.TextSize = 10
store.TextBox4.Font = Enum.Font.GothamBold
store.TextBox4.ClearTextOnFocus = false
store.TextBox4.Parent = store.Frame15

store["TextButton12"] = Instance.new("TextButton")
store.TextButton12.Name = "TextButton"
store.TextButton12.ZIndex = 4
store.TextButton12.Size = UDim2.new(1,0,1,0)
store.TextButton12.BackgroundTransparency = 1
store.TextButton12.Text = ""
store.TextButton12.AutoButtonColor = false
store.TextButton12.Parent = store.Frame12

store["Frame16"] = Instance.new("Frame")
store.Frame16.Name = "Frame"
store.Frame16.ZIndex = 8
store.Frame16.ClipsDescendants = true
store.Frame16.Position = UDim2.new(0,128,0.5,-11)
store.Frame16.Size = UDim2.new(0,46,0,22)
store.Frame16.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame16.BackgroundTransparency = 0.6
store.Frame16.BorderSizePixel = 0
store.Frame16.Parent = store.Frame12

store["UICorner12"] = Instance.new("UICorner")
store.UICorner12.Name = "UICorner"
store.UICorner12.Parent = store.Frame16

store["TextLabel5"] = Instance.new("TextLabel")
store.TextLabel5.Name = "TextLabel"
store.TextLabel5.ZIndex = 9
store.TextLabel5.Size = UDim2.new(1,0,1,0)
store.TextLabel5.BackgroundTransparency = 1
store.TextLabel5.Text = "None"
store.TextLabel5.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel5.TextSize = 12
store.TextLabel5.TextScaled = true
store.TextLabel5.Font = Enum.Font.GothamBold
store.TextLabel5.TextWrapped = true
store.TextLabel5.Parent = store.Frame16

store["UITextSizeConstraint2"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint2.Name = "UITextSizeConstraint"
store.UITextSizeConstraint2.MinTextSize = 6
store.UITextSizeConstraint2.MaxTextSize = 12
store.UITextSizeConstraint2.Parent = store.TextLabel5

store["TextButton13"] = Instance.new("TextButton")
store.TextButton13.Name = "TextButton"
store.TextButton13.ZIndex = 10
store.TextButton13.Position = UDim2.new(0,-2,0,-2)
store.TextButton13.Size = UDim2.new(1,4,1,4)
store.TextButton13.BackgroundTransparency = 1
store.TextButton13.Text = ""
store.TextButton13.AutoButtonColor = false
store.TextButton13.Parent = store.Frame16

-- Frame17
store["Frame17"] = Instance.new("Frame")
store.Frame17.Name = "Frame"
store.Frame17.ZIndex = 4
store.Frame17.LayoutOrder = 10
store.Frame17.Size = UDim2.new(1,0,0,44)
store.Frame17.BackgroundColor3 = Color3.fromRGB(32,32,32)
store.Frame17.BackgroundTransparency = 0.5
store.Frame17.BorderSizePixel = 0
store.Frame17.Parent = store.Page_Speed

store["UICorner13"] = Instance.new("UICorner")
store.UICorner13.Name = "UICorner"
store.UICorner13.CornerRadius = UDim.new(0,12)
store.UICorner13.Parent = store.Frame17

store["UIStroke7"] = Instance.new("UIStroke")
store.UIStroke7.Name = "UIStroke"
store.UIStroke7.Color = Color3.fromRGB(254,254,254)
store.UIStroke7.Thickness = 1.4
store.UIStroke7.Transparency = 0.2
store.UIStroke7.Parent = store.Frame17

store["TextLabel6"] = Instance.new("TextLabel")
store.TextLabel6.Name = "TextLabel"
store.TextLabel6.ZIndex = 5
store.TextLabel6.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel6.Size = UDim2.new(0,110,0,18)
store.TextLabel6.BackgroundTransparency = 1
store.TextLabel6.Text = "Normal Speed"
store.TextLabel6.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel6.TextSize = 12
store.TextLabel6.Font = Enum.Font.GothamBold
store.TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel6.Parent = store.Frame17

store["Frame18"] = Instance.new("Frame")
store.Frame18.Name = "Frame"
store.Frame18.ZIndex = 5
store.Frame18.Position = UDim2.new(0,12,0.5,9)
store.Frame18.Size = UDim2.new(0,76,0,1)
store.Frame18.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame18.BackgroundTransparency = 0.5
store.Frame18.BorderSizePixel = 0
store.Frame18.Parent = store.Frame17

store["Frame19"] = Instance.new("Frame")
store.Frame19.Name = "Frame"
store.Frame19.ZIndex = 6
store.Frame19.Position = UDim2.new(1,-56,0.5,-13)
store.Frame19.Size = UDim2.new(0,44,0,26)
store.Frame19.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame19.BackgroundTransparency = 0.5
store.Frame19.BorderSizePixel = 0
store.Frame19.Parent = store.Frame17

store["UICorner14"] = Instance.new("UICorner")
store.UICorner14.Name = "UICorner"
store.UICorner14.Parent = store.Frame19

store["UIStroke8"] = Instance.new("UIStroke")
store.UIStroke8.Name = "UIStroke"
store.UIStroke8.Color = Color3.fromRGB(254,254,254)
store.UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke8.Transparency = 0.45
store.UIStroke8.Parent = store.Frame19

store["UIGradient8"] = Instance.new("UIGradient")
store.UIGradient8.Name = "UIGradient"
store.UIGradient8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient8.Parent = store.UIStroke8

store["TextBox5"] = Instance.new("TextBox")
store.TextBox5.Name = "TextBox"
store.TextBox5.ZIndex = 7
store.TextBox5.Size = UDim2.new(1,0,1,0)
store.TextBox5.BackgroundTransparency = 1
store.TextBox5.Text = "29"
store.TextBox5.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox5.TextSize = 10
store.TextBox5.Font = Enum.Font.GothamBold
store.TextBox5.ClearTextOnFocus = false
store.TextBox5.Parent = store.Frame19

store["Frame20"] = Instance.new("Frame")
store.Frame20.Name = "Frame"
store.Frame20.ZIndex = 6
store.Frame20.Position = UDim2.new(1,-112,0.5,-13)
store.Frame20.Size = UDim2.new(0,44,0,26)
store.Frame20.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame20.BackgroundTransparency = 0.5
store.Frame20.BorderSizePixel = 0
store.Frame20.Parent = store.Frame17

store["UICorner15"] = Instance.new("UICorner")
store.UICorner15.Name = "UICorner"
store.UICorner15.Parent = store.Frame20

store["UIStroke9"] = Instance.new("UIStroke")
store.UIStroke9.Name = "UIStroke"
store.UIStroke9.Color = Color3.fromRGB(254,254,254)
store.UIStroke9.Thickness = 1.8
store.UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke9.Transparency = 0.05
store.UIStroke9.Parent = store.Frame20

store["UIGradient9"] = Instance.new("UIGradient")
store.UIGradient9.Name = "UIGradient"
store.UIGradient9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient9.Parent = store.UIStroke9

store["TextBox6"] = Instance.new("TextBox")
store.TextBox6.Name = "TextBox"
store.TextBox6.ZIndex = 7
store.TextBox6.Size = UDim2.new(1,0,1,0)
store.TextBox6.BackgroundTransparency = 1
store.TextBox6.Text = "60"
store.TextBox6.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox6.TextSize = 10
store.TextBox6.Font = Enum.Font.GothamBold
store.TextBox6.ClearTextOnFocus = false
store.TextBox6.Parent = store.Frame20

store["TextButton14"] = Instance.new("TextButton")
store.TextButton14.Name = "TextButton"
store.TextButton14.ZIndex = 4
store.TextButton14.Size = UDim2.new(1,0,1,0)
store.TextButton14.BackgroundTransparency = 1
store.TextButton14.Text = ""
store.TextButton14.AutoButtonColor = false
store.TextButton14.Parent = store.Frame17

store["Frame21"] = Instance.new("Frame")
store.Frame21.Name = "Frame"
store.Frame21.ZIndex = 8
store.Frame21.ClipsDescendants = true
store.Frame21.Position = UDim2.new(0,128,0.5,-11)
store.Frame21.Size = UDim2.new(0,46,0,22)
store.Frame21.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame21.BackgroundTransparency = 0.6
store.Frame21.BorderSizePixel = 0
store.Frame21.Parent = store.Frame17

store["UICorner16"] = Instance.new("UICorner")
store.UICorner16.Name = "UICorner"
store.UICorner16.Parent = store.Frame21

store["TextLabel7"] = Instance.new("TextLabel")
store.TextLabel7.Name = "TextLabel"
store.TextLabel7.ZIndex = 9
store.TextLabel7.Size = UDim2.new(1,0,1,0)
store.TextLabel7.BackgroundTransparency = 1
store.TextLabel7.Text = "None"
store.TextLabel7.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel7.TextSize = 12
store.TextLabel7.TextScaled = true
store.TextLabel7.Font = Enum.Font.GothamBold
store.TextLabel7.TextWrapped = true
store.TextLabel7.Parent = store.Frame21

store["UITextSizeConstraint3"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint3.Name = "UITextSizeConstraint"
store.UITextSizeConstraint3.MinTextSize = 6
store.UITextSizeConstraint3.MaxTextSize = 12
store.UITextSizeConstraint3.Parent = store.TextLabel7

store["TextButton15"] = Instance.new("TextButton")
store.TextButton15.Name = "TextButton"
store.TextButton15.ZIndex = 10
store.TextButton15.Position = UDim2.new(0,-2,0,-2)
store.TextButton15.Size = UDim2.new(1,4,1,4)
store.TextButton15.BackgroundTransparency = 1
store.TextButton15.Text = ""
store.TextButton15.AutoButtonColor = false
store.TextButton15.Parent = store.Frame21

-- Frame22
store["Frame22"] = Instance.new("Frame")
store.Frame22.Name = "Frame"
store.Frame22.ZIndex = 4
store.Frame22.LayoutOrder = 9
store.Frame22.Size = UDim2.new(1,0,0,34)
store.Frame22.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame22.BackgroundTransparency = 0.5
store.Frame22.BorderSizePixel = 0
store.Frame22.Parent = store.Page_Speed

store["UICorner17"] = Instance.new("UICorner")
store.UICorner17.Name = "UICorner"
store.UICorner17.CornerRadius = UDim.new(0,12)
store.UICorner17.Parent = store.Frame22

store["UIStroke10"] = Instance.new("UIStroke")
store.UIStroke10.Name = "UIStroke"
store.UIStroke10.Color = Color3.fromRGB(35,35,45)
store.UIStroke10.Transparency = 0.4
store.UIStroke10.Parent = store.Frame22

store["TextLabel8"] = Instance.new("TextLabel")
store.TextLabel8.Name = "TextLabel"
store.TextLabel8.ZIndex = 5
store.TextLabel8.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel8.Size = UDim2.new(1,-136,0,16)
store.TextLabel8.BackgroundTransparency = 1
store.TextLabel8.Text = "Speed Change Method"
store.TextLabel8.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel8.TextSize = 11
store.TextLabel8.Font = Enum.Font.GothamBold
store.TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel8.Parent = store.Frame22

store["Frame23"] = Instance.new("Frame")
store.Frame23.Name = "Frame"
store.Frame23.Visible = false
store.Frame23.ZIndex = 5
store.Frame23.Position = UDim2.new(0,12,0.5,7)
store.Frame23.Size = UDim2.new(0,112,0,1)
store.Frame23.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame23.BackgroundTransparency = 0.5
store.Frame23.BorderSizePixel = 0
store.Frame23.Parent = store.Frame22

store["TextButton16"] = Instance.new("TextButton")
store.TextButton16.Name = "TextButton"
store.TextButton16.ZIndex = 5
store.TextButton16.Position = UDim2.new(1,-118,0.5,-12)
store.TextButton16.Size = UDim2.new(0,50,0,24)
store.TextButton16.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton16.BackgroundTransparency = 0.5
store.TextButton16.BorderSizePixel = 0
store.TextButton16.Text = "V1"
store.TextButton16.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton16.TextSize = 10
store.TextButton16.Font = Enum.Font.GothamBold
store.TextButton16.AutoButtonColor = false
store.TextButton16.Parent = store.Frame22

store["UICorner18"] = Instance.new("UICorner")
store.UICorner18.Name = "UICorner"
store.UICorner18.Parent = store.TextButton16

store["TextButton17"] = Instance.new("TextButton")
store.TextButton17.Name = "TextButton"
store.TextButton17.ZIndex = 5
store.TextButton17.Position = UDim2.new(1,-62,0.5,-12)
store.TextButton17.Size = UDim2.new(0,50,0,24)
store.TextButton17.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton17.BackgroundTransparency = 0.5
store.TextButton17.BorderSizePixel = 0
store.TextButton17.Text = "V2"
store.TextButton17.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton17.TextSize = 10
store.TextButton17.Font = Enum.Font.GothamBold
store.TextButton17.AutoButtonColor = false
store.TextButton17.Parent = store.Frame22

store["UICorner19"] = Instance.new("UICorner")
store.UICorner19.Name = "UICorner"
store.UICorner19.Parent = store.TextButton17

-- Frame24
store["Frame24"] = Instance.new("Frame")
store.Frame24.Name = "Frame"
store.Frame24.ZIndex = 4
store.Frame24.LayoutOrder = 16
store.Frame24.Size = UDim2.new(1,0,0,40)
store.Frame24.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame24.BackgroundTransparency = 0.5
store.Frame24.BorderSizePixel = 0
store.Frame24.Parent = store.Page_Speed

store["UICorner20"] = Instance.new("UICorner")
store.UICorner20.Name = "UICorner"
store.UICorner20.CornerRadius = UDim.new(0,10)
store.UICorner20.Parent = store.Frame24

store["UIStroke11"] = Instance.new("UIStroke")
store.UIStroke11.Name = "UIStroke"
store.UIStroke11.Color = Color3.fromRGB(28,28,34)
store.UIStroke11.Parent = store.Frame24

store["TextLabel9"] = Instance.new("TextLabel")
store.TextLabel9.Name = "TextLabel"
store.TextLabel9.ZIndex = 5
store.TextLabel9.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel9.Size = UDim2.new(0.6,0,0,16)
store.TextLabel9.BackgroundTransparency = 1
store.TextLabel9.Text = "Auto Speed"
store.TextLabel9.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel9.TextSize = 11
store.TextLabel9.Font = Enum.Font.GothamBold
store.TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel9.Parent = store.Frame24

store["Frame25"] = Instance.new("Frame")
store.Frame25.Name = "Frame"
store.Frame25.Visible = false
store.Frame25.ZIndex = 5
store.Frame25.Position = UDim2.new(0,12,0.5,7)
store.Frame25.Size = UDim2.new(0,57,0,1)
store.Frame25.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame25.BackgroundTransparency = 0.5
store.Frame25.BorderSizePixel = 0
store.Frame25.Parent = store.Frame24

store["Frame26"] = Instance.new("Frame")
store.Frame26.Name = "Frame"
store.Frame26.ZIndex = 6
store.Frame26.Position = UDim2.new(1,-44,0.5,-8)
store.Frame26.Size = UDim2.new(0,32,0,16)
store.Frame26.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame26.BackgroundTransparency = 0.5
store.Frame26.BorderSizePixel = 0
store.Frame26.Parent = store.Frame24

store["UICorner21"] = Instance.new("UICorner")
store.UICorner21.Name = "UICorner"
store.UICorner21.CornerRadius = UDim.new(1,0)
store.UICorner21.Parent = store.Frame26

store["UIStroke12"] = Instance.new("UIStroke")
store.UIStroke12.Name = "UIStroke"
store.UIStroke12.Color = Color3.fromRGB(70,70,70)
store.UIStroke12.Transparency = 0.5
store.UIStroke12.Parent = store.Frame26

store["Frame27"] = Instance.new("Frame")
store.Frame27.Name = "Frame"
store.Frame27.ZIndex = 7
store.Frame27.Position = UDim2.new(0,2,0.5,-6)
store.Frame27.Size = UDim2.new(0,12,0,12)
store.Frame27.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame27.BackgroundTransparency = 0.5
store.Frame27.BorderSizePixel = 0
store.Frame27.Parent = store.Frame26

store["UICorner22"] = Instance.new("UICorner")
store.UICorner22.Name = "UICorner"
store.UICorner22.CornerRadius = UDim.new(1,0)
store.UICorner22.Parent = store.Frame27

store["TextButton18"] = Instance.new("TextButton")
store.TextButton18.Name = "TextButton"
store.TextButton18.ZIndex = 8
store.TextButton18.Size = UDim2.new(1,0,1,0)
store.TextButton18.BackgroundTransparency = 1
store.TextButton18.Text = ""
store.TextButton18.Parent = store.Frame24

store["PressPop"] = Instance.new("UIScale")
store.PressPop.Name = "PressPop"
store.PressPop.Parent = store.Frame24

store["TextButton19"] = Instance.new("TextButton")
store.TextButton19.Name = "TextButton"
store.TextButton19.ZIndex = 12
store.TextButton19.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton19.Size = UDim2.new(0,32,0,22)
store.TextButton19.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton19.BackgroundTransparency = 0.5
store.TextButton19.BorderSizePixel = 0
store.TextButton19.Text = ""
store.TextButton19.AutoButtonColor = false
store.TextButton19.Parent = store.Frame24

store["UICorner23"] = Instance.new("UICorner")
store.UICorner23.Name = "UICorner"
store.UICorner23.CornerRadius = UDim.new(0,6)
store.UICorner23.Parent = store.TextButton19

store["UIStroke13"] = Instance.new("UIStroke")
store.UIStroke13.Name = "UIStroke"
store.UIStroke13.Color = Color3.fromRGB(254,254,254)
store.UIStroke13.Thickness = 1.4
store.UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke13.Transparency = 0.25
store.UIStroke13.Parent = store.TextButton19

store["UIGradient10"] = Instance.new("UIGradient")
store.UIGradient10.Name = "UIGradient"
store.UIGradient10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient10.Parent = store.UIStroke13

store["TextLabel10"] = Instance.new("TextLabel")
store.TextLabel10.Name = "TextLabel"
store.TextLabel10.ZIndex = 20
store.TextLabel10.Size = UDim2.new(1,0,1,0)
store.TextLabel10.BackgroundTransparency = 1
store.TextLabel10.Text = "▼"
store.TextLabel10.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel10.TextSize = 15
store.TextLabel10.Font = Enum.Font.GothamBlack
store.TextLabel10.Parent = store.TextButton19

store["DropdownPanel"] = Instance.new("Frame")
store.DropdownPanel.Name = "DropdownPanel"
store.DropdownPanel.Visible = false
store.DropdownPanel.ZIndex = 4
store.DropdownPanel.LayoutOrder = 17
store.DropdownPanel.Size = UDim2.new(1,0,0,34)
store.DropdownPanel.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel.BackgroundTransparency = 0.5
store.DropdownPanel.BorderSizePixel = 0
store.DropdownPanel.Parent = store.Page_Speed

store["UICorner24"] = Instance.new("UICorner")
store.UICorner24.Name = "UICorner"
store.UICorner24.CornerRadius = UDim.new(0,12)
store.UICorner24.Parent = store.DropdownPanel

store["UIStroke14"] = Instance.new("UIStroke")
store.UIStroke14.Name = "UIStroke"
store.UIStroke14.Color = Color3.fromRGB(254,254,254)
store.UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke14.Transparency = 0.5
store.UIStroke14.Parent = store.DropdownPanel

store["TextLabel11"] = Instance.new("TextLabel")
store.TextLabel11.Name = "TextLabel"
store.TextLabel11.ZIndex = 5
store.TextLabel11.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel11.Size = UDim2.new(0.5,0,0,16)
store.TextLabel11.BackgroundTransparency = 1
store.TextLabel11.Text = "Auto Speed"
store.TextLabel11.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel11.TextSize = 11
store.TextLabel11.Font = Enum.Font.GothamBold
store.TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel11.Parent = store.DropdownPanel

store["Frame28"] = Instance.new("Frame")
store.Frame28.Name = "Frame"
store.Frame28.Visible = false
store.Frame28.ZIndex = 5
store.Frame28.Position = UDim2.new(0,12,0.5,7)
store.Frame28.Size = UDim2.new(0,57,0,1)
store.Frame28.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame28.BackgroundTransparency = 0.5
store.Frame28.BorderSizePixel = 0
store.Frame28.Parent = store.DropdownPanel

store["TextButton20"] = Instance.new("TextButton")
store.TextButton20.Name = "TextButton"
store.TextButton20.ZIndex = 5
store.TextButton20.Position = UDim2.new(1,-174,0,5)
store.TextButton20.Size = UDim2.new(0,78,0,24)
store.TextButton20.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton20.BackgroundTransparency = 0.5
store.TextButton20.BorderSizePixel = 0
store.TextButton20.Text = "On Pick Up"
store.TextButton20.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton20.TextSize = 10
store.TextButton20.Font = Enum.Font.GothamBold
store.TextButton20.AutoButtonColor = false
store.TextButton20.Parent = store.DropdownPanel

store["UICorner25"] = Instance.new("UICorner")
store.UICorner25.Name = "UICorner"
store.UICorner25.Parent = store.TextButton20

store["TextButton21"] = Instance.new("TextButton")
store.TextButton21.Name = "TextButton"
store.TextButton21.ZIndex = 5
store.TextButton21.Position = UDim2.new(1,-90,0,5)
store.TextButton21.Size = UDim2.new(0,78,0,24)
store.TextButton21.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton21.BackgroundTransparency = 0.5
store.TextButton21.BorderSizePixel = 0
store.TextButton21.Text = "Soft Steal"
store.TextButton21.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton21.TextSize = 10
store.TextButton21.Font = Enum.Font.GothamBold
store.TextButton21.AutoButtonColor = false
store.TextButton21.Parent = store.DropdownPanel

store["UICorner26"] = Instance.new("UICorner")
store.UICorner26.Name = "UICorner"
store.UICorner26.Parent = store.TextButton21

-- Steal Page
store["Page_Steal"] = Instance.new("Frame")
store.Page_Steal.Name = "Page_Steal"
store.Page_Steal.ZIndex = 3
store.Page_Steal.LayoutOrder = 2001
store.Page_Steal.Size = UDim2.new(1,0,0,0)
store.Page_Steal.BackgroundTransparency = 1
store.Page_Steal.BorderSizePixel = 0
store.Page_Steal.Parent = store.ScrollingFrame

store["UIListLayout4"] = Instance.new("UIListLayout")
store.UIListLayout4.Name = "UIListLayout"
store.UIListLayout4.Padding = UDim.new(0,10)
store.UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout4.Parent = store.Page_Steal

store["UIPadding4"] = Instance.new("UIPadding")
store.UIPadding4.Name = "UIPadding"
store.UIPadding4.PaddingTop = UDim.new(0,10)
store.UIPadding4.PaddingLeft = UDim.new(0,12)
store.UIPadding4.PaddingRight = UDim.new(0,12)
store.UIPadding4.Parent = store.Page_Steal

store["Frame29"] = Instance.new("Frame")
store.Frame29.Name = "Frame"
store.Frame29.LayoutOrder = 1
store.Frame29.Size = UDim2.new(1,0,0,42)
store.Frame29.BackgroundTransparency = 1
store.Frame29.BorderSizePixel = 0
store.Frame29.Parent = store.Page_Steal

store["TextLabel12"] = Instance.new("TextLabel")
store.TextLabel12.Name = "TextLabel"
store.TextLabel12.ZIndex = 4
store.TextLabel12.Position = UDim2.new(0,0,0,20)
store.TextLabel12.Size = UDim2.new(1,0,0,16)
store.TextLabel12.BackgroundTransparency = 1
store.TextLabel12.Text = "STEAL CONFIGURATION"
store.TextLabel12.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel12.TextSize = 12
store.TextLabel12.Font = Enum.Font.GothamBlack
store.TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel12.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel12.Parent = store.Frame29

store["Frame30"] = Instance.new("Frame")
store.Frame30.Name = "Frame"
store.Frame30.ZIndex = 3
store.Frame30.Position = UDim2.new(0,0,0,38)
store.Frame30.Size = UDim2.new(1,0,0,1)
store.Frame30.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame30.BackgroundTransparency = 0.85
store.Frame30.BorderSizePixel = 0
store.Frame30.Parent = store.Frame29

store["Frame31"] = Instance.new("Frame")
store.Frame31.Name = "Frame"
store.Frame31.ZIndex = 4
store.Frame31.LayoutOrder = 12
store.Frame31.Size = UDim2.new(1,0,0,40)
store.Frame31.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame31.BackgroundTransparency = 0.5
store.Frame31.BorderSizePixel = 0
store.Frame31.Parent = store.Page_Steal

store["UICorner27"] = Instance.new("UICorner")
store.UICorner27.Name = "UICorner"
store.UICorner27.CornerRadius = UDim.new(0,10)
store.UICorner27.Parent = store.Frame31

store["UIStroke15"] = Instance.new("UIStroke")
store.UIStroke15.Name = "UIStroke"
store.UIStroke15.Color = Color3.fromRGB(28,28,34)
store.UIStroke15.Parent = store.Frame31

store["TextLabel13"] = Instance.new("TextLabel")
store.TextLabel13.Name = "TextLabel"
store.TextLabel13.ZIndex = 5
store.TextLabel13.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel13.Size = UDim2.new(0.6,0,0,16)
store.TextLabel13.BackgroundTransparency = 1
store.TextLabel13.Text = "Radius"
store.TextLabel13.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel13.TextSize = 11
store.TextLabel13.Font = Enum.Font.GothamBold
store.TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel13.Parent = store.Frame31

store["Frame32"] = Instance.new("Frame")
store.Frame32.Name = "Frame"
store.Frame32.Visible = false
store.Frame32.ZIndex = 5
store.Frame32.Position = UDim2.new(0,12,0.5,7)
store.Frame32.Size = UDim2.new(0,33,0,1)
store.Frame32.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame32.BackgroundTransparency = 0.5
store.Frame32.BorderSizePixel = 0
store.Frame32.Parent = store.Frame31

store["Frame33"] = Instance.new("Frame")
store.Frame33.Name = "Frame"
store.Frame33.ZIndex = 6
store.Frame33.Position = UDim2.new(1,-54,0.5,-11)
store.Frame33.Size = UDim2.new(0,46,0,22)
store.Frame33.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.Frame33.BackgroundTransparency = 0.5
store.Frame33.BorderSizePixel = 0
store.Frame33.Parent = store.Frame31

store["UICorner28"] = Instance.new("UICorner")
store.UICorner28.Name = "UICorner"
store.UICorner28.Parent = store.Frame33

store["UIStroke16"] = Instance.new("UIStroke")
store.UIStroke16.Name = "UIStroke"
store.UIStroke16.Color = Color3.fromRGB(254,254,254)
store.UIStroke16.Thickness = 1.4
store.UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke16.Transparency = 0.25
store.UIStroke16.Parent = store.Frame33

store["UIGradient11"] = Instance.new("UIGradient")
store.UIGradient11.Name = "UIGradient"
store.UIGradient11.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient11.Parent = store.UIStroke16

store["TextBox7"] = Instance.new("TextBox")
store.TextBox7.Name = "TextBox"
store.TextBox7.ZIndex = 7
store.TextBox7.Size = UDim2.new(1,0,1,0)
store.TextBox7.BackgroundTransparency = 1
store.TextBox7.Text = "62"
store.TextBox7.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox7.TextSize = 11
store.TextBox7.Font = Enum.Font.GothamBold
store.TextBox7.ClearTextOnFocus = false
store.TextBox7.Parent = store.Frame33

store["Frame34"] = Instance.new("Frame")
store.Frame34.Name = "Frame"
store.Frame34.ZIndex = 4
store.Frame34.LayoutOrder = 10
store.Frame34.Size = UDim2.new(1,0,0,40)
store.Frame34.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame34.BackgroundTransparency = 0.5
store.Frame34.BorderSizePixel = 0
store.Frame34.Parent = store.Page_Steal

store["UICorner29"] = Instance.new("UICorner")
store.UICorner29.Name = "UICorner"
store.UICorner29.CornerRadius = UDim.new(0,10)
store.UICorner29.Parent = store.Frame34

store["UIStroke17"] = Instance.new("UIStroke")
store.UIStroke17.Name = "UIStroke"
store.UIStroke17.Color = Color3.fromRGB(28,28,34)
store.UIStroke17.Parent = store.Frame34

store["TextLabel14"] = Instance.new("TextLabel")
store.TextLabel14.Name = "TextLabel"
store.TextLabel14.ZIndex = 5
store.TextLabel14.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel14.Size = UDim2.new(0.6,0,0,16)
store.TextLabel14.BackgroundTransparency = 1
store.TextLabel14.Text = "Auto Steal"
store.TextLabel14.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel14.TextSize = 11
store.TextLabel14.Font = Enum.Font.GothamBold
store.TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel14.Parent = store.Frame34

store["Frame35"] = Instance.new("Frame")
store.Frame35.Name = "Frame"
store.Frame35.Visible = false
store.Frame35.ZIndex = 5
store.Frame35.Position = UDim2.new(0,12,0.5,7)
store.Frame35.Size = UDim2.new(0,50,0,1)
store.Frame35.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame35.BackgroundTransparency = 0.5
store.Frame35.BorderSizePixel = 0
store.Frame35.Parent = store.Frame34

store["Frame36"] = Instance.new("Frame")
store.Frame36.Name = "Frame"
store.Frame36.ZIndex = 6
store.Frame36.Position = UDim2.new(1,-44,0.5,-8)
store.Frame36.Size = UDim2.new(0,32,0,16)
store.Frame36.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame36.BackgroundTransparency = 0.5
store.Frame36.BorderSizePixel = 0
store.Frame36.Parent = store.Frame34

store["UICorner30"] = Instance.new("UICorner")
store.UICorner30.Name = "UICorner"
store.UICorner30.CornerRadius = UDim.new(1,0)
store.UICorner30.Parent = store.Frame36

store["UIStroke18"] = Instance.new("UIStroke")
store.UIStroke18.Name = "UIStroke"
store.UIStroke18.Color = Color3.fromRGB(70,70,70)
store.UIStroke18.Transparency = 0.5
store.UIStroke18.Parent = store.Frame36

store["Frame37"] = Instance.new("Frame")
store.Frame37.Name = "Frame"
store.Frame37.ZIndex = 7
store.Frame37.Position = UDim2.new(0,2,0.5,-6)
store.Frame37.Size = UDim2.new(0,12,0,12)
store.Frame37.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame37.BackgroundTransparency = 0.5
store.Frame37.BorderSizePixel = 0
store.Frame37.Parent = store.Frame36

store["UICorner31"] = Instance.new("UICorner")
store.UICorner31.Name = "UICorner"
store.UICorner31.CornerRadius = UDim.new(1,0)
store.UICorner31.Parent = store.Frame37

store["TextButton22"] = Instance.new("TextButton")
store.TextButton22.Name = "TextButton"
store.TextButton22.ZIndex = 8
store.TextButton22.Size = UDim2.new(1,0,1,0)
store.TextButton22.BackgroundTransparency = 1
store.TextButton22.Text = ""
store.TextButton22.Parent = store.Frame34

store["TextButton23"] = Instance.new("TextButton")
store.TextButton23.Name = "TextButton"
store.TextButton23.ZIndex = 12
store.TextButton23.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton23.Size = UDim2.new(0,32,0,22)
store.TextButton23.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton23.BackgroundTransparency = 0.5
store.TextButton23.BorderSizePixel = 0
store.TextButton23.Text = ""
store.TextButton23.AutoButtonColor = false
store.TextButton23.Parent = store.Frame34

store["UICorner32"] = Instance.new("UICorner")
store.UICorner32.Name = "UICorner"
store.UICorner32.CornerRadius = UDim.new(0,6)
store.UICorner32.Parent = store.TextButton23

store["UIStroke19"] = Instance.new("UIStroke")
store.UIStroke19.Name = "UIStroke"
store.UIStroke19.Color = Color3.fromRGB(254,254,254)
store.UIStroke19.Thickness = 1.4
store.UIStroke19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke19.Transparency = 0.25
store.UIStroke19.Parent = store.TextButton23

store["UIGradient12"] = Instance.new("UIGradient")
store.UIGradient12.Name = "UIGradient"
store.UIGradient12.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient12.Parent = store.UIStroke19

store["TextLabel15"] = Instance.new("TextLabel")
store.TextLabel15.Name = "TextLabel"
store.TextLabel15.ZIndex = 20
store.TextLabel15.Size = UDim2.new(1,0,1,0)
store.TextLabel15.BackgroundTransparency = 1
store.TextLabel15.Text = "▼"
store.TextLabel15.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel15.TextSize = 15
store.TextLabel15.Font = Enum.Font.GothamBlack
store.TextLabel15.Parent = store.TextButton23

store["DropdownPanel2"] = Instance.new("Frame")
store.DropdownPanel2.Name = "DropdownPanel"
store.DropdownPanel2.Visible = false
store.DropdownPanel2.ZIndex = 4
store.DropdownPanel2.LayoutOrder = 11
store.DropdownPanel2.Size = UDim2.new(1,0,0,34)
store.DropdownPanel2.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.DropdownPanel2.BackgroundTransparency = 0.5
store.DropdownPanel2.BorderSizePixel = 0
store.DropdownPanel2.Parent = store.Page_Steal

store["UICorner33"] = Instance.new("UICorner")
store.UICorner33.Name = "UICorner"
store.UICorner33.CornerRadius = UDim.new(0,12)
store.UICorner33.Parent = store.DropdownPanel2

store["UIStroke20"] = Instance.new("UIStroke")
store.UIStroke20.Name = "UIStroke"
store.UIStroke20.Color = Color3.fromRGB(254,254,254)
store.UIStroke20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke20.Transparency = 0.5
store.UIStroke20.Parent = store.DropdownPanel2

store["TextLabel16"] = Instance.new("TextLabel")
store.TextLabel16.Name = "TextLabel"
store.TextLabel16.ZIndex = 5
store.TextLabel16.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel16.Size = UDim2.new(0.5,0,0,16)
store.TextLabel16.BackgroundTransparency = 1
store.TextLabel16.Text = "Steal Mode"
store.TextLabel16.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel16.TextSize = 11
store.TextLabel16.Font = Enum.Font.GothamBold
store.TextLabel16.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel16.Parent = store.DropdownPanel2

store["Frame38"] = Instance.new("Frame")
store.Frame38.Name = "Frame"
store.Frame38.Visible = false
store.Frame38.ZIndex = 5
store.Frame38.Position = UDim2.new(0,12,0.5,7)
store.Frame38.Size = UDim2.new(0,54,0,1)
store.Frame38.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame38.BackgroundTransparency = 0.5
store.Frame38.BorderSizePixel = 0
store.Frame38.Parent = store.DropdownPanel2

store["TextButton24"] = Instance.new("TextButton")
store.TextButton24.Name = "TextButton"
store.TextButton24.ZIndex = 5
store.TextButton24.Position = UDim2.new(1,-174,0,5)
store.TextButton24.Size = UDim2.new(0,78,0,24)
store.TextButton24.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton24.BackgroundTransparency = 0.5
store.TextButton24.BorderSizePixel = 0
store.TextButton24.Text = "Normal"
store.TextButton24.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton24.TextSize = 10
store.TextButton24.Font = Enum.Font.GothamBold
store.TextButton24.AutoButtonColor = false
store.TextButton24.Parent = store.DropdownPanel2

store["UICorner34"] = Instance.new("UICorner")
store.UICorner34.Name = "UICorner"
store.UICorner34.Parent = store.TextButton24

store["TextButton25"] = Instance.new("TextButton")
store.TextButton25.Name = "TextButton"
store.TextButton25.ZIndex = 5
store.TextButton25.Position = UDim2.new(1,-90,0,5)
store.TextButton25.Size = UDim2.new(0,78,0,24)
store.TextButton25.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton25.BackgroundTransparency = 0.5
store.TextButton25.BorderSizePixel = 0
store.TextButton25.Text = "Semi"
store.TextButton25.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton25.TextSize = 10
store.TextButton25.Font = Enum.Font.GothamBold
store.TextButton25.AutoButtonColor = false
store.TextButton25.Parent = store.DropdownPanel2

store["UICorner35"] = Instance.new("UICorner")
store.UICorner35.Name = "UICorner"
store.UICorner35.Parent = store.TextButton25

store["Frame39"] = Instance.new("Frame")
store.Frame39.Name = "Frame"
store.Frame39.ZIndex = 4
store.Frame39.LayoutOrder = 16
store.Frame39.Size = UDim2.new(1,0,0,40)
store.Frame39.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame39.BackgroundTransparency = 0.5
store.Frame39.BorderSizePixel = 0
store.Frame39.Parent = store.Page_Steal

store["UICorner36"] = Instance.new("UICorner")
store.UICorner36.Name = "UICorner"
store.UICorner36.CornerRadius = UDim.new(0,10)
store.UICorner36.Parent = store.Frame39

store["UIStroke21"] = Instance.new("UIStroke")
store.UIStroke21.Name = "UIStroke"
store.UIStroke21.Color = Color3.fromRGB(28,28,34)
store.UIStroke21.Parent = store.Frame39

store["TextLabel17"] = Instance.new("TextLabel")
store.TextLabel17.Name = "TextLabel"
store.TextLabel17.ZIndex = 5
store.TextLabel17.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel17.Size = UDim2.new(0.6,0,0,16)
store.TextLabel17.BackgroundTransparency = 1
store.TextLabel17.Text = "Ragdoll Steal"
store.TextLabel17.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel17.TextSize = 11
store.TextLabel17.Font = Enum.Font.GothamBold
store.TextLabel17.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel17.Parent = store.Frame39

store["Frame40"] = Instance.new("Frame")
store.Frame40.Name = "Frame"
store.Frame40.Visible = false
store.Frame40.ZIndex = 5
store.Frame40.Position = UDim2.new(0,12,0.5,7)
store.Frame40.Size = UDim2.new(0,64,0,1)
store.Frame40.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame40.BackgroundTransparency = 0.5
store.Frame40.BorderSizePixel = 0
store.Frame40.Parent = store.Frame39

store["Frame41"] = Instance.new("Frame")
store.Frame41.Name = "Frame"
store.Frame41.ZIndex = 6
store.Frame41.Position = UDim2.new(1,-44,0.5,-8)
store.Frame41.Size = UDim2.new(0,32,0,16)
store.Frame41.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame41.BackgroundTransparency = 0.5
store.Frame41.BorderSizePixel = 0
store.Frame41.Parent = store.Frame39

store["UICorner37"] = Instance.new("UICorner")
store.UICorner37.Name = "UICorner"
store.UICorner37.CornerRadius = UDim.new(1,0)
store.UICorner37.Parent = store.Frame41

store["UIStroke22"] = Instance.new("UIStroke")
store.UIStroke22.Name = "UIStroke"
store.UIStroke22.Color = Color3.fromRGB(70,70,70)
store.UIStroke22.Transparency = 0.5
store.UIStroke22.Parent = store.Frame41

store["Frame42"] = Instance.new("Frame")
store.Frame42.Name = "Frame"
store.Frame42.ZIndex = 7
store.Frame42.Position = UDim2.new(0,2,0.5,-6)
store.Frame42.Size = UDim2.new(0,12,0,12)
store.Frame42.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame42.BackgroundTransparency = 0.5
store.Frame42.BorderSizePixel = 0
store.Frame42.Parent = store.Frame41

store["UICorner38"] = Instance.new("UICorner")
store.UICorner38.Name = "UICorner"
store.UICorner38.CornerRadius = UDim.new(1,0)
store.UICorner38.Parent = store.Frame42

store["TextButton26"] = Instance.new("TextButton")
store.TextButton26.Name = "TextButton"
store.TextButton26.ZIndex = 8
store.TextButton26.Size = UDim2.new(1,0,1,0)
store.TextButton26.BackgroundTransparency = 1
store.TextButton26.Text = ""
store.TextButton26.Parent = store.Frame39

store["PressPop2"] = Instance.new("UIScale")
store.PressPop2.Name = "PressPop"
store.PressPop2.Parent = store.Frame39

-- Movement Page
store["Page_Movement"] = Instance.new("Frame")
store.Page_Movement.Name = "Page_Movement"
store.Page_Movement.ZIndex = 3
store.Page_Movement.LayoutOrder = 3001
store.Page_Movement.Size = UDim2.new(1,0,0,0)
store.Page_Movement.BackgroundTransparency = 1
store.Page_Movement.BorderSizePixel = 0
store.Page_Movement.Parent = store.ScrollingFrame

store["UIListLayout5"] = Instance.new("UIListLayout")
store.UIListLayout5.Name = "UIListLayout"
store.UIListLayout5.Padding = UDim.new(0,10)
store.UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
store.UIListLayout5.Parent = store.Page_Movement

store["UIPadding5"] = Instance.new("UIPadding")
store.UIPadding5.Name = "UIPadding"
store.UIPadding5.PaddingTop = UDim.new(0,10)
store.UIPadding5.PaddingLeft = UDim.new(0,12)
store.UIPadding5.PaddingRight = UDim.new(0,12)
store.UIPadding5.Parent = store.Page_Movement

store["Frame43"] = Instance.new("Frame")
store.Frame43.Name = "Frame"
store.Frame43.LayoutOrder = 55
store.Frame43.Size = UDim2.new(1,0,0,42)
store.Frame43.BackgroundTransparency = 1
store.Frame43.BorderSizePixel = 0
store.Frame43.Parent = store.Page_Movement

store["TextLabel18"] = Instance.new("TextLabel")
store.TextLabel18.Name = "TextLabel"
store.TextLabel18.ZIndex = 4
store.TextLabel18.Position = UDim2.new(0,0,0,20)
store.TextLabel18.Size = UDim2.new(1,0,0,16)
store.TextLabel18.BackgroundTransparency = 1
store.TextLabel18.Text = "COUNTERS CONFIGURATION"
store.TextLabel18.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel18.TextSize = 12
store.TextLabel18.Font = Enum.Font.GothamBlack
store.TextLabel18.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel18.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel18.Parent = store.Frame43

store["Frame44"] = Instance.new("Frame")
store.Frame44.Name = "Frame"
store.Frame44.ZIndex = 3
store.Frame44.Position = UDim2.new(0,0,0,38)
store.Frame44.Size = UDim2.new(1,0,0,1)
store.Frame44.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame44.BackgroundTransparency = 0.85
store.Frame44.BorderSizePixel = 0
store.Frame44.Parent = store.Frame43

store["Frame45"] = Instance.new("Frame")
store.Frame45.Name = "Frame"
store.Frame45.LayoutOrder = 18
store.Frame45.Size = UDim2.new(1,0,0,42)
store.Frame45.BackgroundTransparency = 1
store.Frame45.BorderSizePixel = 0
store.Frame45.Parent = store.Page_Movement

store["TextLabel19"] = Instance.new("TextLabel")
store.TextLabel19.Name = "TextLabel"
store.TextLabel19.ZIndex = 4
store.TextLabel19.Position = UDim2.new(0,0,0,20)
store.TextLabel19.Size = UDim2.new(1,0,0,16)
store.TextLabel19.BackgroundTransparency = 1
store.TextLabel19.Text = "AIMBOT CONFIGURATION"
store.TextLabel19.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel19.TextSize = 12
store.TextLabel19.Font = Enum.Font.GothamBlack
store.TextLabel19.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel19.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel19.Parent = store.Frame45

store["Frame46"] = Instance.new("Frame")
store.Frame46.Name = "Frame"
store.Frame46.ZIndex = 3
store.Frame46.Position = UDim2.new(0,0,0,38)
store.Frame46.Size = UDim2.new(1,0,0,1)
store.Frame46.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame46.BackgroundTransparency = 0.85
store.Frame46.BorderSizePixel = 0
store.Frame46.Parent = store.Frame45

store["Frame47"] = Instance.new("Frame")
store.Frame47.Name = "Frame"
store.Frame47.ZIndex = 4
store.Frame47.LayoutOrder = 20
store.Frame47.Size = UDim2.new(1,0,0,40)
store.Frame47.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame47.BackgroundTransparency = 0.5
store.Frame47.BorderSizePixel = 0
store.Frame47.Parent = store.Page_Movement

store["UICorner39"] = Instance.new("UICorner")
store.UICorner39.Name = "UICorner"
store.UICorner39.CornerRadius = UDim.new(0,10)
store.UICorner39.Parent = store.Frame47

store["UIStroke23"] = Instance.new("UIStroke")
store.UIStroke23.Name = "UIStroke"
store.UIStroke23.Color = Color3.fromRGB(28,28,34)
store.UIStroke23.Parent = store.Frame47

store["TextLabel20"] = Instance.new("TextLabel")
store.TextLabel20.Name = "TextLabel"
store.TextLabel20.ZIndex = 5
store.TextLabel20.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel20.Size = UDim2.new(0.6,0,0,16)
store.TextLabel20.BackgroundTransparency = 1
store.TextLabel20.Text = "Bat Aimbot"
store.TextLabel20.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel20.TextSize = 11
store.TextLabel20.Font = Enum.Font.GothamBold
store.TextLabel20.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel20.Parent = store.Frame47

store["Frame48"] = Instance.new("Frame")
store.Frame48.Name = "Frame"
store.Frame48.Visible = false
store.Frame48.ZIndex = 5
store.Frame48.Position = UDim2.new(0,12,0.5,7)
store.Frame48.Size = UDim2.new(0,55,0,1)
store.Frame48.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame48.BackgroundTransparency = 0.5
store.Frame48.BorderSizePixel = 0
store.Frame48.Parent = store.Frame47

store["Frame49"] = Instance.new("Frame")
store.Frame49.Name = "Frame"
store.Frame49.ZIndex = 9
store.Frame49.ClipsDescendants = true
store.Frame49.Position = UDim2.new(1,-44,0.5,-11)
store.Frame49.Size = UDim2.new(0,32,0,22)
store.Frame49.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame49.BackgroundTransparency = 0.6
store.Frame49.BorderSizePixel = 0
store.Frame49.Parent = store.Frame47

store["UICorner40"] = Instance.new("UICorner")
store.UICorner40.Name = "UICorner"
store.UICorner40.Parent = store.Frame49

store["TextLabel21"] = Instance.new("TextLabel")
store.TextLabel21.Name = "TextLabel"
store.TextLabel21.ZIndex = 10
store.TextLabel21.Size = UDim2.new(1,0,1,0)
store.TextLabel21.BackgroundTransparency = 1
store.TextLabel21.Text = "None"
store.TextLabel21.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel21.TextSize = 10
store.TextLabel21.TextScaled = true
store.TextLabel21.Font = Enum.Font.GothamBold
store.TextLabel21.TextWrapped = true
store.TextLabel21.Parent = store.Frame49

store["UITextSizeConstraint4"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint4.Name = "UITextSizeConstraint"
store.UITextSizeConstraint4.MinTextSize = 6
store.UITextSizeConstraint4.MaxTextSize = 10
store.UITextSizeConstraint4.Parent = store.TextLabel21

store["TextButton27"] = Instance.new("TextButton")
store.TextButton27.Name = "TextButton"
store.TextButton27.ZIndex = 11
store.TextButton27.Size = UDim2.new(1,0,1,0)
store.TextButton27.BackgroundTransparency = 1
store.TextButton27.Text = ""
store.TextButton27.AutoButtonColor = false
store.TextButton27.Parent = store.Frame49

store["TextButton28"] = Instance.new("TextButton")
store.TextButton28.Name = "TextButton"
store.TextButton28.ZIndex = 12
store.TextButton28.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton28.Size = UDim2.new(0,32,0,22)
store.TextButton28.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton28.BackgroundTransparency = 0.5
store.TextButton28.BorderSizePixel = 0
store.TextButton28.Text = ""
store.TextButton28.AutoButtonColor = false
store.TextButton28.Parent = store.Frame47

store["UICorner41"] = Instance.new("UICorner")
store.UICorner41.Name = "UICorner"
store.UICorner41.CornerRadius = UDim.new(0,6)
store.UICorner41.Parent = store.TextButton28

store["UIStroke24"] = Instance.new("UIStroke")
store.UIStroke24.Name = "UIStroke"
store.UIStroke24.Color = Color3.fromRGB(254,254,254)
store.UIStroke24.Thickness = 1.4
store.UIStroke24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke24.Transparency = 0.25
store.UIStroke24.Parent = store.TextButton28

store["UIGradient13"] = Instance.new("UIGradient")
store.UIGradient13.Name = "UIGradient"
store.UIGradient13.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient13.Parent = store.UIStroke24

store["TextLabel22"] = Instance.new("TextLabel")
store.TextLabel22.Name = "TextLabel"
store.TextLabel22.ZIndex = 20
store.TextLabel22.Size = UDim2.new(1,0,1,0)
store.TextLabel22.BackgroundTransparency = 1
store.TextLabel22.Text = "▼"
store.TextLabel22.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel22.TextSize = 15
store.TextLabel22.Font = Enum.Font.GothamBlack
store.TextLabel22.Parent = store.TextButton28

store["Frame50"] = Instance.new("Frame")
store.Frame50.Name = "Frame"
store.Frame50.Visible = false
store.Frame50.ZIndex = 4
store.Frame50.LayoutOrder = 24
store.Frame50.Size = UDim2.new(1,0,0,34)
store.Frame50.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame50.BackgroundTransparency = 0.5
store.Frame50.BorderSizePixel = 0
store.Frame50.Parent = store.Page_Movement

store["UICorner42"] = Instance.new("UICorner")
store.UICorner42.Name = "UICorner"
store.UICorner42.CornerRadius = UDim.new(0,12)
store.UICorner42.Parent = store.Frame50

store["UIStroke25"] = Instance.new("UIStroke")
store.UIStroke25.Name = "UIStroke"
store.UIStroke25.Color = Color3.fromRGB(35,35,45)
store.UIStroke25.Transparency = 0.4
store.UIStroke25.Parent = store.Frame50

store["TextLabel23"] = Instance.new("TextLabel")
store.TextLabel23.Name = "TextLabel"
store.TextLabel23.ZIndex = 5
store.TextLabel23.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel23.Size = UDim2.new(0.55,0,0,16)
store.TextLabel23.BackgroundTransparency = 1
store.TextLabel23.Text = "Aimbot Normal Speed"
store.TextLabel23.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel23.TextSize = 11
store.TextLabel23.Font = Enum.Font.GothamBold
store.TextLabel23.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel23.Parent = store.Frame50

store["Frame51"] = Instance.new("Frame")
store.Frame51.Name = "Frame"
store.Frame51.Visible = false
store.Frame51.ZIndex = 5
store.Frame51.Position = UDim2.new(0,12,0.5,7)
store.Frame51.Size = UDim2.new(0,108,0,1)
store.Frame51.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame51.BackgroundTransparency = 0.5
store.Frame51.BorderSizePixel = 0
store.Frame51.Parent = store.Frame50

store["TextBox8"] = Instance.new("TextBox")
store.TextBox8.Name = "TextBox"
store.TextBox8.ZIndex = 5
store.TextBox8.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox8.Size = UDim2.new(0,70,0,24)
store.TextBox8.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox8.BorderSizePixel = 0
store.TextBox8.Text = "58"
store.TextBox8.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox8.TextSize = 12
store.TextBox8.Font = Enum.Font.GothamBold
store.TextBox8.ClearTextOnFocus = false
store.TextBox8.Parent = store.Frame50

store["UICorner43"] = Instance.new("UICorner")
store.UICorner43.Name = "UICorner"
store.UICorner43.Parent = store.TextBox8

store["UIStroke26"] = Instance.new("UIStroke")
store.UIStroke26.Name = "UIStroke"
store.UIStroke26.Color = Color3.fromRGB(254,254,254)
store.UIStroke26.Thickness = 1.4
store.UIStroke26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke26.Transparency = 0.25
store.UIStroke26.Parent = store.TextBox8

store["UIGradient14"] = Instance.new("UIGradient")
store.UIGradient14.Name = "UIGradient"
store.UIGradient14.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient14.Parent = store.UIStroke26

store["Frame52"] = Instance.new("Frame")
store.Frame52.Name = "Frame"
store.Frame52.Visible = false
store.Frame52.ZIndex = 4
store.Frame52.LayoutOrder = 26
store.Frame52.Size = UDim2.new(1,0,0,34)
store.Frame52.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame52.BackgroundTransparency = 0.5
store.Frame52.BorderSizePixel = 0
store.Frame52.Parent = store.Page_Movement

store["UICorner44"] = Instance.new("UICorner")
store.UICorner44.Name = "UICorner"
store.UICorner44.CornerRadius = UDim.new(0,12)
store.UICorner44.Parent = store.Frame52

store["UIStroke27"] = Instance.new("UIStroke")
store.UIStroke27.Name = "UIStroke"
store.UIStroke27.Color = Color3.fromRGB(35,35,45)
store.UIStroke27.Transparency = 0.4
store.UIStroke27.Parent = store.Frame52

store["TextLabel24"] = Instance.new("TextLabel")
store.TextLabel24.Name = "TextLabel"
store.TextLabel24.ZIndex = 5
store.TextLabel24.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel24.Size = UDim2.new(0.55,0,0,16)
store.TextLabel24.BackgroundTransparency = 1
store.TextLabel24.Text = "Aimbot Lagger Speed"
store.TextLabel24.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel24.TextSize = 11
store.TextLabel24.Font = Enum.Font.GothamBold
store.TextLabel24.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel24.Parent = store.Frame52

store["Frame53"] = Instance.new("Frame")
store.Frame53.Name = "Frame"
store.Frame53.Visible = false
store.Frame53.ZIndex = 5
store.Frame53.Position = UDim2.new(0,12,0.5,7)
store.Frame53.Size = UDim2.new(0,107,0,1)
store.Frame53.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame53.BackgroundTransparency = 0.5
store.Frame53.BorderSizePixel = 0
store.Frame53.Parent = store.Frame52

store["TextBox9"] = Instance.new("TextBox")
store.TextBox9.Name = "TextBox"
store.TextBox9.ZIndex = 5
store.TextBox9.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox9.Size = UDim2.new(0,70,0,24)
store.TextBox9.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox9.BorderSizePixel = 0
store.TextBox9.Text = "40"
store.TextBox9.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox9.TextSize = 12
store.TextBox9.Font = Enum.Font.GothamBold
store.TextBox9.ClearTextOnFocus = false
store.TextBox9.Parent = store.Frame52

store["UICorner45"] = Instance.new("UICorner")
store.UICorner45.Name = "UICorner"
store.UICorner45.Parent = store.TextBox9

store["UIStroke28"] = Instance.new("UIStroke")
store.UIStroke28.Name = "UIStroke"
store.UIStroke28.Color = Color3.fromRGB(254,254,254)
store.UIStroke28.Thickness = 1.4
store.UIStroke28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke28.Transparency = 0.25
store.UIStroke28.Parent = store.TextBox9

store["UIGradient15"] = Instance.new("UIGradient")
store.UIGradient15.Name = "UIGradient"
store.UIGradient15.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient15.Parent = store.UIStroke28

store["Frame54"] = Instance.new("Frame")
store.Frame54.Name = "Frame"
store.Frame54.Visible = false
store.Frame54.ZIndex = 4
store.Frame54.LayoutOrder = 28
store.Frame54.Size = UDim2.new(1,0,0,34)
store.Frame54.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame54.BackgroundTransparency = 0.5
store.Frame54.BorderSizePixel = 0
store.Frame54.Parent = store.Page_Movement

store["UICorner46"] = Instance.new("UICorner")
store.UICorner46.Name = "UICorner"
store.UICorner46.CornerRadius = UDim.new(0,12)
store.UICorner46.Parent = store.Frame54

store["UIStroke29"] = Instance.new("UIStroke")
store.UIStroke29.Name = "UIStroke"
store.UIStroke29.Color = Color3.fromRGB(35,35,45)
store.UIStroke29.Transparency = 0.4
store.UIStroke29.Parent = store.Frame54

store["TextLabel25"] = Instance.new("TextLabel")
store.TextLabel25.Name = "TextLabel"
store.TextLabel25.ZIndex = 5
store.TextLabel25.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel25.Size = UDim2.new(0.55,0,0,16)
store.TextLabel25.BackgroundTransparency = 1
store.TextLabel25.Text = "Aimbot Custom Speed"
store.TextLabel25.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel25.TextSize = 11
store.TextLabel25.Font = Enum.Font.GothamBold
store.TextLabel25.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel25.Parent = store.Frame54

store["Frame55"] = Instance.new("Frame")
store.Frame55.Name = "Frame"
store.Frame55.Visible = false
store.Frame55.ZIndex = 5
store.Frame55.Position = UDim2.new(0,12,0.5,7)
store.Frame55.Size = UDim2.new(0,110,0,1)
store.Frame55.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame55.BackgroundTransparency = 0.5
store.Frame55.BorderSizePixel = 0
store.Frame55.Parent = store.Frame54

store["TextBox10"] = Instance.new("TextBox")
store.TextBox10.Name = "TextBox"
store.TextBox10.ZIndex = 5
store.TextBox10.Position = UDim2.new(1,-82,0.5,-12)
store.TextBox10.Size = UDim2.new(0,70,0,24)
store.TextBox10.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextBox10.BorderSizePixel = 0
store.TextBox10.Text = "58"
store.TextBox10.TextColor3 = Color3.fromRGB(255,255,255)
store.TextBox10.TextSize = 12
store.TextBox10.Font = Enum.Font.GothamBold
store.TextBox10.ClearTextOnFocus = false
store.TextBox10.Parent = store.Frame54

store["UICorner47"] = Instance.new("UICorner")
store.UICorner47.Name = "UICorner"
store.UICorner47.Parent = store.TextBox10

store["UIStroke30"] = Instance.new("UIStroke")
store.UIStroke30.Name = "UIStroke"
store.UIStroke30.Color = Color3.fromRGB(254,254,254)
store.UIStroke30.Thickness = 1.4
store.UIStroke30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke30.Transparency = 0.25
store.UIStroke30.Parent = store.TextBox10

store["UIGradient16"] = Instance.new("UIGradient")
store.UIGradient16.Name = "UIGradient"
store.UIGradient16.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient16.Parent = store.UIStroke30

store["Frame56"] = Instance.new("Frame")
store.Frame56.Name = "Frame"
store.Frame56.Visible = false
store.Frame56.ZIndex = 4
store.Frame56.LayoutOrder = 29
store.Frame56.Size = UDim2.new(1,0,0,40)
store.Frame56.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame56.BackgroundTransparency = 0.5
store.Frame56.BorderSizePixel = 0
store.Frame56.Parent = store.Page_Movement

store["UICorner48"] = Instance.new("UICorner")
store.UICorner48.Name = "UICorner"
store.UICorner48.CornerRadius = UDim.new(0,10)
store.UICorner48.Parent = store.Frame56

store["UIStroke31"] = Instance.new("UIStroke")
store.UIStroke31.Name = "UIStroke"
store.UIStroke31.Color = Color3.fromRGB(28,28,34)
store.UIStroke31.Parent = store.Frame56

store["TextLabel26"] = Instance.new("TextLabel")
store.TextLabel26.Name = "TextLabel"
store.TextLabel26.ZIndex = 5
store.TextLabel26.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel26.Size = UDim2.new(0.6,0,0,16)
store.TextLabel26.BackgroundTransparency = 1
store.TextLabel26.Text = "Auto Swing"
store.TextLabel26.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel26.TextSize = 11
store.TextLabel26.Font = Enum.Font.GothamBold
store.TextLabel26.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel26.Parent = store.Frame56

store["Frame57"] = Instance.new("Frame")
store.Frame57.Name = "Frame"
store.Frame57.Visible = false
store.Frame57.ZIndex = 5
store.Frame57.Position = UDim2.new(0,12,0.5,7)
store.Frame57.Size = UDim2.new(0,57,0,1)
store.Frame57.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame57.BackgroundTransparency = 0.5
store.Frame57.BorderSizePixel = 0
store.Frame57.Parent = store.Frame56

store["Frame58"] = Instance.new("Frame")
store.Frame58.Name = "Frame"
store.Frame58.ZIndex = 6
store.Frame58.Position = UDim2.new(1,-44,0.5,-8)
store.Frame58.Size = UDim2.new(0,32,0,16)
store.Frame58.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame58.BackgroundTransparency = 0.5
store.Frame58.BorderSizePixel = 0
store.Frame58.Parent = store.Frame56

store["UICorner49"] = Instance.new("UICorner")
store.UICorner49.Name = "UICorner"
store.UICorner49.CornerRadius = UDim.new(1,0)
store.UICorner49.Parent = store.Frame58

store["UIStroke32"] = Instance.new("UIStroke")
store.UIStroke32.Name = "UIStroke"
store.UIStroke32.Color = Color3.fromRGB(255,255,255)
store.UIStroke32.Transparency = 0.4
store.UIStroke32.Parent = store.Frame58

store["Frame59"] = Instance.new("Frame")
store.Frame59.Name = "Frame"
store.Frame59.ZIndex = 7
store.Frame59.Position = UDim2.new(0,18,0.5,-6)
store.Frame59.Size = UDim2.new(0,12,0,12)
store.Frame59.BackgroundColor3 = Color3.fromRGB(255,255,255)
store.Frame59.BackgroundTransparency = 0.5
store.Frame59.BorderSizePixel = 0
store.Frame59.Parent = store.Frame58

store["UICorner50"] = Instance.new("UICorner")
store.UICorner50.Name = "UICorner"
store.UICorner50.CornerRadius = UDim.new(1,0)
store.UICorner50.Parent = store.Frame59

store["TextButton29"] = Instance.new("TextButton")
store.TextButton29.Name = "TextButton"
store.TextButton29.ZIndex = 8
store.TextButton29.Size = UDim2.new(1,0,1,0)
store.TextButton29.BackgroundTransparency = 1
store.TextButton29.Text = ""
store.TextButton29.Parent = store.Frame56

store["PressPop3"] = Instance.new("UIScale")
store.PressPop3.Name = "PressPop"
store.PressPop3.Parent = store.Frame56

store["Frame60"] = Instance.new("Frame")
store.Frame60.Name = "Frame"
store.Frame60.Visible = false
store.Frame60.ZIndex = 4
store.Frame60.LayoutOrder = 38
store.Frame60.Size = UDim2.new(1,0,0,40)
store.Frame60.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame60.BackgroundTransparency = 0.5
store.Frame60.BorderSizePixel = 0
store.Frame60.Parent = store.Page_Movement

store["UICorner51"] = Instance.new("UICorner")
store.UICorner51.Name = "UICorner"
store.UICorner51.CornerRadius = UDim.new(0,10)
store.UICorner51.Parent = store.Frame60

store["UIStroke33"] = Instance.new("UIStroke")
store.UIStroke33.Name = "UIStroke"
store.UIStroke33.Color = Color3.fromRGB(28,28,34)
store.UIStroke33.Parent = store.Frame60

store["TextLabel27"] = Instance.new("TextLabel")
store.TextLabel27.Name = "TextLabel"
store.TextLabel27.ZIndex = 5
store.TextLabel27.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel27.Size = UDim2.new(0.6,0,0,16)
store.TextLabel27.BackgroundTransparency = 1
store.TextLabel27.Text = "Remove Camera Shake"
store.TextLabel27.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel27.TextSize = 11
store.TextLabel27.Font = Enum.Font.GothamBold
store.TextLabel27.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel27.Parent = store.Frame60

store["Frame61"] = Instance.new("Frame")
store.Frame61.Name = "Frame"
store.Frame61.Visible = false
store.Frame61.ZIndex = 5
store.Frame61.Position = UDim2.new(0,12,0.5,7)
store.Frame61.Size = UDim2.new(0,113,0,1)
store.Frame61.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame61.BackgroundTransparency = 0.5
store.Frame61.BorderSizePixel = 0
store.Frame61.Parent = store.Frame60

store["Frame62"] = Instance.new("Frame")
store.Frame62.Name = "Frame"
store.Frame62.ZIndex = 6
store.Frame62.Position = UDim2.new(1,-44,0.5,-8)
store.Frame62.Size = UDim2.new(0,32,0,16)
store.Frame62.BackgroundColor3 = Color3.fromRGB(40,40,40)
store.Frame62.BackgroundTransparency = 0.5
store.Frame62.BorderSizePixel = 0
store.Frame62.Parent = store.Frame60

store["UICorner52"] = Instance.new("UICorner")
store.UICorner52.Name = "UICorner"
store.UICorner52.CornerRadius = UDim.new(1,0)
store.UICorner52.Parent = store.Frame62

store["UIStroke34"] = Instance.new("UIStroke")
store.UIStroke34.Name = "UIStroke"
store.UIStroke34.Color = Color3.fromRGB(70,70,70)
store.UIStroke34.Transparency = 0.5
store.UIStroke34.Parent = store.Frame62

store["Frame63"] = Instance.new("Frame")
store.Frame63.Name = "Frame"
store.Frame63.ZIndex = 7
store.Frame63.Position = UDim2.new(0,2,0.5,-6)
store.Frame63.Size = UDim2.new(0,12,0,12)
store.Frame63.BackgroundColor3 = Color3.fromRGB(120,120,120)
store.Frame63.BackgroundTransparency = 0.5
store.Frame63.BorderSizePixel = 0
store.Frame63.Parent = store.Frame62

store["UICorner53"] = Instance.new("UICorner")
store.UICorner53.Name = "UICorner"
store.UICorner53.CornerRadius = UDim.new(1,0)
store.UICorner53.Parent = store.Frame63

store["TextButton30"] = Instance.new("TextButton")
store.TextButton30.Name = "TextButton"
store.TextButton30.ZIndex = 8
store.TextButton30.Size = UDim2.new(1,0,1,0)
store.TextButton30.BackgroundTransparency = 1
store.TextButton30.Text = ""
store.TextButton30.Parent = store.Frame60

store["PressPop4"] = Instance.new("UIScale")
store.PressPop4.Name = "PressPop"
store.PressPop4.Parent = store.Frame60

store["Frame64"] = Instance.new("Frame")
store.Frame64.Name = "Frame"
store.Frame64.ZIndex = 4
store.Frame64.LayoutOrder = 32
store.Frame64.Size = UDim2.new(1,0,0,40)
store.Frame64.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame64.BackgroundTransparency = 0.5
store.Frame64.BorderSizePixel = 0
store.Frame64.Parent = store.Page_Movement

store["UICorner54"] = Instance.new("UICorner")
store.UICorner54.Name = "UICorner"
store.UICorner54.CornerRadius = UDim.new(0,10)
store.UICorner54.Parent = store.Frame64

store["UIStroke35"] = Instance.new("UIStroke")
store.UIStroke35.Name = "UIStroke"
store.UIStroke35.Color = Color3.fromRGB(28,28,34)
store.UIStroke35.Parent = store.Frame64

store["TextLabel28"] = Instance.new("TextLabel")
store.TextLabel28.Name = "TextLabel"
store.TextLabel28.ZIndex = 5
store.TextLabel28.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel28.Size = UDim2.new(0.6,0,0,16)
store.TextLabel28.BackgroundTransparency = 1
store.TextLabel28.Text = "TP Bat"
store.TextLabel28.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel28.TextSize = 11
store.TextLabel28.Font = Enum.Font.GothamBold
store.TextLabel28.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel28.Parent = store.Frame64

store["Frame65"] = Instance.new("Frame")
store.Frame65.Name = "Frame"
store.Frame65.Visible = false
store.Frame65.ZIndex = 5
store.Frame65.Position = UDim2.new(0,12,0.5,7)
store.Frame65.Size = UDim2.new(0,32,0,1)
store.Frame65.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame65.BackgroundTransparency = 0.5
store.Frame65.BorderSizePixel = 0
store.Frame65.Parent = store.Frame64

store["Frame66"] = Instance.new("Frame")
store.Frame66.Name = "Frame"
store.Frame66.ZIndex = 9
store.Frame66.ClipsDescendants = true
store.Frame66.Position = UDim2.new(1,-44,0.5,-11)
store.Frame66.Size = UDim2.new(0,32,0,22)
store.Frame66.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame66.BackgroundTransparency = 0.6
store.Frame66.BorderSizePixel = 0
store.Frame66.Parent = store.Frame64

store["UICorner55"] = Instance.new("UICorner")
store.UICorner55.Name = "UICorner"
store.UICorner55.Parent = store.Frame66

store["TextLabel29"] = Instance.new("TextLabel")
store.TextLabel29.Name = "TextLabel"
store.TextLabel29.ZIndex = 10
store.TextLabel29.Size = UDim2.new(1,0,1,0)
store.TextLabel29.BackgroundTransparency = 1
store.TextLabel29.Text = "None"
store.TextLabel29.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel29.TextSize = 10
store.TextLabel29.TextScaled = true
store.TextLabel29.Font = Enum.Font.GothamBold
store.TextLabel29.TextWrapped = true
store.TextLabel29.Parent = store.Frame66

store["UITextSizeConstraint5"] = Instance.new("UITextSizeConstraint")
store.UITextSizeConstraint5.Name = "UITextSizeConstraint"
store.UITextSizeConstraint5.MinTextSize = 6
store.UITextSizeConstraint5.MaxTextSize = 10
store.UITextSizeConstraint5.Parent = store.TextLabel29

store["TextButton31"] = Instance.new("TextButton")
store.TextButton31.Name = "TextButton"
store.TextButton31.ZIndex = 11
store.TextButton31.Size = UDim2.new(1,0,1,0)
store.TextButton31.BackgroundTransparency = 1
store.TextButton31.Text = ""
store.TextButton31.AutoButtonColor = false
store.TextButton31.Parent = store.Frame66

store["TextButton32"] = Instance.new("TextButton")
store.TextButton32.Name = "TextButton"
store.TextButton32.ZIndex = 12
store.TextButton32.Position = UDim2.new(1,-84,0.5,-11)
store.TextButton32.Size = UDim2.new(0,32,0,22)
store.TextButton32.BackgroundColor3 = Color3.fromRGB(0,0,0)
store.TextButton32.BackgroundTransparency = 0.5
store.TextButton32.BorderSizePixel = 0
store.TextButton32.Text = ""
store.TextButton32.AutoButtonColor = false
store.TextButton32.Parent = store.Frame64

store["UICorner56"] = Instance.new("UICorner")
store.UICorner56.Name = "UICorner"
store.UICorner56.CornerRadius = UDim.new(0,6)
store.UICorner56.Parent = store.TextButton32

store["UIStroke36"] = Instance.new("UIStroke")
store.UIStroke36.Name = "UIStroke"
store.UIStroke36.Color = Color3.fromRGB(254,254,254)
store.UIStroke36.Thickness = 1.4
store.UIStroke36.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
store.UIStroke36.Transparency = 0.25
store.UIStroke36.Parent = store.TextButton32

store["UIGradient17"] = Instance.new("UIGradient")
store.UIGradient17.Name = "UIGradient"
store.UIGradient17.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(90,90,90)),ColorSequenceKeypoint.new(0.48,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(90,90,90))})
store.UIGradient17.Parent = store.UIStroke36

store["TextLabel30"] = Instance.new("TextLabel")
store.TextLabel30.Name = "TextLabel"
store.TextLabel30.ZIndex = 20
store.TextLabel30.Size = UDim2.new(1,0,1,0)
store.TextLabel30.BackgroundTransparency = 1
store.TextLabel30.Text = "▼"
store.TextLabel30.TextColor3 = Color3.fromRGB(254,254,254)
store.TextLabel30.TextSize = 15
store.TextLabel30.Font = Enum.Font.GothamBlack
store.TextLabel30.Parent = store.TextButton32

store["Frame67"] = Instance.new("Frame")
store.Frame67.Name = "Frame"
store.Frame67.Visible = false
store.Frame67.ZIndex = 4
store.Frame67.LayoutOrder = 34
store.Frame67.Size = UDim2.new(1,0,0,34)
store.Frame67.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame67.BackgroundTransparency = 0.5
store.Frame67.BorderSizePixel = 0
store.Frame67.Parent = store.Page_Movement

store["UICorner57"] = Instance.new("UICorner")
store.UICorner57.Name = "UICorner"
store.UICorner57.CornerRadius = UDim.new(0,12)
store.UICorner57.Parent = store.Frame67

store["UIStroke37"] = Instance.new("UIStroke")
store.UIStroke37.Name = "UIStroke"
store.UIStroke37.Color = Color3.fromRGB(35,35,45)
store.UIStroke37.Transparency = 0.4
store.UIStroke37.Parent = store.Frame67

store["TextLabel31"] = Instance.new("TextLabel")
store.TextLabel31.Name = "TextLabel"
store.TextLabel31.ZIndex = 5
store.TextLabel31.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel31.Size = UDim2.new(1,-136,0,16)
store.TextLabel31.BackgroundTransparency = 1
store.TextLabel31.Text = "TP Mode"
store.TextLabel31.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel31.TextSize = 11
store.TextLabel31.Font = Enum.Font.GothamBold
store.TextLabel31.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel31.TextTruncate = Enum.TextTruncate.AtEnd
store.TextLabel31.Parent = store.Frame67

store["Frame68"] = Instance.new("Frame")
store.Frame68.Name = "Frame"
store.Frame68.Visible = false
store.Frame68.ZIndex = 5
store.Frame68.Position = UDim2.new(0,12,0.5,7)
store.Frame68.Size = UDim2.new(0,43,0,1)
store.Frame68.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame68.BackgroundTransparency = 0.5
store.Frame68.BorderSizePixel = 0
store.Frame68.Parent = store.Frame67

store["TextButton33"] = Instance.new("TextButton")
store.TextButton33.Name = "TextButton"
store.TextButton33.ZIndex = 5
store.TextButton33.Position = UDim2.new(1,-118,0.5,-12)
store.TextButton33.Size = UDim2.new(0,50,0,24)
store.TextButton33.BackgroundColor3 = Color3.fromRGB(30,30,30)
store.TextButton33.BackgroundTransparency = 0.5
store.TextButton33.BorderSizePixel = 0
store.TextButton33.Text = "V1"
store.TextButton33.TextColor3 = Color3.fromRGB(165,165,170)
store.TextButton33.TextSize = 10
store.TextButton33.Font = Enum.Font.GothamBold
store.TextButton33.AutoButtonColor = false
store.TextButton33.Parent = store.Frame67

store["UICorner58"] = Instance.new("UICorner")
store.UICorner58.Name = "UICorner"
store.UICorner58.Parent = store.TextButton33

store["TextButton34"] = Instance.new("TextButton")
store.TextButton34.Name = "TextButton"
store.TextButton34.ZIndex = 5
store.TextButton34.Position = UDim2.new(1,-62,0.5,-12)
store.TextButton34.Size = UDim2.new(0,50,0,24)
store.TextButton34.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.TextButton34.BackgroundTransparency = 0.5
store.TextButton34.BorderSizePixel = 0
store.TextButton34.Text = "V2"
store.TextButton34.TextColor3 = Color3.fromRGB(0,0,0)
store.TextButton34.TextSize = 10
store.TextButton34.Font = Enum.Font.GothamBold
store.TextButton34.AutoButtonColor = false
store.TextButton34.Parent = store.Frame67

store["UICorner59"] = Instance.new("UICorner")
store.UICorner59.Name = "UICorner"
store.UICorner59.Parent = store.TextButton34

store["Frame69"] = Instance.new("Frame")
store.Frame69.Name = "Frame"
store.Frame69.Visible = false
store.Frame69.ZIndex = 4
store.Frame69.LayoutOrder = 36
store.Frame69.Size = UDim2.new(1,0,0,40)
store.Frame69.BackgroundColor3 = Color3.fromRGB(18,18,18)
store.Frame69.BackgroundTransparency = 0.5
store.Frame69.BorderSizePixel = 0
store.Frame69.Parent = store.Page_Movement

store["UICorner60"] = Instance.new("UICorner")
store.UICorner60.Name = "UICorner"
store.UICorner60.CornerRadius = UDim.new(0,10)
store.UICorner60.Parent = store.Frame69

store["UIStroke38"] = Instance.new("UIStroke")
store.UIStroke38.Name = "UIStroke"
store.UIStroke38.Color = Color3.fromRGB(28,28,34)
store.UIStroke38.Parent = store.Frame69

store["TextLabel32"] = Instance.new("TextLabel")
store.TextLabel32.Name = "TextLabel"
store.TextLabel32.ZIndex = 5
store.TextLabel32.Position = UDim2.new(0,12,0.5,-9)
store.TextLabel32.Size = UDim2.new(0.6,0,0,16)
store.TextLabel32.BackgroundTransparency = 1
store.TextLabel32.Text = "Auto Swing"
store.TextLabel32.TextColor3 = Color3.fromRGB(255,255,255)
store.TextLabel32.TextSize = 11
store.TextLabel32.Font = Enum.Font.GothamBold
store.TextLabel32.TextXAlignment = Enum.TextXAlignment.Left
store.TextLabel32.Parent = store.Frame69

store["Frame70"] = Instance.new("Frame")
store.Frame70.Name = "Frame"
store.Frame70.Visible = false
store.Frame70.ZIndex = 5
store.Frame70.Position = UDim2.new(0,12,0.5,7)
store.Frame70.Size = UDim2.new(0,57,0,1)
store.Frame70.BackgroundColor3 = Color3.fromRGB(254,254,254)
store.Frame70.BackgroundTransparency = 0.5
store.Frame70.BorderSizePixel = 0
store.Frame70.Pa…"
 content://media/external/downloads/1000098769#:~:text=local%20Players%20%3D%20game,end)%0A%09end%0Aend)