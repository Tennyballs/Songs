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
	P[pn]:x(scx)
	P[pn]:fov(90)
end

-- your code goes here here:
setdefault {2, 'xmod', 100, 'overhead', 100, 'dizzyholds', 100, 'modtimer'}

set{0, 100, 'drunk', 100, 'tipsy', 100, 'dizzy', 100, 'stealth', 100, 'dark'}
ease{4, 6, linear, 0, 'drunk', 0, 'tipsy', 0, 'dizzy', 0, 'stealth', 0, 'dark'}

ease{22, 16, linear, 100, 'drunk', 100, 'orient'}

ease{34, 3, bounce, 100, 'drunk0'}
ease{37, 3, bounce, 100, 'drunk1'}
ease{40, 3, bounce, 100, 'drunk2'}
ease{43, 3, bounce, 100, 'drunk3'}

ease{46, 4*3, linear, 0, 'drunk', 3, 'xmod'}

for i=0, 2*(24+6)-1, 3 do
	add{58+i, 0.25, flip(linear), 100, 'drunk', -25, 'mini'}
	add{59.5+i, 0.25, flip(linear), 100, 'drunk', -25, 'mini'}
	add{60.5+i, 0.25, flip(linear), 100, 'tipsy', 100, 'mini'}
end

set{82, 175, 'drunkspeed'}
ease{82, 3, outExpo, 200, 'drunk', -80, 'drunksize'}
ease{85, 3, outExpo, 50, 'tipsy'}

ease{118, 10, linear, 100, 'stealth', 100, 'dark', 100, 'cover'}
ease{106, 2, outExpo, 0, 'drunk', 0, 'tipsy'}

set{131, 360*8, 'rotationy'}
reset{132, 4, outExpo, exclude={'xmod'}}

ease{136, 1, flip(linear), -200, 'tiny'}
ease{137.5, 1, flip(linear), -200, 'tiny'}
ease{139, 3, flip(linear), -200, 'tiny'}

ease{136, 0.25, flip(linear), 100, 'drunk', 100, 'tipsy'}
ease{137.5, 0.25, flip(linear), -100, 'drunk', -100, 'tipsy'}
ease{139, 4, flip(linear), 100, 'drunk', 100, 'tipsy'}

ease{139, 3, flip(linear), 100, 'zigzag', -100, 'zigzagsize'}
ease{147, 3, flip(linear), 100, 'zigzag', -100, 'zigzagsize'}

ease{132, .25, linear, 100, 'reverse0'}
ease{132.25, .25, linear, 100, 'reverse1'}
ease{132.5, .25, linear, 100, 'reverse2'}
ease{132.75, .25, linear, 100, 'reverse3'}
ease{133, .25, linear, 0, 'reverse0'}
ease{133.25, .25, linear, 0, 'reverse1'}
ease{133.5, .25, linear, 0, 'reverse2'}
ease{133.75, .25, linear, 0, 'reverse3'}
ease{132+2, .25, linear, 100, 'reverse0'}
ease{132.25+2, .25, linear, 100, 'reverse1'}
ease{132.5+2, .25, linear, 100, 'reverse2'}
ease{132.75+2, .25, linear, 100, 'reverse3'}
ease{133+2, .25, linear, 0, 'reverse0'}
ease{133.25+2, .25, linear, 0, 'reverse1'}
ease{133.5+2, .25, linear, 0, 'reverse2'}
ease{133.75+2, .25, linear, 0, 'reverse3'}

ease{136, 2, flip(linear), 45, 'rotationx', -45, 'rotationy'}
ease{137.5, 2, flip(linear), -45, 'rotationx', 45, 'rotationy'}
ease{139, 2, flip(linear), 45, 'rotationx', 45, 'rotationy'}

ease{144, 2, flip(linear), -45, 'rotationx', 45, 'rotationy'}

ease{144, 1, flip(linear), -200, 'tiny'}
ease{145.5, 1, flip(linear), -200, 'tiny'}
ease{147, 3, flip(linear), -200, 'tiny'}
ease{144, 0.25, flip(linear), 100, 'drunk', 100, 'tipsy'}
ease{145.5, 0.25, flip(linear), -100, 'drunk', -100, 'tipsy'}
ease{146.5, 0.25, flip(linear), -100, 'drunk', -100, 'tipsy'}
ease{147, 4, flip(linear), 100, 'drunk', 100, 'tipsy'}
ease{150.25, .5, tri, 5000, 'zigzagz'}
ease{151-.25, .5, flip(linear), 100, 'drunk'}
ease{151.25, .5, flip(linear), -100, 'drunk'}


ease{152, .5, flip(linear), 100, 'drunk', 100, 'tipsy'}
ease{153.5, .5, flip(linear), -100, 'drunk', -100, 'tipsy'}
ease{154.5, .5, flip(linear), -100, 'drunk', -100, 'tipsy'}
ease{155, 4, flip(linear), 100, 'drunk', 100, 'tipsy'}

ease{158, 2, inOutExpo, 360*4, 'rotationy'}

for i=166, 168-.25, 0.25 do if i*4 % 2 == 0 then ease{i, 0.25, outExpo, 100, 'drunk'} else ease{i, 0.25, outExpo, -100, 'drunk'} end end
for i=0, 3*8-1, 2 do if i % 4 == 0 then ease{168+i+1, 1, outExpo, 50, 'drunk', 50, 'tipsy'} else ease{168+i+1, 1, outExpo, -50, 'drunk', -50, 'tipsy'}end end
for i=0, 3*8-1 do ease{168+i, 1, bounce, -25, 'y'} end
ease{195, 6, linear, 10000, 'gayholds', 0, 'drunk', 0, 'tipsy'}