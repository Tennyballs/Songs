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
aft(Aft);
sprite(AftSprite);
AftSprite:SetTexture(Aft:GetTexture());
BG:xy(scx, scy);
BG:diffuse(0.5, 0.5, 0.5, 1)

local function vibrate(beat, len, ease, plr)
	plr = plr or {1, 2}
	
	func{beat, function()
		for pn in plr do
			P[pn]:vibrate()
		end
	end}

	func_ease{beat, len, ease, 0, 50, function(v)
		for pn in plr do
			P[pn]:effectmagnitude(v, v, v)
		end
	end}
end

definemod{'shader0', function(v)
	AftSprite:GetShader():uniform1f('amount', v/100)
end}

ease{0, 32, flip(linear), 100, 'shader0'}
ease{32, 4, flip(outExpo), 100, 'shader0'}
vibrate(0, 32, flip(linear))
vibrate(32, 4, flip(outExpo))
for i=0, 3 do

	ease{100+i*8, 8, bounce, 100, 'shader0'}
end