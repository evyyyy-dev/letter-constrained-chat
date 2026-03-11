-- ============================== --
-- Letter-constrained chat (Snippet)
-- This snippet demonstrates the weighted letter rolling and the message filtering.
-- ============================================================================= --

-- Gets a random letter using a weighted chance system.
function Pool.GetBoostedPrize(lettersTable)
	updateLetterBoosts(lettersTable)

	local filteredPool = {}
	local currentTotal = 0

	for prize, chance in pairs(Pool.LetterChances) do
		filteredPool[prize] = chance
		currentTotal += chance
	end

	if currentTotal <= 0 then
		warn("[PoolModule] Total chance is under or equal to 0, cannot pick a prize!")
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

-- Filters the message based on the letters still available.
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
