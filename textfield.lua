local screen = require("screen")
local utf8 = require("utf8")
local font, wrapped

local t = {}

local cursor_x, cursor_y = 0, 0
local font_height
local cursor_visible = true
local cursor_timer = 0.5

function t.load()
	font = love.graphics.getFont()
	font_height = font:getHeight()
end

function t.new(arg)
	return {
		id = arg.id or nil,
		x = arg.x or 0,
		y = arg.y or 0,
		w = arg.w or 620,
		h = arg.h or 175,
		text = arg.text or "",
		limit = arg.limit or nil,
	}
end

function t.draw(field)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill", field.x, field.y, field.w, field.h)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", field.x + 0.5, field.y + 0.5, field.w, field.h)
	love.graphics.stencil(function()
		love.graphics.rectangle("fill", field.x, field.y, field.w, field.h)
	end)
	love.graphics.setStencilTest("greater", 0)
	love.graphics.printf(field.text, field.x + 5, field.y, field.w - 10)
	if field.enabled and cursor_visible then
		love.graphics.rectangle("fill", cursor_x, cursor_y, 1, font_height - 2)
	end
	love.graphics.setStencilTest()
end

function t.update(dt)
	if cursor_timer > 0 then
		cursor_timer = cursor_timer - dt
	else
		cursor_timer = 0.5
		cursor_visible = not cursor_visible
	end
end

function t.update_cursor(field)
	_, wrapped = font:getWrap(field.text, field.w - 10)
	cursor_x = field.x + 5 + font:getWidth(wrapped[#wrapped])
	cursor_y = field.y + 4 + font:getHeight() * (#wrapped - 1)
end

function t:mousepressed(field)
	if
		screen.mx > field.x
		and screen.mx < field.x + field.w
		and screen.my > field.y
		and screen.my < field.y + field.h
	then
		field.enabled = true
		self.last_clicked = field
		self.update_cursor(field)
	else
		field.enabled = false
	end
end

function t:textinput(field, c)
	if not field.enabled then
		return
	end
	if field.limit and #field.text + 1 > field.limit then
		return
	end
	field.text = field.text .. c
	self.update_cursor(field)
	if #wrapped * font_height > field.h then
		self:keypressed(field, "backspace")
		return
	end
end

function t:keypressed(field, key)
	if not field.enabled then
		return
	end
	if key == "backspace" then
		local byteoffset = utf8.offset(field.text, -1)
		if byteoffset then
			field.text = string.sub(field.text, 1, byteoffset - 1)
		end
		self.update_cursor(field)
	end
end

return t
