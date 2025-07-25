if not P1 or not P2 then
	backToSongWheel('Two Player Mode Required')
	return
end

-- judgment / combo proxies
for pn = 1, 2 do
	setupJudgeProxy(PJ[pn], P[pn]:GetChild('Judgment'), pn)
	setupJudgeProxy(PC[pn], P[pn]:GetChild('Combo'), pn)
end
-- player proxies
for pn = 1, #PP do
	PP[pn]:SetTarget(P[pn])
	P[pn]:hidden(1)
end

-- your code goes here here:
setdefault {2, 'xmod', 100, 'overhead', 100, 'dizzyholds', 100, 'modtimer'}

for pn=1,2 do
	P[pn]:x(scx);
	P[pn]:fov(90);
end

ease{0, 1, flip(outBack), 100, 'x', 25, 'zoomx'}
ease{4, 1, flip(outBack), -100, 'x', 25, 'zoomx'}
ease{8, 1, flip(outBack), 100, 'x', 25, 'zoomx'}
ease{12, 1, flip(outBack), -100, 'x', 25, 'zoomx'}
ease{14, 1, flip(outBack), 100, 'x', 25, 'zoomx'}
ease{16, 1, flip(outBack), -100, 'x', 25, 'zoomx'}
ease{20, 1, flip(outBack), 100, 'x', 25, 'zoomx'}
ease{24, 1, flip(outBack), -100, 'x', 25, 'zoomx'}
ease{28, 1, flip(outBack), 100, 'x', 25, 'zoomx'}
ease{30, 1, flip(outBack), -100, 'x', 25, 'zoomx'}

local function check_it_out(beat)
	ease{beat, 2, pop, 100, 'movey3'}
	ease{beat+2/3, 2, pop, 100, 'movey2'}
	ease{beat+1+2/3, 2, pop, -100, 'movey1'}
end
local function im_in_the_house(beat)
	ease{beat+1/3*2, 2, pop, 100, 'movey0'}
	ease{beat+1, 2, pop, 100, 'movey1'}
	ease{beat+1+1/3*2, 2, pop, -100, 'movey2'}
	ease{beat+2, 2, pop, 100, 'movey3'}
end
local function im_in_the_house2(beat)
	ease{beat, 2, pop, 100, 'movey0'}
	ease{beat+2/3, 2, pop, 100, 'movey1'}
	ease{beat+2, 2, pop, -100, 'movey2'}
	ease{beat+2+2/3, 2, pop, 100, 'movey3'}
end
local function carpet(beat)
	ease{beat, 2, pop, -100, 'movey0'}
	ease{beat+1/3*2, 2, pop, 100, 'movey2'}
end
local function carpet2(beat)
	ease{beat, 2, pop, -100, 'movey0'}
	ease{beat+4/3, 2, pop, 100, 'movey1'}
end
local function like_carpet(beat)
	ease{beat, 2, pop, 100, 'movey1'}
	carpet(beat+1)
end
local function check_it_out2(beat)
	ease{beat, 2, pop, 100, 'movey3'}
	ease{beat+2/3, 2, pop, 100, 'movey0'}
	ease{beat+1, 2, pop, -100, 'movey1'}
end

check_it_out(32)
im_in_the_house(34)
like_carpet(39)
like_carpet(43)
carpet(46)
carpet(48)

check_it_out2(51)
im_in_the_house2(53)


check_it_out(64)
im_in_the_house(66)
like_carpet(71)
like_carpet(75)
carpet(78)
carpet(80)

ease{57+2/3, 2, pop, 100, 'movey0'}
ease{58+2/3, 2, pop, 100, 'movey1'}
ease{59+2/3, 2, pop, 100, 'movey2'}
ease{60, 2, pop, 100, 'movey3'}

carpet2(61+2/3)

check_it_out2(83)
im_in_the_house2(85)

ease{89+2/3, 2, pop, 100, 'movey0'}
ease{90+2/3, 2, pop, 100, 'movey1'}
ease{91+2/3, 2, pop, 100, 'movey2'}
ease{92, 2, pop, 100, 'movey3'}

carpet2(92+2/3)

ease{96, 4, linear, 100, 'drunk'}