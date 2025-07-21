self:fov(45)
for pn = 1, 2 do
  setupJudgeProxy(PJ[pn], (P[pn]):GetChild("Judgment"), pn)
  setupJudgeProxy(PC[pn], (P[pn]):GetChild("Combo"), pn)
  do end (PJ[pn]):zoom(0.8)
  do end (PC[pn]):zoom(0.8)
  do end (PJ[pn]):y((scy - 20))
  do end (PC[pn]):y((scy + 50))
end
for pn = 1, 2 do
  for k, v in pairs(PP) do
    if v[pn] then
      do end (v[pn]):SetTarget(P[pn])
      do end (v[pn]):hidden(1)
    end
  end
  do end (P[pn]):hidden(1)
end
local active = "back"
local function ppshow(name)
  do end (PP[active][1]):hidden(1)
  active = name
  return (PP[active][1]):hidden(0)
end
do end (PP.back[1]):hidden(0)
do end (PP.back[2]):hidden(0)
bgquad:diffuse(0.1796875, 0.203125, 0.25, 1)
bgquad:xywh(scx, scy, sw, sh)
cover:diffuse(0.1796875, 0.203125, 0.25, 1)
cover:xywh(scx, scy, sw, sh)
local function k()
  return cover:hidden(1)
end
xero.func({0, k})
local orbpool = orbcontainer:GetChildren()
for i = 1, #orbpool do
  local orb = orbpool[i]
  orb:hidden(1)
  orb:blend("add")
  orb:SetWidth(256)
  orb:SetHeight(256)
end
local function orb(beat, size, r, g, b)
  local len = 60
  local orb0 = nil
  local x = rand.int(0, sw)
  local y = rand.int(0, sh)
  local function init()
    local index = rand.int(1, #orbpool)
    orb0 = table.remove(orbpool)
    orb0:xy(x, y)
    return orb0:hidden(0)
  end
  xero.func({beat, init, defer = true})
  local function run(p)
    orb0:zoom(p)
    return orb0:diffuse(r, g, b, p)
  end
  xero.func({beat, len, bell, 0, 0.4, run})
  local function deinit()
    table.insert(orbpool, orb0)
    return orb0:hidden(1)
  end
  return xero.func({(beat + len), deinit})
end
local colors = {{0.55859375, 0.734375, 0.73046875, 1}, {0.53125, 0.75, 0.8125, 1}, {0.50390625, 0.62890625, 0.75390625, 1}, {0.55859375, 0.734375, 0.73046875, 1}, {0.53125, 0.75, 0.8125, 1}, {0.50390625, 0.62890625, 0.75390625, 1}, {0.74609375, 0.37890625, 0.4140625, 1}, {0.8125, 0.52734375, 0.4375, 1}, {0.91796875, 0.79296875, 0.54296875, 1}, {0.63671875, 0.7421875, 0.546875, 1}, {0.703125, 0.5546875, 0.67578125, 1}}
for b = 1, 320 do
  local i = rand.int(1, #colors)
  orb(b, rand.float(0.3, 0.5), unpack(colors[i]))
  rand.int(5)
end
local height = 9
local width = 12
local gridpool = {}
for r = 1, height do
  for c = 1, width do
    local tile = gridcontainer:GetChildAt((((r - 1) * width) + (c - 1)))
    table.insert(gridpool, tile)
    tile:hidden(1)
    tile:xy((((((c - 0.5) / width) * 640) - 320) + scx), (((((r - 0.5) / height) * 480) - 240) + scy))
    tile:SetWidth((sw / width))
    tile:SetHeight((sh / height))
    tile:zbuffer(1)
  end
end
crosscontainer:SetVanishPoint(scx, scy)
local crosspool = crosscontainer:GetChildren()
crosscontainer:fov(90)
crosscontainer:xy(scx, scy)
for i = 1, #crosspool do
  local cross = crosspool[i]
  cross:diffuse(unpack(colors[rand.int(#colors)]))
  cross:diffusealpha(0.5)
  local pos = (i - ((#crosspool * 0.5) + 0.5))
  local inner = cross:GetChildAt(0)
  inner:z((( - scx) * 0.2))
  inner:xywh(0, 0, 10, 1000)
  cross:rotationx(90)
  cross:hidden(1)
end
do
  aft(aft1)
  sprite(sprite1)
  aftsprite(aft1, sprite1)
  local shader = sprite1:GetShader()
  local function flatten(xs)
    local result = {}
    for _, x in ipairs(xs) do
      for _0, e in ipairs(x) do
        result[(#result + 1)] = e
      end
    end
    return result
  end
  shader:uniform4fv("scheme", flatten({{0.1796875, 0.203125, 0.25, 1}, {0.23046875, 0.2578125, 0.3203125, 1}, {0.26171875, 0.296875, 0.3671875, 1}, {0.296875, 0.3359375, 0.4140625, 1}, {0.84375, 0.8671875, 0.91015625, 1}, {0.89453125, 0.91015625, 0.9375, 1}, {0.921875, 0.93359375, 0.953125, 1}, {0.55859375, 0.734375, 0.73046875, 1}, {0.53125, 0.75, 0.8125, 1}, {0.50390625, 0.62890625, 0.75390625, 1}, {0.3671875, 0.50390625, 0.671875, 1}, {0.74609375, 0.37890625, 0.4140625, 1}, {0.8125, 0.52734375, 0.4375, 1}, {0.91796875, 0.79296875, 0.54296875, 1}, {0.63671875, 0.7421875, 0.546875, 1}, {0.703125, 0.5546875, 0.67578125, 1}, {0, 0, 0, 0}}))
end
do
  aft(aft2)
  sprite(sprite2)
  aftsprite(aft2, sprite2)
  sprite2:zbias(-1)
  sprite2:zbuffer(1)
end
local function void(t)
  if (t == 1) then
    aft2:hidden(1)
    return sprite2:hidden(1)
  else
    aft2:hidden(0)
    sprite2:hidden(0)
    sprite2:cropleft((t * 0.5))
    sprite2:cropright((t * 0.5))
    sprite2:croptop((t * 0.5))
    return sprite2:cropbottom((t * 0.5))
  end
end
xero["gridpool"] = gridpool
xero["crosspool"] = crosspool
xero["ppshow"] = ppshow
xero["void"] = void
return nil
