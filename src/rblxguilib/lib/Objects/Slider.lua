local Slider = {}
Slider.__index = Slider

local util = require(script.Parent.Parent.GUIUtil)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Slider,GUIObject)

function Slider:SetDisabled(State)
    self.Disabled = State
    self.SliderSelected = false
    if self.Disabled then
        self.CursorIcon = "rbxasset://SystemCursors/Forbidden"
        self.SlideBar.BackgroundTransparency, self.SlideButton.BackgroundTransparency = 0.5, 0.5
    else
        self.CursorIcon = "rbxasset://SystemCursors/PointingHand"
        self.SlideBar.BackgroundTransparency, self.SlideButton.BackgroundTransparency = 0, 0
    end
end

function Slider:ToggleDisable()
    self:SetDisabled(not self.Disabled)
end

function Slider:Changed(func)
    self.Action = func
end

function Slider.new(Min, Max, InitalValue, Increment, Size, Disabled, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Slider)
    Increment = Increment or 0
    InitalValue = InitalValue or Min
    self.SliderFrame = Instance.new("Frame", self.Frame)
    self.SliderFrame.BackgroundTransparency = 1
    self.SlideBar = Instance.new("Frame", self.SliderFrame)
    self.SlideBar.AnchorPoint = Vector2.new(0.5,0.5)
    self.SlideBar.Position = UDim2.new(0.5,0,0.5,0)
    Size = util.GetScale(Size) or UDim.new(1,-20)
    self.SlideBar.Size = UDim2.new(Size.Scale, Size.Offset, 0, 5)
    util.ColorSync(self.SlideBar, "BackgroundColor3", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
    self.SlideButton = Instance.new("TextButton", self.SlideBar)
    self.SlideButton.Text = ""
    self.SlideButton.AnchorPoint = Vector2.new(0.5,0.5)
    self.SlideButton.Position = UDim2.new((InitalValue-Min)/(Max-Min),0,0.5,0)
    self.SlideButton.Size = UDim2.new(0,8,0,16)
    util.ColorSync(self.SlideButton, "BackgroundColor3", Enum.StudioStyleGuideColor.Border)
    util.ColorSync(self.SlideButton, "BorderColor3", Enum.StudioStyleGuideColor.InputFieldBorder)
    self.SlideBar.BorderSizePixel = 0
    self.SliderSelected = false
    self.InitialX = 0
    self.SlideButton.MouseButton1Down:Connect(function(x)
        if self.Disabled then return end
        self.SliderSelected = true
        self.InitialX = self.SlideButton.AbsolutePosition.X - x
    end)
    self.PreviousValue = InitalValue
    _G.InputFrame.MouseMoved:Connect(function(x)
        if not self.SliderSelected then return end
        self.Value = util.RoundNumber(math.clamp((x + self.InitialX - self.SlideBar.AbsolutePosition.X + self.SlideButton.Size.X.Offset / 2)/self.SlideBar.AbsoluteSize.X, 0, 1) * (Max - Min) + Min, Increment)
        self.SlideButton.Position = UDim2.new((self.Value-Min)/(Max - Min), 0, 0.5, 0)
        if self.Value ~= self.PreviousValue then
            self.PreviousValue = self.Value
            if self.Action then self.Action(self.Value) end
        end
    end)
    _G.InputFrame.InputEnded:Connect(function(p)
        if self.SliderSelected and p.UserInputType == Enum.UserInputType.MouseButton1 then self.SliderSelected = false end
    end)
    _G.InputFrame.MouseLeave:Connect(function() if self.SliderSelected then self.SliderSelected = false end end)
    self.SlideButton.MouseMoved:Connect(function()
        _G.PluginObject:GetMouse().Icon = self.CursorIcon
    end)
    self.SlideButton.MouseLeave:Connect(function()
        task.wait(0)
        _G.PluginObject:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
    end)
    self:SetDisabled(Disabled)
    self.Object = self.SlideButton
    self.MainMovable = self.SliderFrame
    return self
end

return Slider