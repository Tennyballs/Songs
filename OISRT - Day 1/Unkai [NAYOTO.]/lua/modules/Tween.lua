local Queue = import "Queue";
local TimingData = import "TimingData";
local Tween = {};
local Meta = {
	__call = function(self,...)
		return self:Create(unpack(arg));
	end,
};

local function lerp(x,l,h)
	return x * (h - l) + l;
end

local function copy(orig)
	local res = {};
	for k,v in pairs(orig) do
		rawset(res,k,v);
	end
	return res;
end

local function swap(orig,other)
	for k,v in pairs(other) do
		orig[k] = v or 0;
	end
end

local function ApplyModifiers(mods,player)
	if type(player) == "table" then
		for pn in ivalues(player) do
			ApplyModifiers(mods,pn);
		end
	else
		if GameState.ApplyModifiers then
			GAMESTATE:ApplyModifiers("*-1 "..mods,player);
		else
			GAMESTATE:ApplyGameCommand("mod,*99999 "..mods,player);
		end
	end
end

local function DefaultCallback(self,current,param)
	for k,v in pairs(current) do
		local str = string.format("%f%% %s",v*100,k);
		if string.lower(k) == "xmod" then str = string.format("%fx",v);
	elseif string.lower(k) == "cmod" then str = string.format("C%d",v);
	elseif string.lower(k) == "mmod" then str = string.format("M%d",v);
		end
		ApplyModifiers(str,param.Player);
	end
end

function Tween:Create(param)
	local param = {
		Beat = param.Beat,
		Time = param.Time,
		Tweens = {},
		Current = param.State and copy(param.State) or {},
		Start = {},
		Callback = param.Cmd or DefaultCallback,
		Player = param.Player,
	};
	return setmetatable(param,{ __index = self });
end

function Tween:InitState(param)
	if type(param) == "table" then
		self.Current = copy(param);
	end
	return self;
end

function Tween:Finish()
	local param = {
		Len = 0.000,
		Cmd = function(children,param)
			local fDeltaTime = param.Delta;
			while next(self.Tweens) and fDeltaTime > 0 do
				local TS = self.Tweens[1].State;
				local TI = self.Tweens[1].Info;
				local bBeginning = TI.Remain == TI.Time;
				local fSubtract = math.min(TI.Remain,fDeltaTime);
				TI.Remain = TI.Remain - fSubtract;
				fDeltaTime = fDeltaTime - fSubtract;
				if bBeginning then
					swap(self.Start,self.Current);
				end
				if TI.Remain <= 0 then
					swap(self.Current,TS);
					table.remove(self.Tweens,1);
				else
					local fPercent = 1 - (TI.Remain / TI.Time);
					for k,v in pairs(TS) do
						local fStart = self.Start[k] or 0;
						self.Current[k] = lerp(TI.Easing(fPercent),fStart,v);
					end
				end
			end
			self.Callback(children,self.Current,param);
		end,
		Player = self.Player,
	};
	param.Time = self.Beat and TimingData.GetElapsedTimeFromBeatNoOffset(self.Beat) or self.Time;
	for i,v in ipairs(self.Tweens) do
		param.Len = param.Len + v.Info.Time;
	end
	Queue:Create(param);
end

function Tween:DestTweenState()
	local i = table.getn(self.Tweens);
	if i == 0 then
		return self.Current;
	else
		return self.Tweens[i].State;
	end
end

function Tween:BeginTweening(time,easing)
	do
		local t = { State = {}, Info = {} };
		t.State = copy(self:DestTweenState());
		table.insert(self.Tweens,t);
	end
	do
		local i = table.getn(self.Tweens);
		local TS = self.Tweens[i].State;
		local TI = self.Tweens[i].Info;
		if i > 1 then
			swap(TS,self.Tweens[i-1].State);
		else
			swap(TS,self.Current);
		end
		TI.Easing = easing or (function(t) return t; end);
		TI.Time = time;
		TI.Remain = time;
	end
	return self;
end

function Tween:Easing(time,easing)
	self:BeginTweening(time,easing);
	return self;
end

function Tween:Delay(time)
	self:BeginTweening(time);
	self:BeginTweening(0);
	return self;
end

function Tween:To(param)
	local TS = self:DestTweenState();
	swap(TS,param);
	return self;
end

return setmetatable(Tween,Meta);
