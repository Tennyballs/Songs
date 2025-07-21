local Queue = require "modules/Queue";

do
	local spellcards = {
		{  0.000, 36.000,1},
		{ 36.000, 68.000,2},
		{ 68.000,132.000,4},
		{132.000,164.000,5},
		{164.000,210.000,6},
		{210.000,276.000,4},
		{276.000,288.000,3},
	};
	ClearSpellcard();
	for i,v in pairs(spellcards) do
		AddSpellcard{
			v[1],
			v[2],
			string.format("Phase %d",i),
			v[3],
			colorlerp(scale(i,1,#spellcards,0,1),"#2A1AD8","#B948FF"),
		};
	end
	SetLastBeatHint(296.000);
end

return function(self)
	local c = GetChildrenTable(self);
	for i,v in pairs(Screen():GetChildren()) do
		if v then
			if
				v:GetName() ~= "SongForeground" and
				v:GetName() ~= "Currents" and
				v:GetName() ~= "AttacksP1" and
				v:GetName() ~= "AttacksP2"
			then
				v:hidden(1);
			end
		end
	end
	for pn = 3,8 do
		SetInputPlayer(pn,3);
	end
	if c.SongBackground then
		c.SongBackground:SetTarget(Screen():GetChild("SongBackground"):GetChild(""));
	end
	if c.PlayField then
		local c = GetChildrenTable(c.PlayField);
		if istable(c.NoteField) then
			for i,v in pairs(c.NoteField) do
				if v then
					SetPlayerProxy(v,i,"NoteField");
				end
			end
		end
		if istable(c.Judgment) then
			for i,v in pairs(c.Judgment) do
				local multi = i % 2 == 1 and -1 or 1;
				if v then
					SetPlayerProxy(v,i,"Judgment");
					v:x(multi*160);
				end
			end
		end
		if istable(c.Combo) then
			for i,v in pairs(c.Combo) do
				local multi = i % 2 == 1 and -1 or 1;
				if v then
					SetPlayerProxy(v,i,"Combo");
					v:x(multi*160);
				end
			end
		end
	end
	do
		local nd = GetNoteData(136.000,164.000);
		for i,v in pairs(nd) do
			Queue{ BeatAt = v[1], Mods = "*-1 TinyX".. v[2] ..",*-1 -400% TinyY".. v[2] };
		end
	end
	do
		local notedata = {
			{244.000,0,2,length=1.000},
			{245.000,2,2,length=2.000},
			{247.000,3,2,length=1.000},
			{248.000,1,2,length=1.000},
			{249.000,0,2,length=1.000},
			{250.000,2,2,length=1.000},
			{251.000,1,2,length=1.000},
			{252.000,3,2,length=2.000},
			{256.000,2,2,length=2.000},
			{258.000,1,2,length=1.000},
			{259.000,0,2,length=1.000},
			{261.000,3,2,length=0.250},
			{261.250,2,2,length=0.250},
			{261.500,1,2,length=0.250},
			{261.750,0,2,length=2.250},
			{264.000,2,2,length=0.750},
			{264.750,1,2,length=0.750},
			{265.500,3,2,length=0.500},
			{266.000,2,2,length=1.000},
			{267.000,0,2,length=1.000},
			{268.000,1,2,length=2.000},
			{270.000,2,2,length=2.000},
			{272.000,3,2,length=2.000},
			{274.000,1,2,length=1.000},
			{275.000,2,2,length=1.000},
		};
		local colors = {
			[3] = "#D91D81",
			[4] = "#00AAEE",
		};
		for pn = 3,4 do
			local c = Player(pn);
			if c then
				c:SetNoteDataFromLua(notedata);
				for col = 0,3 do
					c:SetNumStealthGradientPoints(col,1);
					c:SetStealthGradientPoint(0,col,1);
					c:SetStealthGradientColor(0,col,rgba(colors[pn]));
				end
			end
		end
	end
end;
