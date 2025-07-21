function isnil(n) return type(n) == "nil"; end
function isboolean(n) return type(n) == "boolean"; end
function isnumber(n) return type(n) == "number"; end
function isstring(n) return type(n) == "string"; end
function istable(n) return type(n) == "table"; end
function isfunction(n) return type(n) == "function"; end
function isuserdata(n) return type(n) == "userdata"; end
function isthread(n) return type(n) == "thread"; end

function lerp(x,l,h)
	return x * (h - l) + l;
end

function scale(x,l1,h1,l2,h2)
	return (x - l1) * (h2 - l2) / (h1 - l1) + l2;
end

function ivalues(t)
	local i = 0;
	return function()
		i = i + 1;
		return t[i];
	end;
end

function iif(expr,truepart,falsepart)
	return expr and truepart or falsepart;
end

function explode(s,pattern)
	local t = {};
	local i = 1;
	while true do
		local from,to = string.find(s,pattern,i,true);
		if not from then
			break;
		end
		table.insert(t,string.sub(s,i,from-1));
		i = to + 1;
	end
	return t;
end

math = import "MathHelper";
table = import "TableHelper";

NOTITG_VERSION = tonumber(GAMESTATE:GetVersionDate());
NUM_PLAYFIELDS = 8;
ARROW_SIZE = 64;

GRAY_ARROWS_Y_STANDARD = tonumber(THEME:GetMetric("Player","ReceptorArrowsYStandard"));
GRAY_ARROWS_Y_REVERSE = tonumber(THEME:GetMetric("Player","ReceptorArrowsYReverse"));
DRAW_DISTANCE_AFTER_TARGET_PIXELS = tonumber(THEME:GetMetric("Player","StartDrawingAtPixels"));
DRAW_DISTANCE_BEFORE_TARGET_PIXELS = tonumber(THEME:GetMetric("Player","StopDrawingAtPixels"));

NOTEFIELD_HEIGHT = GRAY_ARROWS_Y_REVERSE - GRAY_ARROWS_Y_STANDARD;
NOTEFIELD_MIDDLE = (GRAY_ARROWS_Y_STANDARD + GRAY_ARROWS_Y_REVERSE) / 2;
