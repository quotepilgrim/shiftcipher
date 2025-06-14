local label = require("label")
local button = require("button")
local textfield = require("textfield")
local gridshift = require("gridshift")

local y = 0
local x = 10
local margin = 8

local t = {}

t.labels = {}
t.buttons = {}
t.textfields = {}

function t.load()
	table.insert(
		t.labels,
		label.new({
			x = x,
			y = y,
			text = "Input:",
		})
	)

	y = y + t.labels[#t.labels].h
	table.insert(
		t.textfields,
		textfield.new({
			x = x,
			y = y,
			id = "input",
		})
	)

	y = y + margin + t.textfields[#t.textfields].h
	table.insert(
		t.labels,
		label.new({
			x = x,
			y = y,
			text = "Output:",
		})
	)

	y = y + t.labels[#t.labels].h
	table.insert(
		t.textfields,
		textfield.new({
			x = x,
			y = y,
			id = "output",
		})
	)

	y = y + margin + t.textfields[#t.textfields].h
	table.insert(t.labels, label.new({ x = x, y = y, text = "Shifts:" }))

	x = x + math.floor(margin * 0.5) + t.labels[#t.labels].w
	table.insert(
		t.textfields,
		textfield.new({
			x = x,
			y = y,
			w = 250,
			h = t.labels[#t.labels].h - 2,
			id = "rules",
			text = "",
		})
	)

	x = x + margin * 2 + t.textfields[#t.textfields].w
	table.insert(t.labels, label.new({ x = x, y = y, text = "Keyword:" }))

	x = x + math.floor(margin * 0.5) + t.labels[#t.labels].w
	table.insert(
		t.textfields,
		textfield.new({
			x = x,
			y = y,
			w = 233,
			h = t.textfields[#t.textfields].h,
			id = "key",
		})
	)

	x = t.labels[#t.labels - 1].x
	y = y + margin + t.textfields[#t.textfields].h
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Encipher",
			callback = function()
				local input, output, ruleset, keyword
				for _, field in ipairs(t.textfields) do
					if field.id == "input" then
						input = field
					elseif field.id == "output" then
						output = field
					elseif field.id == "rules" then
						ruleset = field.text
					elseif field.id == "key" then
						keyword = field.text
					end
				end
				output.text = gridshift.encipher(input.text, ruleset, keyword)
			end,
		})
	)

	x = x + margin + t.buttons[#t.buttons].w
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Decipher",
			callback = function()
				local input, output, ruleset, keyword
				for _, field in ipairs(t.textfields) do
					if field.id == "input" then
						input = field
					elseif field.id == "output" then
						output = field
					elseif field.id == "rules" then
						ruleset = field.text
					elseif field.id == "key" then
						keyword = field.text
					end
				end
				output.text = gridshift.decipher(input.text, ruleset, keyword)
			end,
		})
	)

	x = x + margin + t.buttons[#t.buttons].w
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Swap",
			callback = function()
				local output, input
				for _, field in ipairs(t.textfields) do
					if field.id == "output" then
						output = field
					elseif field.id == "input" then
						input = field
					end
				end
				input.text, output.text = output.text, input.text
			end,
		})
	)

	x = x + margin * 12 + t.buttons[#t.buttons].w - 2
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Clear",
			callback = function()
				for _, field in ipairs(t.textfields) do
					if field.enabled then
						field.text = ""
						break
					end
				end
			end,
		})
	)

	x = x + margin + t.buttons[#t.buttons].w
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Copy",
			callback = function()
				for _, field in ipairs(t.textfields) do
					if field.enabled then
						love.system.setClipboardText(field.text)
						break
					end
				end
			end,
		})
	)

	x = x + margin + t.buttons[#t.buttons].w
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Paste",
			callback = function()
				for _, field in ipairs(t.textfields) do
					if field.enabled then
						field.text = field.text .. love.system.getClipboardText()
						textfield.update_cursor(field)
					end
				end
			end,
		})
	)

	x = x + margin * 12 + t.buttons[#t.buttons].w
	table.insert(
		t.buttons,
		button.new({
			x = x,
			y = y,
			text = "Clear all",
			callback = function()
				for _, field in ipairs(t.textfields) do
					field.text = ""
				end
			end,
		})
	)
end

return t
