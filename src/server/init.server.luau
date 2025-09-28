local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events
local PlayerValues = script.PlayerValues

local function onPlayerAdded(player: Player)
    local values = PlayerValues:Clone()
    values.Parent = player
    
    values.CharacterValue.Value = "Dafault"
    Events.CharacterSelected:FireClient(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
    onPlayerAdded(player)
end