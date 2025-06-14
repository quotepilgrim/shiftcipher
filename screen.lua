local t = {}

t.states = {}

t.w = 640
t.h = 480
t.scale = 1
t.ox, t.oy = 0, 0
t.mx, t.my = 0, 0

function t:resize(w, h)
	self.scale = math.min(w / self.w, h / self.h)
	self.ox = (w - self.w * self.scale) * 0.5
	self.oy = (h - self.h * self.scale) * 0.5
end

return t
