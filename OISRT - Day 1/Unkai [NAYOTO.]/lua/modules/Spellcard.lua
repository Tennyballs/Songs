import "Global";
import "Utils";
local Spellcard = {};
local pSong = GAMESTATE:GetCurrentSong();

function Spellcard.Set(spellcards)
	if pSong and pSong.SetNumSpellCards then
		pSong:SetNumSpellCards(table.getn(spellcards));
		for i,v in ipairs(spellcards) do
			if table.getn(v) == 5 then
				pSong:SetSpellCardTiming(i-1,v[1],v[2]);
				pSong:SetSpellCardDifficulty(i-1,v[3]);
				pSong:SetSpellCardName(i-1,v[4]);
				pSong:SetSpellCardColor(i-1,rgba(v[5]));
			end
		end
	end
end

function Spellcard.Add(t)
	local spellcards = {};
	table.insert(spellcards,t);
	if pSong and pSong.GetSpellCards then
		for i,v in ipairs(pSong:GetSpellCards()) do
			local param = {
				v.StartBeat,
				v.EndBeat,
				v.Difficulty,
				v.Name,
				v.Color,
			};
			table.insert(spellcards,param);
		end
		local function comp(a,b)
			return a[1] < b[1];
		end
		table.sort(spellcards,comp);
		Spellcard.Set(spellcards);
	end
end

function Spellcard.Clear()
	if pSong and pSong.SetNumSpellCards then
		pSong:SetNumSpellCards(0);
	end
end

function Spellcard.SetLabel(labels)
	if pSong and pSong.ClearLabels then
		pSong:ClearLabels();
		for i,v in ipairs(labels) do
			if table.getn(v) == 2 then
				pSong:AddLabel(v[1],v[2]);
			end
		end
	end
end

return Spellcard;
