import "Global";
local Player = import "PlayerHelper";
local NoteData = {};

-- TODO: Don't have a hard-coded track limit.
local MAX_NOTE_TRACKS = 16;

-- This is a divisor for our "fixed-point" time/beat representation.  It must be evenly divisible
-- by 2, 3, and 4, to exactly represent 8th, 12th and 16th notes.
local ROWS_PER_BEAT = 48;

-- In the editor, enforce a reasonable limit on the number of notes.
local MAX_NOTES_PER_MEASURE = 50;

local BEATS_PER_MEASURE = 4;
local ROWS_PER_MEASURE = ROWS_PER_BEAT * BEATS_PER_MEASURE;
local MAX_NOTE_ROW = 1073741824;

local function clamp(x,l,h)
	return math.min(math.max(x,l),h);
end

function NoteData.BeatToNoteRow( beat ) return math.round( beat * ROWS_PER_BEAT ); end
function NoteData.NoteRowToBeat( row ) return row / ROWS_PER_BEAT; end

function NoteData.NoteTypeToBeat(nt)
	-- 4th, 8th, 12th, 16th, 20th, 24th, 32nd, 48th, 64th, 96th, 192nd
	local t = { 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/8, 1/12, 1/16, 1/24, 1/48 };
	local nt = clamp( math.floor(nt), 1, table.getn(t) );
	return t[nt];
end

function NoteData.GetNoteData(first,last)
	local c = Player.GetChild(GAMESTATE:GetMasterPlayerNumber()+1);
	local nd = c:GetNoteData(first,last);
	local res = {};
	local last = last or NoteData.NoteRowToBeat(MAX_NOTE_ROW);
	for i,v in ipairs(nd) do
		if v[1] < last then
			table.insert(res,v);
		end
	end
	return res;
end

return NoteData;
