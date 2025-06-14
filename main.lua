local screen = require("screen")
local button = require("button")
local textfield = require("textfield")
local label = require("label")
local ui = require("ui")
local labels = ui.labels
local buttons = ui.buttons
local fields = ui.textfields

function love.load()
	love.graphics.setDefaultFilter("nearest")
	local font = love.graphics.newFont("awspring.otf", 14)
	screen:resize(love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setFont(font)
	button.load()
	textfield.load()
	label.load()
	ui.load()

	textfield.update_cursor(fields[1])
	textfield.last_clicked = fields[1]
	fields[1].enabled = true
	love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
	for _, btn in ipairs(buttons) do
		button.update(btn)
	end
	textfield.update(dt)
end

function love.draw()
	love.graphics.clear(0.1, 0.1, 0.1)
	love.graphics.push()
	love.graphics.translate(screen.ox, screen.oy)
	love.graphics.scale(screen.scale, screen.scale)
	for _, f in ipairs(fields) do
		textfield.draw(f)
	end
	for _, l in ipairs(labels) do
		label.draw(l)
	end
	for _, b in ipairs(buttons) do
		button.draw(b)
	end
	love.graphics.pop()
end

function love.resize(w, h)
	screen:resize(w, h)
end

function love.mousemoved(x, y)
	screen.mx, screen.my = (x - screen.ox) / screen.scale, (y - screen.oy) / screen.scale
end

function love.textinput(c)
	for _, field in ipairs(fields) do
		textfield:textinput(field, c)
	end
end

function love.keypressed(key)
	for _, field in ipairs(fields) do
		textfield:keypressed(field, key)
	end
end

function love.mousepressed()
	local reenable = false
	for _, btn in ipairs(buttons) do
		if button.mousepressed(btn) then
			reenable = true
		end
	end
	for _, field in ipairs(fields) do
		textfield:mousepressed(field)
	end
	if reenable then
		textfield.last_clicked.enabled = true
		textfield.update_cursor(textfield.last_clicked)
	end
end
