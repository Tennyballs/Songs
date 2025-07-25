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

set{126,1800,'drunkspeed'}


ease{134-4,8,spike, 250, 'drunk', plr=1}
ease{166-4,8,spike, 250, 'drunk', plr=1}
ease{138-4,8,spike, -250, 'drunk', 50, 'stealth', -500, 'tiny', plr=2}
ease{170-4,8,spike, -250, 'drunk', 50, 'stealth', -500, 'tiny', plr=2}
ease{138,2,flip(outBack),250,'dizzy'}
ease{170,2,flip(outBack),250,'dizzy'}

for pn = 1, 2 do
	P[pn]:fov(90)
end

set{124, 100, 'beat', -50, 'beatmult'}

ease{120, 1, flip(outExpo), 50, 'rotationx', -25, 'rotationy', plr=1}
ease{120, 1, flip(outExpo), 50, 'rotationx', 25, 'rotationy', plr=2}
ease{121, 1, flip(outExpo), 20, 'rotationx', 45, 'rotationy', plr=1}
ease{121, 1, flip(outExpo), 20, 'rotationx', -45, 'rotationy', plr=2}
ease{122, 1, flip(outExpo), 20, 'rotationx', -50, 'rotationy', plr=1}
ease{122, 1, flip(outExpo), 20, 'rotationx', -50, 'rotationy', plr=2}
ease{123, 1, flip(outExpo), 50, 'rotationx', -25, 'rotationy', plr=1}
ease{123, 1, flip(outExpo), -50, 'rotationx', -25, 'rotationy', plr=2}

for i=0, 3 do
	ease{148+i*2, 2, flip(linear), 1, 'xmod'}
	ease{180+i*2, 2, flip(linear), 1, 'xmod'}
end

ease{130, 1.5, flip(linear), 1000, 'zigzag', -500, 'zigzagsize'}
ease{146, 1.5, flip(linear), 1000, 'zigzag', -500, 'zigzagsize'}
ease{154, 1.5, flip(linear), 1000, 'zigzag', -500, 'zigzagsize'}
ease{162, 1.5, flip(linear), 1000, 'zigzag', -500, 'zigzagsize'}
ease{178, 1.5, flip(linear), 1000, 'zigzag', -500, 'zigzagsize'}

set{188, 200, 'drunkspeed'}
ease{188, 8, linear, 100, 'drunk', 1.5, 'xmod'}

reset{251, 1, outExpo}