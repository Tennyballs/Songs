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
setdefault {3, 'xmod', 100, 'overhead', 100, 'dizzyholds', 100, 'modtimer'}

ease{0, 8, flip(linear), 0, 'zoom'}

ease{0, .25, flip(linear), 100, 'x'}
ease{0.25, .25, flip(linear), -100, 'x'}
ease{0.75, .25, flip(linear), 100, 'x'}
ease{1.25, .25, flip(linear), -100, 'x'}
ease{1.5, .25, flip(linear), 100, 'x'}
ease{2.25, .25, flip(linear), 100, 'x'}
ease{2.5, .25, flip(linear), -100, 'x'}
ease{3, .25, flip(linear), 100, 'x'}
ease{3.5, .25, flip(linear), -100, 'x'}
ease{3.75, .25, flip(linear), 100, 'x'}
ease{4, .25, flip(linear), 100, 'x'}

ease{4.5, .5, pop, 100, 'tipsy'}
ease{5.5, .5, pop, -100, 'tipsy'}
ease{6.5, .5, pop, 100, 'tipsy'}
ease{7.5, .5, pop, -100, 'tipsy'}

set{8, 300, 'beat'}
ease{7, 2, inOutExpo, 45, 'rotationx', math.rad(-45)*100, 'confusionxoffset'}
ease{8, 2, inOutExpo, 135, 'rotationx', math.rad(-135)*100, 'confusionxoffset'}
ease{9, 2, inOutExpo, 180, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{9, 1, bounce, 300, 'zoomy'}

ease{12, 4, flip(linear), 5000, 'drunkoffset', 250, 'drunkspeed'}
ease{12, 2, bounce, -45, 'confusionzoffset', 200, 'drunk', 100, 'arrowpath'}
ease{14, 2, bounce, 45, 'confusionzoffset', -200, 'drunk', 100, 'arrowpath'}

local function vibrate(beat, len)
	func{beat, function()
		P1:vibrate()
		P2:vibrate()
	end}
	func_ease{beat, len, linear, 10, 0, function(v)
		P1:effectmagnitude(v, v, v)
		P2:effectmagnitude(v, v, v)
	end}
end

local function hsvToRgb(h, s, v)
    local r, g, b
    if s <= 0 then
        -- Achromatic (grayscale)
        r, g, b = v, v, v
    else
        h = h * 6 -- Scale hue to 0-6
        local i = math.floor(h)
        local f = h - i -- Fractional part of hue
        local p = v * (1 - s)
        local q = v * (1 - (s * f))
        local t = v * (1 - (s * (1 - f)))

        if i == 0 then
            r, g, b = v, t, p
        elseif i == 1 then
            r, g, b = q, v, p
        elseif i == 2 then
            r, g, b = p, v, t
        elseif i == 3 then
            r, g, b = p, q, v
        elseif i == 4 then
            r, g, b = t, p, v
        else -- i == 5
            r, g, b = v, p, q
        end
    end
    return r, g, b
end

vibrate(10, 4)
vibrate(18, 4)
vibrate(26, 4)
vibrate(34, 4)
vibrate(36, 4)

ease{15, 2, inOutExpo, 45+90, 'rotationx', math.rad(-45-90)*100, 'confusionxoffset'}
ease{16, 2, inOutExpo, 135+135, 'rotationx', math.rad(-135-90)*100, 'confusionxoffset'}
ease{17, 2, inOutExpo, 360, 'rotationx', math.rad(-360)*100, 'confusionxoffset'}
ease{17, 1, bounce, 300, 'zoomy'}

for i=0, 3 do
	ease{20+i, 1, pop, 50, 'zoomy'}
	ease{52+i, 1, pop, 50, 'zoomy'}
	ease{68+i, 1, pop, 50, 'zoomy'}
end

ease{22, 1, bounce, 100, 'skewx'}
ease{23, 1, bounce, -100, 'skewx'}

set{23.5, 100, 'skewy'}
set{23.75, -100, 'skewy'}
set{24, 0, 'skewy'}

-- background
local colors = {
	{1, 0, 0.25, 1},
	{0.16, 0.94, 0.81, 1},
	{0.97, 0.97, 0, 1},
	{0.63, 0.13, 0.94, 1}
}
func_ease{36, 4, linear, 0, 0, function(v)
	BG2:rotationz(0)
end}

set{35.5, 0, 'beat'}

for i=0, 31 do
	local color1 = colors[i % #colors + 1]
	local color2 = colors[(i + 1 ) % #colors + 1]

	func_ease{40+i, 1, outBack, 0, 1, function(v)
		BG2:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT * v * 0.75)

		if(8+i == 9) then
			BG1:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT * v * .25 + SCREEN_HEIGHT * 0.75)
		end

		local b = GAMESTATE:GetSongBeat()
		if (math.floor(b) % 2) == 1 then
			BG2:rotationz(pop(b % 1)*25)
		else
			BG2:rotationz(-pop(b % 1)*25)
		end
	end}


	func{40+i, function()
		BG1:diffuse(color1[1], color1[2], color1[3], color1[4])
		BG2:diffuse(color2[1], color2[2], color2[3], color2[4])
	end}

	if i < 28 then
		func_ease{8+i, 1, outBack, 0, 1, function(v)
			BG2:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT * v * 0.75)

			if(8+i == 9) then
				BG1:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT * v * .25 + SCREEN_HEIGHT * 0.75)
			end
		end}

		func{8+i, function()
			BG1:diffuse(color1[1], color1[2], color1[3], color1[4])
			BG2:diffuse(color2[1], color2[2], color2[3], color2[4])
		end}
	end
end

func{0, function()
	EFFECT:GetShader():uniform1f("amount", 0.01)
end}

for i=0, 36-8-1 do
	func_ease{8+i, 1, outExpo, 0.1, 0.001, function(v)
		EFFECT:GetShader():uniform1f("amount", v)
	end}
end
func_ease{36, 4, linear, 0.05, 0.01, function(v)
	EFFECT:GetShader():uniform1f("amount", v)
end}
for i=0, 72-40-1 do
	func_ease{40+i, 1, outExpo, 0.1, 0.005, function(v)
		EFFECT:GetShader():uniform1f("amount", v)
	end}
end

ease{40, 1, outExpo, 1000, 'beat'}


func_ease{6, 2, bounce, 0, 1, function(v)
	Hornet:diffusealpha(v*.5)
	Hornet:zoom(v*5+1)
end}

func_ease{35, 1, inExpo, 0, 1, function(v)
	BG2:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT * v)
	BG2:diffuse(0, 0, 0, 1)
end}

reset{24, exclude={'beat'}}
reset{36, exclude={'beat'}}

aft(AFT)
sprite(EFFECT)
EFFECT:SetTexture(AFT:GetTexture())

ease{23, 2, inOutExpo, -45, 'rotationx', math.rad(45)*100, 'confusionxoffset'}
ease{24, 2, inOutExpo, 135, 'rotationx', math.rad(-135)*100, 'confusionxoffset'}
ease{25, 2, inOutExpo, 180, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{25, 1, bounce, 300, 'zoomy'}

ease{28, 4, flip(linear), 5000, 'drunkoffset', 250, 'drunkspeed'}
ease{28, 2, bounce, -45, 'confusionzoffset', 200, 'drunk', 100, 'arrowpath'}
ease{30, 2, bounce, 45, 'confusionzoffset', -200, 'drunk', 100, 'arrowpath'}


ease{31, 2, inOutExpo, 45+90, 'rotationx', math.rad(-45-90)*100, 'confusionxoffset'}
ease{32, 2, inOutExpo, 135+135, 'rotationx', math.rad(-135-90)*100, 'confusionxoffset'}
ease{33, 2, inOutExpo, 360, 'rotationx', math.rad(-360)*100, 'confusionxoffset'}
ease{33, 1, bounce, 300, 'zoomy'}

for i=1, 4 do
	BG[i]:zoomto(100, 100)
	BG[i]:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
	BG[i]:diffuse(1, 1, 1, 1)
end

for i=2, 4 do
	BG[i]:diffusealpha(0)
end

func_ease{4, 4, linear, 1, 0, function(v)
	BG[1]:zoom(v*100)
	BG[1]:rotationz(v*90)
	local r, g, b = hsvToRgb(v, v, 1)
	BG[1]:diffuse(r, g, b, 1)
end}

func_ease{36, 1, outBack, 0, 1, function(v)
	BG[1]:zoomto(v*100, v*100)
	BG[1]:x(SCREEN_WIDTH/5)
	BG[1]:diffuse(1, 1, 1, 1)
end}
func_ease{37, 1, outBack, 0, 1, function(v)
	BG[2]:zoomto(v*100, v*100)
	BG[2]:x((SCREEN_WIDTH/5)*2)
	BG[2]:diffuse(1, 1, 1, 1)
end}
func_ease{38, 1, outBack, 0, 1, function(v)
	BG[3]:zoomto(v*100, v*100)
	BG[3]:x((SCREEN_WIDTH/5)*3)
	BG[3]:diffuse(1, 1, 1, 1)
end}
func_ease{39, .5, outBack, 0, 1, function(v)
	BG[4]:zoomto(v*100, v*100)
	BG[4]:x((SCREEN_WIDTH/5)*4)
	BG[4]:diffuse(1, 1, 1, 1)
end}
func_ease{39.5, .5, bounce, 0, 1, function(v)
	BG[4]:zoomto(v*100, v*100)
	BG[4]:x((SCREEN_WIDTH/5)*4)
	BG[4]:diffuse(1, 1, 1, 1)
end}

func_ease{39.5, .5, inExpo, 1, 0, function(v)

	for i=1, 4 do
		BG[i]:zoomto(100*v, 100*v)
		BG[i]:diffuse(1, 1, 1, 1)
	end
end}

ease{36, 4, flip(linear), 50, 'reverse'}


ease{39, 2, inOutExpo, -45, 'rotationx', math.rad(45)*100, 'confusionxoffset'}
ease{40, 2, inOutExpo, 135, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{41, 2, inOutExpo, 180, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{41, 1, bounce, 300, 'zoomy'}

ease{40.5, 1, inOutExpo, 100, 'invert'}
ease{41.5, 1, inOutExpo, 0, 'invert'}

ease{44, 4, flip(linear), 5000, 'drunkoffset', 250, 'drunkspeed'}
ease{44, 2, bounce, -45, 'confusionzoffset', 200, 'drunk', 100, 'arrowpath'}
ease{46, 2, bounce, 45, 'confusionzoffset', -200, 'drunk', 100, 'arrowpath'}


ease{47, 2, inOutExpo, 45+90, 'rotationx', math.rad(-45-90)*100, 'confusionxoffset'}
ease{48, 2, inOutExpo, 135+135, 'rotationx', math.rad(-135-90)*100, 'confusionxoffset', 100, 'flip'}
ease{49, 2, inOutExpo, 360, 'rotationx', math.rad(-360)*100, 'confusionxoffset', 0, 'flip'}
ease{49, 1, bounce, 300, 'zoomy'}

ease{54, 1, bounce, 100, 'skewx'}
ease{55, 1, bounce, -100, 'skewx'}

set{55.5, 100, 'skewy'}
set{55.75, -100, 'skewy'}
set{56, 0, 'skewy'}

vibrate(42, 4)
vibrate(50, 4)
vibrate(58, 4)
vibrate(66, 4)


ease{55, 2, inOutExpo, -45, 'rotationx', math.rad(45)*100, 'confusionxoffset'}
ease{56, 2, inOutExpo, 135, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{57, 2, inOutExpo, 180, 'rotationx', math.rad(-180)*100, 'confusionxoffset'}
ease{57, 1, bounce, 300, 'zoomy'}

ease{56.5, 1, inOutExpo, 100, 'invert'}
ease{57.5, 1, inOutExpo, 0, 'invert'}

ease{60, 4, flip(linear), 5000, 'drunkoffset', 250, 'drunkspeed'}
ease{60, 2, bounce, -45, 'confusionzoffset', 200, 'drunk', 100, 'arrowpath'}
ease{62, 2, bounce, 45, 'confusionzoffset', -200, 'drunk', 100, 'arrowpath'}


ease{63, 2, inOutExpo, 45+90, 'rotationx', math.rad(-45-90)*100, 'confusionxoffset'}
ease{64, 2, inOutExpo, 135+135, 'rotationx', math.rad(-135-90)*100, 'confusionxoffset', 100, 'flip'}
ease{65, 2, inOutExpo, 360, 'rotationx', math.rad(-360)*100, 'confusionxoffset', 0, 'flip'}
ease{65, 1, bounce, 300, 'zoomy'}

ease{54, 1, bounce, 100, 'skewx'}
ease{55, 1, bounce, -100, 'skewx'}

for i=0, 32 do
	if i % 2 == 0 then
		set{40+i, 3, 'xmod'}
	else
		set{40+i, 2, 'xmod'}
	end
end

set{71.5, 100, 'skewy'}
set{71.75, -100, 'skewy'}
set{72, 0, 'skewy'}

ease{72, 4, linear, 100, 'wave', 2, 'xmod'}