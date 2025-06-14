local t = {}

local alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
local inverse_dirs = { n = "s", e = "w", s = "n", w = "e" }

local function make_square(k)
	local square = {}
	k = k or ""
	local key = (k .. alphabet):lower()
	local uniques = ""
	local seen = {}
	for i = 1, #key do
		local c = key:sub(i, i)
		if not seen[c] then
			uniques = uniques .. c
			seen[c] = true
		end
	end
	for i = 1, 6 do
		square[i] = {}
		for j = 1, 6 do
			local ix = (i - 1) * 6 + j
			square[i][j] = uniques:sub(ix, ix)
		end
	end
	return square
end

local function parse_rules(ruleset)
	local rules = {}
	local function is_dir(c)
		return c == "n" or c == "e" or c == "s" or c == "w"
	end
	local function is_digit(c)
		c = tonumber(c) or 0
		return c >= 1 and c <= 6
	end
	for i = 1, #ruleset do
		local c = ruleset:sub(i, i):lower()
		local nc = ruleset:sub(i + 1, i + 1)
		if is_dir(c) and not is_digit(nc) then
			table.insert(rules, c)
		elseif is_dir(c) and is_digit(nc) then
			i = i + 1
			while is_digit(nc) do
				c = c .. nc
				i = i + 1
				nc = ruleset:sub(i, i)
			end
			table.insert(rules, c)
		end
	end
	return rules
end

local function shift(square, direction, index)
	if direction == "n" then
		local tmp = square[1][index]
		for i = 1, 5 do
			square[i][index] = square[i + 1][index]
		end
		square[6][index] = tmp
	elseif direction == "e" then
		local tmp = square[index][6]
		for i = 6, 2, -1 do
			square[index][i] = square[index][i - 1]
		end
		square[index][1] = tmp
	elseif direction == "s" then
		local tmp = square[6][index]
		for i = 6, 2, -1 do
			square[i][index] = square[i - 1][index]
		end
		square[1][index] = tmp
	elseif direction == "w" then
		local tmp = square[index][1]
		for i = 1, 5 do
			square[index][i] = square[index][i + 1]
		end
		square[index][6] = tmp
	end
end

local function apply_rule(rule, square)
	if not rule then
		return
	end
	local dir, indices = rule:match("(%w)(.*)")
	local indices_found = {}
	for i = 1, #indices do
		indices_found[tonumber(indices:sub(i, i))] = true
	end
	for i = 1, 6 do
		if indices_found[i] or indices == "" then
			shift(square, dir, i)
		else
			shift(square, inverse_dirs[dir], i)
		end
	end
end

local function find_char(c, square)
	for i = 1, 6 do
		for j = 1, 6 do
			if square[i][j] == c then
				return i, j
			end
		end
	end
end

function t.encipher(text, ruleset, keyword, decipher)
	local source_square = make_square()
	local target_square = make_square(keyword)
	local rules = parse_rules(ruleset)
	local rule_index = 1
	local ciphertext = ""
	apply_rule(rules[1], target_square)
	for i = 1, #text do
		local row, col
		local c = text:sub(i, i)
		local cc = ""

		if decipher then
			row, col = find_char(c:lower(), target_square)
			cc = source_square[row] and source_square[row][col] or cc
		else
			row, col = find_char(c:lower(), source_square)
			cc = target_square[row] and target_square[row][col] or cc
		end

		if cc == "" then
			ciphertext = ciphertext .. c
		else
			rule_index = rule_index % #rules + 1
			apply_rule(rules[rule_index], target_square)
			ciphertext = ciphertext .. cc
		end
	end
	return ciphertext
end

function t.decipher(text, ruleset, keyword)
	return t.encipher(text, ruleset, keyword, true)
end

return t
