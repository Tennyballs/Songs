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
	P[pn]:x(scx)
end

-- your code goes here here:
sprite(SPRITE)
aft(AFT)
SPRITE:SetTexture(AFT:GetTexture())
sprite(SPRITE2)
aft(AFT2)
SPRITE2:SetTexture(AFT2:GetTexture())
SPRITE2:diffusealpha(0)

BG:xy(scx, scy)
BG:diffuse(0.5, 0.5, 0.5, 1)
setdefault {1, 'xmod', 100, 'overhead', 100, 'dizzyholds', 100, 'modtimer'}

definemod {
    'blacksphere',
    function(offset)
        local invert = 50 - 50 * math.cos(offset * math.pi / 180)
        local alternate = 25 * math.sin(offset * math.pi / 180)
        local reverse = -12.5 * math.sin(offset * math.pi / 180)
        return invert, alternate, reverse
    end,
    'invert', 'alternate', 'reverse',
}

local function rad(v)
	return math.rad(v)*100
end

definemod {'rotx', function(x)
	local rotationx = x
	local confusionxoffset = -rad(x)
	return rotationx, confusionxoffset
end, 'rotationx', 'confusionxoffset'}

definemod {'roty', function(y)
	local rotationy = y
	local confusionyoffset = -rad(y)
	return rotationy, confusionyoffset
end, 'rotationy', 'confusionyoffset'}

definemod {'rotz', function(z)
	local rotationz = z
	local confusionzoffset = -rad(z)
	return rotationz, confusionzoffset
end, 'rotationz', 'confusionzoffset'}


for i=0, 47, 3 do
	add{i, 3, inExpo, 45/2, 'rotz'}
end

local function vibrate(beat, len, ease, a, b)

	func{beat, function()
		for i=1, 2 do
			P[i]:vibrate()
		end
	end}

	func_ease{beat, len, ease, a, b, function(vib)
		for i=1, 2 do
			P[i]:effectmagnitude(vib, vib, vib)
		end
	end}

	func{beat+len, function()
		for i=1, 2 do
			P[i]:stopeffect()
		end
	end}

end

for i = 0, 3 do
	vibrate(48+6*i, 3, pop, 0, 10)
end

ease{54-1.5, 3, inOutExpo, 34, 'rotx'}
ease{60-1.5, 3, inOutExpo, 90+23, 'rotx'}
ease{66-3, 6, inOutExpo, 360, 'rotx'}


ease{72, 3*15, linear, 100, 'drunk'}
for i=0, 23 do

	if i+3*i < 64 then
		ease{0+3*i, 3, tap, 200, 'centered2'}
	end

	ease{72+i, 1, flip(linear), 30, 'brake', -50, 'centered2'}
end

ease{96, 3, linear, 100, 'wave', 2, 'xmod', 100, 'beat', 100, 'tipsy'}
ease{132, 3, linear, 0, 'wave', 0, 'drunk', 0, 'tipsy'}