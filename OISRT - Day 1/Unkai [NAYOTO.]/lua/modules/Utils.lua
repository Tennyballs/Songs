import "Global";
local TimingData = import "TimingData";
local gmatch = string.gmatch or string.gfind;
local unpack = unpack or table.unpack;

local function pack(...)
	return { unpack(arg) };
end

function printf(fmt,...)
	print(string.format(fmt,unpack(arg)));
end

function shallowcopy(orig)
	if type(orig) ~= "table" then
		return orig;
	end
	local copy = {};
	for k,v in pairs(orig) do
		copy[k] = v;
	end
	return copy;
end

function deepcopy(orig)
	if type(orig) ~= "table" then
		return orig;
	end
	local copy = {};
	for k,v in next,orig,nil do
		copy[deepcopy(k)] = deepcopy(v);
	end
	return setmetatable(copy,deepcopy(getmetatable(orig)));
end

function rgba(s)
	if type(s) == "table" then
		return unpack(s);
	end
	local i = 1;
	local t = {1,1,1,1};
	local comma = string.find(s,",");
	local pattern = comma and "[^,]+" or "%x%x";
	local base = comma and 10 or 16;
	local div = comma and 1 or 255;
	for w in gmatch(s,pattern) do
		t[i] = tonumber(w,base) / div;
		i = i + 1;
	end
	return unpack(t);
end

function colorlerp(x,before,after)
	local t = {1,1,1,1};
	local l = pack(rgba(before));
	local h = pack(rgba(after));
	for i = 1,4 do
		t[i] = lerp(x,l[i],h[i]);
	end
	return t;
end

function PixelToPercent(pixel)
	return pixel / ARROW_SIZE;
end

function GetAFTAlpha()
	local name = string.lower(PREFSMAN:GetPreference("LastSeenVideoDriver"));
	if string.find(name,"nvidia") then
		return 0.9;
	end
	return 1.0;
end

function SetLastSecondHint(time)
	if GameState.SetSongEndTime then
		local fMusicRate = NOTITG_VERSION < 20210711 and GAMESTATE:GetMusicRate() or 1;
		GAMESTATE:SetSongEndTime(time * fMusicRate);
	end
end

function SetLastBeatHint(beat)
	SetLastSecondHint(TimingData.GetElapsedTimeFromBeatNoOffset(beat));
end
