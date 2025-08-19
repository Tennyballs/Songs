local TimingData = {};

function TimingData.GetElapsedTimeFromBeatNoOffset(beat)
	local pSong = GAMESTATE:GetCurrentSong();
	assert(pSong.GetElapsedTimeFromBeat,"\"GetElapsedTimeFromBeat\" is empty");
	return pSong:GetElapsedTimeFromBeat(beat);
end

function TimingData.GetBeatFromElapsedTimeNoOffset(time)
	local pSong = GAMESTATE:GetCurrentSong();
	assert(pSong.GetBeatFromElapsedTime,"\"GetBeatFromElapsedTime\" is empty");
	return pSong:GetBeatFromElapsedTime(time);
end

function TimingData.GetElapsedTimeFromBeat(beat)
	local fGlobalOffsetSeconds = PREFSMAN:GetPreference("GlobalOffsetSeconds");
	return TimingData.GetElapsedTimeFromBeatNoOffset(beat) + fGlobalOffsetSeconds;
end

function TimingData.GetBeatFromElapsedTime(time)
	local fGlobalOffsetSeconds = PREFSMAN:GetPreference("GlobalOffsetSeconds");
	return TimingData.GetBeatFromElapsedTimeNoOffset(time + fGlobalOffsetSeconds);
end

return TimingData;
