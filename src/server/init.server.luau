-- Server script

-- Normalmente os códigos com o sufixo /server.luau têm a finalidade de executar instruções diretamente no servidor.
-- É nele que realizamos chamadas de eventos e configuramos funções no servidor que serão disparadas sempre que certo evento acontecer.

local Players = game:GetService("Players")
-- game:GetService() obtém o acesso a um serviço principal do jogo.
-- Esses serviços podem ser considerados as “pastas-pai” principais do ambiente, e cada uma possui suas funções específicas.
-- Guardamos o serviço dentro de uma variável para facilitar o uso.
-- "Players" é o serviço que contém todos os jogadores conectados ao servidor, incluindo o jogador local e os demais.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Mais uma vez usamos GetService.
-- "ReplicatedStorage" é o serviço onde armazenamos arquivos que precisam ser acessados tanto pelo servidor quanto pelo cliente,
-- como módulos, eventos, e às vezes modelos ou GUIs compartilhadas.
-- (Modelos, scripts e GUIs específicas geralmente são armazenadas em pastas mais adequadas, como ServerStorage ou StarterGui.)

local Events = ReplicatedStorage:WaitForChild("Events")
-- Aqui acessamos a pasta "Events" dentro do ReplicatedStorage e a armazenamos em uma variável.
-- Usamos WaitForChild para garantir que a pasta exista antes de ser acessada.

local PlayerValues = script:WaitForChild("PlayerValues")
-- Aqui acessamos o objeto filho "PlayerValues" dentro do script e o armazenamos em uma variável.

local function onPlayerAdded(player: Player)
    -- Função responsável por adicionar o arquivo "PlayerValues" que contém a propriedade CharacterValue,
    -- usada para armazenar a classe do jogador em formato de string.

    local values = PlayerValues:Clone()
    -- Em vez de enviarmos o PlayerValues original, criamos uma cópia (clone) para o jogador.

    values.Parent = player
    -- Definimos o jogador como pai do clone, adicionando assim o PlayerValues clonado diretamente dentro do player.

    values.CharacterValue.Value = "Default"
    -- Definimos o valor padrão do CharacterValue.

    Events.CharacterSelected:FireClient(player)
    -- Disparamos o evento CharacterSelected para o cliente, passando o player como parâmetro.
end

Players.PlayerAdded:Connect(onPlayerAdded)
-- Conectamos a função onPlayerAdded para ser executada sempre que um jogador entrar no servidor.

for _, player in Players:GetPlayers() do
    onPlayerAdded(player)
    -- Chamamos manualmente a função para todos os jogadores já conectados, caso o evento PlayerAdded não tenha sido disparado.
end
