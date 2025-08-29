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
	P[pn]:fov(90)
end

-- your code goes here here:
set{0, 200, 'mini'}

ease{0, 8, bounce, 100, 'mini'}
ease{8, 8, bounce, 50, 'mini'}
ease{16, 8, bounce, 25, 'mini'}
ease{24, 8, outExpo, 0, 'mini', 100, 'dark', 2, 'xmod'}

ease{168, 8, tri, 2500/2, 'zigzagz', 100, 'dizzy'}

func{158, function()
	for pn=1, 2 do
		P[pn]:vibrate()
	end
end}

func_ease{158, 2, tap, 0, 40, function(v)
	for pn=1, 2 do
		P[pn]:effectmagnitude(v, v, v)
	end
end}

for _, note in P1:GetNoteData(32, 63) do
	ease{note[1], 4, flip(linear), 1.5, 'xmod'} -- beat = note[1]
end

for i=0, 3 do
	ease{72+i*2, 2, tri, 1.5, 'xmod'}
	ease{88+i*2, 2, tri, 1.5, 'xmod'}
	ease{104+i*2, 2, tri, 1.5, 'xmod'}
	ease{120+i*2, 2, tri, 1.5, 'xmod'}
end

local i = true
perframe{63, 1-0.01, function(beat)
	val = bounce((beat - 63) * 2) * 100

	i = not i
	for pn = 1,2 do
		if i then
			GAMESTATE:ApplyModifiers("*-1 "..val.." drunk", pn)
		else
			GAMESTATE:ApplyModifiers("*-1 "..-val.." drunk", pn)
		end
	end
end}

func{64, function()
	for pn = 1,2 do
		GAMESTATE:ApplyModifiers("*-1 0 drunk", pn)
	end
end}

set{64, 100, 'beat'}
ease{64, 32, linear, 3, 'xmod'}

ease{48, 0.1, linear, 100, 'invert', 0, 'dark'}
ease{52, 0.1, linear, 100, 'flip', -100, 'invert'}
ease{56, 0.1, linear, 0, 'invert'}
ease{58, 0.1, linear, 100, 'invert', 0, 'flip'}
ease{59.5, 0.1, linear, 0, 'invert'}

for i=0, 7, 4 do
	ease{96+i, 2, bounce, 100, 'drunk'}
	ease{98+i, 2, bounce, -100, 'drunk'}
	ease{112+i, 2, bounce, 100, 'drunk'}
	ease{114+i, 2, bounce, -100, 'drunk'}
end

ease{127, 1, linear, 1, 'xmod', 0, 'beat'}
-- (1/7)
set{126.5+0/7, (1/7)*(scx/2), 'x', plr=1}
set{126.5+1/7, (2/7)*(scx/2), 'x', plr=1}
set{126.5+2/7, (3/7)*(scx/2), 'x', plr=1}
set{126.5+3/7, (4/7)*(scx/2), 'x', plr=1}
set{126.5+4/7, (5/7)*(scx/2), 'x', plr=1}
set{126.5+6/7, (6/7)*(scx/2), 'x', plr=1}
set{126.5+7/7, (7/7)*(scx/2), 'x', plr=1}


set{126.5+0/7, -(1/7)*(scx/2), 'x', plr=2}
set{126.5+1/7, -(2/7)*(scx/2), 'x', plr=2}
set{126.5+2/7, -(3/7)*(scx/2), 'x', plr=2}
set{126.5+3/7, -(4/7)*(scx/2), 'x', plr=2}
set{126.5+4/7, -(5/7)*(scx/2), 'x', plr=2}
set{126.5+6/7, -(6/7)*(scx/2), 'x', plr=2}
set{126.5+7/7, -(7/7)*(scx/2), 'x', plr=2}

set{128, 0, 'x'}
func{128, function()
	for pn=1,2 do
		P[pn]:x(scx)
	end
end}

ease{128, .1, linear, -100, 'flip', -100, 'tiny',-1000, 'vanish', 100, 'vanishsize', -100, 'vanishoffset', 100, 'dark'}
ease{128, .1, linear, -100, 'flip', 100, 'tiny', -1000, 'vanish', 100, 'vanishsize', 100, 'vanishoffset', plr=2}

ease{144, .1, linear, -100, 'flip', -100, 'tiny',-1000, 'vanish', 100, 'vanishsize', 100, 'vanishoffset', 100, 'dark'}
ease{144, .1, linear, -100, 'flip', 100, 'tiny', -1000, 'vanish', 100, 'vanishsize', -100, 'vanishoffset', plr=1}

reset{158, 2, linear}

