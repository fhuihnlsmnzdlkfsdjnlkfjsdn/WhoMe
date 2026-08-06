local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShopDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ShopDisplay"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- Collect all cases and bundles from ShopDisplay
-- ============================================================

local allCases = {}
local seenCases = {}

local function addCase(item)
	if item and item[4] == "Case" and not seenCases[item[1]] then
		seenCases[item[1]] = true
		table.insert(allCases, {
			name = item[1],
			price = item[2],
			currency = item[3],
			itemType = item[8] or "Knife",
		})
	end
end

for _, item in ipairs(ShopDisplay.getKnifeShop()) do addCase(item) end

local petShop = ShopDisplay.getPetShop()
if petShop then
	for _, item in ipairs(petShop) do addCase(item) end
end

local featured = ShopDisplay.getFeaturedShop()
if featured then
	for _, item in ipairs(featured) do addCase(item) end
end

local allBundles = {}
local seenBundles = {}
for _, item in ipairs(ShopDisplay.getRobuxItems()) do
	if item[3] == "Bundle" and not seenBundles[item[1]] then
		seenBundles[item[1]] = true
		local contents = ShopDisplay.getBundleContents(item[1])
		table.insert(allBundles, {
			name = item[1],
			robuxId = item[2],
			contents = contents or {},
		})
	end
end

-- Key-purchasable cases (using RequestCasePurchaseWithSecondaryKeys)
local keyCases = {
	-- Event / seasonal cases (purchasable with keys)
	{name = "Merry Case", price = 1, currency = "Keys"},
	{name = "Decorated Case", price = 1, currency = "Keys"},
	{name = "Infected Case", price = 1, currency = "Keys"},
	{name = "Skeleton Case", price = 1, currency = "Keys"},
	{name = "Shop Case", price = 1, currency = "Keys"},
	{name = "Festive Case", price = 1, currency = "Keys"},
	{name = "Jolly Case", price = 1, currency = "Keys"},
	{name = "Easter Case", price = 1, currency = "Keys"},
	{name = "Summer Case", price = 1, currency = "Keys"},
	{name = "Coffin Case", price = 1, currency = "Keys"},
	{name = "Valentine Case", price = 1, currency = "Keys"},
	{name = "Spring Case", price = 1, currency = "Keys"},

}

-- Token-purchasable effects (merged from EffectShop)
local allEffects = {
	{name = "Pumpkin Fear", price = 3000, currency = "Tokens"},
	{name = "Autumn", price = 3000, currency = "Tokens"},
	{name = "Rose Petals", price = 3000, currency = "Tokens"},
	{name = "Candy", price = 3500, currency = "Tokens"},
	{name = "Stinky Flies", price = 12345, currency = "Tokens"},
}

-- Token-purchasable knives (new section)
local allKnives = {
	{name = "Darkheart", price = 1, currency = "Tokens"},
	{name = "Legend Hammer", price = 1, currency = "Tokens"},
	{name = "Armor Eye", price = 1, currency = "Tokens"},
	{name = "Dark Age", price = 1, currency = "Tokens"},
	{name = "Flame Thrower", price = 1, currency = "Tokens"},
	{name = "Imp", price = 1, currency = "Tokens"},
	{name = "Jade Maiden", price = 1, currency = "Tokens"},
	{name = "Void", price = 1, currency = "Tokens"},
	{name = "Duality", price = 1, currency = "Tokens"},
	{name = "Onyx", price = 1, currency = "Tokens"},
	{name = "Sakura", price = 1, currency = "Tokens"},
	{name = "Beam Core", price = 1, currency = "Tokens"},
	{name = "Energy Slicer", price = 1, currency = "Tokens"},
	{name = "Fang", price = 1, currency = "Tokens"},
	{name = "Behemoth", price = 1, currency = "Tokens"},
	{name = "Cosmic Eye", price = 1, currency = "Tokens"},
	{name = "Elemental Scimitar", price = 1, currency = "Tokens"},
	{name = "Enchanted Jade", price = 1, currency = "Tokens"},
	{name = "Obsidian Lord", price = 1, currency = "Tokens"},
	{name = "Plasma Slayer", price = 1, currency = "Tokens"},
	{name = "Spider", price = 1, currency = "Tokens"},
	{name = "Tech Slicer", price = 1, currency = "Tokens"},
	{name = "Vortex", price = 1, currency = "Tokens"},
	{name = "Wrath", price = 1, currency = "Tokens"},
	{name = "Ancient Steel", price = 1, currency = "Tokens"},
	{name = "Archangel", price = 1, currency = "Tokens"},
	{name = "Bandit", price = 1, currency = "Tokens"},
	{name = "Blossom Scimitar", price = 1, currency = "Tokens"},
	{name = "Chaos Axe", price = 1, currency = "Tokens"},
	{name = "Crescendo", price = 1, currency = "Tokens"},
	{name = "Dark Blade", price = 1, currency = "Tokens"},
	{name = "Dark Claw", price = 1, currency = "Tokens"},
	{name = "Doombringer", price = 1, currency = "Tokens"},
	{name = "Earthen Blade", price = 1, currency = "Tokens"},
	{name = "Emerald Knight", price = 1, currency = "Tokens"},
	{name = "Epic Blue", price = 1, currency = "Tokens"},
	{name = "Epic Red", price = 1, currency = "Tokens"},
	{name = "Faerie", price = 1, currency = "Tokens"},
	{name = "Fire Scimitar", price = 1, currency = "Tokens"},
	{name = "Flamebrand", price = 1, currency = "Tokens"},
	{name = "Frost Dragon", price = 1, currency = "Tokens"},
	{name = "Fury", price = 1, currency = "Tokens"},
	{name = "Gilded", price = 1, currency = "Tokens"},
	{name = "Hatchet", price = 1, currency = "Tokens"},
	{name = "Hunter", price = 1, currency = "Tokens"},
	{name = "Ice Dagger", price = 1, currency = "Tokens"},
	{name = "Ice Lord", price = 1, currency = "Tokens"},
	{name = "Lava Blade", price = 1, currency = "Tokens"},
	{name = "Misfortune", price = 1, currency = "Tokens"},
	{name = "Nemesis", price = 1, currency = "Tokens"},
	{name = "Noble Dagger", price = 1, currency = "Tokens"},
	{name = "Overseer", price = 1, currency = "Tokens"},
	{name = "Paladin", price = 1, currency = "Tokens"},
	{name = "Phantom", price = 1, currency = "Tokens"},
	{name = "Pharaoh", price = 1, currency = "Tokens"},
	{name = "Proton", price = 1, currency = "Tokens"},
	{name = "Ruby", price = 1, currency = "Tokens"},
	{name = "Shadow", price = 1, currency = "Tokens"},
	{name = "Slab Hammer", price = 1, currency = "Tokens"},
	{name = "Steel Maiden", price = 1, currency = "Tokens"},
	{name = "Striker", price = 1, currency = "Tokens"},
	{name = "Synergy", price = 1, currency = "Tokens"},
	{name = "Unicorn", price = 1, currency = "Tokens"},
	{name = "Water Scimitar", price = 1, currency = "Tokens"}
	
}

-- ============================================================
-- Build the GUI
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CaseShopGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 620, 0, 520)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Cases & Bundles Shop"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -37, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Open button (shows when shop cis closed)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 130, 0, 34)
openButton.Position = UDim2.new(0, 12, 0.5, 0)
openButton.BackgroundColor3 = Color3.fromRGB(60, 140, 210)
openButton.Text = "Open Shop"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ItemList"
scrollFrame.Size = UDim2.new(1, -20, 1, -52)
scrollFrame.Position = UDim2.new(0, 10, 0, 46)
scrollFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = scrollFrame

-- ============================================================
-- Helper functions
-- ============================================================

local function createSection(titleText)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 28)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.TextColor3 = Color3.fromRGB(200, 200, 215)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.Parent = scrollFrame
	return label
end

local function createCaseEntry(case)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 52)
	entry.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	entry.BorderSizePixel = 0
	entry.Parent = scrollFrame

	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = case.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.2, 0, 1, 0)
	priceLabel.Position = UDim2.new(0.47, 0, 0, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = case.price .. " " .. case.currency
	if case.currency == "Tokens" then
		priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif case.currency == "Keys" then
		priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	else
		priceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	end
	priceLabel.Font = Enum.Font.GothamMedium
	priceLabel.TextSize = 13
	priceLabel.Parent = entry

	local xLabel = Instance.new("TextLabel")
	xLabel.Size = UDim2.new(0, 12, 0, 20)
	xLabel.Position = UDim2.new(1, -148, 0.5, -10)
	xLabel.BackgroundTransparency = 1
	xLabel.Text = "x"
	xLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
	xLabel.Font = Enum.Font.GothamMedium
	xLabel.TextSize = 13
	xLabel.Parent = entry

	local amountBox = Instance.new("TextBox")
	amountBox.Size = UDim2.new(0, 35, 0, 30)
	amountBox.Position = UDim2.new(1, -135, 0.5, -15)
	amountBox.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
	amountBox.Text = "1"
	amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	amountBox.Font = Enum.Font.GothamMedium
	amountBox.TextSize = 13
	amountBox.ClearTextOnFocus = false
	amountBox.Parent = entry

	local amountCorner = Instance.new("UICorner")
	amountCorner.CornerRadius = UDim.new(0, 6)
	amountCorner.Parent = amountBox

	amountBox:GetPropertyChangedSignal("Text"):Connect(function()
		local num = tonumber(amountBox.Text)
		if not num or num < 1 then
			amountBox.Text = "1"
		elseif num > 100 then
			amountBox.Text = "100"
		end
	end)

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 75, 0, 32)
	buyButton.Position = UDim2.new(1, -85, 0.5, -16)
	buyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 210)
	buyButton.Text = "Buy"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextSize = 13
	buyButton.Parent = entry

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	buyButton.MouseButton1Click:Connect(function()
		local amount = tonumber(amountBox.Text) or 1
		amount = math.clamp(amount, 1, 100)
		buyButton.Text = "..."
		local itemType = case.itemType or "Knife"
		local allSuccess = true
		for i = 1, amount do
			local success, result = pcall(function()
				return Remotes.RequestItemPurchase:InvokeServer(itemType, "Case", case.name)
			end)
			if not success then
				allSuccess = false
				warn("Case purchase " .. i .. " failed for " .. case.name .. ": " .. tostring(result))
				break
			end
		end
		if allSuccess then
			buyButton.Text = "Done!"
		else
			buyButton.Text = "Failed"
		end
		task.wait(1.5)
		buyButton.Text = "Buy"
	end)
end

local function createKeyCaseEntry(case)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 52)
	entry.BackgroundColor3 = Color3.fromRGB(42, 38, 30)
	entry.BorderSizePixel = 0
	entry.Parent = scrollFrame

	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = case.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 220, 150)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.2, 0, 1, 0)
	priceLabel.Position = UDim2.new(0.47, 0, 0, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = case.price .. " " .. case.currency
	priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	priceLabel.Font = Enum.Font.GothamMedium
	priceLabel.TextSize = 13
	priceLabel.Parent = entry

	local xLabel = Instance.new("TextLabel")
	xLabel.Size = UDim2.new(0, 12, 0, 20)
	xLabel.Position = UDim2.new(1, -148, 0.5, -10)
	xLabel.BackgroundTransparency = 1
	xLabel.Text = "x"
	xLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
	xLabel.Font = Enum.Font.GothamMedium
	xLabel.TextSize = 13
	xLabel.Parent = entry

	local amountBox = Instance.new("TextBox")
	amountBox.Size = UDim2.new(0, 35, 0, 30)
	amountBox.Position = UDim2.new(1, -135, 0.5, -15)
	amountBox.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
	amountBox.Text = "1"
	amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	amountBox.Font = Enum.Font.GothamMedium
	amountBox.TextSize = 13
	amountBox.ClearTextOnFocus = false
	amountBox.Parent = entry

	local amountCorner = Instance.new("UICorner")
	amountCorner.CornerRadius = UDim.new(0, 6)
	amountCorner.Parent = amountBox

	amountBox:GetPropertyChangedSignal("Text"):Connect(function()
		local num = tonumber(amountBox.Text)
		if not num or num < 1 then
			amountBox.Text = "1"
		elseif num > 100 then
			amountBox.Text = "100"
		end
	end)

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 75, 0, 32)
	buyButton.Position = UDim2.new(1, -85, 0.5, -16)
	buyButton.BackgroundColor3 = Color3.fromRGB(180, 140, 50)
	buyButton.Text = "Use Key"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextSize = 12
	buyButton.Parent = entry

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	buyButton.MouseButton1Click:Connect(function()
		local amount = tonumber(amountBox.Text) or 1
		amount = math.clamp(amount, 1, 100)
		buyButton.Text = "..."
		local allSuccess = true
		for i = 1, amount do
			local success, result = pcall(function()
				return Remotes.RequestCasePurchaseWithSecondaryKeys:InvokeServer(case.name)
			end)
			if not success then
				allSuccess = false
				warn("Key case purchase " .. i .. " failed for " .. case.name .. ": " .. tostring(result))
				break
			end
		end
		if allSuccess then
			buyButton.Text = "Done!"
		else
			buyButton.Text = "Failed"
		end
		task.wait(1.5)
		buyButton.Text = "Use Key"
	end)
end

local function createBundleEntry(bundle)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 52)
	entry.BackgroundColor3 = Color3.fromRGB(48, 36, 56)
	entry.BorderSizePixel = 0
	entry.Parent = scrollFrame

	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.3, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = bundle.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 230, 180)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local contentsText = ""
	for i, content in ipairs(bundle.contents) do
		if i > 1 then contentsText = contentsText .. ", " end
		contentsText = contentsText .. content[2]
	end
	if contentsText == "" then contentsText = "View contents" end

	local contentsLabel = Instance.new("TextLabel")
	contentsLabel.Size = UDim2.new(0.35, 0, 1, 0)
	contentsLabel.Position = UDim2.new(0.32, 0, 0, 0)
	contentsLabel.BackgroundTransparency = 1
	contentsLabel.Text = contentsText
	contentsLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
	contentsLabel.Font = Enum.Font.Gotham
	contentsLabel.TextSize = 11
	contentsLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentsLabel.Parent = entry

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 80, 0, 32)
	buyButton.Position = UDim2.new(1, -90, 0.5, -16)
	buyButton.BackgroundColor3 = Color3.fromRGB(210, 145, 55)
	buyButton.Text = "Buy R$"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextSize = 13
	buyButton.Parent = entry

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	buyButton.MouseButton1Click:Connect(function()
		MarketplaceService:PromptProductPurchase(player, bundle.robuxId)
	end)
end

local function createEffectEntry(effect)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 52)
	entry.BackgroundColor3 = Color3.fromRGB(40, 48, 40)
	entry.BorderSizePixel = 0
	entry.Parent = scrollFrame

	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = effect.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.2, 0, 1, 0)
	priceLabel.Position = UDim2.new(0.47, 0, 0, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = effect.price .. " " .. effect.currency
	priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	priceLabel.Font = Enum.Font.GothamMedium
	priceLabel.TextSize = 13
	priceLabel.Parent = entry

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 75, 0, 32)
	buyButton.Position = UDim2.new(1, -85, 0.5, -16)
	buyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 210)
	buyButton.Text = "Buy"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextSize = 13
	buyButton.Parent = entry

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	buyButton.MouseButton1Click:Connect(function()
		buyButton.Text = "..."
		local success, result = pcall(function()
			return Remotes.RequestItemPurchase:InvokeServer("Tokens", "Item", effect.name)
		end)
		if success then
			buyButton.Text = "Done!"
		else
			buyButton.Text = "Failed"
		end
		task.wait(1.5)
		buyButton.Text = "Buy"
	end)
end

local function createKnifeEntry(knife)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 52)
	entry.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	entry.BorderSizePixel = 0
	entry.Parent = scrollFrame

	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = knife.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.2, 0, 1, 0)
	priceLabel.Position = UDim2.new(0.47, 0, 0, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = knife.price .. " " .. knife.currency
	priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	priceLabel.Font = Enum.Font.GothamMedium
	priceLabel.TextSize = 13
	priceLabel.Parent = entry

	local buyButton = Instance.new("TextButton")
	buyButton.Size = UDim2.new(0, 75, 0, 32)
	buyButton.Position = UDim2.new(1, -85, 0.5, -16)
	buyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 210)
	buyButton.Text = "Buy"
	buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyButton.Font = Enum.Font.GothamBold
	buyButton.TextSize = 13
	buyButton.Parent = entry

	local buyCorner = Instance.new("UICorner")
	buyCorner.CornerRadius = UDim.new(0, 6)
	buyCorner.Parent = buyButton

	buyButton.MouseButton1Click:Connect(function()
		buyButton.Text = "..."
		local success, result = pcall(function()
			return Remotes.RequestItemPurchase:InvokeServer("Knife", "Item", knife.name)
		end)
		if success then
			buyButton.Text = "Done!"
		else
			buyButton.Text = "Failed"
		end
		task.wait(1.5)
		buyButton.Text = "Buy"
	end)
end

-- ============================================================
-- Populate the list
-- ============================================================

createSection("CASES (" .. #allCases .. ")")
for _, case in ipairs(allCases) do
	createCaseEntry(case)
end

if #keyCases > 0 then
	createSection("KEY CASES (" .. #keyCases .. ")")
	for _, case in ipairs(keyCases) do
		createKeyCaseEntry(case)
	end
end

if #allBundles > 0 then
	createSection("BUNDLES (" .. #allBundles .. ")")
	for _, bundle in ipairs(allBundles) do
		createBundleEntry(bundle)
	end
end

if #allEffects > 0 then
	createSection("EFFECTS (" .. #allEffects .. ")")
	for _, effect in ipairs(allEffects) do
		createEffectEntry(effect)
	end
end

if #allKnives > 0 then
	createSection("KNIVES (" .. #allKnives .. ")")
	for _, knife in ipairs(allKnives) do
		createKnifeEntry(knife)
	end
end

-- ============================================================
-- Toggle logic
-- ============================================================

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	openButton.Visible = false
end)
