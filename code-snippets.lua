-- ============================== --
-- Letter constrained chat (Snippet)
-- This snippet demonstrates the weighted letter rolling and the message filtering.
-- ============================================================================= --

--PrizePool.lua

--===========--
-- VARIABLES --
--===========--

local Pool = {}

local BOOST_AMOUNT = 6

Pool.LetterChances = {}

--==================--
-- FUNCTIONS (MAIN) --
--==================--

local function updateLetterBoosts(lettersTable)
	for letter, shouldBoost in pairs(lettersTable) do
		if shouldBoost then
			Pool.LetterChances[letter] = BOOST_AMOUNT
			continue
		end

		Pool.LetterChances[letter] = 1
	end
end

function Pool.GetBoostedPrize(lettersTable)
	updateLetterBoosts(lettersTable)

	local filteredPool = {}
	local currentTotal = 0

	for prize, chance in pairs(Pool.LetterChances) do
		filteredPool[prize] = chance
		currentTotal += chance
	end

	if currentTotal == 0 then
		warn("[PoolModule] Total chance is 0, cannot pick a prize!")
		return
	end

	for prize, chance in pairs(filteredPool) do
		filteredPool[prize] = chance / currentTotal
	end

	local random = math.random()
	local cumulative = 0

	for prize, chance in pairs(filteredPool) do
		cumulative += chance
		if random <= cumulative then
			return prize
		end
	end
end

return Pool

--ChatServer.lua

--===========--
-- VARIABLES --
--===========--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local events = require(ReplicatedStorage:WaitForChild("EventRegistry"))

local receiveMessage = events.RemoteEvents.receiveMessage

local modules = ServerScriptService:WaitForChild("Modules")
local mainModules = modules:WaitForChild("Main")
local prizePool = require(mainModules:WaitForChild("PrizePool"))

local ROLL_COOLDOWN = 0.0625
local MAX_LAYOUT_ORDER = 2^31 - 1
local lastLayoutOrder = MAX_LAYOUT_ORDER

local Chat = {}
Chat.lastCall = {}

--==================--
-- FUNCTIONS (MAIN) --
--==================--

function Chat:FilterMessage(player: Player, playerData, message: string)
	if typeof(message) ~= "string" then 
		warn("[ChatService] Message isn't a string!")
		return
	end

	local data = playerData[player]
	if not data then return end

	local tempLetters = table.clone(data)
	local characters = table.create(#message)
	local index = 0

	for i = 1, #message do
		local char = string.sub(message, i, i)
		local lowerChar = string.lower(char) 

		local letterAmount = tempLetters[lowerChar]

		if letterAmount then
			if letterAmount <= 0 then continue end
			tempLetters[lowerChar] -= 1
		end

		index += 1
		characters[index] = char
	end

	playerData[player] = tempLetters

	return table.concat(characters, "")
end

function Chat:GetRandomLetter(player: Player, lettersTable, playerData)
	local now = os.clock()
	if Chat.lastCall[player] and now - Chat.lastCall[player] < ROLL_COOLDOWN then return end
	Chat.lastCall[player] = now

	local randomLetter = prizePool.GetBoostedPrize(lettersTable)
	if not randomLetter then return end

	playerData[player][randomLetter] += 1 

	return randomLetter, playerData[player][randomLetter]
end

return Chat
