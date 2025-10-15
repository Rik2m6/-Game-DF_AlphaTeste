-- init.client.luau
-- Script principal do lado do cliente (client-side).
-- Sua função é controlar tudo que o jogador vê e interage diretamente:
-- interfaces (GUIs), entrada do teclado/mouse, sons, e respostas a eventos enviados pelo servidor.

-- Serviços principais que o cliente vai utilizar
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Acessa a pasta de eventos compartilhados entre servidor e cliente
local Events = ReplicatedStorage:WaitForChild("Events")

-- Obtém o jogador local (o jogador que está rodando o jogo neste cliente)
local player = Players.LocalPlayer

-- Importa as configurações dos personagens, que contêm informações como vida, força e velocidade
local CharacterConfigs = require(ReplicatedStorage.Configs.CharacterConfigs)

-- Variável global para armazenar o personagem selecionado pelo jogador
local CharacterSelected = nil


-------------------------------------------------------------------
-- 🩸 Função: Cria a interface da barra de vida (HUD)
-------------------------------------------------------------------
local function createGui()
    local playerGui = player:WaitForChild("PlayerGui")
    local LifeGui = playerGui:WaitForChild("Life") -- ScreenGui chamada "Life"
    local lifeParteUm = LifeGui:WaitForChild("LifeBaseParteUm")
    local lifeParteDois = lifeParteUm:WaitForChild("LifeBaseParteDois")

    -- Obtém os pontos de vida do personagem selecionado
    local vidaMax = CharacterSelected.StatusValues.BaseLifePoints

    -- Define parâmetros visuais da barra
    local larguraMinima = 143      -- Largura mínima (pixels)
    local fatorCrescimento = 0.25  -- Aumento de largura por ponto de vida

    -- Calcula a largura final com base na vida máxima
    local larguraBarra = larguraMinima + (vidaMax * fatorCrescimento)

    -- Configura a base da barra (fundo cinza)
    lifeParteUm.Size = UDim2.new(0, larguraBarra, 0, 20)
    lifeParteUm.Position = UDim2.new(0, 20, 0, 5)
    lifeParteUm.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    
    -- Configura a parte verde (vida atual)
    lifeParteDois.Size = UDim2.new(0.80, 0, 0.9, 0)
    lifeParteDois.Position = UDim2.new(0, 1, 0.025, 0)
    lifeParteDois.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
end


-------------------------------------------------------------------
-- ❤️ Função: Atualiza a barra de vida durante o jogo
-------------------------------------------------------------------
local function updateLife(current, max)
    local playerGui = player:WaitForChild("PlayerGui")
    local LifeGui = playerGui:WaitForChild("Life")
    local lifeParteUm = LifeGui:WaitForChild("LifeBaseParteUm")
    local lifeParteDois = lifeParteUm:WaitForChild("LifeBaseParteDois")

    -- Evita erros se algum dado estiver faltando
    if not current or not max then return end

    -- Calcula a porcentagem de vida atual
    local porcentagem = math.clamp(current / max, 0, 1)

    -- Atualiza o tamanho da parte verde conforme a porcentagem de vida
    lifeParteDois.Size = UDim2.new(porcentagem, 0, 0.9, 0)
end


-------------------------------------------------------------------
-- 🧠 Função: Executada quando o jogador seleciona um personagem
-------------------------------------------------------------------
local function onCharacterSelected()
    -- Obtém o nome do personagem escolhido
    local CharacterName = player.PlayerValues.CharacterValue.Value
    if not CharacterName then return end

    -- Busca as configurações do personagem dentro da tabela CharacterConfigs
    CharacterSelected = CharacterConfigs[CharacterName]

    -- Cria a interface de vida correspondente ao personagem
    createGui()
end


-------------------------------------------------------------------
-- ⌨️ Função: Detecta entrada do teclado ou mouse do jogador
-------------------------------------------------------------------
local function onInputBegan(input, processed)
    -- Ignora se a entrada já foi tratada por outro script
    if processed then return end

    -- Exemplo: dispara um evento para o servidor ao apertar a tecla de espaço
    if input.KeyCode == Enum.KeyCode.Space then
        print("Tecla de pulo pressionada!")
        Events.JumpPressed:FireServer() -- Envia o evento ao servidor
    end
end


-------------------------------------------------------------------
-- 🌐 Conexões de eventos
-------------------------------------------------------------------
-- Escuta o evento enviado pelo servidor quando o personagem é selecionado
Events.CharacterSelected.OnClientEvent:Connect(onCharacterSelected)

-- Escuta o evento que atualiza a vida (enviado pelo servidor durante o jogo)
Events.UpdateLife.OnClientEvent:Connect(updateLife)

-- Detecta entradas de teclado e mouse do jogador
UserInputService.InputBegan:Connect(onInputBegan)
