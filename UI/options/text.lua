
return function(Page, textContent, Library)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextElement"
    TextLabel.Size = UDim2.new(1, 0, 0, 24)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = textContent or "— TEXT —"
    TextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 13
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center -- Текст будет ровно по центру вкладки
    TextLabel.Parent = Page
    
    -- Добавим небольшой отступ сверху и снизу, чтобы элементы не слипались
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 4)
    UIPadding.Parent = TextLabel

    return TextLabel
end
