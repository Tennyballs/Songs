import "Global";
import "Utils";
local clock = os and os.clock;

local fStartTime = 0.000;
local fStopTime = 0.000;
local iCount = 0;
local fDefaultWaitTime = 1.000;
local fWaitTime = fDefaultWaitTime;
local fTotalLagTime = 0.000;

local function Init(time)
	fDefaultWaitTime = time;
	fWaitTime = fDefaultWaitTime;
end

local function Start()
	if clock then
		fStartTime = clock();
	end
end

local function Stop(delta)
	if clock then
		fStopTime = clock();
		iCount = iCount + 1;
		fWaitTime = fWaitTime - delta;
		fTotalLagTime = fTotalLagTime + (fStopTime - fStartTime);
	end
	if fWaitTime <= 0.000 then
		printf(
			"[Benchmark] Total Lag-Time: %.3f sec, Average Lag-Time: %.3f sec",
			fTotalLagTime,
			fTotalLagTime / iCount
		);
		printf(
			"[Benchmark] Memory Allocate: %d KB, Memory Threshold: %d KB",
			gcinfo()
		);
		iCount = 0;
		fWaitTime = fDefaultWaitTime;
		fTotalLagTime = 0.000;
	end
end

return {
	Init = Init,
	Start = Start,
	Stop = Stop,
};
