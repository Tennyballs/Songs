function math.angle(x1,y1,x2,y2)
	return math.atan2(y2 - y1,x2 - x1);
end

function math.clamp(x,l,h)
	return math.min(math.max(x,l),h);
end

function math.dist(x1,y1,x2,y2)
	return math.hypot(x2 - x1,y2 - y1);
end
math.distance = math.dist;

function math.fmod(x,y)
	return x - math.floor(x/y) * y;
end
math.mod = math.fmod;

function math.frac(x)
	return x - math.trunc(x);
end

math.huge = math.huge or 2^1023;

function math.hypot(...)
	local n = 0;
	for i = 1,#arg do
		n = n + arg[i]^2;
	end
	return math.sqrt(n);
end

function math.modf(x)
	return math.trunc(x),math.frac(x);
end

function math.prandom(m,n)
	return lerp(math.random(),m,n);
end

function math.round(num,ndp)
	local mult = 10 ^ (ndp or 0);
	local func = num < 0 and math.ceil or math.floor;
	return func(num * mult + math.sign(num) * 0.5) / mult;
end

function math.sign(x)
	return x / math.abs(x);
end

function math.rsign()
	return math.random() < 0.5 and -1 or 1;
end

function math.smoothstep(e1,e2,x)
	local t = math.clamp((x - e1) / (e2 - e1),0,1);
	return t ^ 2 * (3 - 2 * t);
end

function math.trunc(x)
	return x < 0 and math.ceil(x) or math.floor(x);
end
