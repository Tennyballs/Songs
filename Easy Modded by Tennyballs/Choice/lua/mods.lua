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

ease{0, 4, flip(outQuad), 10000, 'drunkspeed', 200, 'drunk', 0, 'xmod'}
func_ease{0, 4, outQuad, 0, 1, function(v)
	local x1 = v * (scx)
	local x2 = (scx * 2) - (v * scx)
	P1:x(x1)
	P2:x(x2)
end}

function confOff(deg)
	return math.rad(deg)*100
end

definemod {'rotx', 'roty', 'rotz', function(x,y,z)
		return x, confOff(-x), y, confOff(-y), z, confOff(-z)
	end,
	'rotationx', 'confusionxoffset',
	'rotationy', 'confusionyoffset',
	'rotationz', 'confusionzoffset'}

ease{3, 1, inQuad, 180, 'rotx', -180, 'roty', 200, 'beat'}
ease{5, 1, outExpo, 0, 'roty'}
ease{6, 1, outExpo, 0, 'rotx'}

ease{7-1/4, 1/4, outExpo, 45, 'rotz'}
ease{7, 1, outExpo, -45, 'rotz'}
ease{8, 2, bounce, 250, 'z', 360, 'roty', plr=2}
ease{8, 2, linear, 0, 'rotz'}

ease{10, 1, tri, 100, 'drunk'}

ease{12, 1, outExpo, 100, 'flip'}

set{13-0.1, 100, 'stealth', 100, 'dark', 100, 'cover', 100, 'hidenoteflashes'}
set{14, 0, 'stealth', 0, 'flip', 100, 'reverse', 0, 'cover', 0, 'dark', 0, 'hidenoteflashes'}

ease{15-1/4, 2, outQuad, 0, 'reverse'}

ease{16, 2, bounce, 250, 'z', 360, 'roty', plr=2}

set{20-0.1, 100, 'dark', 100, 'hidenoteflashes', plr=2}
set{20-0.1, 100, 'stealth', plr=1}
set{20-0.1, 100, 'cover'}
set{21, 0, 'cover'}
ease{20, 1, tri, 100, 'centered2', plr=2}

ease{21, 1, bounce, -100, 'x'}

ease{22+.5, .5, bell, 100, 'invert'}

ease{24, 2, bounce, 250, 'z', plr=2}
ease{24, 2, outExpo, 360, 'roty', plr=2}
ease{26, 2, tri, 400, 'drunk'}

set{28, 100, 'invert'}
set{29, 0, 'invert'}
set{30, 100, 'flip'}
set{30+1/2, 0, 'flip'}

for i=0,1 do
	ease{30+i/2+1/2, 1/5, flip(linear), 100, 'stealth'}
end

ease{32-1/4, 1, bell, 50, 'zoomy'}
ease{32+1/2, 1+1/2, outExpo, 300, 'zoomy'}

ease{34, 2, flip(outQuad), 10000, 'drunkspeed', 200, 'drunk', 0, 'xmod'}
ease{34, 2, linear, 100, 'zoomy'}

reset{36, exclude={'beat'}}

ease{37, 1/2, inOutQuad, 50, 'zoomy'}
ease{37+1/2, 1/2, inOutQuad, 100, 'zoomy'}
ease{38, 1/2, inOutQuad, 50, 'zoomx'}
ease{38+1/2, 1/2, inOutQuad, 100, 'zoomx'}

ease{38, 1, flip(linear), 250, 'drunk', 100, 'drunkspeed'}

ease{39, 1, linear, 200, 'centered2'}

ease{40, 4, linear, 25, 'tandrunkz'}
BG:diffuse(0.5, 0.5, 0.5, 1)
BG:xy(scx, scy)

ease{42, 0, instant, 100, 'centered2'}
ease{42+1/4, 0, instant, 0, 'centered2'}

ease{43, 1/4, flip(inExpo), 100, 'flip'}
ease{43+1/2, 1/4, flip(inExpo), 100, 'invert'}

ease{44, 1, bounce, -45, 'rotationz'}
ease{45, 1, bounce, 45/4*3, 'rotationz'}
ease{46, 1, bounce, -45/2, 'rotationz'}
ease{47, 1, bounce, 45/2, 'rotationz'}
ease{47+1/2, 2, bounce, -45, 'rotationz'}

set{50, 0, 'beat', 0, 'tandrunkz'}

for i=0, 8 do
	p = i/8
	set{46+p, tri(p)*100, 'vanish', tri(p)*200, 'drunk'}
	set{47+p, tri(p)*-100, 'vanish', tri(p)*-200, 'drunk'}
	set{50+p, tri(p)*100, 'vanish', tri(p)*200, 'drunk'}
	set{51+p, tri(p)*-100, 'vanish', tri(p)*-200, 'drunk'}
	set{62+p, tri(p)*100, 'vanish', tri(p)*200, 'drunk'}
	set{63+p, tri(p)*-100, 'vanish', tri(p)*-200, 'drunk'}
end

func{13, function()
	BG:hidden(1)
end}

func{14-1/10, function()
	BG:hidden(0)
end}

ease{53, 1, flip(linear), 250, 'drunk', 100, 'drunkspeed'}
ease{55, 1, linear, 200, 'centered2'}

ease{56, 2, tri, 300, 'drunk'}
ease{57, 2, tri, 300, 'tipsy'}

ease{59+1/2, 0, instant, 100, 'centered2'}
ease{59+3/4, 0, instant, 0, 'centered2'}


ease{61, 1, flip(linear), 250, 'drunk', 100, 'drunkspeed', 100, 'arrowpath'}
ease{63, 1, flip(linear), 250, 'drunk', 100, 'drunkspeed', 100, 'arrowpath'}

ease{67.5, 10, linear, 200, 'tornado', 100, 'tornadooffset'}