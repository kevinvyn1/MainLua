local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
--[[

WindUI.Creator.AddIcons("solar", {
    ["CheckSquareBold"] = "rbxassetid://132438947521974",
    ["CursorSquareBold"] = "rbxassetid://120306472146156",
    ["FileTextBold"] = "rbxassetid://89294979831077",
    ["FolderWithFilesBold"] = "rbxassetid://74631950400584",
    ["HamburgerMenuBold"] = "rbxassetid://134384554225463",
    ["Home2Bold"] = "rbxassetid://92190299966310",
    ["InfoSquareBold"] = "rbxassetid://119096461016615",
    ["PasswordMinimalisticInputBold"] = "rbxassetid://109919668957167",
    ["SolarSquareTransferHorizontalBold"] = "rbxassetid://125444491429160",
})--]]

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")
local versionbeta = "V.0.0.1"
function BetaTestingWelcome()
    return WindUI:Popup({
        Title = "Welcome To Hexyra",
        Icon = "rbxassetid://128773645319812",
        Content = "Selamat datang! Terimakasih telah memcoba beta-testing"..tostring(versionbeta),
        Buttons = {
            {
                Title = "Sama-Sama King",
                Icon = "crown",
                Variant = "Tertiary"
            },
        }
    })
end
BetaTestingWelcome()
-- */  Window  /* --
local Window = WindUI:CreateWindow({
    Title = "Hexyra",
    Icon = "rbxassetid://128773645319812", 
    Author = "by Hexyra Studios",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.7,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    
    
    User = {
        Enabled = true,
        Anonymous = true,
    },
    KeySystem = { 
        Key = {"Hexyra--200029182301823999920481039-V0.0.1"},
        Note = "If you load this script, then the risk is your own responsibility.",     
        Thumbnail = {
            Image = "rbxassetid://128773645319812",
            Title = "Thumbnail",
        },       
        URL = "discord.gg/ojukontol",       
        SaveKey = true, 
        KeyValidator = function(EnteredKey)
            if EnteredKey == Key then
                createPopup()
                return true
            end
            return false
        end
    },
})
Window:Tag({
    Title = "v0.0.1",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0, -- from 0 to 13
})
Window:EditOpenButton({
    Title = "Hexyra",
    Icon = "handphone",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})


--==// Main Tabs // ===--
do
    local Main = Window:Tab({
        Title = "| Main",
        Icon = "Home", 
        Locked = false,
    })

    local Run = Main:Toggle({
        Title = "Toggle",
        Desc = "Toggle Description",
        Icon = "bird",
        Type = "Checkbox",
        Value = false, -- default value
        Callback = function(state) 
            print("Toggle Activated" .. tostring(state))
        end
    })
end