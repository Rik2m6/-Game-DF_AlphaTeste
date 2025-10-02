-- Server script

-- Normalmente os codigos /server.luau tem a finalidade de passar uma instrução direta ao servidor;
-- Nele é aonde realizamos as chamadas de eventos, podemos configurar uma função no servidor para disparar sempre que certo evento acontecer;

local Players = game:GetService("Players")
-- game:getService vai buscar e fazer o requisito de uma das pastas que servem como pai. [pastas pai referencio as pastas pai principais, mas pode ocorrer de existir uma pasta com filhos dentro dela]
-- Normalmente usamos isso para guarda a pasta dentro de uma variavel no nosso script;
-- "players" a pasta onde fica os players, como o local e todos os outros presentes no servidor.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
--Mais uma vez usamos o getService;
--"ReplicatedStorage" é aonde guardamos os arquivos do nosso sistema que vamos utilizar mais tarde, arquivos esses como modulos e events. [No caso de modelos, sccript, Gui e etc, vamos armazenalos em pastas semelhantes.

local Events = ReplicatedStorage.Events
-- Na linha acima acessamos a pasta events dentro da variavel que criamos a ReplicatedStorage

local PlayerValues = script.PlayerValues
-- Na linha acima chamo o arquivo filho do meu script e o armazeno em uma variavel.

local function onPlayerAdded(player: Player) -- Funcão responsavel por adicionar o arquivo PlayerValues que contem CharacterValue[Uma string que armazena a classe do player]

    local values = PlayerValues:Clone() --Não mandamos O PlayerValues diretamente para o nosso player e sim o clonamos.
    values.Parent = player -- Passando para o server que o nosso values é parente do arquivo player[folder], assim adicionando ele diratamente lá com o nosso PlayerValues clonado.
    
    values.CharacterValue.Value = "Dafault" -- Especificando o nosso CharacterValue padrão.
    Events.CharacterSelected:FireClient(player) -- Chamando o Evento e passando o nosso player para ele.
end

Players.PlayerAdded:Connect(onPlayerAdded) --Chama a função onPlayerAdded quando o player conectar no server.

for _, player in Players:GetPlayers() do
    onPlayerAdded(player) -- faz uma busca pelo o player caso o programa bug e não chame o "Players.PlayerAdded:Connect(onPlayerAdded)"
end