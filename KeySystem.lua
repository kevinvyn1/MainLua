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

--==// Popup/Notify //===--
function BetaTestingWelcome()
    return WindUI:Notify({
        Title = "Welcome To Hexyra",
        Icon = "rbxassetid://128773645319812",
        Content = "Selamat datang! Terimakasih telah memcoba beta-testing"..tostring(versionbeta),
    })
end

function Notify(Titles,Icons,Contents)
    return WindUI:Notify({
        Title = Titles,
        Icon = Icons,
        Content = Contents,
        Duration = 5,
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
    BackgroundImageTransparency = 1,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    
    
    User = {
        Enabled = true,
        Anonymous = true,
    },
    KeySystem = { 
        Key = "Hexyra--200029182301823999920481039-V0.0.1",
        Note = "If you load this script, then the risk is your own responsibility.",     
        Thumbnail = {
            Image = "rbxassetid://128773645319812",
            Title = "Thumbnail",
        },       
        URL = "discord.gg/ojukontol",       
        SaveKey = true, 
        KeyValidator = function(EnteredKey)
            if EnteredKey == "Hexyra--200029182301823999920481039-V0.0.1" then
                loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
                Notify("Key Validated", "lucide:check", "You have successfully entered the key!")
                Notify("Key Validated", "lucide:check", "Load The Script!")
                return true
            end
            return false
        end
    },
})

