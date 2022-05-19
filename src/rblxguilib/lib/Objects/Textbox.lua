local Textbox = {}
Textbox.__index = Textbox

local util = require(script.Parent.Parent.Util)
local GUIObject = require(script.Parent.GUIObject)
setmetatable(Textbox,GUIObject)

function Textbox.new(Text, Font, Alignment, Size, Parent)
    local self = GUIObject.new(Parent)
    setmetatable(self,Textbox)
    if not Alignment then Alignment = Enum.TextXAlignment.Center end
    if not Font then Font = Enum.Font.SourceSans end
    if not Size then Size = 15 end
    self.Textbox = Instance.new("TextLabel", self.Frame)
    self.Textbox.BackgroundTransparency = 1
    self.Textbox.Size = UDim2.new(1,0,1,0)
    self.Textbox.TextXAlignment = Alignment
    self.Textbox.TextSize = Size
    self.Textbox.Font = Font
    self.Textbox.Text = Text
    util.ColorSync(self.Textbox, "TextColor3", Enum.StudioStyleGuideColor.MainText)
    self.Object = self.Textbox
    self.Object.Changed:Connect(function(p)
        if p == "Parent" then
            task.wait(0)
            self.Frame = self.Textbox.Parent
        end
    end)
    self.Frame = self.Textbox.Parent
    return self
end

return Textbox