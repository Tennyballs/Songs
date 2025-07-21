local ActorHelper = import "modules.ActorHelper";
local AntiMashing = import "modules.AntiMashing";
local PlayerHelper = import "modules.PlayerHelper";
local TimingData = import "modules.TimingData";
local Queue = import "modules.Queue";
local Tween = import "modules.Tween";
local easing = import "modules.Easing";

local bIsEdit = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDifficulty() == DIFFICULTY_EDIT;
local iDrawDistanceAfterTargetsPixels = math.trunc(DRAW_DISTANCE_AFTER_TARGET_PIXELS);
local iDrawDistanceBeforeTargetsPixels = math.trunc(DRAW_DISTANCE_BEFORE_TARGET_PIXELS);
local iHeight = iDrawDistanceBeforeTargetsPixels - iDrawDistanceAfterTargetsPixels;
local iOffset = math.ceil(iHeight/(ARROW_SIZE*1.5));

Queue{
	Beat = 0.000,
	End = math.huge,
	Mod = "1.88x,-9999% Cover,GlobalModTimer,ApproachType,DizzyHolds,100% ScrollSpeedMult,100% ScrollSpeedMult0,100% ScrollSpeedMult1,100% ScrollSpeedMult2,100% ScrollSpeedMult3,100% ArrowPathDrawSizeBack",
};

Queue{
	Time = 0.000,
	Cmd = function(self)
		if bIsEdit then
			AntiMashing(self);
		end
	end,
};

local function BassDrum(fBeat,fLength)
	Tween{ Beat = fBeat }
	:InitState{ Tiny = -2 }
	:Easing(fLength,easing.InQuad)
	:To{ Tiny = 0 }
	:Finish();
end

local function CurveSpline(fBeat,fEnd,player)
	Queue{
		Beat = fBeat,
		End = fEnd,
		Cmd = function(self,param)
			local size = 250;
			local l1 = param.Start;
			local h1 = param.Start + 4.000;
			local l2 = param.End - 4.000;
			local h2 = param.End;
			if param.Beat <= h1 then
				size = scale(param.Beat,l1,h1,0,1) * size;
		elseif param.Beat >= l2 then
				size = scale(param.Beat,l2,h2,1,0) * size;
			end
			local n = table.getn(player);
			for i,v in ipairs(player) do
				local c = PlayerHelper.GetChild(v);
				if c then
					local index = 0;
					for offset = -iOffset,iOffset do
						local rad = (param.Duration + offset) * math.pi/4 + scale(i,1,n+1,0,math.pi*2);
						local x = math.sin(rad) * size;
						local z = math.cos(rad) * size;
						c:SetXSpline(index,-1,x,offset*150,-1);
						c:SetZSpline(index,-1,z,offset*150,-1);
						index = index + 1;
					end
				end
			end
		end
	};
end

local function ShadowMod(fBeat,fLength,easein,easeout,modname,value)
	Queue{
		Beat = fBeat,
		Len = fLength,
		Cmd = function(self,param)
			local multi = param.Frame % 2 == 0 and -1 or 1;
			local value = value * multi;
			if param.Percent < 0.5 then value = easein(scale(param.Percent,0.0,0.5,0,1)) * value;
		elseif param.Percent < 1.0 then value = easeout(scale(param.Percent,0.5,1.0,1,0)) * value;
			end
			GAMESTATE:ApplyModifiers(string.format("*-1 %f%% %s",value,modname));
		end,
	}
	:Add{ Mod = string.format("*-1 No %s",modname) };
end

Queue{ Beat = 0.000, End = 36.000, Mod = "*-1 -75% SquarePeriod" };

local inc = 0;
local t = {
	5.000,
	9.000,
	13.000,
	17.000,
	21.000,
	25.000,
	29.000,
};
for i,v in pairs(t) do
	local rad = math.rad(i % 2 == 1 and 90 or -90);
	local f = Tween{ Beat = v };
	for col = 0,3 do
		local col = i % 2 == 1 and col or 3 - col;
		f:Easing(240/160/12,easing.OutQuint):To{
			["ArrowPath"..col] = 1,
			["ConfusionOffset"..col] = rad,
		};
	end
	f:Easing(240/160/4,easing.InQuint);
	for col = 0,3 do
		f:To{
			["ArrowPath"..col] = 0,
			["ConfusionOffset"..col] = 0,
		};
	end
	f:Finish();
	if i % 2 == 0 then
		Tween{ Beat = v + 1.000 }
		:Easing(240/160/4,easing.InQuint):To{ Square = inc % 2 == 0 and 8 or -8 }
		:Easing(240/160/4,easing.OutQuint):To{ Square = 0 }
		:Finish();
		inc = inc + 1;
	end
end

for i = 4.000,28.000,8.000 do
	BassDrum(i+0.000,240/160/8*3);
	BassDrum(i+1.500,240/160/8*3);
	BassDrum(i+4.500,240/160/8*3);
	BassDrum(i+6.000,240/160/8*3);
end

Queue{ Beat = 20.000, Len = 16.000, Mod = "*-1 -95% ParabolaZOffset" };

Tween{ Beat = 20.000 }
:InitState{ ScrollSpeedMult = 1.00 }
:Easing(240/160*4,easing.InCirc):To{ DrawSize = -0.25, ScrollSpeedMult = 0.75, ParabolaZ = 24 }
:Easing(240/160*8,easing.OutCirc):To{ DrawSize = 0.00, ScrollSpeedMult = 1.00, ParabolaZ = 0 }
:Finish();

Queue{ Beat = 28.000, Cmd = "ShowParticle" };

Queue{ Mod = "*-1 200% Beat", Beat = 35.500, End = 67.500 }
:Add{ Mod = "*-1 No Beat" };

do
	local function Stealth(fBeat)
		Queue{ Mod = "*2 Stealth", Beat = fBeat, Len = 1.000 }
		:Add{ Mod = "*-1 No Stealth" };
	end
	Stealth(40.000);
	Stealth(44.000);
	Stealth(48.000);
	Stealth(52.000);
end

-- Brief: Table inheritance is issue.
Queue{ Beat = 51.000, Mod = "*6.28 No ConfusionOffset", Len = 1.000 };
Queue{ Beat = 51.000, Mod = "*-1 628% ConfusionOffset" };

Queue{ Mod = "*0.083 Boost,*0.083 Wave", Beat = 52.000, End = 64.000 }
:Add{ Mod = "*0.25 No Boost,*0.25 No Wave", End = 68.000 };

Queue{ Beat = 53.000, Mod = "*4 No TinyY", Len = 1.000 };
Queue{ Beat = 53.000, Mod = "*-1 -400% TinyY" };

Queue{ Beat =  64.000, End = 132.000, Mod = "*-1 ZBuffer,*-1 ReceptorZBuffer,*-1 200% SplineXType,*-1 200% SplineYType,*-1 200% SplineZType,*-1 StealthPastReceptors,*1 ArrowPath,*1 75% Dark,*2 No Stealth0,*2 No Stealth1,*2 No Stealth2,*2 No Stealth3" };
Queue{ Beat = 128.000, End = 132.000, Mod = "*0.25 No ArrowPath,*0.25 No Dark" };
Queue{ Beat = 132.000, Mod = "*-1 No ZBuffer,*-1 No ReceptorZBuffer,*-1 No SplineXType,*-1 No SplineYType,*-1 No SplineZType,*-1 No StealthPastReceptors" };

for col = 0,3 do
	Queue{ Beat = 64.000, End = 80.000 + col, Mod = "*2 85% Stealth"..col, Player = 1 };
	Queue{ Beat = 80.000 + col, Len = 16.000, Mod = "*2 85% Stealth"..col, Player = 2 };
	Queue{ Beat = 96.000 + col, Len = 16.000, Mod = "*2 85% Stealth"..col, Player = 1 };
	if bIsEdit then
		Queue{ Beat = 64.000, End = 132.000, Mod = "*8 No Dizzy"..col };
		Queue{ Beat = 64.000, End = 80.000 + col, Mod = "*8 1600% Dizzy"..col, Player = 2 };
		Queue{ Beat = 80.000 + col, Len = 16.000, Mod = "*8 1600% Dizzy"..col, Player = 1 };
		Queue{ Beat = 96.000 + col, Len = 16.000, Mod = "*8 1600% Dizzy"..col, Player = 2 };
	end
end

CurveSpline(64.000,132.000,{1,2});

Queue{ Beat = 68.000, End = 132.000, Mod = "*0.7 No TinyX,*2.7 No TinyY" };
for i = 68.000,128.000,4.000 do
	Queue{ Beat = i + 0.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };
	Queue{ Beat = i + 1.500, Mod = "*-1 TinyX,*-1 -400% TinyY" };
end

Tween{ Beat = 118.000 }
:InitState{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4*2,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Tween{ Beat = 122.000 }
:InitState{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4*2,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Queue{ Beat = 124.000, Cmd = "ShowBlackScreen" };

Queue{ Beat = 128.000, End = 152.000, Mod = "*0.125 50% ScrollSpeedMult" };

Queue{ Beat = 132.000, End = 196.000, Mod = "*-1 300% ArrowPathSize" };

local darkandstealth = {
	{132.000,0},
	{132.500,1},
	{133.000,2},
	{134.000,3},
	{135.000,3},
	{135.500,2},
	{136.000,1},
	{137.000,0},
	{138.000,0},
	{138.500,1},
	{139.000,2},
	{140.000,3},
	{141.000,3},
	{141.500,2},
	{142.000,1},
	{143.000,0},
	{143.500,1},
	{144.000,2},
	{145.000,3},
	{146.000,3},
	{146.500,2},
	{147.000,1},
	{147.500,0},
	{148.000,3},
	{148.500,2},
	{149.000,1},
	{150.000,0},
	{151.000,0},
	{151.500,1},
	{152.000,2},
	{153.000,3},
	{154.000,3},
	{154.500,2},
	{155.000,1},
	{156.000,0},
	{157.000,0},
	{157.500,1},
	{158.000,2},
	{159.000,3},
	{159.500,2},
	{160.000,1},
	{161.000,0},
	{162.000,0},
	{162.500,1},
	{163.000,2},
	{163.500,3},
	{164.000,0},
	{164.500,1},
	{165.000,2},
	{166.000,3},
	{167.000,3},
	{167.500,2},
	{168.000,1},
	{169.000,0},
	{170.000,0},
	{170.500,1},
	{171.000,2},
	{172.000,3},
	{173.000,3},
	{173.500,2},
	{174.000,1},
	{175.000,0},
	{175.500,1},
	{176.000,2},
	{177.000,3},
	{178.000,3},
	{178.500,2},
	{179.000,1},
	{179.500,0},
	{180.000,3},
	{180.500,2},
	{181.000,1},
	{182.000,0},
	{183.000,0},
	{183.500,1},
	{184.000,2},
	{185.000,3},
	{186.000,3},
	{186.500,2},
	{187.000,1},
	{188.000,0},
	{189.000,0},
	{189.500,1},
	{190.000,2},
	{191.000,3},
	{191.500,2},
	{192.000,1},
	{193.000,0},
	{194.000,0},
	{194.500,1},
	{195.000,2},
	{195.500,3},
};
for i,v in pairs(darkandstealth) do
	Tween{ Beat = v[1] }
	:InitState{
		["ArrowPath"..v[2]] = 1,
		["Stealth"..v[2]] = 1,
	}
	:Easing(240/160/4,easing.OutCirc):To{
		["ArrowPath"..v[2]] = 0,
		["Stealth"..v[2]] = 0,
	}
	:Finish();
end

Queue{
	Beat = 136.000,
	End = 164.000,
	Mod = "*1 No TinyX0,*1 No TinyX1,*1 No TinyX2,*1 No TinyX3,*4 No TinyY0,*4 No TinyY1,*4 No TinyY2,*4 No TinyY3"
};

do
	local inc = 0;
	local function SquareY(fBeat,fLength)
		local fEnd = fBeat + fLength;
		local f = Tween{ Beat = fBeat };
		for i = fBeat,fEnd,0.500 do
			if i < fEnd then
				f:Easing(240/160/8,easing.OutCubic):To{
					MoveY0 = inc % 2 == 0 and -0.5 or 0.5,
					MoveY1 = inc % 2 == 1 and -0.5 or 0.5,
					MoveY2 = inc % 2 == 0 and -0.5 or 0.5,
					MoveY3 = inc % 2 == 1 and -0.5 or 0.5,
				};
				inc = inc + 1;
			end
		end
		f:Easing(240/160/8,easing.OutCubic):To{
			MoveY0 = 0,
			MoveY1 = 0,
			MoveY2 = 0,
			MoveY3 = 0,
		};
		f:Finish();
	end
	SquareY(138.000,1.000);
	SquareY(146.000,0.500);
	SquareY(150.000,0.500);
	SquareY(154.000,0.500);
	SquareY(158.000,0.500);
	SquareY(161.500,1.000);
end

Tween{ Beat = 143.000 }
:InitState{ Flip = 0, Invert = 0 }
:Easing(240/160/8,easing.OutCubic):To{ Flip = 0, Invert =  1 }
:Easing(240/160/8,easing.OutCubic):To{ Flip = 1, Invert =  0 }
:Easing(240/160/4,easing.OutCubic):To{ Flip = 1, Invert = -1 }
:Easing(240/160/4,easing.OutCubic):To{ Flip = 0, Invert =  0 }
:Easing(240/160/4,easing.OutCubic):To{ Flip = 0, Invert =  1 }
:Easing(240/160/4,easing.OutCubic):To{ Flip = 1, Invert =  0 }
:Delay(240/160/8)
:Easing(240/160/4,easing.OutCubic):To{ Flip = 0, Invert =  0 }
:Finish();

Queue{ Beat = 150.000, End = 196.000, Mod = "*4 No Tiny" };
Queue{ Beat = 150.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 154.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 158.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 161.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 162.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 150.000 + 16.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 154.000 + 16.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 158.000 + 16.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 161.000 + 16.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 162.000 + 16.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 150.000 + 32.000, Mod = "*-1 -400% Tiny" };
-- Queue{ Beat = 154.000 + 32.000, Mod = "*-1 -400% Tiny" };
-- Queue{ Beat = 158.000 + 32.000, Mod = "*-1 -400% Tiny" };
Queue{ Beat = 161.000 + 32.000, Mod = "*-1 -400% Tiny" };
-- Queue{ Beat = 162.000 + 32.000, Mod = "*-1 -400% Tiny" };

Tween{ Beat = 152.000 }
:InitState{ ScrollSpeedMult = 0.500, ConfusionOffset = math.rad(360*2) }
:Easing(240/160,easing.InQuad)
:To{ ScrollSpeedMult = 0.125, ConfusionOffset = math.rad(360) }
:Easing(240/160,easing.OutQuad)
:To{ ScrollSpeedMult = 1.000, ConfusionOffset = 0 }
:Finish();

Queue{ Beat = 164.000, End = 208.000, Mod = "*-1 -50% SquarePeriod,*-1 -75% SquareZPeriod" };

ShadowMod(
	164.000,
	4.000,
	easing.OutCubic,
	easing.InCubic,
	"Square",
	300
);

ShadowMod(
	168.000,
	2.000,
	easing.InCubic,
	easing.OutCubic,
	"Square",
	100
);

local f = Tween{ Beat = 170.000 - 4/24 };
for i = 0,5 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/24,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/24,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

ShadowMod(
	172.000,
	4.000,
	easing.OutCubic,
	easing.InCubic,
	"Square",
	300
);

local f = Tween{ Beat = 175.000 - 4/48 };
for i = 0,5 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/48,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/48,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

for col = 3,0,-1 do
	Tween{ Beat = 176.000 + (3-col) }
	:Easing(240/160/8,easing.OutCubic):To{ ["Drunk"..col] = 2, ["DrunkY"..col] = 2 }
	:Easing(240/160/8,easing.OutCubic):To{ ["Drunk"..col] = 0, ["DrunkY"..col] = 0 }
	:Finish();
end

ShadowMod(
	180.000,
	2.000,
	easing.OutCubic,
	easing.OutCubic,
	"Square",
	300
);

local f = Tween{ Beat = 185.000 - 4/48 };
for i = 0,5 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/48,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/48,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

Tween{ Beat = 186.000 }
:Easing(240/160/8,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/8,easing.OutCubic):To{ Square =  0 }
:Finish();

local f = Tween{ Beat = 187.000 - 4/16 };
for i = 0,1 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/16,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/16,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

Tween{ Beat = 182.000 }
:Easing(240/160/8,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/8,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/8,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/8,easing.OutCubic):To{ Square =  0 }
:Finish();

Tween{ Beat = 188.000 }
:Easing(240/160/4,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/8,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/8,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/4,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/4,easing.OutCubic):To{ Square =  0 }
:Finish();

local f = Tween{ Beat = 192.000 - 4/16 };
for i = 0,1 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/16,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/16,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

ShadowMod(
	194.000,
	2.000,
	easing.OutCubic,
	easing.OutCubic,
	"SquareZ",
	500
);

Tween{ Beat = 196.000 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square =  0 }
:Finish();

Tween{ Beat = 198.000 }
:Easing(240/160/8,easing.OutCubic):To{ Tipsy =  2 }
:Easing(240/160/8,easing.OutCubic):To{ Tipsy = -2 }
:Easing(240/160/8,easing.OutCubic):To{ Tipsy =  0 }
:Finish();

ShadowMod(
	200.000,
	1.000,
	easing.OutCubic,
	easing.OutCubic,
	"Square",
	300
);

Tween{ Beat = 201.000 }
:Easing(240/160/12,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/12,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/12,easing.OutCubic):To{ Square =  0 }
:Finish();

ShadowMod(
	202.000,
	1.000,
	easing.OutCubic,
	easing.OutCubic,
	"SquareZ",
	500
);
ShadowMod(
	202.000 + 1.000,
	1.000,
	easing.OutCubic,
	easing.OutCubic,
	"SquareZ",
	500
);

Queue{ Beat = 206.000, Cmd = "HideBlackScreen" };

local f = Tween{ Beat = 204.000 - 4/32 };
for i = 0,3 do
	local p = i % 2 == 0 and 1 or -1;
	f:Easing(240/160/32,easing.OutCubic):To{ Tipsy = p, Drunk = p };
	f:Easing(240/160/32,easing.InCubic):To{ Tipsy = 0, Drunk = 0 };
end
f:Finish();

Tween{ Beat = 205.000 }
:Easing(240/160/16,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/16,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/16,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/16,easing.OutCubic):To{ Square =  0 }
:Finish();

ShadowMod(
	206.000,
	1.000,
	easing.OutCubic,
	easing.OutCubic,
	"SquareZ",
	500
);
ShadowMod(
	206.000 + 1.000,
	1.000,
	easing.OutCubic,
	easing.OutCubic,
	"SquareZ",
	500
);

Tween{ Beat = 208.000 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square = -2 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square =  2 }
:Easing(240/160/12*2,easing.OutCubic):To{ Square =  0 }
:Finish();

Queue{ Beat = 208.000, End = 276.000, Mod = "*-1 ZBuffer,*-1 ReceptorZBuffer,*-1 200% SplineXType,*-1 200% SplineYType,*-1 200% SplineZType,*-1 StealthPastReceptors,*1 ArrowPath,*1 75% Dark,*2 No Stealth" };
Queue{ Beat = 272.000, End = 276.000, Mod = "*0.25 No ArrowPath,*0.25 No Dark" };
Queue{ Beat = 276.000, Mod = "*-1 No ZBuffer,*-1 No ReceptorZBuffer,*-1 No SplineXType,*-1 No SplineYType,*-1 No SplineZType,*-1 No StealthPastReceptors" };

CurveSpline(208.000,276.000,{1,3,2,4});

Queue{ Mod = "*-1 BeatY", Beat = 211.500, End = 275.500 }
:Add{ Mod = "*-1 No BeatY" };

Queue{ Beat = 208.000, End = 244.000, Mod = "*2 85% Stealth", Player = 1 };
Queue{ Beat = 244.000, End = 272.000, Mod = "*2 85% Stealth", Player = 2 };
Queue{ Beat = 272.000, End = 276.000, Mod = "*0.25 No Stealth" };

if bIsEdit then
	Queue{ Beat = 208.000, End = 276.000, Mod = "*8 No Dizzy" };
	Queue{ Beat = 208.000, End = 244.000, Mod = "*8 1600% Dizzy", Player = 2 };
	Queue{ Beat = 244.000, End = 272.000, Mod = "*8 1600% Dizzy", Player = 1 };
end

Tween{ Beat = 218.000, Player = 1 }
:Easing(240/160/4,easing.OutCirc):To{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Queue{ Beat = 220.000, End = 228.000, Mod = "*1 No TinyX,*4 No TinyY" };
Queue{ Beat = 221.000 + 0.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };
Queue{ Beat = 221.000 + 2.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };
Queue{ Beat = 221.000 + 4.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };
Queue{ Beat = 221.000 + 5.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };
Queue{ Beat = 221.000 + 6.000, Mod = "*-1 TinyX,*-1 -400% TinyY" };

Queue{ Beat = 228.000, Mod = "*1 No Stealth", Player = 2, Len = 1.000 };
Queue{ Beat = 228.000, Mod = "*-1 Stealth", Player = 2 };

Tween{ Beat = 235.000, Player = 1 }
:Easing(240/160/4,easing.InCirc):To{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Tween{ Beat = 254.000, Player = 1 }
:Easing(240/160/4,easing.InCirc):To{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Tween{ Beat = 259.000, Player = 2 }
:Easing(240/160/4,easing.InCirc):To{ ConfusionOffset = math.rad(360) }
:Easing(240/160/4,easing.OutCirc):To{ ConfusionOffset = 0 }
:Finish();

Queue{ Beat = 268.000, Cmd = "ShowBlackScreen" };

Queue{ Beat = 272.000, End = math.huge, Mod = "25% ScrollSpeedMult" };
Tween{ Beat = 272.000 }
:InitState{ ScrollSpeedMult = 1.00 }
:Easing(240/160*4,easing.OutQuad)
:To{ ScrollSpeedMult = 0.25 }
:Finish();

BassDrum(277.000,240/160/4);
BassDrum(279.000,240/160/4);
BassDrum(281.000,240/160/4);
BassDrum(282.500,240/160/4);
BassDrum(283.500,240/160/8);

Queue{ Beat = 284.000, End = math.huge, Mod = "*1.5 Stealth" };
Queue{ Beat = 284.000, Mod = "*-1 No Stealth" };
Queue{ Beat = 285.500, Mod = "*-1 No Stealth" };
Queue{ Beat = 287.000, Mod = "*-1 No Stealth" };

Queue{ Beat = 287.000, End = math.huge, Mod = "*1.5 Dark" };

Queue{ Beat = 0.000, End = math.huge, Mod = "*-1 No ArrowPath,*-1 HideNoteFlash,*-1 ManualNoteFlash,*-1 Dark,*-1 85% Stealth", Player = {3,4} };
Queue{ Beat = 0.000, End = 208.000, Mod = "Hide", Player = {3,4} };
