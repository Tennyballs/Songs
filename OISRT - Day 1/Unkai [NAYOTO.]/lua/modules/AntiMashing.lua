local NoteDataHelper = import "NoteDataHelper";
local SongPosition = import "SongPosition";
local TimingData = import "TimingData";

local TapNoteScore = {
	["TNS_BOO"] = PREFSMAN:GetPreference("JudgeWindowSecondsBoo"),
	["TNS_GOOD"] = PREFSMAN:GetPreference("JudgeWindowSecondsGood"),
	["TNS_GREAT"] = PREFSMAN:GetPreference("JudgeWindowSecondsGreat"),
	["TNS_PERFECT"] = PREFSMAN:GetPreference("JudgeWindowSecondsPerfect"),
	["TNS_MARVELOUS"] = PREFSMAN:GetPreference("JudgeWindowSecondsMarvelous"),
};

local TimingScale = 0.03333333333;
local NoteData = {};
local InputLogs = {};
for pn = 1,NUM_PLAYERS do
	InputLogs[pn] = {};
	for col = 1,4 do
		InputLogs[pn][col] = -9999;
	end
end

local function setmap(map,row)
	map[row] = (map[row] or 0) + 1;
end

local function GetNoteData()
	local map = {};
	local nd = NoteDataHelper.GetNoteData();
	for i,v in nd do
		local row = NoteDataHelper.BeatToNoteRow(v[1]);
		setmap(map,row);
		if v.length then
			local row = row + NoteDataHelper.BeatToNoteRow(v.length);
			setmap(map,row);
		end
	end
	local keys = {};
	for k,v in pairs(map) do
		keys[#keys+1] = tonumber(k);
	end
	table.sort(keys);
	local newnd = {};
	local prevnotes = 0;
	for i,v in keys do
		local notes = map[v];
		if prevnotes ~= notes then
			newnd[#newnd+1] = {
				NoteDataHelper.NoteRowToBeat(v),
				notes,
			};
			prevnotes = notes;
		end
	end
	do
		local row = keys[#keys];
		local notes = map[row];
		newnd[#newnd+1] = {
			NoteDataHelper.NoteRowToBeat(row),
			notes,
		};
	end
	local res = {};
	local offset = TapNoteScore[THEME:GetMetric("Gameplay","MinScoreToContinueCombo")];
	for i,v in newnd do
		local j,w = next(newnd,i);
		if j then
			res[#res+1] = {
				TimingData.GetElapsedTimeFromBeatNoOffset(v[1]) - offset,
				TimingData.GetElapsedTimeFromBeatNoOffset(w[1]) - offset,
				v[2],
			};
		end
	end
	return res;
end

local function HitMine(pn)
	local fLifeDeltaPercentChangeHitMine = PREFSMAN:GetPreference("LifeDeltaPercentChangeHitMine");
	local iPercentScoreWeightHitMine = PREFSMAN:GetPreference("PercentScoreWeightHitMine");
	if GAMESTATE:IsPlayerEnabled(pn-1) then
		local Screen = SCREENMAN:GetTopScreen();
		if Screen.SetLife then
			local life = Screen:GetLife(pn-1) + fLifeDeltaPercentChangeHitMine;
			Screen:SetLife(pn-1,life);
		end
		local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn-1);
		if pss then
			local dp = pss:GetActualDancePoints() + iPercentScoreWeightHitMine;
			pss:SetActualDancePoints(dp);
			MESSAGEMAN:Broadcast(string.format("HitMineP%d",pn));
		end
	end
end

local function StepInput(pn,dir,duplication)
	local fTime = SongPosition.GetMusicSecondsVisible();
	InputLogs[pn][dir] = fTime;
	while next(NoteData) do
		local nd = NoteData[1];
		if not nd then
			break;
		elseif fTime < nd[1] then
			break;
		elseif fTime > nd[2] then
			table.remove(NoteData,1);
		else
			local inputs = 0;
			for col = 1,4 do
				local diff = fTime - InputLogs[pn][col];
				if diff <= TimingScale then
					inputs = inputs + 1;
				end
			end
			if nd[3] < inputs then
				for col = 1,4 do
					InputLogs[pn][col] = -9999;
				end
				HitMine(pn);
			end
			break;
		end
	end
	local bInputDuplication = PREFSMAN:GetPreference("InputDuplication");
	if bInputDuplication and not duplication then
		local pn = (NUM_PLAYERS+1) - pn;
		StepInput(pn,dir,true);
	end
end

local function Init(self)
	local function fmt(pn,col)
		local dir = {
			"Left",
			"Down",
			"Up",
			"Right",
		};
		return string.format("StepP%d%sPressMessage",pn,dir[col]);
	end
	for pn = 1,NUM_PLAYERS do
		for col = 1,4 do
			local co = coroutine.wrap(function(pn,col)
				while true do
					coroutine.yield();
					StepInput(pn,col);
				end
			end);
			co(pn,col);
			self:addcommand(fmt(pn,col),co);
		end
	end
	NoteData = GetNoteData();
end

return Init;
