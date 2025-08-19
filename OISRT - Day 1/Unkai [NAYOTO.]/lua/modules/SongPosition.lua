local SongPosition = {};
local TimingData = import "TimingData";

function SongPosition.GetMusicSecondsVisible()
	return GAMESTATE:GetSongTimeVisible();
end

function SongPosition.GetSongBeatVisible()
	return GAMESTATE:GetSongBeatVisible();
end

function SongPosition.GetMusicSeconds()
	local fGlobalOffsetSeconds = PREFSMAN:GetPreference("GlobalOffsetSeconds");
	return GAMESTATE:GetSongTime() + fGlobalOffsetSeconds;
end

function SongPosition.GetSongBeat()
	return GAMESTATE:GetSongBeat();
end

function SongPosition.GetSongBeatNoOffset()
	local fTime = GAMESTATE:GetSongTime();
	return TimingData.GetBeatFromElapsedTimeNoOffset(fTime);
end

return SongPosition;
