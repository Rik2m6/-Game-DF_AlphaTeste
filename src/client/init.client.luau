local Player = game:GetService("Players")
local player = Player.LocalPlayer

-- Pega a GUI do jogador
local playerGui = player:WaitForChild("PlayerGui")
local LifeGui = playerGui:WaitForChild("Life") -- o nome da ScreenGui

-- Pega as partes da barra de vida
local lifeParteUm = LifeGui:WaitForChild("LifeBaseParteUm")
local lifeParteDois = lifeParteUm:WaitForChild("LifeBaseParteDois")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local CharacterConfigs = require(ReplicatedStorage.Configs.CharacterConfigs)

local CharacterSelected = nil

local function createGui()
    local vidaMax = CharacterSelected.StatusValues.BaseLifePoints
    local larguraMinima = 143  -- largura mínima da barra
    local fatorCrescimento = 0.25 -- pixels por ponto de vida extra

-- calcula a largura final da barra
    local larguraBarra = larguraMinima + (vidaMax * fatorCrescimento)
    lifeParteUm.Size = UDim2.new(0, larguraBarra, 0, 20)
    lifeParteUm.Position = UDim2.new (0, 20, 0, 5)
    lifeParteUm.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    
    lifeParteDois.Size = UDim2.new(0.80, 0, 0.9, 0)
    lifeParteDois.Position = UDim2.new(0, 1, 0.025, 0)
    lifeParteDois.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
end

local function onCharacterSelected()
    local CharacterName = player.PlayerValues.CharacterValue.Value
    CharacterSelected = CharacterConfigs[CharacterName] 
 
    if not CharacterName then return end

    createGui()
end

Events.CharacterSelected.OnClientEvent:Connect(onCharacterSelected)