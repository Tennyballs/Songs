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

ease{}