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
setdefault {2, 'xmod', 100, 'dizzyholds', 100, 'stealthtype', 100, 'stealthpastreceptors', 100, 'reversetype', 100, 'modtimer'}

ease{7, 1, inOutExpo, 3, 'xmod', 100, 'beat'}

for i=0, 3 do

	ease{8+i*8, .5, flip(linear), -25, 'x'}
	ease{8.5+i*8, .5, flip(linear), 25, 'x'}
	ease{10.5+i*8, .5, flip(linear), -25, 'x'}

	ease{12+i*8, .5, flip(linear), -25, 'x'}
	ease{12.5+i*8, .5, flip(linear), 25, 'x'}
	ease{14.5+i*8, .5, flip(linear), -25, 'x'}
end

ease{52, 4, linear, 100, 'cover', 100, 'stealth'}
ease{56, 1, flip(linear), 0, 'stealth'}
ease{57, 1, flip(linear), 0, 'stealth'}