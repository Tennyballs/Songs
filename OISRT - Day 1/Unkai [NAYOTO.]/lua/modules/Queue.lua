local SongPosition = import "SongPosition";
local Queue = {
	Stack = {},
};
local Meta = {
	__index = Queue,
	__call = function(self,...)
		return self:Create(unpack(arg));
	end,
};

local fLastMusicSeconds = SongPosition.GetMusicSecondsVisible();
local iFrame = 0;

local TABLE_MAX = 10000;

local function copy(orig)
	local res = {};
	for k,v in pairs(orig) do
		rawset(res,k,v);
	end
	return res;
end

local function StartType(param)
	return param.Beat and "Beat" or param.Time and "Time";
end

local function ApplyModifiers(mods,player)
	if type(player) == "table" then
		for i,v in player do
			ApplyModifiers(mods,v);
		end
	else
		if GameState.ApplyModifiers then
			GAMESTATE:ApplyModifiers(mods,player);
		else
			GAMESTATE:ApplyGameCommand("mod,"..mods,player);
		end
	end
end

function Queue:Create(param)
	local sType = StartType(param);
	assert(sType);
	local fStart = param[sType];
	local fLength = 0;
	if param["Len"] then
		fLength = param["Len"];
	elseif param["End"] then
		fLength = param["End"] - fStart;
	end
	local tNewParam = {
		[sType] = fStart,
		Length = fLength,
		Mod = param["Mod"],
		Cmd = param["Cmd"],
		Player = param["Player"],
	};
	table.insert(self.Stack,copy(tNewParam));
	return setmetatable(tNewParam,Meta);
end

function Queue:Add(param)
	local orig = copy(self);
	local sType = StartType(param) or StartType(orig);
	assert(sType);
	local fStart = orig[sType] + orig["Length"];
	if param[sType] then
		fStart = param[sType];
	end
	local tNewParam = {
		[sType] = fStart,
		Len = param["Len"],
		End = param["End"],
		Mod = param["Mod"],
		Cmd = param["Cmd"],
		Player = param["Player"] or orig["Player"],
	};
	return self:Create(tNewParam);
end

function Queue:Update(children)
	local i = 1;
	local Stack = self.Stack;
	while next(Stack) and i < TABLE_MAX do
		local v = Stack[i];
		if not v then
			break;
		end
		local fCurrentBeat = SongPosition.GetSongBeatVisible();
		local fCurrentTime = SongPosition.GetMusicSecondsVisible();
		local fElapsed = v.Beat and fCurrentBeat or fCurrentTime;
		local fStart = v.Beat or v.Time;
		local fLength = v.Length;
		local fEnd = fStart + fLength;
		local bBegan = fStart < fElapsed;
		local bEnded = fEnd < fElapsed;
		if bBegan then
			if type(v.Mod) == "string" then
				ApplyModifiers(v.Mod,v.Player);
			elseif type(v.Cmd) == "function" then
				local fDeltaTime = fCurrentTime - fLastMusicSeconds;
				local fDuration = math.min(fElapsed,fEnd) - fStart;
				local fPercent = fDuration / fLength;
				local param = {
					Type = StartType(v),
					Start = fStart,
					Length = fLength,
					End = fEnd,
					Beat = fCurrentBeat,
					Time = fCurrentTime,
					Delta = fDeltaTime,
					Frame = iFrame,
					Duration = fDuration,
					Percent = math.min(fPercent,1.0),
					Player = v.Player,
				};
				v.Cmd(children,param);
			elseif type(v.Cmd) == "string" then
				bEnded = true;
				MESSAGEMAN:Broadcast(v.Cmd);
			end
		end
		if bEnded then
			table.remove(Stack,i);
		else
			i = i + 1;
		end
	end
	fLastMusicSeconds = SongPosition.GetMusicSecondsVisible();
	iFrame = iFrame + 1;
end

return setmetatable(Queue,Meta);
