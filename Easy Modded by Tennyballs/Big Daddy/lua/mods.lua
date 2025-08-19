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
sprite(SPRITE)
aft(AFT)
SPRITE:SetTexture(AFT:GetTexture())
sprite(SPRITE2)
aft(AFT2)
SPRITE2:SetTexture(AFT2:GetTexture())
SPRITE2:diffusealpha(0)

BG:xy(scx, scy)
BG:diffuse(0.5, 0.5, 0.5, 1)
setdefault {2, 'xmod', 100, 'overhead', 100, 'dizzyholds', 100, 'modtimer'}

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


ease{36, 28, linear, 200, 'beat', 3, 'xmod', 100, 'hallway', 200, 'zoomy'}
ease{64, 1, outBack, 0, 'hallway', 100, 'zoomy', 0, 'beat'}
set{68, 200, 'beat'}

for i=0, 3 do
	add{32+i, 1, linear, 180, 'blacksphere'}
	ease{32+i, 1, bounce, -25, 'movey'}
	if i % 2 == 0 then
		ease{32+i, 1, bounce, 25, 'skewx'}
	else
		ease{32+i, 1, bounce, -25, 'skewx'}
	end

	add{80+i, 1, linear, 180, 'blacksphere'}
	ease{80+i, 1, bounce, -25, 'movey'}
	if i % 2 == 0 then
		ease{80+i, 1, bounce, 25, 'skewx'}
	else
		ease{80+i, 1, bounce, -25, 'skewx'}
	end
end

func{36, function()
	for pn=1,2 do
		P[pn]:vibrate()
	end
end}

func_ease{36, 1, inQuad, 10, 0, function(v)
	for pn=1,2 do
		P[pn]:effectmagnitude(v, v, v)
	end
end}

local shakes = {
	75, 77, 78, 79,
	93, 94, 95,
	132
}

for i=0, 3 do
	table.insert(shakes, 69+i)
	table.insert(shakes, 85+i)
	table.insert(shakes, 101+i)
	table.insert(shakes, 109+i)
	table.insert(shakes, 117+i)

	for j=0, 7 do
		table.insert(shakes, 236+i*8+j)
	end
end

for i=1, #shakes do
	local shake = shakes[i]
	func_ease{shake, 1, inQuad, 10, 0, function(v)
		for pn=1,2 do
			P[pn]:effectmagnitude(v, v, v)
		end
	end}

	ease{shake, 1, linear, 300, 'centered2'}
	set{shake+1, 0, 'centered2'}
end

ease{73, .25, outExpo, 45, 'rotx'}
ease{73.5, .25, outExpo, 90, 'rotx'}
ease{74, .25, outExpo, 135, 'rotx'}
ease{74.5, .25, outExpo, 180, 'rotx'}

ease{88, .25, outExpo, 270, 'rotx'}
ease{88.5, .25, outExpo, 0, 'rotx'}

ease{89, 1, bell, -100, 'flip'}
ease{90.1, 0.5, outExpo, 100, 'invert'}
ease{91, 0.5, outExpo, 0, 'invert'}

ease{92, 1, flip(linear), 200, 'spiralz'}

set{96, 0, 'beat', 1.5, 'xmod', 100, 'drunk'}
ease{99, 1, linear, 3, 'xmod', 0, 'drunk', 500, 'beat'}

func_ease{364, 32, linear, .5, 0, function(v)
	BG:diffuse(v, v, v, 1)
end}

perframe{4, 28, function(v)
	P1:x(math.sin(v)*scx/2+scx)
	P1:rotationz(math.cos(v)*-45/2)
	P2:x(-math.sin(v)*scx/2+scx)
	P2:rotationz(math.cos(v)*45/2)
end}


perframe{32, 4, function(beat)
	local x1 = P1:GetX()
	local x2 = P1:GetX()
	for pn=1,2 do
		P[pn]:rotationz(0)
	end
	P1:x((x1 + (scx/2))/2)
	P2:x((x1 + (scx/2*5))/2)
end}

ease{132, 32, outExpo, 0, 'beat', 1.5, 'xmod', 100, 'drunk', 50, 'brake'}
set{164, 0, 'drunk', 2, 'xmod', 100, 'brake'}
ease{132, 64, linear, 360*2, 'roty', 200, 'tornadoz', 3, 'xmod', 100, 'arrowpath'}

func_ease{67, 1, outBack, scx/2, scx, 'P1:x'}
func_ease{67, 1, outBack, scx/2*3, scx, 'P2:x'}

ease{73+32, .25, outExpo, 45, 'rotx'}
ease{73.5+32, .25, outExpo, 90, 'rotx'}
ease{74+32, .25, outExpo, 135, 'rotx'}
ease{74.5+32, .25, outExpo, 180, 'rotx'}

ease{88+33, .25, outExpo, 270, 'rotx'}
ease{88.5+33, .25, outExpo, 0, 'rotx'}


ease{89+32, 1, bell, -100, 'flip'}
ease{90.1+32, 0.5, outExpo, 100, 'invert'}
ease{91+32, 0.5, outExpo, 0, 'invert'}
set{196, 0, 'tornadoz', 0, 'brake', 0, 'arrowpath'}

ease{92+32, 1, flip(linear), 200, 'spiralz'}

ease{244, 0.5, linear, 45, 'rotz'}

ease{251, 1, bell, 200, 'zoomx'}

set{252, 0, 'rotz'}
ease{260, 0.5, linear, -45, 'rotz'}

ease{264, 1, bounce, 200, 'zoomx'}

SPRITE2:wag()
func{396, function()
	SPRITE2:zoom(1.05)
	SPRITE2:diffusealpha(1)
	SPRITE2:rainbow(1)
	SPRITE:wag()
	SPRITE:effectclock('beat')
end}

func_ease{132, 32, linear, 1, 0, 'BG:diffusealpha'}
ease{196, 32, linear, 150, 'hallway'}
set{208, 400, 'centered2'}
ease{208, 2, flip(linear), 0, 'centered2'}
set{210, 0, 'centered2'}
ease{232, 4, outBack, 0, 'hallway', 3, 'xmod'}


for i=1, 31+32 do
	func_ease{396+i, 1, linear, 1, 1.05, 'SPRITE2:zoom'}
end

for i=0, 4*16-5, 2 do
	ease{396+i, 1.5, pop, -scx/2, 'x', -100, 'y', plr=1}
	ease{396+i+1, 1.5, pop, scx/2, 'x', 100, 'y', plr=2}
end

reset{392, 4, outBack}
for i=0, 2, .5 do
	ease{208+i, 0.25/2, linear, 180, 'blacksphere'}
	ease{208.25+i, 0.25/2, linear, 0, 'blacksphere'}
end

ease{456, 4, linear, 80, 'stealth'}
func_ease{456, 4, bounce, 1.05, 1, 'SPRITE2:zoom'}

for i=0, 31, 0 do
	ease{460+i, 1, flip(linear), 100, 'stealth'}
end

func{408, function()
	for pn=1, 2 do
		P[pn]:vibrate()
	end
end}

func_ease{408, 1, linear, 100, 0, function(v)
	for pn=1, 2 do
		P[pn]:effectmagnitude(0, v, 0)
	end
end}

func_ease{409, 2, linear, 2, 0, function(v)
	v = bounce(v % 1)
	for pn=1, 2 do
		P[pn]:effectmagnitude(v* 100, 0, 0)
	end
end}

ease{411, 1, outExpo, 100, 'reverse'}


ease{424, 4, bounce, 180, 'rotx'}