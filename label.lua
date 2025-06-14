local t = {}
local font

function t.load()
	font = love.graphics.getFont()
end

function t.new(arg)
	arg = arg or {}
	local text = arg.text or "LABEL"
	return {
		id = arg.id or nil,
		text = text,
		x = arg.x or 0,
		y = arg.y or 0,
		w = font:getWidth(text),
		h = font:getHeight(text) + 10,
	}
end

function t.draw(label)
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.rectangle("fill", label.x, label.y + 5, label.w, label.h - 10)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(label.text, label.x, label.y + 3)
end

return t
