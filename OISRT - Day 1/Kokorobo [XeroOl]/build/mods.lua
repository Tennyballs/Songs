local function grid(beat, count)
  if count then
    for i = 1, count do
      grid(beat)
    end
    return
  end
  local len = 2
  local grid0 = nil
  local function init()
    local index = rand.int(#gridpool)
    grid0 = table.remove(gridpool, index)
    return grid0:hidden(0)
  end
  xero.func({beat, init})
  local function attr(p)
    grid0:zoom((1 + (0.2 * p)))
    grid0:diffusealpha((p * 1))
    return grid0:glow(0.1796875, 0.203125, 0.25, (0.5 - (0.5 * (p ^ 0.2))))
  end
  xero.func({beat, len, pop, attr})
  local function deinit()
    table.insert(gridpool, grid0)
    return grid0:hidden(1)
  end
  return xero.func({(beat + len), deinit})
end
local function cross(beat, count)
  if count then
    for i = 1, count do
      cross(beat)
    end
    return
  end
  local len = math.min((56 - beat), 32)
  local cross0 = nil
  local startAngle = rand.int(360)
  local dir = ((rand.bool() and 1) or -1)
  local function init()
    local index = rand.int(#crosspool)
    cross0 = table.remove(crosspool, index)
    return cross0:hidden(0)
  end
  xero.func({beat, init})
  local function attr(a)
    local p = linear(a)
    cross0:rotationy((startAngle + (((dir * p) * 3) * len)))
    local p0 = bounce(a)
    return cross0(1):zoomx((p0 * 40))
  end
  xero.func({beat, len, linear, attr})
  local function deinit()
    table.insert(crosspool, cross0)
    return cross0:hidden(1)
  end
  return xero.func({(beat + len), deinit})
end
rand.seed(1)
cross(1, 2)
cross(8)
cross(12)
cross(13.5)
cross(26.5)
cross(26.625)
cross(26.75)
cross(26.875)
cross(27)
cross(36)
cross(40)
cross(41.5)
local function definition(px, pn)
  local amount = (px * 0.005)
  do end (P[1]):x((scx * (1 - amount)))
  return (P[2]):x((scx * (1 + amount)))
end
xero.definemod({"px", definition})
local function f(a, b)
  return ((a * (50 - b)) * 0.02)
end
xero.node({"movey", "reverse0", f, "movey", defer = true})
xero.definemod({"rot", 100, "rot0", 100, "rot1", 100, "rot2", 100, "rot3"})
xero.definemod({"dir", 100, "dir0", 100, "dir1", 100, "dir2", 100, "dir3"})
for col = 0, 3 do
  local rot = ("rot" .. col)
  local dir = ("dir" .. col)
  local reverse = ("reverse" .. col)
  local zigzagperiod = ("zigzagperiod" .. col)
  local zigzagoffset = ("zigzagoffset" .. col)
  local zigzag = ("zigzag" .. col)
  local zigzagzperiod = ("zigzagzperiod" .. col)
  local zigzagzoffset = ("zigzagzoffset" .. col)
  local zigzagz = ("zigzagz" .. col)
  local function rotate(rot0, dir0)
    if ((rot0 % 360) == 0) then
      return 0, 0, 0, 0, 0, 0, 0
    elseif ((rot0 % 180) == 0) then
      return 100, 0, 0, 0, 0, 0, 0
    else
      local rot_theta = ((rot0 * math.pi) * 0.01)
      local dir_theta = ((dir0 * math.pi) * 0.005)
      local cos = math.cos(rot_theta)
      local sin = math.sin(rot_theta)
      local dir_cos = math.cos(dir_theta)
      local dir_sin = math.sin(dir_theta)
      return (50 - (50 * cos)), 900, 900, -212.5, -212.5, ((1000 * sin) * dir_cos), ((1000 * sin) * dir_sin)
    end
  end
  xero.definemod({rot, dir, rotate, reverse, zigzagperiod, zigzagzperiod, zigzagoffset, zigzagzoffset, zigzagz, zigzag})
end
setdefault({1.5, "xmod", 100, "dizzyholds", 100, "reversetype", 100, "stealthtype", 100, "stealthpastreceptors", 100, "spiralholds", -100, "drawsizeback"})
local m = xero.set
ease({16, 12, inOutQuad, 200, "rot"})
ease({12, 32, bell, -50, "rot"})
ease({20, 34, inOutQuad, 600, "rot"})
ease({28, 28, inOutQuad, 400, "rot0", 200, "rot2", -400, "rot3"})
m({56, 0, "rot", 0, "rot0", 0, "rot1", 0, "rot2", 0, "rot3"})
for col = 0, 3 do
  local dark = ("dark" .. col)
  m({0, 100, dark})
end
for _, b in ipairs({67, 75, 83, 131, 251, 331, 339, 347, 355}) do
  ease({b, 2, linear, 150, "dark"})
  if (b == 83) then
    m({(b + 4), 0, "dark"})
  else
    m({(b + 5), 0, "dark"})
  end
end
ease({16, 10, bounce, 50, "dark"})
ease({59, 3, bounce, 100, "dark"})
local function digital(beat, len)
  for i = (beat - 1), beat, (1 / 8) do
    grid(i)
  end
  for i = beat, (beat + len), (1 / 4) do
    grid(i)
  end
  for col = 0, 3 do
    local dark = ("dark" .. col)
    ease({(beat - 4), 3, outQuad, 100, dark})
    m({((beat - 1) + (col * 0.1)), 50, dark})
  end
  return nil
end
digital(28, 4)
digital(88, 6)
digital(152, 6)
digital(168, 6)
digital(212, 5)
digital(272, 5.5)
digital(304, 5)
digital(336, 6)
local function three_sparkle(i)
  grid(i, 10)
  grid((i + 1.5), 10)
  return grid((i + 3), 10)
end
local flout = flip(outExpo)
local function driven_drop(i)
  ease({i, 4, flout, -100, "tiny"})
  ease({(i + 1.5), 4, flout, -100, "tiny"})
  ease({(i + 3), 4, flout, -100, "tiny"})
  xero.plr = 1
  ease({i, 3, linear, 450, "movey"})
  acc({i, 100, "hidenoteflash", 100, "dark"})
  acc({(i + 3), -450, "movey", -100, "hidenoteflash", -100, "dark"})
  xero.plr = 2
  m({i, 100, "stealth"})
  m({(i + 3), 0, "stealth"})
  xero.plr = nil
  return nil
end
local function driven_drop_fix(i)
  xero.plr = 2
  m({(i + 1), 0, "stealth", 100, "hidden", 100, "hiddenoffset"})
  ease({(i + 1), 2, linear, 0, "hiddenoffset"})
  m({(i + 3), 0, "hidden", 0, "hiddenoffset"})
  xero.plr = nil
  return nil
end
for i = 56, 112, 8 do
  three_sparkle(i)
  driven_drop(i)
end
driven_drop_fix(56)
for i = 152, 160, 8 do
  driven_drop(i)
end
for i = 336, 360, 8 do
  driven_drop(i)
end
local function cycle(b, mod, len)
  local len0 = (len or 5)
  xero.plr = 1
  m({b, 0, "zoom"})
  ease({b, len0, linear, 100, "zoom"})
  xero.plr = 2
  ease({b, len0, inExpo, -1000, mod})
  xero.plr = nil
  return m({(b + len0), 0, mod})
end
cycle(48, "flip", 8)
m({0, 100, "sudden", 150, "suddenoffset"})
m({0, 50, "drawsize"})
m({56, 0, "drawsize"})
ease({49, 7, inQuad, 100, "holdstealth"})
m({64, 0, "holdstealth"})
ease({0, 1000, linear, (1000 * 100), "bumpyxoffset"})
cycle(115, "invert")
ease({115, 5, flip(linear), 100, "brake"})
ease({0, 0, instant, 100, "orient", -50, "straightholds"})
local function swap2(self, len)
  table.insert(self, 2, (len or 3))
  table.insert(self, 3, inOutExpo)
  do end (self)[1] = (self[1] - ((self[2] / 2) + 0.1))
  return swap(self)
end
swap2({120, "ldru"})
swap2({121, "ldur"})
swap2({121.5, "ldru"})
swap2({122.5, "dlru"})
swap2({123, "dlur"})
swap2({123.5, "ldur"})
swap2({124, "lurd"})
swap2({125, "lrdu"})
swap2({126, "drlu"})
swap2({127, "ldru"})
swap2({128, "ldur"})
swap2({129.5, "dlru"})
swap2({131, "ldur"}, 4)
swap2({136, "ldru"})
swap2({137, "ludr"})
swap2({137.5, "lurd"})
swap2({138.5, "lrud"})
swap2({139, "lrdu"})
swap2({141.5, "ldru"})
swap2({142, "ldur"})
swap2({142.5, "dlur"})
swap2({143, "dulr"})
swap2({144, "dlur"})
swap2({145, "ldru"})
swap2({146, "dlur"})
swap2({147, "ldur"})
acc({155.699997, 100, "flip", 314, "co0", 314, "co1", 314, "co2", 314, "co3"})
add({155, 4, outExpo, 314, "co1", -314, "co2", -314, "co0", 314, "co3"})
add({163, 4, outExpo, -314, "co1", 314, "co2", 314, "co0", -314, "co3"})
acc({163.699997, -100, "flip", -314, "co0", -314, "co1", -314, "co2", -314, "co3"})
aux({"co0", "co1", "co2", "co3"})
local function strangebehavior(a, b)
  return (((b == 100) and ( - a)) or a)
end
xero.node({"co0", "flip", strangebehavior, "confusionoffset0"})
xero.node({"co1", "flip", strangebehavior, "confusionoffset1"})
xero.node({"co2", "flip", strangebehavior, "confusionoffset2"})
xero.node({"co3", "flip", strangebehavior, "confusionoffset3"})
local timings = {152, "dulr", 153.5, "uldr", 155, "ldur", 160, "dulr-flipped", 161.5, "udlr-flipped", 163, "ldur-flipped", 168, "dlur", 169, "dlru", 169.5, "dlur", 170.5, "dulr", 171, {"dlur", 4}, 173.5, "dlru", 174, "ldru", 174.5, "ldur", 175, "dlru", 176, "ldur", 177, "ldru", 178, "dlur", 179, "ldur"}
for i = 1, #timings, 2 do
  if (type(timings[(i + 1)]) == "string") then
    swap2({timings[i], timings[(i + 1)]})
  else
    swap2({timings[i], timings[(i + 1)][1]}, timings[(i + 1)][2])
  end
end
xero.func({175, "ppshow", "front"})
xero.func({184, "ppshow", "back"})
xero.plr = 1
m({175, 99.5, "stealth", 100, "zbuffer", 10000, "movex0", 10000, "movex2", 10000, "movex3", 100, "hidenoteflash", 100, "dark"})
local function inv(x)
  return (1 / (1 - x))
end
ease({179, 5, inv, 200, "longholds"})
ease({179, 5, outQuad, (((sw / 64) * -200) - 200), "tiny"})
ease({179, 5, linear, -200, "movey", 0, "drawsize", 200, "zoomy"})
xero.func({184, "void", 1})
m({184.050003, 0, "tiny", 0, "movey", 0, "stealth", 0, "drawsize", 0, "holdstealth", 0, "zbuffer", 0, "movex0", 0, "movex2", 0, "movex3", 0, "hidenoteflash", 0, "longholds", 0, "dark", 100, "zoomy"})
xero.plr = 2
m({175, 100, "stealth1"})
m({184, 0, "stealth1"})
xero.plr = nil
add({181, 10, inOutCubic, 300, "rot0"})
add({188, 15, inOutCubic, 300, "rot0"})
add({184, 12, inOutCubic, 300, "rot1"})
add({190, 16, inOutCubic, 300, "rot1"})
add({179, 10, inOutQuad, 300, "rot2"})
add({186, 19, inOutQuad, 300, "rot2"})
add({179, 10, inOutCubic, 300, "rot3"})
add({185, 16, inOutCubic, 300, "rot3"})
add({212, 10, inOutCubic, 300, "rot0"})
add({224, 16, inOutCubic, 300, "rot0"})
add({206, 22, inOutQuad, 300, "rot1"})
add({220, 19, inOutQuad, 300, "rot1"})
add({210, 13, inOutCubic, 300, "rot2"})
add({220, 15, inOutCubic, 300, "rot2"})
add({201, 20, inOutCubic, 300, "rot3"})
add({228, 12, inOutCubic, 300, "rot3"})
add({184, (240 - 184), inOutQuad, 500, "rot"})
xero.func({232, 8, linear, 1, 0, "void"})
local timings0 = {240, "ldru", 241, "ldur", 241.5, "dlru", 242.5, "ludr", 243, "ldur", 243.5, "ldru", 244, "uldr", 245, "lurd", 246, "rldu", 247, "drul", 248, "dlur", 249.5, "ldru", 251, {"ldur", 5}, 256, "dlur", 257, "dlru", 257.5, "ldru", 258.5, "ldur", 261.5, "lrdu", 262, "dlru", 262.5, "lrdu", 263, "ldur", 264, "ludr", 265, "dlur", 266, "ludr", 267, "ldur", 272, "dlur", 273, "ldur", 273.5, "dlur", 274.5, "dlru", 275, "ldru", 275.5, "lrdu", 276, "ldur", 277, "dlur", 278, "ldru", 279, "lrdu", 280, "ldur", 281.5, "dulr", 283, "ldur", 288, "ldru", 289, "dlru", 289.5, "dlur", 290.5, "ldur", 291, "ldru", 293.5, "dlru", 294, "dlur", 294.5, "ludr", 295, "urld", 296, "rdlu", 297, "rudl", 298, "udrl", 299, "ludr", 304, "ldur", 305, "ludr", 305.5, "lurd", 306.5, "ulrd", 307, "udlr", 307.5, "udlr", 308, "lurd", 309, "ldur", 310, "dulr", 311, "dlru", 312, "ldur", 313.5, "ldru", 315, "ldur", 320, "udlr", 321, "ldur", 321.5, "udlr", 322.5, "uldr", 323, "ldur", 325.5, "dlur", 326, "dlru", 326.5, "ldru", 327, "ldur", 328, "ludr", 329, "lurd", 330, "ludr", 331, "ldur", 336, "durl", 337, "dlur", 337.5, "dulr", 338.5, "drlu", 339, "ldur", 344, "dulr", 345, "drul", 345.5, "rudl", 346.5, "rlud", 347, "ldur", 352, "dulr", 353, "dlur", 353.5, "durl", 354.5, "drlu", 355, "ldur", 360, "lrdu", 361, "ldru", 361.5, "lrdu", 362.5, "ldru", 363, "drul"}
for i = 1, #timings0, 2 do
  if (type((timings0)[(i + 1)]) == "string") then
    swap2({(timings0)[i], (timings0)[(i + 1)]})
  else
    swap2({(timings0)[i], (timings0)[(i + 1)][1]}, (timings0)[(i + 1)][2])
  end
end
local weirdbass = {312.833008, 313.5, 315, 315.333008, 315.666992, 316, 316.5, 317.5, 318.25}
local weirdsnare = {314.166992, 316.833008, 319}
local weirdtick = {316.5, 318.333008}
for i, v in ipairs(weirdbass) do
  if (v ~= 318.25) then
    acc({v, 314, "confusionoffset"})
  end
  add({(v - 1), 1, tap, 50, "movey"})
  add({v, 1, pop, -50, "tiny"})
end
for i, v in ipairs(weirdsnare) do
  add({v, 1, pop, -3000, "tinyz"})
end
for i, v in ipairs(weirdtick) do
  add({v, 1, pop, 50, "skewx"})
end
m({318.5, 100, "invert"})
m({318.75, 0, "invert"})
m({319, 100, "invert"})
m({319.25, 0, "invert"})
m({319.5, 100, "invert"})
m({319.75, 0, "invert"})
for _, i in ipairs(c2l.tick) do
  if ((i >= 164) and (i < 168)) then
    ease({i, 1, pop, 1000, "zoomz"})
  else
    add({i, 1, outExpo, (628 / 5), "confusionoffset"})
    if ((i % 4) == 0) then
      m({(i + 4), 0, "confusionoffset"})
    end
  end
end
for i, v in ipairs(c2l.pulse) do
end
for i, v in ipairs(c2l.snare) do
  add({v, 1, pop, -2000, "tinyz", 50, "zoomz"})
end
for i, v in ipairs(c2l.bass) do
  add({v, 0.5, flout, 100, "tiny"})
end
for i, v in ipairs(c2l.noise) do
  add({v, 0.25, pop, -10, "zoomx"})
end
for i, v in ipairs(c2l.decay) do
  add({v, 1, pop, (100 * ((i % 2) - 0.5)), "noteskew"})
end
for i, v in ipairs(c2l.sizzle) do
  add({v, 1, pop, 100, "drunk"})
  add({v, 1, flout, 628, "confusionoffset"})
end
for i, v in ipairs(c2l.scratch) do
  if (v == 272) then
    m({v, 0, "confusionoffset"})
  else
    m({v, (40 * ((i % 2) - 0.5)), "confusionoffset"})
  end
end
ease({363, 2, linear, 150, "dark"})
local function ending()
  for pn = 1, 2 do
    do end (PJ[pn]):hidden(1)
    do end (PC[pn]):hidden(1)
  end
  return nil
end
xero.func({364, ending})
return finalizesplines()
