-------------------------------------------------------------------
-- Robert Penner's easing functions                              --
-- License: http://www.robertpenner.com/easing_terms_of_use.html --
-------------------------------------------------------------------
local easing = {};

local function invert(ease,x)
	local x = 1 - x;
	return 1 - ease(x);
end

local function easeinout(easein,easeout,x)
	local x = x * 2;
	if x < 1 then
		return easein(x) / 2;
	else
		local x = 2 - x;
		return (1 - easeout(x)) / 2 + 0.5;
	end
end

function easing.inquad(x)
	return x * x;
end
function easing.outquad(x) return invert(easing.inquad,x); end
function easing.inoutquad(x)
	return easeinout(easing.inquad,easing.outquad,x);
end
function easing.incubic(x)
	return x * x * x;
end
function easing.outcubic(x) return invert(easing.incubic,x); end
function easing.inoutcubic(x)
	return easeinout(easing.incubic,easing.outcubic,x);
end
function easing.inquart(x)
	return x * x * x * x;
end
function easing.outquart(x) return invert(easing.inquart,x); end
function easing.inoutquart(x)
	return easeinout(easing.inquart,easing.outquart,x);
end
function easing.inquint(x)
	return x * x * x * x * x;
end
function easing.outquint(x) return invert(easing.inquint,x); end
function easing.inoutquint(x)
	return easeinout(easing.inquint,easing.outquint,x);
end
function easing.insine(x)
	return 1 - math.cos((x * math.pi) / 2);
end
function easing.outsine(x) return invert(easing.insine,x); end
function easing.inoutsine(x)
	return easeinout(easing.insine,easing.outsine,x);
end
function easing.inexpo(x)
	return x < 0 and 0 or math.pow(2,10 * x - 10);
end
function easing.outexpo(x) return invert(easing.inexpo,x); end
function easing.inoutexpo(x)
	return easeinout(easing.inexpo,easing.outexpo,x);
end
function easing.incirc(x)
	return 1 - math.sqrt(1 - math.pow(x,2));
end
function easing.outcirc(x) return invert(easing.incirc,x); end
function easing.inoutcirc(x)
	return easeinout(easing.incirc,easing.outcirc,x);
end
function easing.inelastic(x)
	if t < 0 then return 0; end
	if t > 1 then return 1; end
	local c4 = (2 * math.pi) / 3;
	return -math.pow(2,10 * x - 10) * math.sin((x * 10 - 10.75) * c4);
end
function easing.outelastic(x) return invert(easing.inelastic,x); end
function easing.inoutelastic(x)
	return easeinout(easing.inelastic,easing.outelastic,x);
end
function easing.inback(x)
	local c1 = 1.70158;
	local c3 = c1 + 1;
	return c3 * x * x * x - c1 * x * x;
end
function easing.outback(x) return invert(easing.inback,x); end
function easing.inoutback(x)
	return easeinout(easing.inback,easing.outback,x);
end
function easing.inbounce(x) return invert(easing.outbounce,x); end
function easing.outbounce(x)
	local n1 = 7.5625;
	local d1 = 2.75;
	if x < 1 / d1 then
		return n1 * x ^ 2;
	elseif x < 2 / d1 then
		return n1 * (x - 1.5 / d1) * x + 0.75;
	elseif x < 2.5 / d1 then
		return n1 * (x - 2.25 / d1) * x + 0.9375;
	else
		return n1 * (x - 2.625 / d1) * x + 0.984375;
	end
end
function easing.inoutbounce(x)
	return easeinout(easing.inbounce,easing.outbounce,x);
end

return setmetatable(easing,{
	__index = function(self,key)
		return self[string.lower(key)];
	end
});
