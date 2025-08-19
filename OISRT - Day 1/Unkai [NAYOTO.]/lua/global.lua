require "modules/Math";
require "modules/Table";
require "modules/Utils";
require "modules/Helper";
require "modules/Spellcard";

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
	local n = table.getn(t);
	return function()
		i = i + 1;
		return t[i];
	end;
end
