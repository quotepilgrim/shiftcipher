local screen = require("screen")

local t = {}
local font

function t.load()
	font = love.graphics.getFont()
end

function t.new(arg)
	arg = arg or {}
	local text = arg.text or "BUTTON"
	return {
		id = arg.id or nil,
		text = text,
		x = arg.x or 0,
		y = arg.y or 0,
		w = font:getWidth(text) + 10,
		h = font:getHeight(text) + 10,
		hover = false,
		callback = arg.callback,
	}
end

function t.draw(button)
	if button.hover then
		love.graphics.setColor(1, 0, 0, 1)
	end
	love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(button.text, button.x + 5, button.y + 3)
	love.graphics.setColor(1, 1, 1, 1)
end

function t.update(button)
	if
		screen.mx > button.x
		and screen.my > button.y
		and screen.mx < button.x + button.w
		and screen.my < button.y + button.h
	then
		button.hover = true
	else
		button.hover = false
	end
end

function t.mousepressed(button)
	if button.hover and button.callback then
		button.callback()
		return true
	end
	return false
end

return t
