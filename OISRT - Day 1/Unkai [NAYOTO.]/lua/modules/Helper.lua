local fGlobalOffsetSeconds = PREFSMAN:GetPreference("GlobalOffsetSeconds");

NOTITG_VERSION = tonumber(GAMESTATE:GetVersionDate());
NUM_PLAYFIELDS = 8;
ARROW_SIZE = 64;

GRAY_ARROWS_Y_STANDARD = THEME:GetMetric("Player","ReceptorArrowsYStandard");
GRAY_ARROWS_Y_REVERSE = THEME:GetMetric("Player","ReceptorArrowsYReverse");
START_DRAWING_AT_PIXELS = THEME:GetMetric("Player","StartDrawingAtPixels");
STOP_DRAWING_AT_PIXELS = THEME:GetMetric("Player","StopDrawingAtPixels");

StartDrawingAtPixels = GAMESTATE:IsEditMode() and -100 or START_DRAWING_AT_PIXELS;
StopDrawingAtPixels = GAMESTATE:IsEditMode() and 400 or STOP_DRAWING_AT_PIXELS;
NoteFieldHeight = GRAY_ARROWS_Y_REVERSE - GRAY_ARROWS_Y_STANDARD;

function PixelToPercent(pixel)
	return pixel / ARROW_SIZE * 100;
end

-- TODO: Don't have a hard-coded track limit.
MAX_NOTE_TRACKS = 16;

-- This is a divisor for our "fixed-point" time/beat representation.  It must be evenly divisible
-- by 2, 3, and 4, to exactly represent 8th, 12th and 16th notes.
ROWS_PER_BEAT = 48;

-- In the editor, enforce a reasonable limit on the number of notes.
MAX_NOTES_PER_MEASURE = 50;

BEATS_PER_MEASURE = 4;
ROWS_PER_MEASURE = ROWS_PER_BEAT * BEATS_PER_MEASURE;
MAX_NOTE_ROW = 1073741824;

function BeatToNoteRow( beat ) return math.round( beat * ROWS_PER_BEAT ); end
function NoteRowToBeat( row ) return row / ROWS_PER_BEAT; end

function NoteTypeToBeat(nt)
	-- 4th, 8th, 12th, 16th, 20th, 24th, 32nd, 48th, 64th, 96th, 192nd
	local t = { 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/8, 1/12, 1/16, 1/24, 1/48 };
	local nt = math.clamp( math.trunc(nt), 1, table.getn(t) );
	return t[nt];
end

AFT_ALPHA = 1.0;
local name = string.lower(PREFSMAN:GetPreference("LastSeenVideoDriver"));
if string.find(name,"nvidia") then
	AFT_ALPHA = 0.9;
end

function Screen()
	return SCREENMAN:GetTopScreen();
end

function Player(pn)
	return Screen():GetChild("PlayerP"..pn);
end

function BeatToTime(beat)
	local song = GAMESTATE:GetCurrentSong();
	if song and song.GetElapsedTimeFromBeat then
		local time = song:GetElapsedTimeFromBeat(beat) + fGlobalOffsetSeconds;
		Trace(string.format("BeatToTime: %.3f -> %.3f",beat,time));
		return time;
	end
end

function TimeToBeat(time)
	local song = GAMESTATE:GetCurrentSong();
	if song and song.GetBeatFromElapsedTime then
		local beat = song:GetBeatFromElapsedTime(time + fGlobalOffsetSeconds);
		Trace(string.format("TimeToBeat: %.3f -> %.3f",time,beat));
		return beat;
	end
end

function SetLastSecondHint(time)
	local song = GAMESTATE:GetCurrentSong();
	if song and GameState.SetSongEndTime then
		local fMusicRate = NOTITG_VERSION < 20210711 and GAMESTATE:GetMusicRate() or 1;
		GAMESTATE:SetSongEndTime((time or song:MusicLengthSeconds()) * fMusicRate);
	end
end

function SetLastBeatHint(beat)
	SetLastSecondHint(BeatToTime(beat));
end

function GetChildrenTable(self)
	local children = {};
	for i,v in pairs(self:GetChildren()) do
		local name = v:GetName();
		local c = children[name];
		if c then
			local t = {};
			if type(c) == "table" then
				t = c;
			else
				table.insert(t,c);
			end
			table.insert(t,v);
			children[name] = t;
		else
			children[name] = v;
		end
	end
	return children;
end

function SetInputPlayer(pn,ip)
	local player = Player(pn);
	if player then
		local ip = ip or math.mod(pn - 1,2);
		local pc = PREFSMAN:GetPreference("AutoPlay");
		player:SetAwake(true);
		player:SetInputPlayer(ip);
		player:SetPlayerController(pc);
		return player;
	end
end

function SetPlayerProxy(self,pn,name)
	local player = Player(pn);
	if player then
		local target = name and player:GetChild(name) or player;
		self:SetTarget(target);
		target:hidden(1);
		return self;
	end
end

function SetActorFrameTexture(self)
	self:SetWidth(DISPLAY:GetDisplayWidth());
	self:SetHeight(DISPLAY:GetDisplayHeight());
	self:EnablePreserveTexture(true);
	self:Create();
	return self;
end

function SetTexture(self,target)
	if self and target then
		self:basezoomx(SCREEN_WIDTH/DISPLAY:GetDisplayWidth());
		self:basezoomy(SCREEN_HEIGHT/DISPLAY:GetDisplayHeight()*-1);
		self:SetTexture(target:GetTexture());
		return self;
	end
end

function SetSpline(param)
	if not param.Player then
		for i = 1,NUM_PLAYFIELDS do
			param.Player = i;
			SetSpline(param);
		end
	else
		local c = Player(param.Player);
		if c then
			local column = param.Column and (param.Column - 1) or -1;
			local speed = param.Speed or -1;
			for k,v in pairs(param.Points) do
				local member = string.lower(k);
				for i = 0,#v-1 do
					local value,offset = v[i+1][2],v[i+1][1];
					if member == "x" then
						c:SetXSpline(i,column,value*(100/ARROW_SIZE),offset*(100/ARROW_SIZE),speed);
				elseif member == "y" then
						c:SetYSpline(i,column,value*(100/ARROW_SIZE),offset*(100/ARROW_SIZE),speed);
				elseif member == "z" then
						c:SetZSpline(i,column,value*(100/ARROW_SIZE),offset*(100/ARROW_SIZE),speed);
				elseif member == "rotx" or member == "rotationx" then
						c:SetRotXSpline(i,column,math.rad(value)*100,offset*(100/ARROW_SIZE),speed);
				elseif member == "roty" or member == "rotationy" then
						c:SetRotYSpline(i,column,math.rad(value)*100,offset*(100/ARROW_SIZE),speed);
				elseif member == "rotz" or member == "rotationz" then
						c:SetRotZSpline(i,column,math.rad(value)*100,offset*(100/ARROW_SIZE),speed);
				elseif member == "size" then
						c:SetSizeSpline(i,column,value*100,offset*(100/ARROW_SIZE),speed);
				elseif member == "skew" then
						c:SetSkewSpline(i,column,value*100,offset*(100/ARROW_SIZE),speed);
				elseif member == "stealth" then
						c:SetStealthSpline(i,column,value*100,offset*(100/ARROW_SIZE),speed);
					end
				end
			end
			c:NoClearSplines(param.NoClear or false);
			return c;
		end
	end
end

function GetNoteData(first,last)
	local p = Player(GAMESTATE:GetMasterPlayerNumber()+1);
	local nd = p:GetNoteData(first,last);
	local res = {};
	local last = last or NoteRowToBeat(MAX_NOTE_ROW);
	for i,v in pairs(nd) do
		if v[1] < last then
			table.insert(res,v);
		end
	end
	return res;
end
