--[[

	"The true pee pee poo poo
		was the friends that we have made along the way"
	- mel

]]

-- CONSTANTS
MAP_WIDTH_TILES = 19
MAP_HEIGHT_TILES = 15
TILE_SIZE = 25

MAP_WIDTH = MAP_WIDTH_TILES * TILE_SIZE
MAP_HEIGHT = MAP_HEIGHT_TILES * TILE_SIZE
MAP_LEFT = ( SCREEN_CENTER_X ) - ( MAP_WIDTH / 2 )
MAP_TOP = ( SCREEN_CENTER_Y ) - ( MAP_HEIGHT / 2 )

TILE_MAX_SIZE = 128
TILE_TEX_X = 3
TILE_TEX_Y = 3
TILE_TEX_W = TILE_SIZE * TILE_TEX_X
TILE_TEX_H = TILE_SIZE * TILE_TEX_Y
TILE_TEX_WN = TILE_TEX_W / TILE_MAX_SIZE
TILE_TEX_HN = TILE_TEX_H / TILE_MAX_SIZE
TILE_TEX_WO = TILE_TEX_WN / TILE_TEX_X
TILE_TEX_HO = TILE_TEX_HN / TILE_TEX_Y

MAX_LEVEL_COUNT = 1
WALK_LEN = 0.1

--

ignoreInput = true
gameStarted = false
gameFinished = false
gameLoop = false
menuState = 0
levelCount = 0
solvedLevelsCount = 0
levelsSolvedFirstTry = 0
levelTryCount = 0
maxPoints = 0
maxLevelPoints = 0
currentPoints = 0
totalPlayerPoints = 0
coinBags = 0
_coinBags = 0
iceMelted = 0
_iceMelted = 0

iceMelts = {
	-- { x, y, state, timer }
}

--

-- i had to split this into two difficulties for two reasons:
-- 1. doing the full 1-10 levels takes more time than the song
-- 2. by the time i realized this, i have added level 10. and i am Not undoing the key gate logic
levelList = {}
is_slump = (GAMESTATE:IsPlayerEnabled(0) and GAMESTATE:GetCurrentSteps(0):GetDifficulty() == 5) or (GAMESTATE:IsPlayerEnabled(1) and GAMESTATE:GetCurrentSteps(1):GetDifficulty() == 5)
if is_slump then
	levelList = {1,2,6,8,9,10} -- i wanna be the puffle
else
	levelList = {1,2,3,4,5,6,7,8} -- normal
end

--

function end_game()
	if not GAMESTATE:IsEditMode() then
		for pn=1,2 do
			if SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn) then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(pn - 1):SetPossibleDancePoints(maxPoints)
				STATSMAN:GetCurStageStats():GetPlayerStageStats(pn - 1):SetActualDancePoints(totalPlayerPoints)
				GAMESTATE:FinishSong()
			end
		end
	else
		SCREENMAN:SystemMessage( totalPlayerPoints .. " / " .. maxPoints .. " (" .. math.round(totalPlayerPoints/maxPoints,2) .. ")")
	end
end

--

function fail_game()
	
	totalPlayerPoints = totalPlayerPoints + currentPoints
	currentPoints = 0
	coinBags = coinBags + _coinBags
	iceMelted = iceMelted + _iceMelted

	local funny = false
	if funny or math.random(1,100) == 1 then
		MESSAGEMAN:Broadcast('GameFailedSfx2')
		local puf = fg('ScreenGame')('Puffle')
		puf:stoptweening()
		puf:decelerate(1)
		puf:rotationz(math.random(180,360))
		puf:addy(-40)
		for _,v in ipairs(puf:GetChildren()) do
			v:stoptweening()
			v:linear(1)
			v:diffusealpha(0)
		end
		MESSAGEMAN:Broadcast('GameFailed')
		-- Tweeny:Tween(2):OnEnd(function() end)
	else
		MESSAGEMAN:Broadcast('GameFailedSfx1')
		MESSAGEMAN:Broadcast('GameFailed')
		Tweeny:Tween(1):OnEnd(function()
			print()
			print('damn hes dead')
		end)
	end
	
end

function win_game()
	if currentLevel ~= nil and not currentLevel.dont_include_points then
		totalPlayerPoints = totalPlayerPoints
		if _iceMelted >= maxLevelPoints then
			solvedLevelsCount = solvedLevelsCount + 1
			if levelTryCount == 1 then levelsSolvedFirstTry = levelsSolvedFirstTry + 1 end
		end

		totalPlayerPoints = totalPlayerPoints + currentPoints
		currentPoints = 0
		coinBags = coinBags + _coinBags
		iceMelted = iceMelted + _iceMelted
	end
	

	fg('ScreenGame')('Timer'):hidden(1)

	MESSAGEMAN:Broadcast('GameFinished')
end

local function set_judgments()

	local fant = player.get_final_points()
	local excel = iceMelted
	local great = solvedLevelsCount
	local decent = coinBags * 10

	mod_plr(function(_,pn)
		local stat = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn-1)
		stat:SetTapNoteScores(TNS_MARVELOUS,fant)
		stat:SetTapNoteScores(TNS_PERFECT,excel)
		stat:SetTapNoteScores(TNS_GREAT,great)
		stat:SetTapNoteScores(TNS_GOOD,decent)
	end)
	
end

function game_check()
	if GAMESTATE:GetSongBeat() > 96 and not gameFinished then
		gameFinished = true
		ignoreInput = true
		gameLoop = false
		if currentLevel.dont_include_points then win_game() else fail_game() end
		set_judgments()
		return true
	end
	return false
end

--

player = {
	_pos = { 1, 1 },
	_oldpos = { 1, 1 },
	_walkTimer = 0,
	_size = 25,
	_lastHeldButton = nil,
	hasKey = false,

	-- why did i put stuff here again? 

	get_final_points = function()
		return totalPlayerPoints
	end,

	can_walk = function() return player._walkTimer <= 0 end,
	set_player_pos = function(x, y)
		player._oldpos = { player._pos[1], player._pos[2] }
		player._pos = { x, y }
	end,
	get_player_pos = function() return { player._pos[1], player._pos[2] } end,
	set_player_sprite = function()
		if player._walkTimer <= 0 then
			local x = MAP_LEFT + ( player._pos[1] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			local y = MAP_TOP + ( player._pos[2] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			fg('ScreenGame')('Puffle'):xy( x, y )
		else
			local ox = MAP_LEFT + ( player._oldpos[1] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			local oy = MAP_TOP + ( player._oldpos[2] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			local nx = MAP_LEFT + ( player._pos[1] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			local ny = MAP_TOP + ( player._pos[2] - 1 ) * TILE_SIZE + ( player._size * 0.5 )
			local tx = linear( WALK_LEN - player._walkTimer, ox, nx-ox, WALK_LEN )
			local ty = linear( WALK_LEN - player._walkTimer, oy, ny-oy, WALK_LEN )
			fg('ScreenGame')('Puffle'):xy( tx, ty )
		end
	end,

	walk = function( btn, vx, vy )

		local old_pos = {
			player._pos[1],
			player._pos[2]
		}
		local new_pos = {
			player._pos[1] + vx,
			player._pos[2] + vy,
		}

		if is_tile_walkable( new_pos[1], new_pos[2] ) then
			ignoreInput = true

			local new_tile = currentLevel.map[ new_pos[2] ][ new_pos[1] ]
			local old_tile = currentLevel.map[ old_pos[2] ][ old_pos[1] ]

			if new_tile == 5 then
				MESSAGEMAN:Broadcast('PuffleCoin')
				currentLevel.map[ new_pos[2] ][ new_pos[1] ] = 2
				currentPoints = currentPoints + 10
				_coinBags = _coinBags + 1
			elseif new_tile == 7 then
				currentLevel.map[ new_pos[2] ][ new_pos[1] ] = 2
				player.hasKey = true
				MESSAGEMAN:Broadcast('PuffleKey')
				fg('ScreenGame')('TileKey'):hidden(1)
			elseif new_tile == 8 then
				currentLevel.map[ new_pos[2] ][ new_pos[1] ] = 2
				MESSAGEMAN:Broadcast('PuffleKey')
			end
			if old_tile == 6 then
				MESSAGEMAN:Broadcast('ThickMelt')
				currentLevel.map[ old_pos[2] ][ old_pos[1] ] = 2
				_iceMelted = _iceMelted + 1
			else
				currentLevel.map[ old_pos[2] ][ old_pos[1] ] = -1
				_iceMelted = _iceMelted + 1
				table.insert( iceMelts, {
					x = old_pos[1]+1,
					y = old_pos[2]+1,
					state = 0,
					timer = 0.02
				} )
			end
			currentPoints = currentPoints + 1

			player._lastHeldButton = btn

			update_map_tiles()

			player.set_player_pos( new_pos[1], new_pos[2] )
			player._walkTimer = WALK_LEN
			if old_tile ~= 6 then MESSAGEMAN:Broadcast('PuffleMove') end
		else
			ignoreInput = false
		end

	end,

	_on_walk_end = function()
		if currentLevel.map[ player._pos[2] ][ player._pos[1] ] == 4 then
			MESSAGEMAN:Broadcast('PuffleNextLevel')
			if levelCount + 1 > #levelList then
				load_level( "bonus" )
				MESSAGEMAN:Broadcast('GameBonus')
			else
				load_next_level()
			end
			ignoreInput = false
			return
		end

		if is_player_stuck() then
			MESSAGEMAN:Broadcast('PuffleSink')
			fg('ScreenGame')('Puffle'):queuecommand('Drown')
			Tweeny:Tween(1.5)
				:OnEnd(function()
					if gameLoop then
						reset_map( true )
						update_map_tiles()

						MESSAGEMAN:Broadcast('PuffleStart')
						fg('ScreenGame')('Puffle'):queuecommand('Spawn')
					end
				end)
			return
		end
		do
			if input_handler:Get( input_handler.TYPE_STEP, 1, player._lastHeldButton ) then
				Tweeny:Tween(0.02)
					:OnEnd(function()
						if gameLoop then
							if input_handler:Get( input_handler.TYPE_STEP, 1, player._lastHeldButton ) then
								player.walk(
									player._lastHeldButton,
									player._lastHeldButton == 1 and -1 or (player._lastHeldButton == 4 and 1 or 0),
									player._lastHeldButton == 3 and -1 or (player._lastHeldButton == 2 and 1 or 0)
								)
							else
								ignoreInput = false
							end
						end
					end)
			else
				ignoreInput = false
			end
		end
	end,
}

--

currentLevel = nil
currentLevelCopy = nil

function is_player_stuck()
	local stuck = { false, false, false, false }
	local dir = { {-1, 0}, {0, 1}, {0, -1}, {1, 0} }
	for i,d in ipairs( dir ) do
		local pos = player.get_player_pos()
		if not is_tile_walkable( pos[1] + d[1], pos[2] + d[2] ) then stuck[i] = true end
	end

	for i=1,4 do
		if stuck[i] == false then return false end
	end
	return true
end

local walkables = {
	[2] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true,
}
function is_tile_walkable( x, y )
	local tile = currentLevel.map[y][x]
	return walkables[ tile ] or (tile == 8 and player.hasKey)
end

function load_level( index )
	if currentLevel ~= nil then
		totalPlayerPoints = totalPlayerPoints
		
		if _iceMelted >= maxLevelPoints then
			solvedLevelsCount = solvedLevelsCount + 1
			if levelTryCount == 1 then levelsSolvedFirstTry = levelsSolvedFirstTry + 1 end
		end
	end

	local level = lua{'fg/maps/' .. index, env=thinice, cache=true}
	maxLevelPoints = level.maxPoints

	for y=1,MAP_HEIGHT_TILES do
		for x=1,MAP_WIDTH_TILES do
			local tile = level.map[y][x]
			set_tile_texture( x-1, y-1, tile )
		end
	end

	currentLevelCopy = level

	levelCount = levelCount + 1
	totalPlayerPoints = totalPlayerPoints + currentPoints
	coinBags = coinBags + _coinBags
	iceMelted = iceMelted + _iceMelted
	
	levelTryCount = 0
	reset_map()
end
function load_next_level()
	load_level( levelList[ levelCount + 1 ] )
end
function reset_map( )
	currentLevel = table.weak_clone( currentLevelCopy )
	currentPoints = 0
	_coinBags = 0
	_iceMelted = 0

	levelTryCount = levelTryCount + 1

	player.set_player_pos( currentLevelCopy.spawn[1], currentLevelCopy.spawn[2] )
	player._oldpos = table.weak_clone( player._pos )
	player.hasKey = false

	if currentLevel.containsKey then
		local key = fg('ScreenGame')('TileKey')
		key:hidden(0)
		key:x( ((currentLevel.keyPos[1]-1)*TILE_SIZE) + (TILE_SIZE/2) )
		key:y( ((currentLevel.keyPos[2]-1)*TILE_SIZE) + (TILE_SIZE/2) )
	end

	iceMelts = {}
end

function index_to_tile_texcoord( i )
	if i == 0 then return 1, 0 end -- empty
	if i == 1 then return 2, 0 end -- wall
	if i == 2 then return 0, 1 end -- ice
	if i == 3 then return 0, 1 end -- spawn (ice)
	if i == 4 then return 1, 1 end -- end
	if i == 5 then return 2, 1 end -- money
	if i == 6 then return 0, 2 end -- double ice
	if i == 7 then return 0, 1 end -- key (ice)
	if i == 8 then return 1, 2 end -- gate

	return 0, 0
end
function update_map_tiles()
	for y=1,MAP_HEIGHT_TILES do
		for x=1,MAP_WIDTH_TILES do
			local tile = currentLevel.map[y][x]
			set_tile_texture( x-1, y-1, tile )
		end
	end
end

function set_tile_texture( x, y, i )
	local tx, ty = index_to_tile_texcoord( i )
	local tl_i = x*4 + y*(MAP_WIDTH_TILES*4)
	local tile_poly = fg('ScreenGame')('TilePolygon')
	local tex_x = TILE_TEX_WN * (tx / TILE_TEX_X)
	local tex_y = TILE_TEX_WN * (ty / TILE_TEX_Y)
	local tex_xa = TILE_TEX_WO
	local tex_ya = TILE_TEX_HO
	tile_poly:SetVertexTexCoord( tl_i+0, tex_x       , tex_y        )
	tile_poly:SetVertexTexCoord( tl_i+1, tex_x+tex_xa, tex_y        )
	tile_poly:SetVertexTexCoord( tl_i+2, tex_x+tex_xa, tex_y+tex_ya )
	tile_poly:SetVertexTexCoord( tl_i+3, tex_x       , tex_y+tex_ya )
end

--[[

function finish_level()
	currentPoints = currentLevel.maxPoints + (currentLevel.coins * 10)
	_coinBags = currentLevel.coins
	_iceMelted = currentLevel.maxPoints

	if levelCount + 1 > #levelList then
		gameFinished = true
		ignoreInput = true
		gameLoop = false

		GAMESTATE:SetSongBeat(96)
		
		win_game()
		set_judgments()
	else
		load_next_level()
	end
end

--]]

--

function init()

	local function cache_map( map, increment )
		local level = lua{'fg/maps/' .. map, env=thinice, cache=true}
		level.coins = 0
		_maxPoints = 0
		for y=1,MAP_HEIGHT_TILES do
			for x=1,MAP_WIDTH_TILES do
				local tile = level.map[y][x]
				if tile == 3 then -- spawn
					_maxPoints = _maxPoints + 1
					level.spawn = {x, y}
				elseif tile == 4 then
					level.finish = {x, y}
				elseif tile == 2 then -- floor
					_maxPoints = _maxPoints + 1
				elseif tile == 5 then -- coin (floor)
					_maxPoints = _maxPoints + 1
					level.coins = level.coins + 1
				elseif tile == 6 then -- thick ice
					_maxPoints = _maxPoints + 2
				elseif tile == 7 then -- key
					_maxPoints = _maxPoints + 1
					level.containsKey = true
					level.keyPos = {x, y}
				elseif tile == 8 then -- gate
					_maxPoints = _maxPoints + 1
				end
			end
		end
		level.maxPoints = _maxPoints -- not incl coins
		if increment then
			maxPoints = maxPoints + _maxPoints
		end
	end

	-- set total max points + initial parse of needed locations
	do
		local _maxPoints = 0
		for levelI=1, #levelList do
			cache_map( levelList[levelI], true )
		end
		cache_map( "bonus", false )
	end

	fg('ScreenGame')('OceanBack'):stretchto( MAP_LEFT, MAP_TOP, MAP_LEFT + MAP_WIDTH, MAP_TOP + MAP_HEIGHT )

	local tile_poly = fg('ScreenGame')('TilePolygon')
	tile_poly:x( MAP_LEFT )
	tile_poly:y( MAP_TOP )
	tile_poly:SetDrawMode('quads')
	tile_poly:SetNumVertices( (MAP_WIDTH_TILES * MAP_HEIGHT_TILES) * 4 )

	fg('ScreenGame')('TileKey'):x2( MAP_LEFT )
	fg('ScreenGame')('TileKey'):y2( MAP_TOP )

	-- generate tile polygon
	local vertice = 0
	for y=0,MAP_HEIGHT_TILES-1 do
		for x=0,MAP_WIDTH_TILES-1 do
			local tlx = x * TILE_SIZE
			local tly = y * TILE_SIZE
			tile_poly:SetVertexPosition( vertice+0, tlx-0          , tly-0          , 0 )
			tile_poly:SetVertexPosition( vertice+1, tlx+TILE_SIZE+1, tly-0          , 0 )
			tile_poly:SetVertexPosition( vertice+2, tlx+TILE_SIZE+1, tly+TILE_SIZE+1, 0 )
			tile_poly:SetVertexPosition( vertice+3, tlx-0          , tly+TILE_SIZE+1, 0 )
			set_tile_texture( x, y, 0 )
			vertice = vertice + 4
		end
	end

	-- :)
	fg('ScreenGame')('OceanRenderer'):xy( MAP_LEFT, MAP_TOP )
	fg('ScreenGame')('OceanRenderer'):SetDrawFunction(function(self)
		local i = 0
		for y=0,MAP_HEIGHT_TILES-1 do
			for x=0,MAP_WIDTH_TILES-1 do
				if currentLevel.map[y+1][x+1] == -1 then
					local spr = self:GetChildAt(i)
					local tlx = x * TILE_SIZE
					local tly = y * TILE_SIZE
					spr:x( tlx + TILE_SIZE / 2 )
					spr:y( tly + TILE_SIZE / 2 )
					spr:Draw()
				end
				i = math.mod( i + 1, 7 )
			end
		end
	end)

	fg('ScreenGame')('IceMeltRenderer'):xy( MAP_LEFT, MAP_TOP )
	fg('ScreenGame')('IceMeltRenderer'):SetDrawFunction(function(self)
		local spr = self:GetChild('Sprite')
		local rem = {}
		for i,ice in pairs(iceMelts) do
			local tlx = (ice.x-1) * TILE_SIZE
			local tly = (ice.y-1) * TILE_SIZE
			spr:x( tlx - (TILE_SIZE / 2) + 1 )
			spr:y( tly - (TILE_SIZE / 2) + 1.5 )
			spr:setstate( ice.state )
			spr:Draw()
		end
	end)
	
	-- input
	input_handler:HookInput( input_handler.TYPE_STEP, 'puffle move', function( btn, plr )
		if ignoreInput or not gameLoop then return end

		if player.can_walk() then
			player.walk(
				btn,
				btn == 1 and -1 or (btn == 4 and 1 or 0),
				btn == 3 and -1 or (btn == 2 and 1 or 0)
			)
		end
	end )

	-- ui

	fg('ScreenGame')('LevelIndicator'):x( MAP_LEFT + 25 )
	fg('ScreenGame')('LevelIndicator'):y( 25 )
	fg('ScreenGame')('ScoreIndicator'):x( SCREEN_CENTER_X )
	fg('ScreenGame')('ScoreIndicator'):y( 25 )
	fg('ScreenGame')('SolvedIndicator'):x( MAP_LEFT + MAP_WIDTH - 25 )
	fg('ScreenGame')('SolvedIndicator'):y( 25 )
	fg('ScreenGame')('PointsIndicator'):x( MAP_LEFT + MAP_WIDTH - 25 )
	fg('ScreenGame')('PointsIndicator'):y( SCREEN_HEIGHT - 25 )

	local br, bg, bb = hex_to_rgb( '#333333' )
	fg('ScreenGame')('BorderLeft'):diffuse( br, bg, bb, 1)
	fg('ScreenGame')('BorderRight'):diffuse( br, bg, bb, 1)
	fg('ScreenGame')('BorderLeft'):stretchto( 0, 0, MAP_LEFT, SCREEN_HEIGHT )
	fg('ScreenGame')('BorderRight'):stretchto( MAP_LEFT + MAP_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT )

end

function update()
	local beat = GAMESTATE:GetSongBeat()

	for i,ice in pairs(iceMelts) do
		if ice.timer > 0 then ice.timer = ice.timer - delta_time
		else
			ice.state = ice.state + 1
			if ice.state > 7 then
				iceMelts[i] = nil
			else
				ice.timer = 0.02
			end
		end
	end

	if not gameLoop then return end
	if game_check() then
		gameLoop = false
		return
	end
	
	if not gameFinished then
		player.set_player_sprite()
	end

	if gameStarted then
		if player._walkTimer > 0 then
			player._walkTimer = player._walkTimer - delta_time;
			if player._walkTimer <= 0 then
				player._on_walk_end()
			end
		end
	end

	if beat >= 10.5 and beat <= 96 then
		fg('ScreenGame')('Timer'):cropleft( (beat-10.5)/(96-10.5) )
	end

	if not gameFinished and currentLevel then
		local is_bonus = currentLevel.dont_include_points or false
		fg('ScreenGame')('LevelIndicator'):settext('LEVEL ' .. levelCount)
		fg('ScreenGame')('ScoreIndicator'):settext(is_bonus and ("0/0") or (_iceMelted .. '/' .. maxLevelPoints))
		do
			local formattedString = solvedLevelsCount
			if formattedString < 10 then formattedString = '0' .. formattedString end
			fg('ScreenGame')('SolvedIndicator'):settext('SOLVED ' .. formattedString)
		end
		fg('ScreenGame')('PointsIndicator'):settext('POINTS ' .. (is_bonus and (totalPlayerPoints) or (totalPlayerPoints + currentPoints)))
	end
end

--

init()