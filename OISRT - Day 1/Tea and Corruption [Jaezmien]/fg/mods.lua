local l, e = 'len', 'end'

pmods.approachtype = 100
pmods.stealthpastreceptors = 100
pmods.xmod = 1.25
pmods.sudden = 100
pmods.suddenoffset = 175
pmods.drawsize = 50
pmods.drawsizeback = 50
pmods.reversetype = 100
pmods.disablemines = 100
pmods.hidemines = 100

mod_plr_origin[1][1] = SCREEN_CENTER_X - (640/4)
mod_plr_origin[2][1] = SCREEN_CENTER_X + (640/4)

math.randomseed( 8008135 )

func{ 0, function()
	mod_plr(function(p,pn)
		for _,v in ipairs({ p, proxy.get_proxy('P'..pn..' Judgment'), proxy.get_proxy('P'..pn..' Combo')}) do
			v:decelerate( am_bl(4) )
			v:x( mod_plr_origin[pn][1] )
		end
	end)
end, persist=true }

local rcol = 1
local function get_rcol()
	local old = rcol
	while rcol == old do rcol = math.random(1,4) end
	return old
end

-- Intro 1
do
	ease{ 0, 100, 'bumpy', 200, 'bumpyperiod', 40, 'wave' }

	func{ 34, function()
		mod_plr(function(p)
			p:bounce()
			p:effectmagnitude( 0, -20, 0 )
			p:effectclock( 'bgm' )
			p:effectperiod( 2 )
		end)
	end, persist=64-0.1 }
	func{ 64+2, function()
		mod_plr(function(p)
			p:stopeffect()
		end)
	end }
	local side = 1
	for i=2, 62, 4 do
		ease{ i, 2, outElastic, i==30 and 0 or (10 * side), 'rotationz', extra={0.5,1} }
		if i~=30 then side = -side end
	end
	ease{ 64, 2.5, outElastic, 'rotationz', extra={0.5,1} }
	ease{ 64, 2.5, outCubic, 'bumpy', 'bumpyperiod', 'wave' }

	local twow = { 8, 24, 40, 56 }
	for _,v in ipairs( twow ) do
		ease{ v, -deg_to_rad(360)*2, 'confusionoffset' }{ v, 2, linear, 'confusionoffset' }
		mod_wiggle( v, 2, outCubic, 50, 0.5, 'drunk' )
	end
end

-- Intro 2a + 2b
do

	local boops = { 66-0.5, 82-0.5, 98-0.5, 114-0.5 }
	for _,start_beat in ipairs( boops ) do
		for off=0,1 do
			local off=off*4
			local mlt=off==0 and 0 or 100
			ease{ start_beat+off+0, 1, inOutCubic, 100-mlt, 'invert' }{ start_beat+off+1, 1, inOutCubic, mlt, 'invert' }{ start_beat+off+2, 1, inOutCubic, 100-mlt, 'invert' }
			mod_bounce( start_beat+off+0, 1, 0, -125, 'tinyx', 'Cubic', true)
			-- mod_bounce( start_beat+off+0, 1, 0, 75, 'tinyy', 'Cubic', true)
			mod_bounce( start_beat+off+1, 1, 0, -125, 'tinyx', 'Cubic', true)
			-- mod_bounce( start_beat+off+1, 1, 0, 75, 'tinyy', 'Cubic', true)
			mod_bounce( start_beat+off+2, 1, 0, -125, 'tinyx', 'Cubic', true)
			-- mod_bounce( start_beat+off+2, 1, 0, 75, 'tinyy', 'Cubic', true)
		end
	end

	ease{ 74-0.5, 1, outCubic, 10, 'reverse' }
	ease{ 75-0.5, 1, inOutCubic, -10, 'reverse' }; mod_bounce( 75-0.5, 1, 0, -50, 'tinyy', 'Cubic', true)
	ease{ 76-0.5, 1, inOutCubic, 10, 'reverse' }; mod_bounce( 76-0.5, 0.8, 0, -50, 'tinyy', 'Cubic', true)
	ease{ 77, 1, inOutCubic, 0, 'reverse' };
	ease{ 77, 360, 'rotationy',  -deg_to_rad(360), 'confusionyoffset' }{ 77, 2, inOutCubic, 0, 'rotationy', 'confusionyoffset' };

	ease{ 106-0.5, 1, outCubic, 90, 'reverse' }
	ease{ 107-0.5, 1, inOutCubic, 110, 'reverse' }; mod_bounce( 107-0.5, 1, 0, -50, 'tinyy', 'Cubic', true)
	ease{ 108-0.5, 1, inOutCubic, 90, 'reverse' }; mod_bounce( 108-0.5, 0.8, 0, -50, 'tinyy', 'Cubic', true)
	ease{ 109, 1, inOutCubic, 100, 'reverse' };
	ease{ 109, -360, 'rotationy',  deg_to_rad(360), 'confusionyoffset' }{ 109, 2, inOutCubic, 0, 'rotationy', 'confusionyoffset' };

	-- pmods.bumpyy = -200
	-- pmods.bumpyyperiod = 400
	-- ease{ 92, 1, outCubic, 50, 'reverse' }{ 94, 1, outCubic, 100, 'reverse' }
	local heck = {89, 90, 91, 91.5, 92, 93, 93.5, 94}
	for i,v in ipairs( heck ) do
		local mlt = (v-heck[1]) / (heck[#heck]-heck[1])
		ease{ v, 0.5, outCubic, 100 * mlt, 'reverse' }
	end
	mod_wiggle(91, 1, inOutCubic,  100, 0.5, 'drunk')
	mod_wiggle(93, 1, inOutCubic, -100, 0.5, 'drunk')
	ease{ 122, 130, linear, 20, 'stealth' }

	ease{ 122, 0, 'reverse', 100, 'reverse0', 'reverse1', 'reverse2', 'reverse3' }
	ease{ 122, -200, 'tinyy3' }{ 122, 2, outCubic, 0, 'reverse3', 'tinyy3' }
	ease{ 124, -200, 'tinyy0' }{ 124, 2, outCubic, 0, 'reverse0', 'tinyy0' }
	ease{ 126, -200, 'tinyy1' }{ 126, 2, outCubic, 0, 'reverse1', 'tinyy1' }
	ease{ 128, -200, 'tinyy2' }{ 128, 2, outCubic, 0, 'reverse2', 'tinyy2' }
	ease{ 128, 2, inCubic, 50, 'reverse', -6000, 'tiny', 50, 'flip' }

	-- ease{ 129, 1, inCubic, -4000, 'mini', 60, 'flip', 50, 'reverse' }
	func{ 128, function()
		mod_plr(function(p)
			p:finishtweening()
			p:accelerate( am_bl(2) )
			p:x( SCREEN_CENTER_X )
		end)
	end }
	ease{ 130, 'flip', 'reverse', 'tiny', 50, 'stealth' }

	func{ 65, function()
		bg('itg'):linear( am_bl(128-65) )
		bg('itg'):zoom( 0.85 )
		bg('itg'):rotationz( -5 )
	end, persist=130 }
	func{ 128, function()
		bg('itg'):stoptweening()
		bg('itg'):tween( am_bl(1.5	), 'inCubic(%f,0,1,1)' )
		bg('itg'):zoom( 1 )
		bg('itg'):rotationz( 0 )
	end }

end

-- Slow 1 + Slow 2
do
	ease{ 130, 0, 'stealth', 'dark', 1, 'zbuffer' }
	func{ 130, function()
		bg('itg'):hidden(1)
		bg('Block'):hidden(0)
		bg('Block'):diffuse( 0, 0, 0, 1 )
		fg('Flash'):hidden(0)
		fg('Flash'):decelerate( am_bl(145-130) )
		fg('Flash'):diffusealpha( 0 )
		fg('Flash'):queuecommand('Hide')
		mod_plr(function(p)
			p:finishtweening()
			p:x( SCREEN_CENTER_X )
		end)
	end, persist=190 }
	func{ 146, function()
		bg('Block'):hidden(0)
		bg('Block'):diffuse( 0, 0, 0, 1 )
		fg('Flash'):finishtweening()
		fg('Flash'):queuecommand('Hide')
	end, persist=190 }

	ease{ 130, 50, 'flip', 120, 'wave', 0, 'waveoffset', 10, 'dizzy', 10, 'drunk', 25, 'tipsy' }
	ease{ 130, -60, 'centered2' }
	local carou_mult = 1
	local carou_rad = 1
	local col_stealth = {}; for i=1,8 do col_stealth[i]=0; end
	local col_arrowpath = {}; for i=1,8 do col_arrowpath[i]=0; end
	func{ 130, 190-0.1, function(b)
		local dir = carou_rad > 0 and 1 or -1
		local t = ((b * 0.5) + carou_offset:getaux()) * dir

		for _col=0,7 do
			local pn = _col < 4 and 1 or 2
			local col = math.mod(_col,4)
			local d = _col / 8
			
			local z = math.cos(t + (d * math.pi * 2)) * (180 * carou_rad) * carou_mult

			pmods[ pn ]['movex'..col] = math.sin(t + (d * math.pi * 2)) * (180 * carou_rad) * carou_mult
			pmods[ pn ]['movez'..col] = z

			col_stealth[_col+1] = lerp(col_stealth[_col+1], z < 0 and 1 or 0, delta_time * 12)
			col_arrowpath[_col+1] = lerp(col_arrowpath[_col+1], z < 0 and 1 or 0, delta_time * 12)
			pmods[ pn ]['stealth'..col] = 80 + col_stealth[_col+1] * 18
			pmods[ pn ]['dark'..col] = 50 + 25 + col_stealth[_col+1] * 20
			pmods[ pn ]['arrowpath'..col] = col_arrowpath[_col+1]
		end
		for pn=1,2 do
			pmods[ pn ]['rotationz'] = math.sin(b * math.pi * 0.2) * 5 * carou_mult
			pmods[ pn ]['confusionzoffset'] = -deg_to_rad(pmods[pn]['rotationz'])
			pmods[ pn ]['skewx'] = math.cos(b * 0.5) * 5 * carou_mult
			pmods[ pn ]['noteskew'] = -pmods[pn]['skewx']
		end
	end }
	local function set_carou_rad(k) carou_rad=k; end
	func_ease{ 146-2, 4,    1, -1.5, set_carou_rad, inOutQuad }
	func_ease{ 150-2, 4, -1.5,  1.5, set_carou_rad, inOutQuad }
	func_ease{ 154-2, 4,  1.5, -1.5, set_carou_rad, inOutQuad }
	func_ease{ 158-2, 4, -1.5,  1.5, set_carou_rad, inOutQuad }
	func_ease{ 162-2, 2,  1.5,    0, set_carou_rad, inQuad    }
	func_ease{ 162-0, 2,    0,   -1, set_carou_rad, outCubic  }

	func_ease{ 178-2, 4,   -1,  1.5, set_carou_rad, inOutQuad }
	func_ease{ 182-2, 4,  1.5, -1.5, set_carou_rad, inOutQuad }	
	func_ease{ 186-2, 4, -1.5,  1.5, set_carou_rad, inOutQuad }	
	func_ease{ 190-2, 2,  1.5,    0, set_carou_rad, inQuad }	
	func{ 190, function()
		carou_mult = 0
	end }
	ease{ 186, 4, inCubic, 'centered2' }
	local r = { 190, 4, outCubic, 0, 'flip', 'wave', 'waveoffset', 'dizzy', 'drunk', 'tipsy', 'rotationz', 'confusionoffset', 'skewx', 'noteskew' }
	for col=0,3 do
		table.insert(r, 'stealth'..col)
		table.insert(r, 'dark'..col)
		table.insert(r, 'movex'..col)
		table.insert(r, 'movez'..col)
		table.insert(r, 'arrowpath'..col)
	end
	ease(r)
	func{ 190, function()
		mod_plr(function(p,pn)
			p:tween( am_bl(4), 'outCubic(%f, 0, 1, 1)')
			p:x( mod_plr_origin[pn][1] )
		end)
	end }

	local haah = {130, 138, 162, 170}
	for _,v in ipairs( haah ) do
		func{ v, 'Haah' }
	end

	ease{ 130, -100, 'arrowpathdrawsizeback', 50, 'arrowpathdrawsize' }
	ease{190, 'arrowpathgirth', 'arrowpathdrawsizeback', 'arrowpathdrawsize'}

	local c2l = lua{ 'fg/slownd' }
	local ap_num=0
	local do_ap = function(b)
		local apn = ap_num
		func_ease{ b, 2, 100, 0, function(k)
			col_arrowpath[apn] = k
		end, outCubic }
		ap_num = math.mod( ap_num , 8 ) + 1
	end
	for i,v in ipairs( c2l ) do
		local b,c,t = unpack(v)
		c=c+1
		if t == 1 then
			if c ~= 4 then
				do_ap(b)
				if c == 2 or c == 3 then
					local colnum = get_rcol() - 1
					mod_bounce(b, 0.5, 0, -100, 'tiny'..colnum, 'Cubic', false, math.random(1,2))
				end
			else
				local colnum = get_rcol() - 1
				mod_bounce(b, 1, 0, -50, 'movey'..colnum, 'Cubic')
				-- mod_bounce(b, 1, 0, -30, 'tinyy'..colnum, 'Cubic')
			end
		elseif t == 2 then
			if c == 3 then
				ease_offset{ b, deg_to_rad(360), 'confusionoffset' }{ b, 2, outCubic, 'confusionoffset' }
				mod_wiggle( b, 1, outCubic, 50, 0.25, 'drunk')
				for i=b,b+1,0.25 do
					do_ap(i)
				end
			end
		elseif t == 'M' then
			func{ b, function()
				carou_offset:tween( am_bl(1), 'outCubic(%f,0,1,1)')
				carou_offset:aux( carou_offset:getaux() + 0.5 )
			end }
		end
	end

	ease_offset{ 192, deg_to_rad(360), 'confusionoffset' }{ 192, 2, outCubic, 'confusionoffset' }

	func{ 190, function()
		bg('Interior'):hidden(0)
		bg('Block'):hidden(0)
		bg('Block'):decelerate( am_bl(4) )
		bg('Block'):diffuse( 0, 0, 0, 0.2 )
	end, persist=true }
end

-- Chorus 1a + Chorus 1b
do
	func_ease{ 194-1, 2, 0, -6, function(k)
		bg('Interior'):GetChild('Inner'):aux( k )
	end, inOutCubic }

	func{ 224-1, function()
		bg('Interior'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):rotationz(180)
		bg('Interior'):GetChild('Inner'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):GetChild('Inner'):y( SCREEN_CENTER_Y*2.5 )
		mod_plr(function(p, pn)
			p:finishtweening()
			p:rotationz( 0 )
			p:tween( am_bl(1), 'inCubic(%f,0,1,1)' )
			p:x( mod_plr_origin[pn][1] + (SCREEN_CENTER_X - mod_plr_origin[pn][1])/2 )
			p:rotationz( pn==1 and 10 or -10 )
			p:tween( am_bl(1), 'outCubic(%f,0,1,1)' )
			p:x( SCREEN_CENTER_X )
			p:rotationz( 0 )
		end)
	end, persist=256-1 }
	func{ 256-1, function()
		bg('Interior'):rotationz(-180)
		bg('Interior'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):rotationz(0)
		bg('Interior'):GetChild('Inner'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):GetChild('Inner'):y(0)
		mod_plr(function(p,pn)
			p:finishtweening()
			p:rotationz( 0 )
			p:tween( am_bl(1), 'inCubic(%f,0,1,1)' )
			p:x( mod_plr_origin[pn][1] + (SCREEN_CENTER_X - mod_plr_origin[pn][1])/2 )
			p:rotationz( pn==1 and -10 or 10 )
			p:tween( am_bl(1), 'outCubic(%f,0,1,1)' )
			p:x( mod_plr_origin[pn][1] )
			p:rotationz( 0 )
		end)
	end, persist=288 }
	func{ 288-1, function()
		bg('Interior'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):rotationz(180)
		bg('Interior'):GetChild('Inner'):tween( am_bl(2), 'inOutCubic(%f,0,1,1)' )
		bg('Interior'):GetChild('Inner'):y( SCREEN_CENTER_Y*2.5 )
		mod_plr(function(p,pn)
			p:finishtweening()
			p:rotationz( 0 )
			p:tween( am_bl(1), 'inCubic(%f,0,1,1)' )
			p:x( mod_plr_origin[pn][1] + (SCREEN_CENTER_X - mod_plr_origin[pn][1])/2 )
			p:rotationz( pn==1 and 10 or -10 )
			p:tween( am_bl(1), 'outCubic(%f,0,1,1)' )
			p:x( SCREEN_CENTER_X )
			p:rotationz( 0 )
		end)
	end, persist=314 }
	func_ease{ 256-1, 2, -6, 6, function(k) bg('Interior'):GetChild('Inner'):aux( k ) end, outInCubic }
	func_ease{ 306, 1, 6, 0, function(k) bg('Interior'):GetChild('Inner'):aux( k ) end, outCubic }
	func_ease{ 309, 1, 24, 0, function(k) bg('Interior'):GetChild('Inner'):aux( k ) end, outCubic }
	func_ease{ 310.5, 1, 24, 0, function(k) bg('Interior'):GetChild('Inner'):aux( k ) end, outCubic }
	func_ease{ 314, 320, 0, 128, function(k) bg('Interior'):GetChild('Inner'):aux( k ) end, inCubic }

	ease{ 256, 2, inCubic, 100, 'reverse', 0, 'hallway' }
	ease{ 256, 2, inCubic, -100, 'tinyy' }{ 256+2, 0, 'tinyy'}
	ease_offset{ 258, 2, inQuint, 10, 'stealth'}{ 260, 274, 0, 'stealth' }

	local c2l = lua{ 'fg/chorusnd' }
	ease{ c2l[1][1], 16000, 'tandrunksize', -100, 'tandrunkperiod', 100, 'zbuffer' }{ c2l[#c2l][1], 1, outCubic, 'bumpy', 'tandrunksize', 'tandrunkperiod', 'zbuffer' }
	local dm = 1
	local tm = 1
	local bm = 1
	local pm = 1
	local zm = 1
	local fop = -1
	local flop = 0
	for i,v in ipairs( c2l ) do
		local b,c,t = unpack(v)
		local sl = (b >= 225 and b <=257) or (b >= 289 and b <= 322)
		local rd = math.random(1,2)==1 and -1 or 1
		local r2d2 = math.random(1,2)==1 and -1 or 1
		c=c+1

		if t == 1 then
			if c == 1 then
				ease{ b, 200 * dm, 'drunk' }{ b, 2, outCubic, 'drunk' }
				dm = -dm
			elseif c == 3 then
				ease_offset{ b, 20, 'bumpy', 100, 'tipsy', 0.2*bm, 'confusion', 500, 'zoomz' }{ b, 4, outCubic, 'bumpy', 'tipsy', 'confusion', 100, 'zoomz' }
				ease_offset{ b, -150, 'tiny' }{ b, 1, outCubic, 'tiny' }
				bm = -bm
			end
		elseif t == 4 then
			if c == 2 then
				ease{ b, 20, 'stealth' }{ b, v.length+0.5, outCubic, 0, 'stealth' }
				if v.length == 2 then
					ease{ b+2, 20, 'stealth' }{ b+2, 2, outCubic, 0, 'stealth' }
				end
			end
		end

		if not sl then

			if t == 'M' and c == 3 then
				ease_offset{ b, -10*tm, 'reverse', 20*tm, 'alternate' }{ b, 1, outCubic, 'reverse', 'alternate' }
				local rand = get_rcol() - 1
				ease{ b, -250, 'tiny'..rand }{ b, 1, outCubic, 'tiny'..rand }
				tm = -tm
			end
			if t == 2 and c == 4 then
				ease_offset{ b, 50*rd, 'zigzag', 50*r2d2, 'square', -50, 'zigzagperiod' }{ b, v.length+0.5, outCubic, 'zigzag', 'square', 'zigzagperiod' }
				ease_offset{ b, 20, 'tandrunk' }{ b, v.length, outCubic, 'tandrunk' }
			end
			if t == 1 and c == 2 then
				ease{ b, 0.5, outCubic, fop==-1 and 25 or 0, 'flip', fop==-1 and -75 or 0, 'invert' }
				ease{ b, 0.5, outCubic, flop == 2 and 0 or (-80 * fop), 'square' }
				fop = -fop
				flop = math.mod( flop + 1, 3 )
			end

		else

			if t == 4 and c == 2 then
				ease{ b, 800, 'dizzy' }{ b, 2, outCubic, 'dizzy' }
				mod_wiggle2( b, 2, outCubic, 80, 0.25, 'drunk' )
				mod_wiggle2( b, 2, outCubic, 80, 0.25, 'tipsy' )
			end
			if c == 4 then
				if t == 1 or t == 'M' then
					local mult = t == 1 and 20 or 50
					local plr = pm==1 and 1 or 2
					local plr2 = pm==1 and 2 or 1
					ease_offset{ b, 5, 'reverse' }
					ease_offset{ b, 1, outCubic, 'reverse' }

					ease_offset{ b, 1, outCubic, 120, 'stealth', 100, 'dark', -50, 'flip', 50, 'dizzy', 200*zm, 'tipsy', plr=plr }
					ease_offset{ b, 1, outCubic, 0, 'stealth', 50, 'dark', 0, 'flip', 'tipsy', plr==2 and -10 or 10, 'dizzy', plr=plr2 }
					pm=-pm
					zm=-zm
				elseif t == 2 or t == 4 then
					local hi = (t == 4) and 2 or 1
					ease_offset{ b, 40 * hi, 'tandrunk' }{ b, v.length, outCubic, 'tandrunk' }
				end
			end

		end
	end

	local fwop = 1
	for i=303,305 do
		ease{i, 1, 0, 'drivendrop' }{ i, 1, linear, 100, 'drivendrop' }
		fwop = math.mod( fwop + 1, 2 )
	end
	ease{306, 2, outCubic, 0, 'drivendrop' }

	local rott = {
		{226,  1},
		{234, -1},
		{242,  2},
		{250, -2},
		{256,  0},
		{290,  1},
		{298, -1},
		{306,  2},
		{314, -2},
	}
	for _,v in ipairs( rott ) do
		if v[1] ~= 256 then
			ease{ v[1], 1, outCubic, 40 * v[2], 'hallway' }
		end
		ease{ v[1], 1, outCubic, v[2]~=0 and -20 or 0, 'mini' }
		if v[2] == 1 then
			ease_offset{ v[1], 2, 50, 'drunk', plr=1 }
			ease_offset{ v[1], 2, -50, 'drunk', plr=2 }
			ease{ v[1], 1, outCubic, -40, 'bumpy', plr=1 }
			ease{ v[1], 1, outCubic, 40, 'bumpy', plr=2 }
		end
		if v[2] == 2 then
			ease_offset{ v[1], 1, outCubic, 'stealth', 'dark', 'flip', 'dizzy', 'tipsy', 'drunk' }
			ease{ v[1], 1, outCubic, 80, 'bumpy' }
		end
	end
	ease{ 320, 2, inCubic, 0, 'hallway', 'reverse', 'mini' }
end

-- round bag
func{ 190, last_beat, function()
	local int = bg('Interior'):GetChild('Inner')
	local amt = int:getaux()
	local pos = int:GetX()
	local sig = amt < 0 and -1 or 1
	local h = 320
	local f = SCREEN_CENTER_X + (h * sig)
	int:addx( amt * (delta_time * 60) )
	
	if (sig < 0 and pos < f) or (sig >= 0 and pos > f) then
		int:addx( h * -sig )
	end
end }

-- Chorus 2a + Chorus 2b
do
	func{ 322, function()
		aft.get_sprite('global'):bounce()
		aft.get_sprite('global'):effectmagnitude( 0, 0, -40 )
		aft.get_sprite('global'):effectclock( 'bgm' )
		aft.get_sprite('global'):effectperiod( 2 )
	end, persist=378 }
	func{ 378, function()
		aft.get_sprite('global'):stopeffect()
	end }

	ease{ 322, 10, 'dizzy', plr=1 }{ 322, -10, 'dizzy', plr=2 }{ 378, 4, linear, 0, 'dizzy' }
	func{ 320, function()
		mod_plr(function(p,pn)
			p:finishtweening()
			p:x( SCREEN_CENTER_X )
			p:tween( am_bl(2), 'inCubic(%f,0,1,1)' )
			p:zoomx( 1.5 )
			p:x( mod_plr_origin[pn][1] )
			p:sleep( 0 )
			p:zoomx( 1 )
		end)
	end }
	func_ease{ 320, 2, 180, 90, function(k) bg('Interior'):rotationz(k) end, inSine }
	func_ease{ 320, 2, SCREEN_CENTER_Y*2.5, SCREEN_CENTER_Y*0.5, function(k) bg('Interior'):GetChild('Inner'):y(k) end, inSine }
	func{ 322, 354, function(b)
		local t = (b-322) * math.pi * 2	
		bg('Interior'):GetChild('Inner'):aux( 6 + (math.mod(b,2) * 4) )
		bg('Interior'):rotationx( math.sin(b*math.pi*0.5*0.5) * 5 )
		bg('Interior'):rotationy( math.cos(b*math.pi*0.5*0.5) * 5 )
	end }
	local intmlt = 1
	func_ease{ 374, 375, 1, 0, function(k) intmlt=k end, linear }
	func{ 354, 375, function(b)
		local t = (b-354) * math.pi * 2
		bg('Interior'):GetChild('Inner'):aux( -6 - (math.mod(b,2) * 4) )
		bg('Interior'):rotationx( math.sin(b*math.pi*0.5*0.5) * 5 * intmlt )
		bg('Interior'):rotationy( math.cos(b*math.pi*0.5*0.5) * 5 * intmlt )
	end }
	func{ 378, function()
		bg('Interior'):tween( am_bl(3), 'outCubic(%f,0,1,1)' )
		bg('Interior'):rotationz(0)
		bg('Interior'):GetChild('Inner'):tween( am_bl(3), 'outCubic(%f,0,1,1)' )
		bg('Interior'):GetChild('Inner'):y( 0 )
	end }

	ease{ 322-0.5, 100, 'beat', -50, 'beatmult' }{ 378, 0, 'beat', 'beatmult' }
	redirs{'xbumpy', function(v,pn)
		pmods[pn].bumpyxperiod = math.abs(v) > 0 and 600 or 0
		pmods[pn].bumpyx = v
	end }
	mod_bounce( 322, 2, 0, 200, 'xbumpy', 'Cubic'); ease{ 322, 100, 'arrowpath' }{ 322, 6, outCubic, 0, 'arrowpath' }
	mod_bounce( 338, 2, 0, -200, 'xbumpy', 'Cubic'); ease{ 338, 100, 'arrowpath' }{ 338, 6, outCubic, 0, 'arrowpath' }
	mod_bounce( 354, 2, 0, 200, 'xbumpy', 'Cubic'); ease{ 354, 100, 'arrowpath' }{ 354, 6, outCubic, 0, 'arrowpath' }
	mod_bounce( 370, 2, 0, -200, 'xbumpy', 'Cubic'); ease{ 370, 100, 'arrowpath' }{ 370, 6, outCubic, 0, 'arrowpath' }

	local swoop_len = 3
	func{ 346, function()
		mod_plr(function(p,pn)
			p:finishtweening()
			p:accelerate( am_bl(swoop_len/2) )
			p:x( SCREEN_CENTER_X )
			p:rotationz( pn==2 and -20 or 20 )
			p:decelerate( am_bl(swoop_len/2) )
			p:x( mod_plr_origin[3-pn][1] )
			p:rotationz( 0 )
		end)
	end }
	func{ 349.5, function()
		mod_plr(function(p,pn)
			p:accelerate( am_bl(swoop_len/2) )
			p:x( SCREEN_CENTER_X )
			p:rotationz( pn==1 and -20 or 20 )
			p:decelerate( am_bl(swoop_len/2) )
			p:x( mod_plr_origin[pn][1] )
			p:rotationz( 0 )
		end)
	end }
	ease{ 378, -360, 'rotationy', deg_to_rad(360), 'confusionyoffset', plr=2 }{ 378, 3, inOutCubic, 'rotationy', 'confusionyoffset', plr=2 }
	ease{ 381.5, 360, 'rotationy', -deg_to_rad(360), 'confusionyoffset', plr=1 }{ 381.5, 3, inOutCubic, 'rotationy', 'confusionyoffset', plr=1 }

	local function vibwonk(b,mult)
		local def = 40
		local min, max = (-def * mult), (def * mult)
		local v = 1
		func_ease{b, 2, 1, 0, function(k)v=k;end, outSine}
		func{b,b+2,function()
			local rx, ry = math.random(min,max), math.random(min,max);
			aft.get_sprite('global'):x2( rx * v )
			aft.get_sprite('global'):y2( ry * v )
		end}
		if mult == 1 then
			func_bounce(b, 2, 0, 1, function(k)
				aft.get_sprite('global'):zoomx( 1.0 + k * 0.2 )
				aft.get_sprite('global'):zoomy( 1.0 - k * 0.2 )
			end, 'Cubic')
		end
		ease{ b, -50*mult, 'mini' }{ b, 4, outCubic, 'mini' }
	end
	vibwonk(322,2)
	vibwonk(338,1)
	vibwonk(354,2)
	vibwonk(370,1)

	mod_bounce( 370, 2, 0, 50, 'mini', 'Cubic', false, 2, nil, true)
	mod_bounce( 370, 2, 0, 100, 'hallway', 'Cubic', false, 2, nil, true)

	local function driven_drop(b, rep)
		ease{ b-0.1, 0, 'centered2', -10 * rep, 'rotationx', -20 * math.abs(rep), 'centered' }
		ease{ b-0.1, 1, linear, 100 * pmods[1].xmod, 'centered2' }
		if math.abs(rep) == 5 then
			ease{ b+1, 6, outElastic, 'rotationx', extra={1,1.5} }
			ease{ b+1, 1, outCubic, 'centered2', 'centered' }
		end
	end
	local drips = { 324, 340, 356, 372 }
	for k,beat in ipairs( drips ) do
		local mlt = math.mod(k,2)==1 and 1 or -1
		for i=0,5 do driven_drop( beat + i, i * mlt ) end
	end

	local function woopstretch(b)
		func{ b+0	, function()
			mod_plr(function(p)
				p:finishtweening()
				p:tween( am_bl(0.8), 'outCubic(%f,0,1,1)' )
				p:zoomx( 1.2 )
				p:zoomy( 0.8 )
			end)
		end }
		func{ b+1, function()
			mod_plr(function(p)
				p:tween( am_bl(0.8), 'outCubic(%f,0,1,1)' )
				p:zoomx( 0.6 )
				p:zoomy( 1.4 )
			end)
		end }
		func{ b+2, function()
			mod_plr(function(p)
				p:tween( am_bl(5), 'outSine(%f,0,1,1)' )
				p:zoomx( 1 )
				p:zoomy( 1 )
			end)
		end }
	end
	woopstretch( 330 )
	woopstretch( 362 )

	local function waggle(v)
		local spr = aft.get_sprite('global')
		local b = GAMESTATE:GetSongBeat()
		local sy = math.cos(b * math.pi * 1.5) * 0.2 * v
		local sx = math.sin(b * math.pi * 1.5) * 0.2 * v
		spr:skewx( sx )
		spr:skewy( sy )
		spr:zoom( 1.0 - (0.1 * v) )
		mod_plr(function(p,pn)
			pmods[pn].noteskew = sx * 100
			pmods[pn].noteskewy = sy * 100
		end)
	end
	local side = 1
	for _,v in ipairs({ {332.5,338} , {364.5,370,1} }) do
		for i=v[1],v[2],0.5 do
			local beat = 1 - ( (i-v[1]) / (v[2]-v[1]) )
			beat = outCubic( beat, 0, 1, 1 )
			if v[3] then
				ease{ i, 0.5, outCubic, 100 * beat * side, 'drunk', pn=1 }
				ease{ i, 0.5, outCubic, 100 * -beat * side, 'drunk', pn=2 }
			else
				ease{ i, 0.5, outCubic, 100 * beat * side, 'drunk' }
			end
			side = -side
		end
		if v[3] then
			mod_wiggle( v[1], v[2], outCubic, 100, 0.5, 'tipsy', false, 1)
			mod_wiggle( v[1], v[2], outCubic, -100, 0.5, 'tipsy', false, 2)
		else
			mod_wiggle( v[1], v[2], outCubic, 100, 0.5, 'tipsy')
		end
		func_bounce( v[1], v[2], 0, 1, waggle, 'Quint')
	end

	for i=322,370,(330-322) do
		ease{ i+0,  150, 'zoomx', -100, 'tinyx' }{ i+0, 2, outCubic, 100, 'zoomx', 0, 'tinyx' }
		ease{ i+2, -300,  'tiny', 200, 'bumpy' }{ i+2, 2, outCubic, 'tiny', 'bumpy' }
		ease{ i+5,  150, 'zoomx', -100, 'tinyx' }{ i+5, 2, outCubic, 100, 'zoomx', 0, 'tinyx' }
		ease{ i+6, -300,  'tiny', 200, 'bumpy' }{ i+6, 1, outCubic, 'tiny', 'bumpy' }
	end

	for i=352.5,353.5,0.5 do
		ease{ i+0.0, 50, 'stealth' }{ i, 0.5, outCubic, 'stealth' }
	end
	ease{ 352.5, 1.5, inCubic, 100, 'reverse', -200, 'tinyy' }{ 352.5+1.5, 0, 'tinyy' }
	ease_offset{ 354, -1000, 'tiny' }{ 354, 1, outCubic, 'tiny' }

	func{ 354, function()
		mod_plr(function(p)
			p:x( SCREEN_CENTER_X )
		end)
		pmods[1].invert = 250
		pmods[2].invert = -250
	end, persist=true }
	ease_offset{ 354, 8, linear, 20, 'drunk', -40, 'tipsy', plr=1 }{ 354, 8, linear, -20, 'drunk', 40, 'tipsy', plr=2 }

	ease{ 386, 400, outSine, 2400, 'bumpy', 200, 'tornado', -50, 'distant', 100, 'dark', 20, 'stealth' }
	ease_offset{ 378, 386, outSine, 'drunk', 'tipsy' }
	func_ease{ 386, 400, -6, 0, function(k) bg('Interior'):GetChild('Inner'):aux(k) end, outCubic }
	ease{ 386, 404, linear, -100, 'suddenoffset' }

	func{ 400, function()
		local f = fg('Fade')
		f:hidden(0)
		f:diffuse(0,0,0,0)
		f:linear( am_bl(418-400) )
		f:diffusealpha(1)
	end }
end