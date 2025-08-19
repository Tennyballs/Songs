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


definemod{'shader0', function(v)
	AftSprite:GetShader():uniform1f('amount', v/100)
end}
for i=1, 4 do
	local p = i / 2
	ease{38+p, 0.25, flip(linear), 100, 'shader0'}
	ease{54+p, 0.25, flip(linear), 100, 'shader0'}
	ease{44+p, 0.25, flip(linear), 100, 'shader0'}
	ease{46+p, 0.25, flip(linear), 100, 'shader0'}
end

ease{60, 4, bounce, 0, 'beat'}

set{60, 1.5, 'xmod'}

ease{0, 16, pop, 100, 'shader0'}
ease{0, 16, linear, 5, 'shader0'}
ease{28, 4, linear, 0, 'shader0'}
ease{48, 2, flip(outQuad), 100, 'shader0'}
ease{64-.5, 1, inOutQuad, 10, 'shader0'}
ease{68-.5, 1, inOutQuad, 20, 'shader0'}
ease{70-.5, 1, inOutQuad, 30, 'shader0'}

ease{72-.5, 1, inOutQuad, 10, 'shader0'}
ease{76-.5, 1, inOutQuad, 20, 'shader0'}
ease{78-.5, 1, inOutQuad, 30, 'shader0'}

ease{80-.5, 1, inOutQuad, 10, 'shader0'}
ease{84-.5, 1, inOutQuad, 20, 'shader0'}
ease{86-.5, 1, inOutQuad, 30, 'shader0'}

ease{88-.5, 4, linear, 0, 'shader0'}

local function Axy(i, x, y)
	A[i]:xy(x, y)
end

local function Azoom(i, z)
	A[i]:zoom(z)
end

local function Arotationz(i, r)
	A[i]:rotationz(r)
end

local function Adiffusealpha(i, a)
	A[i]:diffusealpha(a)
end

local function Adiffuse(i, r, g, b, a)
	A[i]:diffuse(r, g, b, a)
end

for a = 1, 5 do
	Adiffusealpha(a, 0)
	Azoom(a, 0)
	Arotationz(a, 0)
	Axy(a, scx, scy)
end

-- 1800
func_ease{16, 2, linear, 0, 1, function(t)
	A[1]:diffusealpha(1 - t)
	A[1]:zoom(t * 20)
	A[1]:rotationz(t * 45)
end}
func_ease{17, 2, linear, 0, 1, function(t)
	A[3]:diffusealpha(1 - t)
	A[3]:zoom(t * 20)
	A[3]:rotationz(t * -35)
end}
func_ease{18, 2, linear, 0, 1, function(t)
	A[4]:diffusealpha(1 - t)
	A[4]:zoom(t * 20)
	A[4]:rotationz(t * 15)
end}
func_ease{19, 2, linear, 0, 1, function(t)
	A[5]:diffusealpha(1 - t)
	A[5]:zoom(t * 20)
	A[5]:rotationz(t * -25)
end}

-- 1800
func_ease{24, 4, linear, 0, 1, function(t)
	A[1]:diffusealpha(1 - t)
	A[1]:zoom(t * 20)
	A[1]:rotationz(t * 90)
end}
func_ease{25, 4, linear, 0, 1, function(t)
	A[3]:diffusealpha(1 - t)
	A[3]:zoom(t * 20)
	A[3]:rotationz(t * -90)
end}
func_ease{26, 4, linear, 0, 1, function(t)
	A[4]:diffusealpha(1 - t)
	A[4]:zoom(t * 20)
	A[4]:rotationz(t * 90)
end}
func_ease{27, 4, linear, 0, 1, function(t)
	A[5]:diffusealpha(1 - t)
	A[5]:zoom(t * 20)
	A[5]:rotationz(t * -90)
end}

func_ease{32, 1, outBack, 0, 1, function(t)
	A[1]:diffusealpha(1)
	A[1]:zoom(t * 1)
	A[1]:rotationz(23 + t * -23)
end}

func_ease{33, 1, outBack, 0, 1, function(t)
	A[1]:x(scx - 100 * t)
	A[2]:diffusealpha(1)
	A[2]:zoom(t * 1)
	A[2]:x(scx - 50 * t)
	A[3]:diffusealpha(1)
	A[3]:zoom(t * 1)
	A[3]:rotationz(-23 + t * 23)
end}

func_ease{34, 1, outBack, 0, 1, function(t)
	A[4]:diffusealpha(1)
	A[4]:zoom(t * 1)
	A[4]:x(scx + 50 * t)
	A[4]:rotationz(23 + t * -23)
end}

func_ease{34.1, 1, outBack, 0, 1, function(t)
	A[5]:diffusealpha(1)
	A[5]:zoom(t * 1)
	A[5]:x(scx + 100 * t)
	A[5]:rotationz(-23 + t * 23)
end}

func_ease{35, 1, inBack, 0, 1, function(t)
	for i=1, 5 do
		A[i]:y(scy - 300 * t)
	end
end}


-- 1800 2
func_ease{64, 1, outBack, 0, 1, function(t)
	A[1]:xy(scx, scy)
	A[1]:zoom(t)
end}

func_ease{65, 1, outBack, 0, 1, function(t)
	A[1]:xy(scx-100*t, scy)
	A[2]:xy(scx-50*t, scy)
	A[2]:zoom(t)
	A[3]:xy(scx, scy)
	A[3]:zoom(t)
end}

func_ease{66, 1, outBack, 0, 1, function(t)
	A[4]:xy(scx+50*t, scy)
	A[4]:zoom(t)
end}

func_ease{67, 1, outBack, 0, 1, function(t)
	A[5]:xy(scx+100*t, scy)
	A[5]:zoom(t)
end}

func_ease{68, 1, inBack, 0, 1, function(t)
	for i=1, 5 do
		A[i]:y(scy + 300 * t)
	end
end}

-- 1800 2

func_ease{72, 1, outBack, 0, 1, function(t)
	A[1]:xy(scx, scy)
	A[1]:zoom(t)
	A[1]:rotationz(23 + t * -23)
end}

func_ease{73, 1, outBack, 0, 1, function(t)
	A[1]:x(scx - 100 * t)
	A[2]:xy(scx - 50 * t, scy)
	A[2]:zoom(t)
	A[3]:xy(scx, scy)
	A[3]:zoom(t)
	A[3]:rotationz(-23 + t * 23)
end}

func_ease{74, 1, outBack, 0, 1, function(t)
	A[4]:xy(scx + 50 * t, scy)
	A[4]:zoom(t)
	A[4]:rotationz(23 + t * -23)
end}

func_ease{75, 1, outBack, 0, 1, function(t)
	A[5]:xy(scx + 100 * t, scy)
	A[5]:zoom(t)
	A[5]:rotationz(-23 + t * 23)
end}

func_ease{76, 1, inBack, 0, 1, function(t)
	for i=1, 5 do
		A[i]:y(scy - 300 * t)
	end
end}

-- 1800 2
func_ease{80, 1, outBack, 0, 1, function(t)
	A[1]:xy(scx, scy)
	A[1]:zoom(t)
	A[1]:rotationz(23 + t * -23)
end}

func_ease{81, 1, outBack, 0, 1, function(t)
	A[1]:x(scx - 100 * t)
	A[2]:xy(scx - 50 * t, scy)
	A[2]:zoom(t)
	A[3]:xy(scx, scy)
	A[3]:zoom(t)
	A[3]:rotationz(-23 + t * 23)
end}

func_ease{82, 1, outBack, 0, 1, function(t)
	A[4]:xy(scx + 50 * t, scy)
	A[4]:zoom(t)
	A[4]:rotationz(23 + t * -23)
end}

func_ease{83, 1, outBack, 0, 1, function(t)
	A[5]:xy(scx + 100 * t, scy)
	A[5]:zoom(t)
	A[5]:rotationz(-23 + t * 23)
end}

func_ease{84, 1, inBack, 0, 1, function(t)
	for i=1, 5 do
		A[i]:y(scy + 300 * t)
	end
end}

-- 1800 2

func_ease{88, 4, linear, 0, 4, function(t)
	local s = 5
	if(t < 1) then
		A[1]:xy(scx, scy)
		A[1]:zoom((1 - t)*s)
		A[1]:rotationz(23 + t * -23)
		A[1]:diffusealpha(1 - t)
	elseif(t < 2) then
		A[3]:xy(scx, scy)
		A[3]:zoom((2 - t)*s)
		A[3]:rotationz(-23 + t * 23)
		A[3]:diffusealpha(2 - t)
	elseif(t < 3) then
		A[4]:xy(scx, scy)
		A[4]:zoom((3 - t)*s)
		A[4]:rotationz(23 + t * -23)
		A[4]:diffusealpha(3 - t)
	elseif(t < 4) then
		A[5]:xy(scx, scy)
		A[5]:zoom((4 - t)*s)
		A[5]:rotationz(-23 + t * 23)
		A[5]:diffusealpha(4 - t)
	end
end}
ease{30.5, 1, outBack, 100, 'beat', 3.5, 'xmod'}
ease{64-.5, 1, inOutQuad, 4, 'xmod', 25, 'tornado', 300, 'beat'}

ease{96-.5, 1, inOutQuad, 100, 'beat', 0, 'tornado'}