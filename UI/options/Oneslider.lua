-- UI/options/Oneslider.lua
return function(Page, config, Library)
    local SliderName = config.Name or "Toggle Option"
    local TooltipText = config.Info or ""
    local DefaultState = config.Default or false
    local Callback = config.Callback or function() end

    local IsOn = DefaultState

    -- Главный контейнер элемента
    local OnesliderFrame = Instance.new("Frame")
    OnesliderFrame.Name = "Oneslider_" .. SliderName
    OnesliderFrame.Size = UDim2.new(1, 0, 0, 40)
    OnesliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    OnesliderFrame.BorderSizePixel = 0
    OnesliderFrame.Parent = Page

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = OnesliderFrame

    -- Тонкая обводка элемента для красоты
    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(35, 35, 35)
    FrameStroke.Thickness = 1
    FrameStroke.Parent = OnesliderFrame

    -- Текст с названием
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -65, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = SliderName
    Title.TextColor3 = Color3.fromRGB(235, 235, 235)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = OnesliderFrame

    -- Задний трек переключателя (полоска, где катается ползунок)
    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(0, 42, 0, 20)
    Track.Position = UDim2.new(1, -54, 0.5, -10)
    Track.BackgroundColor3 = IsOn and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(40, 40, 40)
    Track.BorderSizePixel = 0
    Track.Parent = OnesliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    -- Сам круглый ползунок (кнопка-шарик)
    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 14, 0, 14)
    -- Смещение в зависимости от начального состояния
    Knob.Position = IsOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    -- Прозрачная кнопка поверх всего элемента для удобного клика
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = OnesliderFrame

    -- Добавляем подсказку, если она указана в инфо
    if TooltipText ~= "" then
        Library:AddTooltip(OnesliderFrame, TooltipText)
    end

    -- Логика переключения и плавных анимаций
    local function Toggle()
        IsOn = not IsOn
        
        if IsOn then
            -- Анимация включения: трек синеет, шарик катится вправо
            Library:Tween(Track, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {BackgroundColor3 = Color3.fromRGB(0, 140, 255)})
            Library:Tween(Knob, {0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = UDim2.new(1, -17, 0.5, -7)})
        else
            -- Анимация выключения: трек сереет, шарик катится влево
            Library:Tween(Track, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            Library:Tween(Knob, {0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 3, 0.5, -7)})
        end

        -- Передаем статус (true/false) в твою функцию обратного вызова
        task.spawn(Callback, IsOn)
    end

    ClickBtn.MouseButton1Click:Connect(Toggle)

    return OnesliderFrame
end
