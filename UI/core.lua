-- UI/core.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    CurrentTab = nil,
    TooltipDelay = 0.6,
    ScreenGui = nil
}

function Library:Tween(object, infoTable, properties)
    local tweenInfo = TweenInfo.new(unpack(infoTable))
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Система анимированных уведомлений (Toast Notifications) внизу экрана
function Library:Notify(title, message, isEnabled)
    if not Library.ScreenGui then return end
    
    local Toast = Instance.new("Frame")
    Toast.Name = "Notification"
    Toast.Size = UDim2.new(0, 230, 0, 55)
    Toast.Position = UDim2.new(1, 20, 1, -80) -- Начальная позиция за экраном справа
    Toast.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Toast.BorderSizePixel = 0
    Toast.ZIndex = 100
    Toast.Parent = Library.ScreenGui
    
    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 8)
    ToastCorner.Parent = Toast
    
    -- Подсвечиваемая неоновая обводка уведомления (Зеленая/Красная)
    local ToastStroke = Instance.new("UIStroke")
    ToastStroke.Color = isEnabled and Color3.fromRGB(0, 220, 120) or Color3.fromRGB(255, 60, 60)
    ToastStroke.Thickness = 1.2
    ToastStroke.Parent = Toast
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 220, 120) or Color3.fromRGB(255, 60, 60)
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Toast
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 8)
    BarCorner.Parent = AccentBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 11
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Toast

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(1, -20, 0, 20)
    MsgLabel.Position = UDim2.new(0, 12, 0, 24)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = message
    MsgLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
    MsgLabel.Font = Enum.Font.GothamMedium
    MsgLabel.TextSize = 13
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.Parent = Toast

    -- Выезд уведомления слева направо
    Library:Tween(Toast, {0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Position = UDim2.new(1, -250, 1, -80)})
    
    task.delay(2.8, function()
        -- Плавный уезд обратно за экран
        Library:Tween(Toast, {0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Position = UDim2.new(1, 20, 1, -80)})
        task.wait(0.4)
        Toast:Destroy()
    end)
end

function Library:CreateWindow(config)
    local WindowName = config.Name or "Xeno Menu"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XenoJubilee_Engine"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Library.ScreenGui = ScreenGui

    -- Главный фрейм
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Красивая тонкая темная обводка для стиля премиум-меню
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- Центральный верхний заголовок активной вкладки
    local TopTabTitle = Instance.new("TextLabel")
    TopTabTitle.Name = "TopTabTitle"
    TopTabTitle.Position = UDim2.new(0, 165, 0, 14)
    TopTabTitle.Size = UDim2.new(1, -215, 0, 25)
    TopTabTitle.BackgroundTransparency = 1
    TopTabTitle.Text = "XENOJUBILEE"
    TopTabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopTabTitle.Font = Enum.Font.GothamBold
    TopTabTitle.TextSize = 15
    TopTabTitle.TextXAlignment = Enum.TextXAlignment.Center
    TopTabTitle.Parent = MainFrame

    -- Кнопка закрытия меню (Крестик ✕)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Position = UDim2.new(1, -34, 0, 14)
    CloseButton.Size = UDim2.new(0, 22, 0, 22)
    CloseButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 11
    CloseButton.Parent = MainFrame

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Нажатие на кнопку K скрывает и открывает главное окно (Уведомления продолжат работать!)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.K then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Логика перетаскивания (Drag)
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Боковая панель (Сайдбар)
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 150, 1, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = SideBar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = SideBar
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 6)
    
    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 14)
    SidePadding.PaddingLeft = UDim.new(0, 8)
    SidePadding.PaddingRight = UDim.new(0, 8)
    SidePadding.Parent = SideBar

    -- Основной контейнер страниц контента
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Position = UDim2.new(0, 165, 0, 48)
    Container.Size = UDim2.new(1, -175, 1, -58)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Панель настроек (Анимированная выезжающая снизу вверх панель)
    local SettingsPanel = Instance.new("Frame")
    SettingsPanel.Name = "SettingsPanel"
    SettingsPanel.Size = Container.Size
    SettingsPanel.Position = UDim2.new(0, 165, 1, 0) -- Скрыта внизу экрана по умолчанию
    SettingsPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SettingsPanel.BorderSizePixel = 0
    SettingsPanel.ZIndex = 10
    SettingsPanel.Parent = MainFrame

    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 10)
    SettingsCorner.Parent = SettingsPanel

    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "MENU SETTINGS"
    SettingsTitle.TextColor3 = Color3.fromRGB(120, 120, 120)
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.TextSize = 13
    SettingsTitle.Parent = SettingsPanel

    -- Кнопка внутри настроек для примера вызова уведомлений
    local DemoButton = Instance.new("TextButton")
    DemoButton.Size = UDim2.new(0, 200, 0, 35)
    DemoButton.Position = UDim2.new(0.5, -100, 0, 50)
    DemoButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DemoButton.Text = "Toggle Anti-Cheat Bypass"
    DemoButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    DemoButton.Font = Enum.Font.GothamMedium
    DemoButton.TextSize = 13
    DemoButton.Parent = SettingsPanel
    local DemoCorner = Instance.new("UICorner")
    DemoCorner.CornerRadius = UDim.new(0, 6)
    DemoCorner.Parent = DemoButton

    local bypassActive = false
    DemoButton.MouseButton1Click:Connect(function()
        bypassActive = not bypassActive
        if bypassActive then
            DemoButton.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
            Library:Notify("Bypass", "Anti-Cheat Protection Activated", true)
        else
            DemoButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Library:Notify("Bypass", "Anti-Cheat Protection Disabled", false)
        end
    end)

    -- Кнопка настроек шестерёнка (Справа внизу)
    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "SettingsButton"
    SettingsBtn.Position = UDim2.new(1, -38, 1, -38)
    SettingsBtn.Size = UDim2.new(0, 26, 0, 26)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    SettingsBtn.Text = "⚙"
    SettingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.TextSize = 15
    SettingsBtn.ZIndex = 11
    SettingsBtn.Parent = MainFrame

    local SettingsBtnCorner = Instance.new("UICorner")
    SettingsBtnCorner.CornerRadius = UDim.new(0, 6)
    SettingsBtnCorner.Parent = SettingsBtn

    local settingsOpen = false
    SettingsBtn.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        if settingsOpen then
            SettingsBtn.TextColor3 = Color3.fromRGB(0, 140, 255)
            Library:Tween(SettingsPanel, {0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 165, 0, 48)})
        else
            SettingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Library:Tween(SettingsPanel, {0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Position = UDim2.new(0, 165, 1, 0)})
        end
    end)

    local WindowAPI = {}
    function WindowAPI:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 34)
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 13
        TabButton.Parent = SideBar

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
        Page.Parent = Container

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
        end)

        -- Функция подсветки и выбора вкладки
        local function SelectThisTab()
            if Library.CurrentTab then
                Library.CurrentTab.Page.Visible = false
                -- Плавное угасание старой вкладки в дефолтный цвет
                Library:Tween(Library.CurrentTab.Button, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    TextColor3 = Color3.fromRGB(160, 160, 160)
                })
            end
            
            -- Если открыты настройки — закрываем их при переключении вкладки
            if settingsOpen then
                settingsOpen = false
                SettingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                Library:Tween(SettingsPanel, {0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Position = UDim2.new(0, 165, 1, 0)})
            end

            Page.Visible = true
            TopTabTitle.Text = tabName:upper()
            
            -- Анимация подсветки активной вкладки неоново-синим цветом
            Library:Tween(TabButton, {0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
                BackgroundColor3 = Color3.fromRGB(0, 140, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            Library.CurrentTab = {Page = Page, Button = TabButton}
        end

        TabButton.MouseButton1Click:Connect(SelectThisTab)

        if not Library.CurrentTab then
            SelectThisTab()
        end

        local TabAPI = {}
        local baseUrl = "https://raw.githubusercontent.com/geragori11/XMENUE/refs/heads/main/UI/options/"
        local optCache = "?t=" .. math.random(1, 999999)
        
        local function loadModule(fileName, ...)
            local targetUrl = baseUrl .. fileName .. optCache
            local success, code = pcall(game.HttpGet, game, targetUrl)
            if not success or not code then return error("Не удалось загрузить: " .. fileName) end
            local chunk, err = loadstring(code)
            if not chunk then return error("Ошибка синтаксиса " .. fileName .. ": " .. tostring(err)) end
            return chunk()(...)
        end

        function TabAPI:AddText(text)
            return loadModule("text.lua", Page, text, Library)
        end

        function TabAPI:AddKeybind(config)
            return loadModule("keybind.lua", Page, config, Library)
        end

        function TabAPI:AddSlider(config)
            return loadModule("slidermove.lua", Page, config, Library)
        end

        function TabAPI:AddColorpicker(config)
            return loadModule("colorpicker.lua", Page, config, Library)
        end

        function TabAPI:AddOneslider(config)
            return loadModule("Oneslider.lua", Page, config, Library)
        end

        return TabAPI
    end

    return WindowAPI
end

return Library
